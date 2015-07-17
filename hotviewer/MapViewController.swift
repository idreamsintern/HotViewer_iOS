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

    @IBOutlet var mapView:MKMapView!
    
    var fbCheckin:FBCheckin!
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        return annotationView
    }

    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

}
