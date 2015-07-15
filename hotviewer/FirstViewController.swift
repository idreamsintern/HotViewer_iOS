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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        searchArticleId(["sort": SortType.click.rawValue, "limit": "15"], {
            articles in
            if let articles = articles {
                self.contentArticles = articles
                dispatch_async(dispatch_get_main_queue()) {
                    self.articlesTableView.reloadData()
                }
            }
        })
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArticles.count
    }
    var emptyImg = UIImage()
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellReuseIdentifier) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: self.cellReuseIdentifier)
        }
        var article = contentArticles[indexPath.row]
        cell?.textLabel?.text = article.title
        
        article.getArticle({

            dispatch_async(dispatch_get_main_queue()) {
                if let content = article.content {
                    cell?.detailTextLabel?.text = content
                }
            }
            
            if let url = NSURL(string: article.thumbnailUrl!) {
                let request = NSURLRequest(URL: url)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                    (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                    dispatch_async(dispatch_get_main_queue()) {
                        cell?.imageView?.image = UIImage(data: data!)
                    }
                }
            }
            
        })
        return cell!
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var webViewCtrl = segue.destinationViewController as! WebViewController
        webViewCtrl.url = sender as? String
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

