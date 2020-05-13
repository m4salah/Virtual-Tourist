//
//  PinAnnotation.swift
//  Virtual Tourist
//
//  Created by Mohamed Abdelkhalek Salah on 5/8/20.
//  Copyright © 2020 Mohamed Abdelkhalek Salah. All rights reserved.
//


import Foundation
import MapKit

class AnnotationPin: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    var pin: Pin
    
    init(coordinate: CLLocationCoordinate2D, pin: Pin) {
        self.coordinate = coordinate
        self.pin = pin
    }
}
