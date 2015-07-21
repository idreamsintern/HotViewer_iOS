//
//  FirstViewController.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/13.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var articlesTableView: UITableView!
    var indicatorView: UIActivityIndicatorView!
    
    var currentArticleTypeIndex: Int = 0
    var contentArticles: [ContentArticle]?
    var pttArticles: [PTTArticle]?
    var fbFanpages: [FBFanpage]?
    
    var refreshControl:UIRefreshControl = UIRefreshControl()
    var currentPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //menu button
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            // Uncomment to change the width of menu
            //self.revealViewController().rearViewRevealWidth = 62
        }
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
    }
    
    override func viewWillAppear(animated: Bool) {
        loadContentArticles()
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
        return [contentArticles?.count, pttArticles?.count, fbFanpages?.count][currentArticleTypeIndex] ?? 0
    }
    let reusedCellIdentifier = ["postCell","pttCell","fbFanpageCell"]
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell = tableView.dequeueReusableCellWithIdentifier(self.cellReuseIdentifier) as? PostCell
        var cell = tableView.dequeueReusableCellWithIdentifier(reusedCellIdentifier[currentArticleTypeIndex]) as? UITableViewCell
//        
//        if (indexPath.row % 2 == 1) {
//            cell?.backgroundColor = UIColor(red: 255/255, green: 250/255, blue: 205/255, alpha: 1)
//        } else {
//            cell?.backgroundColor = UIColor.whiteColor()
//        }

        
        
        switch currentArticleTypeIndex {
            case 0:
                if let cell = cell as? PostCell, let article = contentArticles?[indexPath.row] as ContentArticle? {
                    cell.title?.text = article.title
                    
                    if article.loaded {
                        cell.thumbnailURL = article.thumbnailURL
                        cell.content?.text = article.content
                    } else {
                        article.getArticle({
                            cell.thumbnailURL = article.thumbnailURL
                            cell.content?.text = article.content
                            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                        })
                    }
                }
            case 1:
                if let cell = cell as? pttCell, let pttArticle = pttArticles?[indexPath.row] as PTTArticle? {
                    cell.title.text = pttArticle.title
                    cell.board.text = pttArticle.board
                    cell.push.text = pttArticle.push
                }
            case 2:
                if let cell = cell as? FBFanpageCell, let fbFanpage = fbFanpages?[indexPath.row] as FBFanpage? {
                    cell.title.text = fbFanpage.name
                    cell.about.text = fbFanpage.about
                    cell.fanCount.text = fbFanpage.fanCount
                    cell.thumbnailURL = fbFanpage.thumbnailURL
                }
            default:
                break
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
    
    @IBAction func articleTypeChanged(sender: UISegmentedControl) {
        currentArticleTypeIndex = sender.selectedSegmentIndex
        switch currentArticleTypeIndex {
            case 0:
                loadContentArticles()
            case 1:
                loadPttArticles()
            case 2:
                loadFBFanpage()
            default:
                break
        }
    }
    func loadContentArticles() {
        self.indicatorView.startAnimating()
        ContentAPI.instance.searchArticleId(["sort": ContentSortType.Click.rawValue, "limit": "10", "page": "1"]) {
            (articles: [ContentArticle]?) in
            self.contentArticles = articles
            self.articlesTableView.reloadData()
            self.indicatorView.stopAnimating()
        }

    }
    func loadPttArticles() {
        self.indicatorView.startAnimating()
        SERAPI.instance.searchPTTTopArticle(["period":"10"], onLoad: {
            (pttArticles: [PTTArticle]?) in
            self.pttArticles = pttArticles
            self.articlesTableView.reloadData()
            self.indicatorView.stopAnimating()
        })
    }
    func loadFBFanpage() {
        self.indicatorView.startAnimating()
        SERAPI.instance.searchFBFanpage("休閒旅遊", sortBy: FBFanpageSort.PTA, onLoad: {
            (fbFanpages: [FBFanpage]?) in
            self.fbFanpages = fbFanpages
            self.articlesTableView.reloadData()
            self.indicatorView.stopAnimating()
        })
    }
}

