//
//  ViewController.swift
//  MapNotation
//
//  Created by Yuri Saboia Felix Frota on 9/13/16.
//  Copyright © 2016 Yuri Saboia Felix Frota. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, choosePokemonDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var myLocation : CLLocationCoordinate2D?
    var pressLocation : CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    var pokemon : PokemonTableViewControler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.addMyPoint))
        longGesture.minimumPressDuration = 1.0
        
        self.mapView.addGestureRecognizer(longGesture)
        
        self.locationManager.delegate = self
        self.mapView.delegate = self
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
            self.mapView.showsUserLocation = true
        }
    }
    
    func checkLocalizationPermission() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            print("Autorizado em uso")
        case .authorizedAlways:
            print("Autorizado Sempre")
        case .denied:
            print("Negado")
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            print("Não determinado")
        case .restricted:
            print("Restrito")
        }
    }
    
    func createAlert(_ text : String,andTitle title: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addMyPoint(press : UIGestureRecognizer) {
        if press.state == .began{
            let locationOnView = press.location(in: self.mapView)
            self.pressLocation = self.mapView.convert(locationOnView, toCoordinateFrom: self.mapView)
            performSegue(withIdentifier: "choosePoke", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "choosePoke"{
            self.pokemon = segue.destination as! PokemonTableViewControler
            self.pokemon.delegate = self
        }
        
    }
    func pokemon(donePickingPokemon: String) {
        if let pressLocation = self.pressLocation{
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude:pressLocation.latitude, longitude: pressLocation.longitude), completionHandler: { (placemarks, error) in
                if error == nil{
                    if let placemark = placemarks?.first{
                        if let title = placemark.areasOfInterest?.first{
                            if placemark.thoroughfare != nil{
                                let myPin = MyPin(withTitle: title, andLocationName: placemark.thoroughfare!, andCoordinate: pressLocation, andAnnotationImage: UIImage(named: donePickingPokemon)!)
                                self.mapView.addAnnotation(myPin)
                            }else{
                                let myPin = MyPin(withTitle: title, andLocationName: "unknow address", andCoordinate: pressLocation, andAnnotationImage: UIImage(named: donePickingPokemon)!)
                                self.mapView.addAnnotation(myPin)
                            }
                        }else if let title = placemark.thoroughfare{
                            let myPin = MyPin(withTitle: "myLocation", andLocationName: title, andCoordinate: pressLocation, andAnnotationImage: UIImage(named: donePickingPokemon)!)
                            self.mapView.addAnnotation(myPin)
                        }else{
                            let myPin = MyPin(withTitle: "myLocation", andLocationName: "unknowLocation", andCoordinate: pressLocation, andAnnotationImage: UIImage(named: donePickingPokemon)!)
                            self.mapView.addAnnotation(myPin)
                        }
                    }
                }
            })
        }
    }
    
    @IBAction func pinMyLocation(_ sender: AnyObject) {
        //Adds a pin to the center of the map
//        let pin = MyPin(withTitle: "New pin", andLocationName: "Something Happening Here", andCoordinate: self.mapView.centerCoordinate)
//        self.mapView.addAnnotation(pin)
    }

    
    //Changes map style
    @IBAction func selectMap(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.mapView.mapType = .standard
        case 1:
            self.mapView.mapType = .satellite
        case 2:
            self.mapView.mapType = .hybrid
        default:
            return
        }
    }
    
    //Zoom to user location
    @IBAction func zoomMyLocation(_ sender: AnyObject) {
        if let myLocation = self.myLocation{
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(myLocation, 300, 300)
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    //Updating user location on the mapView
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.myLocation = locations.first?.coordinate
    }
    
    //Needs to be here
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERRO: --- \(error)")
    }
    
    //Center user on screen
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 300, 300)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //TODO
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        print(self.mapView.centerCoordinate)
    }
    
    //adding custom Annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let customAnnotation = annotation as? MyPin{
            return customAnnotation.annotationView!
        }else{
            return nil
        }
    }
//
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        <#code#>
//    }
//    
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        <#code#>
//    }
    
}

