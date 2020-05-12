//
//  HomeViewController.swift
//  321
//
//  Created by Student on 4/11/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Firebase
import FirebaseDatabase
import GoogleSignIn

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var email = "000"
    var uid = "000"
    var lat = 37.32645856
    var long = -122.02645995
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBAction func logoutButtonDidTapped(_ sender: UIButton){
          let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
    }
    @IBOutlet weak var LocationLabel2: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 0.0
        locationManager.requestWhenInUseAuthorization()
        //locationManager.startUpdatingLocation()
        let user = Auth.auth().currentUser
        if let user = user {
          // The user's ID, unique to the Firebase project.
          // Do NOT use this value to authenticate with your backend server,
          // if you have one. Use getTokenWithCompletion:completion: instead.
          uid = user.uid
          email = user.email!
          print(uid)
          print(email)
        }
        let address = CLGeocoder.init()
        address.reverseGeocodeLocation(CLLocation.init(latitude: lat, longitude:long)) { (places, error) in
            if error == nil{
                if let place = places?.first{
                    //here you can get all the info by combining that you can make address
                    self.greetingLabel.text = "\(place.subThoroughfare ?? "") \(place.thoroughfare ?? "")\n\(place.locality ?? ""), \(place.administrativeArea ?? "")"
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        if(status == .authorizedWhenInUse){
            manager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
        let location = locations.first
        lat = location!.coordinate.latitude
        long = location!.coordinate.longitude
        LocationLabel2?.text = "lat: \(location!.coordinate.latitude)"
        LocationLabel?.text = "long: \(location!.coordinate.longitude)"
        print("lat: \(location!.coordinate.latitude) long: \(location!.coordinate.longitude)")
    }
    override func viewWillAppear(_ animated: Bool) {
        LocationLabel2?.text = "lat: \(lat)"
        LocationLabel?.text = "long: \(long)"
    }
    
}
