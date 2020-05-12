//
//  MapViewController.swift
//  321
//
//  Created by Student on 4/10/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Firebase
import FirebaseUI
import CodableFirebase
import CoreLocation
import UserNotifications

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var reportButton: UIButton!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reportTitle: UILabel!
    @IBOutlet weak var reportImage: UIImageView!
    @IBOutlet weak var numofThumbUpLabel: UILabel!
    let locationManager = CLLocationManager()
    let distanceSpan: CLLocationDistance = 1000
    var curLat = 37.33527476//34.0274
    var curLog = -122.03254703//-118.2896
    var numofThumbUp = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 0.0
        locationManager.requestWhenInUseAuthorization()
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .dark
        }
        MapView.showAnnotations(MapView.annotations, animated: true)
        let rootReference = Database.database().reference()
        let annotationReference = rootReference.child("annotation")
        annotationReference.observe(.value) { (snap) in
            if let value_ = snap.value as? [String: AnyObject]{
                do {
                    for (_, value) in value_{
                         let model = try FirebaseDecoder().decode(Annotations.self, from: value)
                         print(model)
                        let onelocation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: model.latitude, longitude: model.longitude), Title: model.Title, ImageName: model.Image )
                        Reportservice.shared.annotationLocations.append(onelocation)
                    }
                    //in main thread update UI interface
                    DispatchQueue.main.async {
                        self.createAllAnnotations()
                    }
                } catch let error{
                    print(error)
                }
                //print("value\(value_)")
            }
        }
        //createAllAnnotations()/*
        popUpView.isHidden = true
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true

        //popUpView.isOpaque = false;
        //popUpView.alpha = 0.8;
        MapView.showAnnotations(MapView.annotations, animated: true)
        let locationLatLog = CLLocation(latitude: curLat, longitude: curLog)
        zoomlevel(location: locationLatLog)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        if(status == .authorizedWhenInUse){
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
        let location = locations.first
        print("here")
        curLat = location!.coordinate.latitude
        curLog = location!.coordinate.longitude
        print("lat: \(location!.coordinate.latitude) long: \(location!.coordinate.longitude)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createAllAnnotations()
        super.viewWillAppear(animated)
        locationManager.stopUpdatingLocation()
        //let locationLatLog = CLLocation(latitude: curLat, longitude: curLog)
        //zoomlevel(location: locationLatLog)
        locationManager.startUpdatingLocation()
    }
    
    @objc func appDidEnterBackground(notification: Notification){ print("Entering background \(notification)")
        print("hahahhaah")
    }
    func zoomlevel(location: CLLocation){
        let MapCoordinates = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distanceSpan, longitudinalMeters: distanceSpan)
        MapView.setRegion(MapCoordinates, animated: true)
    }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !(annotation is MKUserLocation) else {
                return nil
            }

         let annotationIdentifier = "Identifier"
         var annotationView: MKAnnotationView?
         if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }

            if let annotationView = annotationView, let annotation = annotation as? CustomAnnotation, let image = annotation.imageName, let pinImage = UIImage(named: image){
            annotationView.canShowCallout = true
                //change the size of the image
                let size = CGSize(width: 32, height: 32)
                UIGraphicsBeginImageContext(size)
                pinImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()

            annotationView.image = resizedImage
        }
          return annotationView
        }
    
    func createAllAnnotations(){
        let locations = Reportservice.shared.getAllAnnotations()
        for oneLocation in locations {
            MapView.addAnnotation(oneLocation)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let collectionViewController = segue.destination as? CollectionViewController{
            collectionViewController.curLat = curLat
            collectionViewController.curLog = curLog
            }
        if let collectionDetailViewController = segue.source as?
            CollectionDetailViewController{
            curLat = collectionDetailViewController.curLat
            curLog = collectionDetailViewController.curLog
        }
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let reference = Storage.storage().reference().child("\(view.annotation!.coordinate.latitude)\(view.annotation!.coordinate.longitude)")
          print(reference)
        let placeholderImage = UIImage(named: ((view.annotation?.title)!)!)
        popUpView.isHidden = false
        reportImage.sd_setImage(with: reference, placeholderImage: placeholderImage)
        reportTitle.text = (view.annotation?.title)!
        let coordinate1 = CLLocation(latitude: curLat, longitude: curLog)
        let coordinate2 = CLLocation(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!)
        let distanceInMeters = coordinate1.distance(from: coordinate2)/1609
        let s = String(format: "%.2f", distanceInMeters)
        distanceLabel.text = (s + " miles away")
        
    }
    func mapView(_ mapView: MKMapView, didDeselect: MKAnnotationView){
        popUpView.isHidden = true
        numofThumbUp = 0
        numofThumbUpLabel.text = "\(numofThumbUp)"
    }
    
    @IBAction func thumbUpButtonDidTapped(_ sender: Any) {
        numofThumbUp = numofThumbUp+1
        numofThumbUpLabel.text = "\(numofThumbUp)"
    }
}
