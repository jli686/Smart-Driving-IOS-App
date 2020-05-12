//
//  Location.swift
//  321
//
//  Created by Student on 4/12/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Foundation
import MapKit

class Location: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    init(coordinate: CLLocationCoordinate2D){
        self.coordinate = coordinate
    }
    
}
