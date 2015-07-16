//
//  SecondViewController.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/13.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let cellReuseIdentifier = "checkinCell"
    
    @IBOutlet weak var checkinsTableView: UITableView!
    
    
    var fbCheckins: [FBCheckin]?
    
    var refreshControl:UIRefreshControl = UIRefreshControl()
    var currentPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkinsTableView.estimatedRowHeight = CGFloat(400)
        self.checkinsTableView.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view, typically from a nib.
        searchFBCheckin(["coordinates": "25.041399,121.554233", "radius": "10", "period": FBCheckinPeriod.Week.rawValue, "sort": FBCheckinSortType.Total.rawValue], {
            checkins in
            self.fbCheckins = checkins
            self.checkinsTableView.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fbCheckins?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellReuseIdentifier) as? FBCheckinCell
        if let checkin = fbCheckins?[indexPath.row] as FBCheckin? {
            cell?.title?.text = checkin.name
            cell?.thumbnailURL = checkin.thumbnailURL
            if let number = checkin.checkins {
                cell?.content?.text = "打卡數：\(number)"
            }
        }
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

