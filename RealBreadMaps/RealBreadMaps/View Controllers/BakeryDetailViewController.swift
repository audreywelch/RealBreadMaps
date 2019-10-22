//
//  BakeryDetailViewController.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/19/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit
import GoogleMaps

class BakeryDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GMSMapViewDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var bakeryNameLabel: UILabel!
    @IBOutlet weak var bakeryAddressLabel: UILabel!
    @IBOutlet weak var bakeryHoursLabel: UILabel!
    @IBOutlet weak var bakeryWebsiteLabel: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.title = bakery?.name
        self.title = BakeryModelController.shared.currentBakeryName
        
        // Show the correct bakery
        for eachBakery in BakeryModelController.shared.bakeries {
            if eachBakery.name == BakeryModelController.shared.currentBakeryName && eachBakery.formattedAddress == BakeryModelController.shared.currentBakeryAddress {
                self.bakery = eachBakery
            }
        }
        
        setupTheme()
        
        labelSetUp()
        
        mapViewSetUp()
        
        createImageURLStrings()
        
        setupLabelTap()
        
        // Delegates
        mapView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Retrieve the layout and cast it to UICollectionViewFlowLayout
        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError("Unable to retrieve layout")
        }

        // Set the direction of the user's scrolling to be swiping horizontally
        layout.scrollDirection = .horizontal
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        imageURLStrings = []
    }
    
    // MARK: - Collection View Data Source Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // If bakery.photos was not nil, create enough items as there are photos
        if imageURLStrings.count > 0 {
            return imageURLStrings.count
            
        // If bakery.photos was nil, imageURLStrings will be empty - return items to hold the "image not available" image
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Cast cell as a custom collection view cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BakeryImageCollectionViewCell.reuseIdentier, for: indexPath) as! BakeryImageCollectionViewCell
        
        let defaultImageURL = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=CmRZAAAAKXl1BpFclUAmGrcHUZC1nmBk5Gu6SSrbegXHbrSJ2xSDKr13jDIpKAEQpTvJjU5u0IyITt0S5apoGvv5dL5IBdy1ET8Y2ccXpImRpP4xvWuwiD85fTb9i0_IWYjbpnzUEhDrSacgBovoAs-V4RHh3UsvGhQWHhbDYuBSid5EFV7bJ49sRqwL_g&key=AIzaSyBRMVPW8u3LagIW0t_geAdChN9BAKwb2yQ"
        
        // If the bakery has no photos, display an "image unavailable" photo
        if self.bakery?.photos == nil {
            cell.bakeryImageView.image = UIImage(named: "no_image_available")
            
        // Otherwise, load the image URL into the image view
        } else if self.bakery!.photos != nil {
            cell.bakeryImageView.load(url: URL(string: imageURLStrings[indexPath.row]) ?? URL(string: defaultImageURL)!)
        }
        
        return cell
    }
    
    // MARK: - View Setup
    
    // Populate the labels with corresponding information
    func labelSetUp() {
        
        bakeryNameLabel.text = bakery?.name
        bakeryAddressLabel.text = bakery?.formattedAddress
        
        if bakery?.openingHours?.weekdayText != nil {
            let hoursString = bakery?.openingHours?.weekdayText.joined(separator: "\n")
            bakeryHoursLabel.text = hoursString
        } else {
            bakeryHoursLabel.text = "Please visit website for hours."
        }
        
        bakeryWebsiteLabel.setTitle(bakery?.website, for: .normal)
    }
    
    // Create URL Strings from each photoReference
    func createImageURLStrings() {
        
        let baseURL = URL(string: "https://maps.googleapis.com/maps/api/place/")!
        
        let apiKey = GMSPlacesClientApiKey
        
        guard self.bakery?.photos != nil else { return }
            
        for eachReference in self.bakery!.photos! {
        //for eachReference in BakeryModelController.shared.bakery!.photos! {
        imageURLStrings.append("\(baseURL)photo?maxwidth=400&photoreference=\(eachReference.photoReference)&key=\(apiKey)")
                
            //print(imageURLStrings)
        }
    }
    
    // MARK: - Map Setup
    
    // Set up the map view
    func mapViewSetUp() {
        
        mapView.layer.borderWidth = 0.5
        mapView.layer.borderColor = UIColor.lightGray.cgColor
        
        if bakery != nil {
            // Set initial view to the bakery
            let camera = GMSCameraPosition.camera(withLatitude: bakery?.geometry.location.lat ?? 0, longitude: bakery?.geometry.location.lng ?? 0, zoom: 5)
            mapView.camera = camera
            
            // Create a marker for Ibis Bakery
            let marker = GMSMarker()
            marker.icon = GMSMarker.markerImage(with: .roseRed)
            marker.position = CLLocationCoordinate2D(latitude: bakery?.geometry.location.lat ?? 0, longitude: bakery?.geometry.location.lng ?? 0)
            marker.title = "\(bakery!.name)"
            marker.snippet = "Get Directions 👆"
            marker.map = mapView
        }
    }
    
    // Map window tapped
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        // https://www.google.com/maps/dir/?api=1&destination=Lodge+Bread+Company
        
        guard let nameForURL = self.bakery?.name.replacingOccurrences(of: " ", with: "+").replacingOccurrences(of: "'", with: "") else { return }
        //print(nameForURL)
        
        if let url = URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(nameForURL)") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    // MARK: - Clickable Functionality
    
    // When label is tapped, go to google maps
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        guard let nameForURL = self.bakery?.name.replacingOccurrences(of: " ", with: "+").replacingOccurrences(of: "'", with: "") else { return }
        
        //print(nameForURL)
        
        if let url = URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(nameForURL)") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    // Create a UITapGestureRecognizer that calls the labelTapped() function
    func setupLabelTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.bakeryAddressLabel.isUserInteractionEnabled = true
        self.bakeryAddressLabel.addGestureRecognizer(labelTap)
    }
    
    // Leave the app to go to the bakery's website
    @IBAction func websiteURLTapped(_ sender: Any) {
        if let url = URL(string: (bakeryWebsiteLabel.titleLabel?.text)!) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    // When 'Done' is tapped, return to root view controller
    @IBAction func done(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // Icon Color Adjustments
    func setupTheme() {
        
        // Navigation Bar
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        titleLabel.text = self.title
        titleLabel.textColor = UIColor.white
        titleLabel.font = Appearance.titleFontBoldAmiri
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        self.navigationItem.titleView = titleLabel
        
        // Map - Set the map style by passing the URL of the local file
        do {
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        // Icons
        let milledIcon = UIImage(named: "mill red")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        milledInHouseImageView.tintColor = .roseRed
        milledInHouseImageView.image = milledIcon
        
        let organicIcon = UIImage(named: "organic red")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        organicImageView.tintColor = .roseRed
        organicImageView.image = organicIcon
        
        let servesFoodIcon = UIImage(named: "food red")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        servesFoodImageView.tintColor = .roseRed
        servesFoodImageView.image = servesFoodIcon
        
        let sellsLoavesIcon = UIImage(named: "bread red")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        sellsLoavesImageView.tintColor = .roseRed
        sellsLoavesImageView.image = sellsLoavesIcon
    }
}


// Extension of UIImageView to load URLS, convert to data, then convert to a UIImage in a background queue, but load it to the image view on the main thread
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
