//
//  SecondViewController.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/13.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import UIKit
import MapKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    let cellReuseIdentifier = "checkinCell"
    
    @IBOutlet weak var checkinsTableView: UITableView!
    let locationManager = CLLocationManager()
    
    var fbCheckins: [FBCheckin]?
    
    var refreshControl:UIRefreshControl = UIRefreshControl()
    var currentPage: Int = 1
    
    var indicatorView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        // Check if this method exists for iOS 7 compability
        if (locationManager.respondsToSelector(Selector("requestWhenInUseAuthorization"))) {
            // in iOS 8, request authorization when needed
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
                locationManager.startUpdatingLocation()
            } else {
                locationManager.requestWhenInUseAuthorization()
            }
        } else {
            // in iOS 7, just startUpdating
            locationManager.startUpdatingLocation()
        }
        
        self.checkinsTableView.estimatedRowHeight = CGFloat(400)
        self.checkinsTableView.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view, typically from a nib.
        
        indicatorView = getIndicatorView()
        indicatorView.startAnimating()
    }
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse || status == CLAuthorizationStatus.AuthorizedAlways {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        manager.stopUpdatingLocation()
        println("Current location = \(locValue.latitude) \(locValue.longitude)")
        SERAPI.instance.searchFBCheckin(coordinate: locValue, radius: 10, period: FBCheckinPeriod.Week, sort: FBCheckinSortType.Total) {
            (checkins: [FBCheckin]?) in
            self.fbCheckins = checkins
            self.checkinsTableView.reloadData()
            self.indicatorView.stopAnimating()
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fbCheckins?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellReuseIdentifier) as? FBCheckinCell
        
        if (indexPath.row % 2 == 1) {
            cell?.backgroundColor = UIColor(red: 240/255, green: 248/255, blue: 255/255, alpha: 1)
        } else {
            cell?.backgroundColor = UIColor.whiteColor()
        }
        
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
        var mapViewCtrl = segue.destinationViewController as! MapViewController
        mapViewCtrl.fbCheckin = (sender as? FBCheckin)
    }
    func tableView(tableView: UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var fbCheckIn = (fbCheckins?[indexPath.row] as FBCheckin?)
        self.performSegueWithIdentifier("showMapView", sender: fbCheckIn)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func homeScreen(segue:UIStoryboardSegue) {
    }
    
}

