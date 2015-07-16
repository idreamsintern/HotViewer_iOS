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

    
    var contentArticles = [ContentParty]()
    
    var refreshControl:UIRefreshControl = UIRefreshControl()
    var currentPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.articlesTableView.addSubview(refreshControl)
        
        searchArticleId(["sort": SortType.click.rawValue, "limit": "10", "page":"1"], {
            articles in
            if let articles = articles {
                self.contentArticles = articles
                dispatch_async(dispatch_get_main_queue()) {
                    self.articlesTableView.reloadData()
                }
            }
        })
    }
    
    func refresh() {
        searchArticleId(["sort": SortType.click.rawValue, "limit": "10", "page":String(++currentPage)], {
            articles in
            if let articles = articles {
                for article in articles {
                    self.contentArticles.insert(article, atIndex: 0)
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.articlesTableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        })
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArticles.count
    }
    var emptyImg = UIImage()
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellReuseIdentifier) as? PostCell
        
        var article = contentArticles[indexPath.row]
        cell?.title?.text = article.title
        
        article.getArticle({
            cell?.thumbnailURL = article.thumbnailURL
            if let content = article.content {
                cell?.content?.text = content
            }
        })
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var webViewCtrl = segue.destinationViewController as! WebViewController
        webViewCtrl.url = sender as? NSURL
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if let url = contentArticles[indexPath.row].url {
            self.performSegueWithIdentifier("showWebView", sender: url)
        }
        
        //UIApplication.sharedApplication().openURL(NSURL(string: post.url)!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

