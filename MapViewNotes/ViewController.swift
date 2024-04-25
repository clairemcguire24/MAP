//
//  ViewController.swift
//  MapViewNotes
//
//  Created by CLAIRE MCGUIRE on 2/1/24.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapViewOutlet: MKMapView!
    
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation!
    
    var parks : [MKMapItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        mapViewOutlet.showsUserLocation = true
        locationManager.requestWhenInUseAuthorization()
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let center = CLLocationCoordinate2D(latitude: 42.2371, longitude: -88.3226)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1600, longitudinalMeters: 1600)
       // let center2 = locationManager.location!.coordinate
       // let region2 = MKCoordinateRegion(center: center2, span: span)
      
        mapViewOutlet.setRegion(region, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
        
    }


    @IBAction func buttonAct(_ sender: UIButton) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Parks"
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        request.region = MKCoordinateRegion(center: currentLocation.coordinate, span: span)
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response
            else {
                return
            }
            for mapItem in response.mapItems{
                self.parks.append(mapItem)
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.name
                self.mapViewOutlet.addAnnotation(annotation)
            }
        }
    }
}

