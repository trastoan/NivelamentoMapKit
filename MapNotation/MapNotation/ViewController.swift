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
    
    //User initial location
    var myLocation : CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    
    //Needed for the delegate
    var pokemon : PokemonTableViewControler!
    
    //Location pressed by the user
    var pressLocation : CLLocationCoordinate2D?
    
    var resultSearchController: UISearchController?
    var selectedPin: MKPlacemark?
    var allPokemon: [MKAnnotation] = []
    
    var mapItem: (map: MKMapItem, pin: MyPin)? = nil
    
    var gesture: UIGestureRecognizer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatingSearchBar()
        
        //Adding long press gesture
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.addMyPoint))
        longGesture.minimumPressDuration = 1.0
        self.mapView.addGestureRecognizer(longGesture)
        
        //Setting mapView and Location Manager Delegates
        self.locationManager.delegate = self
        self.mapView.delegate = self
        
        
        //Requesting user location authorization
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
            self.mapView.showsUserLocation = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addMyPoint(press : UIGestureRecognizer) {
        if press.state == .began{
            //Get the coordinate where the user pressed than performa segue
            performSegue(withIdentifier: "choosePoke", sender: self)
        }
    }
    
    //You will probably not need to change that
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
                //Create your custom pin here
            })
            
        }
    }

    
    //Changes map style
    @IBAction func selectMap(_ sender: UISegmentedControl) {
        //Use this to change mapStyle
    }
    
    //Zoom to user location
    @IBAction func zoomMyLocation(_ sender: AnyObject) {
        //Zoom to user location here
    }
    
    //Updating user location on the mapView
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Do something if you want
    }
    
    //Needs to be here
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERRO: --- \(error)")
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //Maybe you will want to use this
    }
    
    //TODO
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        print(self.mapView.centerCoordinate)
    }
    
    //adding custom Annotation
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if let customAnnotation = annotation as? MyPin{
//            /*let placemark = MKPlacemark(coordinate: annotation.coordinate, addressDictionary: nil)
//            let mapItem = MKMapItem(placemark: placemark)
//            
//            self.mapItem = (mapItem, customAnnotation)
//            self.showRoute.isEnabled = true*/
//            
//            return customAnnotation.annotationView!
//        }else{
//            return nil
//        }
//    }
    
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
        searchBar.placeholder = "Search for Pokémon or Places"
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
    func zoomIn(coordinate: CLLocationCoordinate2D){
        //To work with zoom you need to make a region
        
        
        
        
    }
}
