//
//  Reportservice.swift
//  321
//
//  Created by Student on 4/19/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MapKit
import CoreLocation
class Reportservice{
    
    public var annotationLocations = [CustomAnnotation]()
    private var annotationsFileLocation: URL!
    
    private init(){
        /*
       annotationLocations = [
            CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 37.33527476, longitude: -122.03254703), Title: "Policeman", ImageName: "Policeman" ),
            CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 37.333927, longitude: -122.047567),Title:"Construction", ImageName: "Construction" ),
            CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 37.330992, longitude: -122.032204), Title:"Slippery", ImageName: "Slippery"),
            CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 37.334507, longitude: -122.026968), Title: "Speeding", ImageName: "Speeding"),
            CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 37.334439, longitude: -122.035680), Title: "Traffic", ImageName: "Traffic")
        ]*/
    }
    static let shared = Reportservice()
    
    public func addAnnotationLocation(newLocation: CustomAnnotation){
        annotationLocations.append(newLocation)
        save(newlocation: newLocation)
    }
    
    public func getAllAnnotations() -> [CustomAnnotation]{
        return annotationLocations
    }
    
    private func load(){
        let rootReference = Database.database().reference()
        let annotationReference = rootReference.child("annotation")
        annotationReference.observe(.value) { (snap) in
            if let value = snap.value as? [String: Any]{
                print("value\(value)")
            }
        }
    }
    private func save(newlocation: CustomAnnotation){
        let rootReference = Database.database().reference()
        let annotationReference = rootReference.child("annotation")
            let location = ["latitude": newlocation.coordinate.latitude, "longitude": newlocation.coordinate.longitude, "Title": newlocation.title, "Image": newlocation.imageName] as [String : Any]
            annotationReference.childByAutoId().setValue(location)
    }
}
