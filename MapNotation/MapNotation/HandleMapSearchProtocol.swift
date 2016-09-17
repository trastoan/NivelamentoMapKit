//
//  HandleMapSearchProtocol.swift
//  MapNotation
//
//  Created by Gabriel Cavalcante on 17/09/16.
//  Copyright © 2016 Yuri Saboia Felix Frota. All rights reserved.
//

import UIKit
import MapKit

//This protocol was created for the comunication between LocationSearchTable and ViewController
protocol HandleMapSearchProtocol {
    func dropPinZoomIn(placemark: MKPlacemark)
}
