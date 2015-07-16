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

    
    var contentArticles: [ContentParty]?
    
    var refreshControl:UIRefreshControl = UIRefreshControl()
    var currentPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.articlesTableView.estimatedRowHeight = CGFloat(400)
        self.articlesTableView.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view, typically from a nib.

        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.articlesTableView.addSubview(refreshControl)
        
        searchArticleId(["sort": ContentSortType.Click.rawValue, "limit": "10", "page": "1"], {
            articles in
            self.contentArticles = articles
            self.articlesTableView.reloadData()
        })
    }
    
    func refresh() {
        searchArticleId(["sort": ContentSortType.Click.rawValue, "limit": "10", "page":String(++currentPage)], {
            articles in
            if let articles = articles {
                self.contentArticles?.splice(articles, atIndex: 0)
                self.articlesTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        })
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArticles?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellReuseIdentifier) as? PostCell
        if let article = contentArticles?[indexPath.row] as ContentParty? {
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
        var webViewCtrl = segue.destinationViewController as! WebViewController
        webViewCtrl.url = sender as? NSURL
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let url = (contentArticles?[indexPath.row] as ContentParty?)?.url {
            self.performSegueWithIdentifier("showWebView", sender: url)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

