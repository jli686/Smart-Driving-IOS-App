//
//  CollectionViewController.swift
//  321
//
//  Created by Student on 4/14/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Foundation
import UIKit
class CollectionViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout{
    var size : CGFloat = 0
    var curLat = 34.0274
    var curLog = -118.2896
    override func viewDidLoad() {
        size = (view.frame.size.width - 100)/3
    }
    var options = [ReportItem(image: UIImage(named:"Policeman"), title: "Policeman"), ReportItem(image: UIImage(named:"Traffic"), title: "Traffic"), ReportItem(image: UIImage(named:"No Entry"), title: "No Entry"),ReportItem(image: UIImage(named:"No Parking"), title: "No Parking"),ReportItem(image: UIImage(named:"Security Camera"), title: "Security Camera"),ReportItem(image: UIImage(named:"Headlight"), title: "Headlight"),ReportItem(image: UIImage(named:"Speeding"), title: "Speeding"),ReportItem(image: UIImage(named:"Construction"), title: "Construction"),ReportItem(image: UIImage(named:"Slippery"), title: "Slippery")]
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
       return CGSize(width: size, height: size + 50)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int{
        return options.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! CollectionViewCell
        cell.ImageView.image = options[indexPath.item].image
        cell.title.text = options[indexPath.item].title
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if identifier == "loadImage" {
                if let CollectionDetailViewController = segue.destination as? CollectionDetailViewController{
                    let indexPath = collectionView.indexPathsForSelectedItems!.first!.row
                    CollectionDetailViewController.title_ = options[indexPath].title
                    CollectionDetailViewController.Image_ = options[indexPath].image
                    CollectionDetailViewController.curLat = curLat
                    CollectionDetailViewController.curLog = curLog
                }
            }
        }
    }

}
