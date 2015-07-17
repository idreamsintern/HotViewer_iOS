//
//  RouteTableViewController.swift
//  hotviewer
//
//  Created by AndyChen on 2015/7/17.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import UIKit
import MapKit;

class RouteTableViewController: UITableViewController {

    var routeSteps = [MKRouteStep]()
    let reuseIdentifier = "stepCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return routeSteps.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.reuseIdentifier, forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = routeSteps[indexPath.row].instructions

        return cell
    }
}