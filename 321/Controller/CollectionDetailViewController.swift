//
//  CollectionDetailViewController.swift
//  321
//
//  Created by Student on 4/18/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import UIKit
import MapKit
import FirebaseStorage
import Firebase

class CollectionDetailViewController : UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //event
    let reportsUploadedSuccessfully = NSNotification.Name("reportsUploadedSuccessfully")
    @IBOutlet weak var cameraButton: UIButton!
    var comment: String!
    var title_ : String!
    var Image_ : UIImage!
    var curLat = 34.0274
    var curLog = -118.2896
    //var completionHandler: ((String, String) -> Void)?
    
    @IBAction func gotoCameraDidTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalPhoto = info[.originalImage]as! UIImage
        cameraButton.setImage(originalPhoto, for: [])
        
        //upload to firebase storage
        let image = originalPhoto
        let data = image.jpegData(compressionQuality : 1.0)
        let imageReference = Storage.storage().reference().child("\(curLat)\(curLog)")
        print(imageReference)
        imageReference.putData(data!, metadata: nil) { (metadata, err)in
            if let err = err {
                return
            }
            imageReference.downloadURL { (url, err) in
                if let downLoadUrl = url{
                    print(downLoadUrl)
                }
            }
        }
    }
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ReportImage: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func sendButtonDidTapped(_ sender: UIButton) {
        comment = commentTextField.text
        Reportservice.shared.addAnnotationLocation(newLocation: CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: curLat, longitude: curLog), Title: comment, ImageName: title_ ))
    
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title_
        //content.subtitle = "Please take care"
        content.body = "Please take care"
        content.sound = UNNotificationSound.default
        do{
        content.attachments = try [UNNotificationAttachment(identifier: title_, url: createLocalUrl(forImageNamed: title_)!, options: nil)]
        } catch{
            
        }
        content.threadIdentifier = "local notification temp"
        
        let date = Date(timeIntervalSinceNow: 1)
        let dataComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dataComponents, repeats: false)
        let request = UNNotificationRequest.init(identifier: "content", content:content, trigger: trigger)
        center.add(request) { (error) in
            if error != nil {
                print(error)
            }
        }
    }
    @IBAction func backButtonDidTapped(_sender: UIButton){
        
    }
    override func viewDidLoad() {
        backButton.layer.cornerRadius = 5
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor.black.cgColor
        sendButton.layer.cornerRadius = 5
        sendButton.layer.cornerRadius = 1
        sendButton.layer.borderColor = UIColor.black.cgColor
        titleLabel.text = title_
        ReportImage.image = Image_
    }
    @IBAction func TextFieldDismiss(_ sender: Any) {
        commentTextField.resignFirstResponder()
    }
     func createLocalUrl(forImageNamed name: String) -> URL? {
        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = cacheDirectory.appendingPathComponent("\(name).png")
        let path = url.path

        guard fileManager.fileExists(atPath: path) else {
            guard
                let image = UIImage(named: name),
                let data = image.pngData()
                else { return nil }

            fileManager.createFile(atPath: path, contents: data, attributes: nil)
            return url
        }

        return url
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        commentTextField.resignFirstResponder()
        return true
    }
    
}
