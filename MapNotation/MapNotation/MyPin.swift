//
//  MyPin.swift
//  MapNotation
//
//  Created by Yuri Saboia Felix Frota on 9/13/16.
//  Copyright © 2016 Yuri Saboia Felix Frota. All rights reserved.
//

import UIKit
import MapKit

class MyPin: NSObject, MKAnnotation {
    let title : String?
    let locationName : String
    let coordinate: CLLocationCoordinate2D
    let annotationImage : UIImage
    let pokemonImage : UIImage
    
    init(withTitle title:String, andLocationName locationName:String, andCoordinate coordinate: CLLocationCoordinate2D, andAnnotationImage image:UIImage) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        self.annotationImage = UIImage(named: "poke")!
        self.pokemonImage = image
    }
    
    
    var annotationView : MKAnnotationView? {
        let view = MKAnnotationView(annotation: self, reuseIdentifier: "myCustomAnnotation")
        view.image = self.annotationImage
        view.isEnabled = true
        view.canShowCallout = true
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        button.setImage(UIImage(named: "compass"), for: .normal)
        view.rightCalloutAccessoryView = button
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = self.pokemonImage
        
        view.leftCalloutAccessoryView = imageView
        
        return view
    }
    var subtitle: String? {
        return locationName
    }
}






























