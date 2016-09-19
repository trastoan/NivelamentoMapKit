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
    let locationManager = CLLocationManager()
    var pokemon : PokemonTableViewControler!
    var pressLocation : CLLocationCoordinate2D?
    
    var resultSearchController: UISearchController?
    var selectedPin: MKPlacemark?
    var allPokemon: [MKAnnotation] = []
    
    var mapItem: (map: MKMapItem, pin: MyPin)? = nil
    
    var gesture: UIGestureRecognizer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatingSearchBar()
        
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
        
        if segue.identifier == "showRoute" {
            let destination = segue.destination as! RouteViewController
            destination.mapItem = self.mapItem
        }
        
    }
    
    //Delegate that receives the pokemon and adds it to the map
    func pokemon(donePickingPokemon: String) {
        if let pressLocation = self.pressLocation {
    
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude:pressLocation.latitude, longitude: pressLocation.longitude), completionHandler: { (placemarks, error) in
                if error == nil{
                    if let placemark = placemarks?.first{
                        if let _ = placemark.areasOfInterest?.first{
                            if placemark.thoroughfare != nil{
                                let myPin = MyPin(withTitle: donePickingPokemon.capitalized, andLocationName: placemark.thoroughfare!, andCoordinate: pressLocation, andAnnotationImage: UIImage(named: donePickingPokemon)!)
                                self.mapView.addAnnotation(myPin)
                            }else{
                                let myPin = MyPin(withTitle: donePickingPokemon.capitalized, andLocationName: "unknow address", andCoordinate: pressLocation, andAnnotationImage: UIImage(named: donePickingPokemon)!)
                                self.mapView.addAnnotation(myPin)
                            }
                        }else if let title = placemark.thoroughfare{
                            let myPin = MyPin(withTitle: donePickingPokemon.capitalized, andLocationName: title, andCoordinate: pressLocation, andAnnotationImage: UIImage(named: donePickingPokemon)!)
                            self.mapView.addAnnotation(myPin)
                        }else{
                            let myPin = MyPin(withTitle: donePickingPokemon.capitalized, andLocationName: "unknowLocation", andCoordinate: pressLocation, andAnnotationImage: UIImage(named: donePickingPokemon)!)
                            self.mapView.addAnnotation(myPin)
                        }
                    }
                    
                }
            })
            
        }
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
    
    
    //Other way
    
//    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
//        if let annotation = annotation as? Artwork {
//            let identifier = "pin"
//            var view: MKPinAnnotationView
//            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//                as? MKPinAnnotationView { // 2
//                dequeuedView.annotation = annotation
//                view = dequeuedView
//            } else {
//                // 3
//                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                view.canShowCallout = true
//                view.calloutOffset = CGPoint(x: -5, y: 5)
//                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
//            }
//            return view
//        }
//        return nil
//    }
    //adding custom Annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let customAnnotation = annotation as? MyPin{
            /*let placemark = MKPlacemark(coordinate: annotation.coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            
            self.mapItem = (mapItem, customAnnotation)
            self.showRoute.isEnabled = true*/
            
            return customAnnotation.annotationView!
        }else{
            return nil
        }
    }
    
    func buttonAction() {
        self.performSegue(withIdentifier: "showRoute", sender: nil)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let customAnnotation = view.annotation as? MyPin{
            let placemark = MKPlacemark(coordinate: (view.annotation?.coordinate)!, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            
            self.gesture = UITapGestureRecognizer(target: self, action: #selector(self.buttonAction))
            view.addGestureRecognizer(self.gesture!)
            
            self.mapItem = (mapItem, customAnnotation)
            
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.removeGestureRecognizer(self.gesture!)
    }
    
}

extension ViewController {
    func creatingSearchBar() {
        
        //LocationSearchTable will appear when the searchBar init to search results
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        //Initializate searchBar with SearchController
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for Places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        //Change color Button Cancel from UISearchBar
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: UIControlState.normal)
        
        //Settings for a cool apresentation
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        //Initializating things from LocationSearchTable
        locationSearchTable.mapView = mapView
        locationSearchTable.handleSearchDelegate = self
    }
}

extension ViewController: HandleMapSearchProtocol {
    func dropPinZoomIn(placemark: MKPlacemark){
        //Cache the pin
        selectedPin = placemark
        //Clear existing pins
        //mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        //mapView.addAnnotation(annotation)
        //let span = MKCoordinateSpanMake(10, 10)
        let region = MKCoordinateRegionMakeWithDistance(placemark.coordinate, 300, 300)//(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
    func zoomIn(coordinate: CLLocationCoordinate2D){
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 300, 300)
        mapView.setRegion(region, animated: true)
    }
}
