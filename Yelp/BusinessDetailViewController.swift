//
//  BusinessDetailViewController.swift
//  Yelp
//
//  Created by Muin Momin on 2/12/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessDetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        navigationItem.title = business.name
        
        let location = CLLocationCoordinate2D(latitude: business.lat, longitude: business.long)
        
        let enclosure: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, enclosure, enclosure)
        map.setRegion(coordinateRegion,animated: true)
        map.setCenterCoordinate(location, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        map.addAnnotation(annotation)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
