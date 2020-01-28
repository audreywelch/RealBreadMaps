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
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var bakeryNameLabel: UILabel!
    @IBOutlet weak var bakeryAddressLabel: UILabel!
    @IBOutlet weak var bakeryHoursLabel: UILabel!
    @IBOutlet weak var bakeryWebsiteButton: UIButton!
    @IBOutlet weak var bakeryPhoneNumberButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var bottomColorBarLabel: UILabel!
    
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
    
    @IBOutlet weak var getDirectionsButton: UIButton!
    
    var firebaseBakery: FirebaseBakery?
    
    var imageURLStrings: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = BakeryModelController.shared.currentBakeryName
        
        // Show the correct bakery when tapped from mapView
        if firebaseBakery == nil {
            for eachBakery in BakeryModelController.shared.firebaseBakeries {

                // Compare using name & address b/c can't pass an object from the map view
                // and need to account for multiple bakery locations with the same name
                if eachBakery.name == BakeryModelController.shared.currentBakeryName
                    && eachBakery.formattedAddress == BakeryModelController.shared.currentBakeryAddress {

                    self.firebaseBakery = eachBakery
                }
            }
        }

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
        
        setupTheme()
        
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
        
        // Clear image when loading new images
        cell.bakeryImageView.image = nil
        
        //let defaultImageURL = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=CmRZAAAAKXl1BpFclUAmGrcHUZC1nmBk5Gu6SSrbegXHbrSJ2xSDKr13jDIpKAEQpTvJjU5u0IyITt0S5apoGvv5dL5IBdy1ET8Y2ccXpImRpP4xvWuwiD85fTb9i0_IWYjbpnzUEhDrSacgBovoAs-V4RHh3UsvGhQWHhbDYuBSid5EFV7bJ49sRqwL_g&key=\(GMSPlacesClientApiKey)"
        
        // If the bakery has no photos, display an "image unavailable" photo
        if self.firebaseBakery?.photos == nil {
            cell.bakeryImageView.image = UIImage(named: "no_image_available")
            
        // Otherwise, load the image URL into the image view
        } else if self.firebaseBakery!.photos != nil {
            
            cell.bakeryImageView.loadImage(urlString: imageURLStrings[indexPath.row])
            
            // cell.bakeryImageView.load(url: URL(string: imageURLStrings[indexPath.row]) ?? URL(string: defaultImageURL)!)
        }
        
        return cell
    }
    
    // MARK: - View Setup
    
    // Populate the labels with corresponding information
    func labelSetUp() {
        
        guard let firebaseBakery = firebaseBakery else { return }
        
        // NAME
        // Make sure name of bakery displayed is specific to its location
        bakeryNameLabel.text = BakeryListTableViewController.bakeryNameSpecifications(bakery: firebaseBakery)
        bakeryNameLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: Appearance.titleFontBoldAmiri!)
        bakeryNameLabel.adjustsFontForContentSizeCategory = true
        
        // ADDRESS
        bakeryAddressLabel.text = firebaseBakery.formattedAddress
        bakeryAddressLabel.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: Appearance.thinFont!)
        bakeryAddressLabel.adjustsFontForContentSizeCategory = true
        
        // HOURS
        if firebaseBakery.weekdayText != nil {
        //if bakery.openingHours?.weekdayText != nil {
            let hoursString = firebaseBakery.weekdayText?.joined(separator: "\n")
            bakeryHoursLabel.text = hoursString
        } else {
            bakeryHoursLabel.text = "Please visit website for hours."
        }
        bakeryHoursLabel.font = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: Appearance.thinSmallFont!)
        bakeryHoursLabel.adjustsFontForContentSizeCategory = true
        
        // WEBSITE
        // Account for Bread Riot Bakehouse selling at the Farmer's Market
        if firebaseBakery.website != nil && firebaseBakery.placeID != "ChIJZ7vNGwP1UocRlrFBI9Tr-Ws" {
            bakeryWebsiteButton.setTitle(firebaseBakery.website, for: .normal)
        } else if firebaseBakery.website != nil && firebaseBakery.placeID == "ChIJZ7vNGwP1UocRlrFBI9Tr-Ws" {
            bakeryWebsiteButton.setTitle("https://breadriotbakehouse.com", for: .normal)
        } else {
            bakeryWebsiteButton.setTitle("Website unavailable", for: .normal)
            bakeryWebsiteButton.isEnabled = false
        }
        bakeryWebsiteButton.titleLabel?.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: Appearance.thinFont!)
        bakeryWebsiteButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        // PHONE NUMBER
        // Account for Bread Riot Bakehouse selling at the Farmer's Market
        if firebaseBakery.internationalPhoneNumber != nil && firebaseBakery.placeID != "ChIJZ7vNGwP1UocRlrFBI9Tr-Ws" {
            bakeryPhoneNumberButton.setTitle(firebaseBakery.internationalPhoneNumber, for: .normal)
        } else {
            bakeryPhoneNumberButton.setTitle("Phone number unavailable", for: .normal)
        }
        bakeryPhoneNumberButton.titleLabel?.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: Appearance.thinFont!)
        bakeryPhoneNumberButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        // INFO
        infoLabel.font = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: Appearance.thinSmallFont!)
        infoLabel.adjustsFontForContentSizeCategory = true
        
        // GET DIRECTIONS
        getDirectionsButton.titleLabel?.font = UIFontMetrics(forTextStyle: .title2).scaledFont(for: Appearance.onboardingBoldAmiri!)
        getDirectionsButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        // BOTTOM COLOR BAR
        bottomColorBarLabel.backgroundColor = .roseRed
        
    }
    
    // Create URL Strings from each photoReference
    func createImageURLStrings() {
        
        let baseURL = URL(string: "https://maps.googleapis.com/maps/api/place/")!
        
        guard self.firebaseBakery?.photos != nil else { return }
            
        for eachReference in self.firebaseBakery!.photos! {
            imageURLStrings.append("\(baseURL)photo?maxwidth=400&photoreference=\(eachReference)&key=\(GMSPlacesClientApiKey)")

        }
    }
    
    // Adjust tag images and labels to account for information in Firebase
    func populateTags() {
        
        guard let firebaseBakery = firebaseBakery else { return }
                
        if firebaseBakery.info == nil {
            infoLabel.isHidden = true
        } else {
            infoLabel.text = firebaseBakery.info
        }
                
        // Icon Color Adjustments
                
        // Organic
        if firebaseBakery.organic == true {
                    
            let organicIcon = UIImage(named: "organic red")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            organicImageView.tintColor = Appearance.Colors.tint //.roseRed
            organicImageView.image = organicIcon
                    
            organicLabel.textColor = Appearance.Colors.label
                    
        } else if firebaseBakery.organic == nil {
                    
            let organicIcon = UIImage(named: "question")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            organicImageView.tintColor = Appearance.Colors.tagDarkerShadow //.lightGray
            organicImageView.image = organicIcon
                    
            organicLabel.textColor = Appearance.Colors.tagDarkerShadow //.lightGray
                    
        } else {
                    
            let organicIcon = UIImage(named: "organic red")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            organicImageView.tintColor = Appearance.Colors.tagLighterShadow //.gray
            organicImageView.image = organicIcon
                    
            let attrString = NSAttributedString(string: "Sells Loaves",
                                                attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                                                             NSAttributedString.Key.strikethroughColor: UIColor.lightGray])
            
            organicLabel.attributedText = attrString
            organicLabel.textColor = Appearance.Colors.tagLighterShadow//.gray
                    
        }
                
        // Milled In-House
        if firebaseBakery.milledInHouse == true {
                    
            let milledIcon = UIImage(named: "mill red")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            milledInHouseImageView.tintColor = Appearance.Colors.tint//.roseRed
            milledInHouseImageView.image = milledIcon
                    
            milledInHouseLabel.textColor = Appearance.Colors.label
                    
        } else if firebaseBakery.milledInHouse == nil {
                    
            let milledIcon = UIImage(named: "question")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            milledInHouseImageView.tintColor = Appearance.Colors.tagDarkerShadow //.lightGray
            milledInHouseImageView.image = milledIcon
                    
            milledInHouseLabel.textColor = Appearance.Colors.tagDarkerShadow //.lightGray
                    
        } else {
                    
            let milledIcon = UIImage(named: "mill red")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            milledInHouseImageView.tintColor = Appearance.Colors.tagLighterShadow //.gray
            milledInHouseImageView.image = milledIcon
                    
            let attrsString = NSAttributedString(string: "Milled In-house",
                                                 attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                                                              NSAttributedString.Key.strikethroughColor: UIColor.gray])
            
            milledInHouseLabel.attributedText = attrsString
            milledInHouseLabel.textColor = Appearance.Colors.tagLighterShadow //.gray
                    
        }
                
        // Serves Food
        if firebaseBakery.servesFood == true {
                    
            let servesFoodIcon = UIImage(named: "food red")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            servesFoodImageView.tintColor = Appearance.Colors.tint //.roseRed
            servesFoodImageView.image = servesFoodIcon
                    
            servesFoodLabel.textColor = Appearance.Colors.label
                    
        } else if firebaseBakery.servesFood == nil {
                    
            let servesFoodIcon = UIImage(named: "question")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            servesFoodImageView.tintColor = Appearance.Colors.tagDarkerShadow //.lightGray
            servesFoodImageView.image = servesFoodIcon
                    
            servesFoodLabel.textColor = Appearance.Colors.tagDarkerShadow //.lightGray
                    
        } else {
                    
            let servesFoodIcon = UIImage(named: "food red")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            servesFoodImageView.tintColor = Appearance.Colors.tagLighterShadow //.gray
            servesFoodImageView.image = servesFoodIcon
                    
            let attrsString = NSAttributedString(string: "Serves Food",
                                                 attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                                                              NSAttributedString.Key.strikethroughColor: UIColor.gray])
            
            servesFoodLabel.attributedText = attrsString
            servesFoodLabel.textColor = Appearance.Colors.tagLighterShadow //.gray
        }
                
        // Sells Loaves
        if firebaseBakery.sellsLoaves == true {
                    
            let sellsLoavesIcon = UIImage(named: "bread red")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            sellsLoavesImageView.tintColor = Appearance.Colors.tint //.roseRed
            sellsLoavesImageView.image = sellsLoavesIcon
                    
            sellsLoavesLabel.textColor = Appearance.Colors.label
                    
        } else if firebaseBakery.sellsLoaves == nil {
                    
            let sellsLoavesIcon = UIImage(named: "question")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            sellsLoavesImageView.tintColor = Appearance.Colors.tagDarkerShadow //.lightGray
            sellsLoavesImageView.image = sellsLoavesIcon
                    
            sellsLoavesLabel.textColor = Appearance.Colors.tagDarkerShadow //.lightGray
                    
        } else {
                    
            let sellsLoavesIcon = UIImage(named: "bread red")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            sellsLoavesImageView.tintColor = Appearance.Colors.tagLighterShadow //.gray
            sellsLoavesImageView.image = sellsLoavesIcon
                    
            let attrsString = NSAttributedString(string: "Sells Loaves",
                                                 attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                                                              NSAttributedString.Key.strikethroughColor: UIColor.gray])
            
            sellsLoavesLabel.attributedText = attrsString
            sellsLoavesLabel.textColor = Appearance.Colors.tagLighterShadow //.gray
                    
        }
                
    }
    
    // MARK: - Map Setup
    
    // Set up the map view
    func mapViewSetUp() {
        
        mapView.layer.borderWidth = 0.5
        mapView.layer.borderColor = UIColor.lightGray.cgColor
        
        guard let firebaseBakery = firebaseBakery else { return }
        guard let firebaseBakeryName = firebaseBakery.name else { return }
        
        // Set initial view to the bakery
        let camera = GMSCameraPosition.camera(withLatitude: firebaseBakery.lat ?? 0, longitude: firebaseBakery.lng ?? 0, zoom: 12)
        mapView.camera = camera
            
        // Create a marker for Ibis Bakery
        let marker = GMSMarker()
        marker.icon = GMSMarker.markerImage(with: .roseRed)
        marker.position = CLLocationCoordinate2D(latitude: firebaseBakery.lat ?? 0, longitude: firebaseBakery.lng ?? 0)
        marker.title = "\(firebaseBakeryName)"
        
        // If location services is enabled, show the distance from user
        if let unwrappedDistance = firebaseBakery.distanceFromUser {
            marker.snippet = "\(BakeryMapViewController.self.convertMetersToMiles(of: unwrappedDistance)) miles" // "Get Directions 👆"
        }
        
        marker.map = mapView
        
    }
    
    // Map window tapped
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        // https://www.google.com/maps/dir/?api=1&destination=Lodge+Bread+Company
        
        guard let firebaseBakery = firebaseBakery else { return }
        
        guard let nameForURL = firebaseBakery.name?.replacingOccurrences(of: " ", with: "+").replacingOccurrences(of: "'", with: "") else { return }
        //print(nameForURL)
        
        if let url = URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(nameForURL)") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    // MARK: - Clickable Functionality
    
    @IBAction func getDirectionsButtonTapped(_ sender: Any) {
        
        // https://www.google.com/maps/dir/?api=1&destination=Lodge+Bread+Company
        
        guard let firebaseBakery = firebaseBakery else { return }
        
        guard let nameForURL = firebaseBakery.name?.replacingOccurrences(of: " ", with: "+").replacingOccurrences(of: "'", with: "") else { return }
        
        if let url = URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(nameForURL)") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    // When label is tapped, go to google maps
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        
        guard let firebaseBakery = firebaseBakery else { return }
        
        guard let nameForURL = firebaseBakery.name?.replacingOccurrences(of: " ", with: "+").replacingOccurrences(of: "'", with: "") else { return }
        
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
        
        guard let firebaseBakery = firebaseBakery else { return }
        
        // Format current phone number
        let formattedNumber = firebaseBakery.internationalPhoneNumber?.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
        
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
        
        getDirectionsButton.tintColor = Appearance.Colors.buttonText //.ibisRed
        getDirectionsButton.backgroundColor = Appearance.Colors.background
        getDirectionsButton.layer.borderColor = Appearance.Colors.tabBarItemTint.cgColor
        getDirectionsButton.layer.borderWidth = 0.3
        
        self.view.backgroundColor = .roseRed
        contentView.backgroundColor = Appearance.Colors.background
        collectionView.backgroundColor = Appearance.Colors.background
        
        bakeryNameLabel.textColor = Appearance.Colors.label
        bakeryAddressLabel.textColor = Appearance.Colors.label
        bakeryHoursLabel.textColor = Appearance.Colors.label
        infoLabel.textColor = Appearance.Colors.label
        
        // Map - Set the map style by passing the URL of the local file
        if #available(iOS 13.0, *) {
            mapStyling()
        } else {
            // Set the map style by passing the URL of the local file
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
    
    func mapStyling() {
        
        if #available(iOS 13.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .dark:
                do {
                    
                    if let styleURL = Bundle.main.url(forResource: "nightStyle", withExtension: "json") {
                        mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                    } else {
                        NSLog("Unable to find style.json")
                    }
                } catch {
                    NSLog("One or more of the map styles failed to load. \(error)")
                }
            case .light:
                do {
                    
                    if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                        mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                    } else {
                        NSLog("Unable to find style.json")
                    }
                } catch {
                    NSLog("One or more of the map styles failed to load. \(error)")
                }
            default:
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
        
    }
    
    
}


// Extension of UIImageView to load URLs, convert to data, then convert to a UIImage in a background queue, but load it to the image view on the main thread
extension UIImageView {
    
    // Load images from a cache
    func loadImage(urlString: String) {
        
        // Create an image cache using NSCache
        let imageCache = NSCache<NSString, UIImage>()
        
        // If the cache already contains the URLString as a key, return it
        if let cacheImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cacheImage
            return
        }
        
        // Create a url out of the urlString
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { ( data, response, error) in
            
            if let error = error {
                print("Couldn't download image: ", error)
                return
            }
            
            // Create data from the URL
            guard let data = data else { return }
            
            // Create an image from the data
            if let image = UIImage(data: data) {
                
                // Put the url and image into the cache
                imageCache.setObject(image, forKey: urlString as NSString)
                
                // Load the image asynchronously
                DispatchQueue.main.async {
                    self.image = image
                }
            }

        }.resume()
        
    }
    
    
//    // ORIGINAL LOAD
//    func load(url: URL) {
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
}
