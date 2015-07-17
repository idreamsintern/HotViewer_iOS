//
//  MapViewController.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/17.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController , MKMapViewDelegate{

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var fbCheckin:FBCheckin!
    var image:UIImage?
    let locationManager = CLLocationManager()
    
    var currentPlacemark:CLPlacemark?
    
    var currentRoute:MKRoute?
    
    var currentTransportType = MKDirectionsTransportType.Automobile
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the segmented control
        segmentedControl.hidden = true
        segmentedControl.addTarget(self, action: "showDirection:", forControlEvents: .ValueChanged)
        
        // Request for a user's authorization for location services
        locationManager.requestWhenInUseAuthorization()
        
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            self.mapView.showsUserLocation = true
        }
        
        mapView.delegate = self
        
        // Add Annotation
        let annotation = MKPointAnnotation()
        annotation.title = self.fbCheckin?.name
        annotation.coordinate = CLLocationCoordinate2D(latitude: fbCheckin.latitude!,longitude: fbCheckin.longitude!)
        self.mapView.showAnnotations([annotation], animated: true)
        self.mapView.selectAnnotation(annotation, animated: true)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let identifier = "MyPin"
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        // Reuse the annotation if possible
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRectMake(0, 0, 53, 53))
        //leftIconView.image = UIImage(data: fbCheckin.thumbnailURL)

        if let url = fbCheckin.thumbnailURL {
            SimpleCache.sharedInstance.getImage(url) { image, error in
                if let err = error {
                    println(err)
                } else if let fullImage = image {
                    leftIconView.image = fullImage
                }
            }
        }
        
        annotationView.leftCalloutAccessoryView = leftIconView
        annotationView.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIView
        
        return annotationView
    }
    
    
    @IBAction func showDirection(sender: AnyObject) {
       
        if segmentedControl.selectedSegmentIndex == 0 {
            currentTransportType = MKDirectionsTransportType.Automobile
        } else {
            currentTransportType = MKDirectionsTransportType.Walking
        }
        segmentedControl.hidden = false
        
        let directionRequest = MKDirectionsRequest()
        
        // Set the source and destination of the route
        directionRequest.setSource(MKMapItem.mapItemForCurrentLocation())
        let destinationPlacemark = MKPlacemark(placemark: currentPlacemark)
        directionRequest.setDestination(MKMapItem(placemark: destinationPlacemark))
        directionRequest.transportType = currentTransportType
        
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        directions.calculateDirectionsWithCompletionHandler { (routeResponse, routeError) -> Void in
            
            if routeError != nil {
                println("Error: \(routeError.localizedDescription)")
            } else {
                let route = routeResponse.routes[0] as! MKRoute
                self.currentRoute = route
                self.mapView.removeOverlays(self.mapView.overlays)
                self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.AboveRoads)
                
                // Scale the map
                let rect = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            }
        }
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        self.performSegueWithIdentifier("showSteps", sender: view)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = (currentTransportType == .Automobile) ? UIColor.blueColor() : UIColor.orangeColor()
        renderer.lineWidth = 3.0
        
        return renderer
    }

    

    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showSteps" {
            let destinationController = segue.destinationViewController as! UINavigationController
            let routeTableViewController = destinationController.childViewControllers.first as! RouteTableViewController
            if let steps = currentRoute?.steps as? [MKRouteStep] {
                routeTableViewController.routeSteps = steps
            }
        }
    }

}
