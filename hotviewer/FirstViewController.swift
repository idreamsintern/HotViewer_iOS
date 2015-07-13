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
    var allArticles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Data.getAllArticles({
            allArticles in
            
            self.allArticles = allArticles!
            dispatch_async(dispatch_get_main_queue(),{
                self.articlesTableView.reloadData()
            })
        })
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allArticles.count
    }
    var emptyImg = UIImage()
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellReuseIdentifier) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: self.cellReuseIdentifier)
        }
        
        let post = self.allArticles[indexPath.row]
        cell!.textLabel?.text = post.title
        cell!.detailTextLabel?.text = post.url
        
        switch post.type {
            case .Facebook:
                let fbPost = post as! FBPost
                cell!.imageView?.imageFromUrl(fbPost.thumbnailUrl)
                cell!.textLabel?.text = fbPost.pageName
            case .Forum:
                cell!.imageView?.image = emptyImg
            case .PTT:
                cell!.imageView?.image = emptyImg
        }

        return cell!
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let post = self.allArticles[indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string: post.url)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

