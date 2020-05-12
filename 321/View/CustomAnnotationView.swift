//
//  CustomAnnotationView.swift
//  321
//
//  Created by Student on 4/16/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//
import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation{
    
    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var title: String?
    
    //var subtitle: String?
    
    var imageName: String?
    
    init(coordinate: CLLocationCoordinate2D, Title: String, ImageName: String) {
        self.coordinate = coordinate
        title = Title
        imageName = ImageName
        super.init()
    }
    
}
