//
//  BakeryDetailViewController.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/19/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit
import GoogleMaps

class BakeryDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GMSMapViewDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var bakeryNameLabel: UILabel!
    @IBOutlet weak var bakeryAddressLabel: UILabel!
    @IBOutlet weak var bakeryHoursLabel: UILabel!
    @IBOutlet weak var bakeryWebsiteLabel: UILabel!
    
    @IBOutlet weak var sellsLoavesImageView: UIImageView!
    @IBOutlet weak var milledInHouseImageView: UIImageView!
    @IBOutlet weak var organicImageView: UIImageView!
    @IBOutlet weak var servesFoodImageView: UIImageView!
    
    @IBOutlet weak var sellsLoavesLabel: UILabel!
    @IBOutlet weak var milledInHouseLabel: UILabel!
    @IBOutlet weak var organicLabel: UILabel!
    @IBOutlet weak var servesFoodLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var bakery: Bakery?
    
    var imageURLs: [URL]?
    var imageURLStrings: [String] = []
    var bakeryImages: [UIImage] = []

    // Flow properties
    let targetDimension: CGFloat = 120
    let insetAmount: CGFloat = 32
    
    override func viewDidLoad() {
        mapView.delegate = self
        
        self.title = bakery?.name
        
        getImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Retrieve the layout and cast it to UICollectionViewFlowLayout
        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError("Unable to retrieve layout")
        }
        
        // Set the inset to 32
        layout.sectionInset = UIEdgeInsets(top: insetAmount, left: insetAmount, bottom: insetAmount, right: insetAmount)
        
        // Set the smallest line spacing to the largest of all the images
        layout.minimumLineSpacing = .greatestFiniteMagnitude
        
        // Set the direction of the user's scrolling to be swiping horizontally
        layout.scrollDirection = .horizontal
        
        mapViewSetUp()
        
        labelSetUp()
    }
    
    @IBAction func done(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func getImages() {
        
        let baseURL = URL(string: "https://maps.googleapis.com/maps/api/place/")!
        
        let apiKey = "AIzaSyBRMVPW8u3LagIW0t_geAdChN9BAKwb2yQ"
        
        //        guard let bakery = BakeryModelController.shared.bakery else {
        //            print("There is no bakery object available")
        //            return
        //
        //        }
        
        if BakeryModelController.shared.bakery != nil {
            
            for eachReference in BakeryModelController.shared.bakery!.photos {
                
                print(eachReference.photoReference)
                
                let photosURL = baseURL.appendingPathComponent("photo")
                
                var components = URLComponents(url: photosURL, resolvingAgainstBaseURL: true)
                
                let widthQueryItem = URLQueryItem(name: "maxwidth", value: "400")
                let searchQueryItem = URLQueryItem(name: "photoreference", value: eachReference.photoReference)
                let apiKeyQueryItem = URLQueryItem(name: "key", value: apiKey)
                
                components?.queryItems = [widthQueryItem, searchQueryItem, apiKeyQueryItem]
                
                guard let requestURL = components?.url else {
                    NSLog("Couldn't make requestURL from \(components)")
                    return
                }
                
                print(requestURL)
                
                //imageURLs?.append(requestURL)
                //print(imageURLs)
                
                imageURLStrings.append("\(baseURL)https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(eachReference.photoReference)&key=\(apiKey)")
                
            }
            
        }
        
        
    }
    
    func mapViewSetUp() {
        
        if bakery != nil {
            // Set initial view to the bakery
            let camera = GMSCameraPosition.camera(withLatitude: bakery?.geometry.location.lat ?? 0, longitude: bakery?.geometry.location.lng ?? 0, zoom: 5)
            mapView.camera = camera
            
            // Create a marker for Ibis Bakery
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: bakery?.geometry.location.lat ?? 0, longitude: bakery?.geometry.location.lng ?? 0)
            marker.title = "\(bakery!.name)"
            marker.snippet = "Get Directions 👆"
            marker.map = mapView
        }
    }
    
    func labelSetUp() {
        
        bakeryNameLabel.text = bakery?.name
        bakeryAddressLabel.text = bakery?.formattedAddress
        
        let hoursString = bakery?.openingHours.weekdayText.joined(separator: "\n")
        bakeryHoursLabel.text = hoursString
        bakeryWebsiteLabel.text = bakery?.website
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        performSegue(withIdentifier: "getDirectionsSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}



extension BakeryDetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return BakeryModelController.shared.photoReferences.count
        return imageURLStrings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BakeryImageCollectionViewCell.reuseIdentier, for: indexPath) as! BakeryImageCollectionViewCell
        
        if imageURLStrings != nil {
            for imageURLString in imageURLStrings {
                
                guard let imageURL = URL(string: imageURLString) else {
                    fatalError("Can't convert string to URL")
                }
                
                guard let imageData = try? Data(contentsOf: imageURL) else {
                    print("Cannot convert URL to data")
                    return cell }
                
                bakeryImages.append(UIImage(data: imageData) ?? UIImage(named: "bread gray")!)
            }
            cell.bakeryImageView.image = bakeryImages[indexPath.row]
            
        }
        
//        if imageURLs != nil {
//
//            for imageURL in imageURLs! {
//                guard let imageData = try? Data(contentsOf: imageURL) else { return cell }
//                //cell.bakeryImageView.image = UIImage(data: imageData)
//                bakeryImages.append(UIImage(data: imageData) ?? UIImage(named: "bread gray")!)
//            }
//
//            cell.bakeryImageView.image = bakeryImages[indexPath.row]
//
//        }
        

        
        //cell.bakeryImageView.image =
        
        return cell
    }
    
}
