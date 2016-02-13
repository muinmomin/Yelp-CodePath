//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MKMapViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var map: MKMapView!
    
    var businesses: [Business]!
    
    var searchBar: UISearchBar = UISearchBar()
    var onShowResultsOnMap: UIBarButtonItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        map.hidden = true
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        
        onShowResultsOnMap.image = UIImage(named: "map.png")
        onShowResultsOnMap.target = self
        onShowResultsOnMap.action = "showResultsInMap"
        
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = onShowResultsOnMap
        
        let enclosure: CLLocationDistance = 2500
        let centerLocation = CLLocationCoordinate2D(latitude: 37.785771, longitude: -122.406165)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(centerLocation, enclosure, enclosure)
        map.setRegion(coordinateRegion,animated: true)
        map.setCenterCoordinate(centerLocation, animated: true)

        Business.searchWithTerm("Food", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            self.loadMap()
        })
    }
    
    func loadMap() {
        map.removeAnnotations(map.annotations)
        for b in businesses {
            let location = CLLocationCoordinate2D(latitude: b.lat, longitude: b.long)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = b.name
            self.map.addAnnotation(annotation)
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    
    
    func search(query: String) {
        Business.searchWithTerm(query, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            self.loadMap()
        })
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        search(searchBar.text!) //safe to force unwrap because search will be disabled unless there's some text
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func showResultsInMap() {
        map.hidden = !map.hidden
        tableView.hidden = !tableView.hidden
        
        if tableView.hidden {
            onShowResultsOnMap.image = UIImage(named: "list.png")
        }
        else {
            onShowResultsOnMap.image = UIImage(named: "map.png")
        }
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetails" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let business = businesses![indexPath!.row]
            let detailVC = segue.destinationViewController as! BusinessDetailViewController
            detailVC.business = business
        }
    }

}
