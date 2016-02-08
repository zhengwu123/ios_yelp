//
//  MapViewController.swift
//  Yelp
//
//  Created by New on 2/7/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate {
    
    var annotations: Array<MKPointAnnotation>!
    
    @IBOutlet var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var businesses: [Business]!
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 100
        // ask for permission to get user location
        locationManager.requestWhenInUseAuthorization()
        let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        goToLocation(centerLocation)
        loaddata()
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    //method to show user location
    /*
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
        }
    }
*/
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var inputText = ""
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        inputText = searchText
        Search(inputText)
        
    }
    
    var Searchannotations: Array<MKPointAnnotation>!
    func Search(searchTerm: String) {
        Business.searchWithTerm(searchTerm, sort: .Distance, categories: [], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            if(searchTerm != ""){
                if(self.Searchannotations != nil){
                self.mapView.removeAnnotations(self.Searchannotations)
                }
                self.businesses = businesses
            print("---------------")
            self.mapView.removeAnnotations(self.annotations)
            self.Searchannotations = []
            for business in businesses {
                
                let annotation = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: Double(business.latitude!), longitude: Double(business.longitude!))
                annotation.coordinate = coordinate
                annotation.title = business.name
                annotation.subtitle = business.address
                self.Searchannotations.append(annotation)
            }
            self.mapView.addAnnotations(self.Searchannotations)
            }
        }
    }

     func loaddata() {
        
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.annotations = []
            for business in businesses {
                
                    let annotation = MKPointAnnotation()
                    let coordinate = CLLocationCoordinate2D(latitude: Double(business.latitude!), longitude: Double(business.longitude!))
                    annotation.coordinate = coordinate
                    annotation.title = business.name
                    annotation.subtitle = business.address
                    self.annotations.append(annotation)
                }
                self.mapView.addAnnotations(self.annotations)
            
        })
}
       /* if let region = businesses["region"] as? Dictionary<String, Dictionary<String, Double>> {
            self.center = nil
            let center = CLLocationCoordinate2D(
                latitude: region["center"]!["latitude"]!,
                longitude: region["center"]!["longitude"]!
            )
            let span = MKCoordinateSpanMake(
                region["span"]!["latitude_delta"]!,
                region["span"]!["longitude_delta"]!
            )
            self.mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
        } else {
            println("error: unable to parse region in response")
        }
        
        self.annotations = []
        for business in results {
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: business.latitude!, longitude: business.longitude!)
            annotation.setCoordinate(coordinate)
            annotation.title = business.name
            annotation.subtitle = business.displayCategories
            self.annotations.append(annotation)
        }
        self.mapView.addAnnotations(self.annotations)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
*/

}
