//
//  RouteViewController.swift
//  HandsOnMapKit
//
//  Created by Clinton de Sá Barreto Maciel on 15/09/16.
//  Copyright © 2016 clintonsbm. All rights reserved.
//

import UIKit
import MapKit

class RouteViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    
    var instructions: [(instruction: String, distance: String)] = []
    
    var mapItem: (map: MKMapItem, pin: MyPin)? = nil
    
    //Tip: get user location throw locationManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func selectedTypeRoute(_ sender: UISegmentedControl) {
        //When the user change the transport type
        print("Segment index changed")
    }
}

extension RouteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.instructions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        cell?.textLabel?.numberOfLines = 4
        cell?.textLabel?.font = UIFont(name: "HoeflerText-Regular", size: 12)
        cell?.isUserInteractionEnabled = false
        
        //Cell text = instruction of certain step
        cell?.textLabel?.text = "fill"
        
        return cell!
    }
    
}


extension RouteViewController: MKMapViewDelegate {
    /*func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

    }*/
}





















