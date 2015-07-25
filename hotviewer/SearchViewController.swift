//
//  SearchViewController.swift
//  hotviewer
//
//  Created by Andy on 2015/7/22.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var articlesTableView: UITableView!
    @IBOutlet weak var articleTypeSegment: UISegmentedControl!
    let reusedCellIdentifier = ["postCell", "pttCell", "fbFanpageCell"]
    
    var indicatorView: UIActivityIndicatorView!
    
    var currentArticleTypeIndex: Int = 0
    var contentArticles: [ContentArticle]?
    var pttArticles: [PTTArticle]?
    var fbFanpages: [FBFanpage]?
    
    var refreshControl:UIRefreshControl = UIRefreshControl()
    var currentPage: Int = 1
    //for search article
    var searchController: UISearchController!
    var searchResults:[FBFanpage]?
    var searchKeyWord: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.articlesTableView.estimatedRowHeight = CGFloat(400)
        self.articlesTableView.rowHeight = UITableViewAutomaticDimension
    
        indicatorView = getIndicatorView()
        
        // Create the search controller, but we'll make sure that this SearchShowResultsInSourceViewController
        // performs the results updating.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.tintColor = UIColor.blackColor()
        //        searchController.searchBar.barTintColor = UIColor(red: 235.0/255.0, green: 73.0/255.0, blue: 27.0/255.0, alpha: 1.0)
        //
        //        searchController.searchBar.prompt = "Quick Search"
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        // Make sure the that the search bar is visible within the navigation bar.
        searchController.searchBar.sizeToFit()
        // Include the search controller's search bar within the table's header view.
        articlesTableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        articleTypeChanged(articleTypeSegment)
    }
    
    override func viewWillAppear(animated: Bool) {
        //loadContentArticles()
    }
    @IBAction func articleTypeChanged(sender: UISegmentedControl) {
        currentArticleTypeIndex = sender.selectedSegmentIndex
        switch currentArticleTypeIndex {
        case 0:
            searchController.searchBar.placeholder = "請輸入文章標題關鍵字"
        case 1:
            searchController.searchBar.placeholder = "請輸入文章標題關鍵字"
        default :
            searchController.searchBar.placeholder = "請輸入粉絲頁標題關鍵字"
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [contentArticles?.count, pttArticles?.count, fbFanpages?.count][currentArticleTypeIndex] ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(reusedCellIdentifier[currentArticleTypeIndex]) as? UITableViewCell
        
        if (indexPath.row % 2 == 1) {
            cell?.backgroundColor = UIColor(red: 255/255, green: 250/255, blue: 205/255, alpha: 1)
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
                    cell.board.text = pttArticle.board
                    cell.push.text = pttArticle.push
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
    var loadContentCounter = 0

    func loadContentArticles(keyword:String, latestCount:Int) {
        if keyword != "" {
            self.indicatorView.startAnimating()
            //self.articlesTableView.reloadData()
            ContentAPI.instance.searchArticleId(limit: 10, page: 1, sort: ContentSortType.Click, keyword: keyword) {
                (articles: [ContentArticle]?) in
                if latestCount == self.loadContentCounter {
                    self.contentArticles = articles
                    self.articlesTableView.reloadData()
                    self.indicatorView.stopAnimating()
                }
            }
        }else{
            contentArticles?.removeAll(keepCapacity: true)
            articlesTableView.reloadData()
        }
        
        
    }
    func loadPTTArticles(keyword:String) {
        if keyword != "" {
            self.indicatorView.startAnimating()
            self.pttArticles?.removeAll()
            
            SERAPI.instance.searchPTTTopArticleByKeyword("title",keyword: keyword,limit:10, sort: "time_desc",onLoad: {
                (pttArticles: [PTTArticle]?) in
                self.pttArticles = pttArticles
                self.articlesTableView.reloadData()
                self.indicatorView.stopAnimating()
            })
        }else{
            pttArticles?.removeAll(keepCapacity: false)
            articlesTableView.reloadData()
        }
    }
    func loadFBFanpage(keyword:String) {
        if keyword != "" {
            self.indicatorView.startAnimating()
            self.fbFanpages?.removeAll()
            SERAPI.instance.searchFBFanpage(keyword: keyword, sortBy: FBFanpageSort.PTA, onLoad: {
                (fbFanpages: [FBFanpage]?) in
                self.fbFanpages = fbFanpages
                self.articlesTableView.reloadData()
                self.indicatorView.stopAnimating()
            })
        }else{
            fbFanpages?.removeAll(keepCapacity: false)
            articlesTableView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        let searchText = searchController.searchBar.text
        switch currentArticleTypeIndex {
            case 0:
                loadContentArticles(searchText, latestCount: ++loadContentCounter)
            case 1:
                loadPTTArticles(searchText)
            default:
                loadFBFanpage(searchText)
        }
    }
}
