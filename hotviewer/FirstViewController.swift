//
//  FirstViewController.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/13.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SWRevealViewControllerDelegate {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var articleTypeSegment: UISegmentedControl!
    @IBOutlet weak var articlesTableView: UITableView!
    let reusedCellIdentifier = ["postCell", "pttCell", "fbFanpageCell"]
    
    var indicatorView: UIActivityIndicatorView!
    
    var currentArticleTypeIndex: Int = 0
    var contentArticles: [ContentArticle]?
    var pttArticles: [PTTArticle]?
    var fbFanpages: [FBFanpage]?
    
    var refreshControl:UIRefreshControl = UIRefreshControl()
    var currentPage: Int = 1
    
    
    func revealController(revealController: SWRevealViewController!, animateToPosition position: FrontViewPosition) {
        if position == .Left {
            // If the category list is closed...
            self.articlesTableView.userInteractionEnabled = true
            // Fire the articleTypeChanged to reload article
            self.articleTypeChanged(self.articleTypeSegment)
        } else {
            // If the category list is opened...
            self.articlesTableView.userInteractionEnabled = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //menu button
        if self.revealViewController() != nil {
            self.revealViewController().delegate = self
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            // Uncomment to change the width of menu
            self.revealViewController().rearViewRevealWidth = self.view.frame.width - 62
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
    
    @IBAction func articleTypeChanged(sender: UISegmentedControl) {
        currentArticleTypeIndex = sender.selectedSegmentIndex
        // Update the category list
        if let prefController = self.revealViewController().rearViewController as? PreferenceViewController {
            prefController.articleTypeIndex = currentArticleTypeIndex
        }
        switch currentArticleTypeIndex {
            case 0:
                currentPage = 1
                loadContentArticles()
                
            case 1:
                loadPTTArticles()
                
            default:
                loadFBFanpage()
        
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [contentArticles?.count, pttArticles?.count, fbFanpages?.count][currentArticleTypeIndex] ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(reusedCellIdentifier[currentArticleTypeIndex]) as? UITableViewCell
 
        if (indexPath.row % 2 == 1) {
            cell?.backgroundColor = UIColor(red: 240/255, green: 248/255, blue: 255/255, alpha: 1)
        } else {
            cell?.backgroundColor = UIColor.whiteColor()
        }
        
        switch currentArticleTypeIndex {
            case 0:
                if let cell = cell as? PostCell, let article = contentArticles?[indexPath.row] as ContentArticle? {
                    cell.title?.text = article.title
                    
                    if article.loaded {
                        cell.thumbnailURL = article.thumbnailURL
                        cell.content?.text = article.content
                    } else {
                        article.getArticle({
                            if indexPath.row < tableView.numberOfRowsInSection(0) {
                                cell.thumbnailURL = article.thumbnailURL
                                tableView.beginUpdates()
                                cell.content?.text = article.content
                                tableView.endUpdates()
                            }
                        })
                    }
                }
            case 1:
                if let cell = cell as? pttCell, let pttArticle = pttArticles?[indexPath.row] as PTTArticle? {
                    cell.title.text = pttArticle.title
                    cell.board.text = "看板 : " + pttArticle.board!
                    cell.push.text = pttArticle.push
                    var img: UIImage?
                    if cell.push.text?.toInt() >= 500 {
                        img = UIImage(named: "pushHot")
                    }
                    else {
                        img = UIImage(named: "pushNotHot")
                    }
                    cell.pushImageView.image = img
                }
            default:
                if let cell = cell as? FBFanpageCell, let fbFanpage = fbFanpages?[indexPath.row] as FBFanpage? {
                    cell.title.text = fbFanpage.name
                    cell.about.text = fbFanpage.about
                    cell.fanCount.text = fbFanpage.fanCount
                    cell.thumbnailURL = fbFanpage.thumbnailURL
                }
        }
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var sender: AnyObject?
        switch currentArticleTypeIndex {
            case 0:
                let article = (contentArticles?[indexPath.row] as ContentArticle?)
                if let rawContent = article?.rawContent, let url = article?.url {
                    sender = article
                }
            case 1:
                let ptt = (pttArticles?[indexPath.row] as PTTArticle?)
                sender = ptt
            default:
                let fbpage = (fbFanpages?[indexPath.row] as FBFanpage?)
                sender = fbpage
        }
        self.performSegueWithIdentifier("showWebView", sender: sender)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let webViewCtrl = segue.destinationViewController as! WebViewController
        
        switch sender {
            case is ContentArticle:
                let article = sender as! ContentArticle
                webViewCtrl.url = article.url
                webViewCtrl.rawContent = article.rawContent
            case is PTTArticle:
                let ptt = sender as! PTTArticle
                webViewCtrl.url = ptt.url
            case is FBFanpage:
                let fbpage = sender as! FBFanpage
                webViewCtrl.url = fbpage.url
            default:
                break
        }
    }
    
    func loadContentArticles(completition: (()->())? = nil) {
        if let prefController = self.revealViewController().rearViewController as? PreferenceViewController {
            self.indicatorView.startAnimating()
            // Release the contentArticles from memory
            self.contentArticles?.removeAll()
            self.contentArticles = [ContentArticle]()
            self.articlesTableView.reloadData()
            
            
            if prefController.atLeastOneSelected {
                // If preference has been set, load by users' preference
                
                // A count of loaded categories
                var loadedCount = 0
                for category in prefController.selectedCategories {
                    // We use ensureValidToken here to prevent simultaneously request multiple tokens for the first time
                    ContentAPI.instance.ensureValidToken() {
                        ContentAPI.instance.searchArticleId(limit: 10, page: self.currentPage, sort: ContentSortType.Click, tag: category.tag) {
                            (articles: [ContentArticle]?) in
                            if let articles = articles {
                                self.contentArticles? += articles
                                self.articlesTableView.reloadData()
                            }
                            // Stop the loading indicator only if after all categories are loaded
                            if ++loadedCount == prefController.selectedCount {
                                self.indicatorView.stopAnimating()
                                if let completition = completition {
                                    completition()
                                }
                            }
                        }
                    }
                }
            } else {
                // If preference has NOT been set, load all without board
                ContentAPI.instance.searchArticleId(limit: 10, page: currentPage, sort: ContentSortType.Click) {
                    (articles: [ContentArticle]?) in
                    if let articles = articles {
                        self.contentArticles? = articles
                        self.articlesTableView.reloadData()
                        self.indicatorView.stopAnimating()
                        if let completition = completition {
                            completition()
                        }
                    }
                }
            }
        }
    }
    func loadPTTArticles() {
        if let prefController = self.revealViewController().rearViewController as? PreferenceViewController {
            self.indicatorView.startAnimating()
            // Release the pttArticles from memory
            self.pttArticles?.removeAll()
            self.pttArticles = [PTTArticle]()
            self.articlesTableView.reloadData()
            
            
            if prefController.atLeastOneSelected {
                // If preference has been set, load by users' preference
                
                // A count of loaded categories
                var loadedCount = 0
                for category in prefController.selectedCategories {
                    // We use ensureValidToken here to prevent simultaneously request multiple tokens for the first time
                    SERAPI.instance.ensureValidToken() {
                        SERAPI.instance.searchPTTTopArticle(period: 10, board: category.tag, limit: 100 / prefController.selectedCount, onLoad: {
                            (pttArticles: [PTTArticle]?) in
                            if let articles = pttArticles {
                                self.pttArticles? += articles
                                self.articlesTableView.reloadData()
                            }
                            // Stop the loading indicator only if after all categories are loaded
                            if ++loadedCount == prefController.selectedCount {
                                self.indicatorView.stopAnimating()
                            }
                        })
                    }
                }
            } else {
                // If preference has NOT been set, load all without board
                SERAPI.instance.searchPTTTopArticle(period: 10, limit: 100, onLoad: {
                    (pttArticles: [PTTArticle]?) in
                    if let articles = pttArticles {
                        self.pttArticles? = articles
                        self.articlesTableView.reloadData()
                        self.indicatorView.stopAnimating()
                    }
                })
            }
        }
    }
    func loadFBFanpage() {
        self.indicatorView.startAnimating()
        SERAPI.instance.searchFBFanpage(category: "休閒旅遊", sortBy: FBFanpageSort.PTA, onLoad: {
            (fbFanpages: [FBFanpage]?) in
            self.fbFanpages = fbFanpages
            self.articlesTableView.reloadData()
            self.indicatorView.stopAnimating()
        })
    }
    func refresh() {
        switch currentArticleTypeIndex {
            case 0:
                currentPage++
                loadContentArticles() {
                    self.refreshControl.endRefreshing()
                }
            case 1:
                self.refreshControl.endRefreshing()
            default:
                self.refreshControl.endRefreshing()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

