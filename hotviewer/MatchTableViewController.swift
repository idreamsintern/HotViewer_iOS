//
//  MatchTableViewController.swift
//  hotviewer
//
//  Created by AndyChen on 2015/7/25.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class MatchTableViewController: UITableViewController, MatchButtonDelegate, RequestMessageDelegate {
    var princess: Princess?
    var toolMan: ToolMan?
    var identity: Int = 0 // 0 = Princess, 1 = Toolman
    var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var newRequestButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        indicatorView = getIndicatorView()
        
        indicatorView.startAnimating()
        if identity == 0 {
            initPrincess()
        } else {
            initToolMan()
            // Toolman should not have request functionality
            newRequestButton.enabled = false
        }
        
        /*
        princess.updateRequestMessage("我想吃茹絲葵")
        var toolman = ToolMan(userId: userID) {
            
        }*/

    }
    func initPrincess() {
        princess = Princess(userId: FBSDKProfile.currentProfile().userID) {
            self.tableView.reloadData()
            self.indicatorView.stopAnimating()
        }
    }
    func initToolMan() {
        toolMan = ToolMan(userId: FBSDKProfile.currentProfile().userID) {
            self.tableView.reloadData()
            self.indicatorView.stopAnimating()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if identity == 0 {
            return princess?.toolmen.count ?? 0
        } else {
            return toolMan?.princesses.count ?? 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if identity == 0 {
            // If I am a princess
            // Display toolman picture
            let cell = tableView.dequeueReusableCellWithIdentifier("toolManCell", forIndexPath: indexPath) as! ToolManCell
            cell.iAlsoDoButton.tag = indexPath.row
            cell.delegate = self
            cell.thumbnailURL = princess?.toolmen[indexPath.row].thumbnailURL
            return cell
        } else {
            // If I am a toolman
            // Display princess picture with request message
            let cell = tableView.dequeueReusableCellWithIdentifier("princessCell", forIndexPath: indexPath) as! PrincessCell
            let princess = toolMan?.princesses[indexPath.row]
            cell.iDoButton.tag = indexPath.row
            cell.delegate = self
            cell.thumbnailURL = princess?.thumbnailURL
            cell.request.text = princess?.requestMessage
            return cell
        }
    }

    func iDoClick(numberOfRow: Int) {
        if identity == 0 {
            // If I am princess and I pick a toolman...
            princess?.removeSelf()
            self.initPrincess()
            // @TODO: Open Toolman's Facebook Page
        } else {
            // If I am toolman and I pick a princess...
            if let princess = toolMan?.princesses[numberOfRow] {
                princess.addToolMan(toolMan!.userId)
            }
        }
    }
    
    @IBAction func presentRequestSetting(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showRequestView", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRequestView" {
            let destination = segue.destinationViewController as! UINavigationController
            let requestViewController = destination.topViewController as! AddRequestTableViewController
            requestViewController.delegate = self
        }
        super.prepareForSegue(segue, sender: sender)
    }
    func newRequest(requestMsg: String) {
        princess?.updateRequestMessage(requestMsg)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        
    }

}
