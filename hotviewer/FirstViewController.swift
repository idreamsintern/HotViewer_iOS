//
//  FirstViewController.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/13.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let cellReuseIdentifier = "postCell"
    
    @IBOutlet weak var articlesTableView: UITableView!
    var indicatorView: UIActivityIndicatorView!
    var contentArticles: [ContentArticle]?
    
    var refreshControl:UIRefreshControl = UIRefreshControl()
    var currentPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Launch walkthrough screens
        if let pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? PageViewController {
            
            self.presentViewController(pageViewController, animated: true, completion: nil)
        }
        
        

        
        self.articlesTableView.estimatedRowHeight = CGFloat(400)
        self.articlesTableView.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view, typically from a nib.

        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.articlesTableView.addSubview(refreshControl)
        
        indicatorView = getIndicatorView()
        ContentAPI.instance.searchArticleId(["sort": ContentSortType.Click.rawValue, "limit": "10", "page": "1"]) {
            (articles: [ContentArticle]?) in
            self.contentArticles = articles
            self.articlesTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.indicatorView.stopAnimating()
        }
    }
    
    func refresh() {
        ContentAPI.instance.searchArticleId(["sort": ContentSortType.Click.rawValue, "limit": "10", "page":String(++currentPage)]) {
            (articles: [ContentArticle]?) in
            if let articles = articles {
                self.contentArticles?.splice(articles, atIndex: 0)
                self.articlesTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArticles?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellReuseIdentifier) as? PostCell
        if let article = contentArticles?[indexPath.row] as ContentArticle? {
            cell?.title?.text = article.title
            
            if article.loaded {
                cell?.thumbnailURL = article.thumbnailURL
                cell?.content?.text = article.content
            } else {
                article.getArticle({
                    cell?.thumbnailURL = article.thumbnailURL
                    cell?.content?.text = article.content
                    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                })
            }
        }
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let webViewCtrl = segue.destinationViewController as! WebViewController
        let article = sender as! ContentArticle
        webViewCtrl.url = article.url
        webViewCtrl.rawContent = article.rawContent
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let article = (contentArticles?[indexPath.row] as ContentArticle?)
        if let rawContent = article?.rawContent, let url = article?.url {
            self.performSegueWithIdentifier("showWebView", sender: article)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

