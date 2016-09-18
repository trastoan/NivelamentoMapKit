//
//  RouteViewController.swift
//  HandsOnMapKit
//
//  Created by Clinton de Sá Barreto Maciel on 15/09/16.
//  Copyright © 2016 clintonsbm. All rights reserved.
//

import UIKit
import MapKit

class RouteViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    
    var instructions: [(instruction: String, distance: String)] = []
    
    var mapItem: (map: MKMapItem, pin: MyPin)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDirectionsWithType(segment: 0)
    }
    
    func getDirectionsWithType(segment: Int) {
        
        self.mapView.removeOverlays(self.mapView.overlays)
        
        self.instructions = []
        
        self.tableView.reloadData()
        
        let source = MKMapItem(placemark: MKPlacemark(coordinate: (self.locationManager.location?.coordinate)!, addressDictionary: nil))
        
        let destination = self.mapItem!.map
        self.mapView.addAnnotation(self.mapItem!.pin)
        
        //Creating region to display (mexer nisso)
        let region = MKCoordinateRegionMakeWithDistance((self.mapItem?.pin.coordinate)!, 300, 300)
        
        self.mapView.setRegion(region, animated: true)
        
        
        //Creating a request for directions
        let request: MKDirectionsRequest = MKDirectionsRequest()
        
        request.source = source
        //MKMapItem(placemark: source)
        
        request.destination = destination
        //MKMapItem(placemark: destination)
        
        request.requestsAlternateRoutes = false
        
        switch segment {
        case 0:
            request.transportType = .walking
        case 1:
            request.transportType = .automobile
        default:
            return
        }

        
        let directions = MKDirections(request: request)
        
        
        //Requesting directions from points A to B
        directions.calculate { (response, error) in
            if let route = response?.routes.first {
                self.mapView.add(route.polyline)
                
                var instructions:[(instruction: String, distance: String)] = []
                
                for step in route.steps {
                    //Instruction and distance in step
                    instructions.append((step.instructions, step.distance.description+" m"))
                }
                
                self.instructions = instructions
            }
            
            self.tableView.reloadData()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func selectedTypeRoute(_ sender: UISegmentedControl) {
        self.getDirectionsWithType(segment: sender.selectedSegmentIndex)
    }
}

extension RouteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.instructions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        cell?.textLabel?.numberOfLines = 4
        cell?.textLabel?.font = UIFont(name: "HoeflerText-Regular", size: 12)
        cell?.isUserInteractionEnabled = false
        
        //Cell text = instruction of certain step
        cell?.textLabel?.text = self.instructions[indexPath.row].instruction
        cell?.detailTextLabel?.text = self.instructions[indexPath.row].distance
        
        return cell!
    }
    
}


extension RouteViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        
        polylineRenderer.strokeColor = UIColor.yellow.withAlphaComponent(0.5)
        
        return polylineRenderer
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let customAnnotation = annotation as? MyPin{
            return customAnnotation.annotationView!
        }else{
            return nil
        }
    }
}





















