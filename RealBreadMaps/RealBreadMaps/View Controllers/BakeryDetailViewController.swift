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
    @IBOutlet weak var bakeryWebsiteButton: UIButton!
    @IBOutlet weak var bakeryPhoneNumberButton: UIButton!
    
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
    
    var imageURLStrings: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.title = bakery?.name
        self.title = BakeryModelController.shared.currentBakeryName
        
        // Show the correct bakery
        for eachBakery in BakeryModelController.shared.bakeries {
            
            // Compare using name & address b/c can't pass an object from the map view
            // and need to account for multiple bakery locations with the same name
            if eachBakery.name == BakeryModelController.shared.currentBakeryName
                && eachBakery.formattedAddress == BakeryModelController.shared.currentBakeryAddress {
                
                self.bakery = eachBakery
            }
        }
        
        setupTheme()
        
        labelSetUp()
        
        populateTags()
        
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
        
        let defaultImageURL = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=CmRZAAAAKXl1BpFclUAmGrcHUZC1nmBk5Gu6SSrbegXHbrSJ2xSDKr13jDIpKAEQpTvJjU5u0IyITt0S5apoGvv5dL5IBdy1ET8Y2ccXpImRpP4xvWuwiD85fTb9i0_IWYjbpnzUEhDrSacgBovoAs-V4RHh3UsvGhQWHhbDYuBSid5EFV7bJ49sRqwL_g&key=\(GMSPlacesClientApiKey)"
        
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
        
        bakeryWebsiteButton.setTitle(bakery?.website, for: .normal)
        
        if bakery?.internationalPhoneNumber != nil {
            bakeryPhoneNumberButton.setTitle(bakery?.internationalPhoneNumber, for: .normal)
        } else {
            bakeryPhoneNumberButton.setTitle("Phone number unavailable", for: .normal)
        }
        
    }
    
    // Create URL Strings from each photoReference
    func createImageURLStrings() {
        
        let baseURL = URL(string: "https://maps.googleapis.com/maps/api/place/")!
        
        guard self.bakery?.photos != nil else { return }
            
        for eachReference in self.bakery!.photos! {
            imageURLStrings.append("\(baseURL)photo?maxwidth=400&photoreference=\(eachReference.photoReference)&key=\(GMSPlacesClientApiKey)")

        }
    }
    
    // Adjust tag images and labels to account for information in Firebase
    func populateTags() {
        
        for eachFirebaseBakery in BakeryModelController.shared.firebaseBakeries {
            if self.bakery?.placeId == eachFirebaseBakery.placeID {
                
                let selectedBakery = eachFirebaseBakery
                
                // Icon Color Adjustments
                
                // Organic
                if selectedBakery.organic == true {
                    
                    let organicIcon = UIImage(named: "organic red")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                    organicImageView.tintColor = .roseRed
                    organicImageView.image = organicIcon
                    
                    organicLabel.textColor = .black
                    
                } else if selectedBakery.organic == nil {
                    
                    let organicIcon = UIImage(named: "question")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                    organicImageView.tintColor = .lightGray
                    organicImageView.image = organicIcon
                    
                    organicLabel.textColor = .lightGray
                    
                } else {
                    
                    let organicIcon = UIImage(named: "organic red")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                    organicImageView.tintColor = .gray
                    organicImageView.image = organicIcon
                    
                    let attrString = NSAttributedString(string: "Sells Loaves",
                                                        attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                                                                     NSAttributedString.Key.strikethroughColor: UIColor.lightGray])
                    organicLabel.attributedText = attrString
                    organicLabel.textColor = .gray
                    
                }
                
                // Milled In-House
                if selectedBakery.milledInHouse == true {
                    
                    let milledIcon = UIImage(named: "mill red")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                    milledInHouseImageView.tintColor = .roseRed
                    milledInHouseImageView.image = milledIcon
                    
                    milledInHouseLabel.textColor = .black
                    
                } else if selectedBakery.milledInHouse == nil {
                    
                    let milledIcon = UIImage(named: "question")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                    milledInHouseImageView.tintColor = .lightGray
                    milledInHouseImageView.image = milledIcon
                    
                    milledInHouseLabel.textColor = .lightGray
                    
                } else {
                    
                    let milledIcon = UIImage(named: "mill red")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                    milledInHouseImageView.tintColor = .gray
                    milledInHouseImageView.image = milledIcon
                    
                    let attrsString = NSAttributedString(string: "Milled In-house",
                                                         attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                                                                      NSAttributedString.Key.strikethroughColor: UIColor.gray])
                    milledInHouseLabel.attributedText = attrsString
                    milledInHouseLabel.textColor = .gray
                    
                }
                
                // Serves Food
                if selectedBakery.servesFood == true {
                    
                    let servesFoodIcon = UIImage(named: "food red")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                    servesFoodImageView.tintColor = .roseRed
                    servesFoodImageView.image = servesFoodIcon
                    
                    servesFoodLabel.textColor = .black
                    
                } else if selectedBakery.servesFood == nil {
                    
                    let servesFoodIcon = UIImage(named: "question")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                    servesFoodImageView.tintColor = .lightGray
                    servesFoodImageView.image = servesFoodIcon
                    
                    servesFoodLabel.textColor = .lightGray
                    
                } else {
                    
                    let servesFoodIcon = UIImage(named: "food red")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                    servesFoodImageView.tintColor = .gray
                    servesFoodImageView.image = servesFoodIcon
                    
                    let attrsString = NSAttributedString(string: "Serves Food",
                                                         attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                                                                      NSAttributedString.Key.strikethroughColor: UIColor.gray])
                    servesFoodLabel.attributedText = attrsString
                    servesFoodLabel.textColor = .gray
                }
                
                // Sells Loaves
                if selectedBakery.sellsLoaves == true {
                    
                    let sellsLoavesIcon = UIImage(named: "bread red")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                    sellsLoavesImageView.tintColor = .roseRed
                    sellsLoavesImageView.image = sellsLoavesIcon
                    
                    sellsLoavesLabel.textColor = .black
                    
                } else if selectedBakery.sellsLoaves == nil {
                    
                    let sellsLoavesIcon = UIImage(named: "question")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                    sellsLoavesImageView.tintColor = .lightGray
                    sellsLoavesImageView.image = sellsLoavesIcon
                    
                    sellsLoavesLabel.textColor = .lightGray
                    
                } else {
                    
                    let sellsLoavesIcon = UIImage(named: "bread red")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                    sellsLoavesImageView.tintColor = .gray
                    sellsLoavesImageView.image = sellsLoavesIcon
                    
                    let attrsString = NSAttributedString(string: "Sells Loaves",
                                                         attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                                                                      NSAttributedString.Key.strikethroughColor: UIColor.gray])
                    sellsLoavesLabel.attributedText = attrsString
                    sellsLoavesLabel.textColor = .gray
                    
                }
                
            }
        }
    }
    
    // MARK: - Map Setup
    
    // Set up the map view
    func mapViewSetUp() {
        
        mapView.layer.borderWidth = 0.5
        mapView.layer.borderColor = UIColor.lightGray.cgColor
        
        if bakery != nil {
            // Set initial view to the bakery
            let camera = GMSCameraPosition.camera(withLatitude: bakery?.geometry.location.lat ?? 0, longitude: bakery?.geometry.location.lng ?? 0, zoom: 10)
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
        if let url = URL(string: (bakeryWebsiteButton.titleLabel?.text)!) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    // Call the phone number when tapped
    @IBAction func phoneNumberTapped(_ sender: Any) {
        
        // Format current phone number
        let formattedNumber = self.bakery?.internationalPhoneNumber?.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
        
        // Unwrap phone number
        guard let unwrappedFormattedNumber = formattedNumber else { return }
        
        // Call phone number
        if let phoneCallURL = URL(string: "telprompt://\(unwrappedFormattedNumber)") {
            let application: UIApplication = UIApplication.shared
            if application.canOpenURL(phoneCallURL) {
                if #available(iOS 13.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.open(phoneCallURL as URL)
                }
            }
        }
        
    }
    
    
    // When 'Done' is tapped, return to root view controller
    @IBAction func done(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // Label and Map appearance
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
    }
}


// Extension of UIImageView to load URLs, convert to data, then convert to a UIImage in a background queue, but load it to the image view on the main thread
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
