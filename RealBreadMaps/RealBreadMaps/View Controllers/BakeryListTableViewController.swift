//
//  BakeryListTableViewController.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/19/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit
import CoreLocation

class BakeryListTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var bakerySearchBar: UISearchBar!

    // MARK: - Properties
    
    // Holds all bakeries
    var firebaseBakeries: [FirebaseBakery] = []
    
    // Holds bakeries that have been filtered to match search criteria
    var filteredBakeries: [FirebaseBakery] = []
    
    lazy var geocoder = CLGeocoder()
    var userSearchLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bakerySearchBar.delegate = self
        
        // Dismiss the keyboard when user scrolls
        tableView.keyboardDismissMode = .onDrag
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.view.backgroundColor = Appearance.Colors.tabBarTint
        bakerySearchBar.isTranslucent = false
        bakerySearchBar.barTintColor = Appearance.Colors.tabBarTint
        bakerySearchBar.placeholder = "Search by 'City, State'"
        
        // Remove bottom border from navigation bar and search bar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backIndicatorImage = UIImage()
        bakerySearchBar.backgroundImage = UIImage()
        
        // Cells should determine their own height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150

        // Set the local bakeries array to hold all the bakeries in held in the model controller
        self.firebaseBakeries = BakeryModelController.shared.firebaseBakeries
        
        // Sort the table view by the distance away from the user
        sortByDistance()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Reload table view if user taps back and then comes to the table view again
        tableView.reloadData()
    }
    
    // Sort the bakeries by distance away from user and reload the table view
    func sortByDistance() {

        if BakeryModelController.shared.userLocation == nil {
            firebaseBakeries.sort { (l1, l2) -> Bool in
                return l1.name ?? "" < l2.name ?? ""
            }
        } else {
            firebaseBakeries.sort { (l1, l2) -> Bool in
                return Double(l1.distanceFromUser!) < Double(l2.distanceFromUser!)
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

    }
    
    // MARK: - Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // If the search bar is being used
        if searchBarIsEmpty() == false {
            
            // Display cells for the amount of bakeries that have been filtered by search result
            return filteredBakeries.count
        }
        
        // Otherwise, return the amount for all bakeries
        return self.firebaseBakeries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "bakeryCell", for: indexPath)
        
        // Cast the cell as the custom bakery cell
        guard let bakeryCell = cell as? BakeryTableViewCell else { return cell }
        
        // Clear image when loading new images
        bakeryCell.bakeryImageView.image = nil
        
        let defaultImageURL = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=CmRZAAAAKXl1BpFclUAmGrcHUZC1nmBk5Gu6SSrbegXHbrSJ2xSDKr13jDIpKAEQpTvJjU5u0IyITt0S5apoGvv5dL5IBdy1ET8Y2ccXpImRpP4xvWuwiD85fTb9i0_IWYjbpnzUEhDrSacgBovoAs-V4RHh3UsvGhQWHhbDYuBSid5EFV7bJ49sRqwL_g&key=\(GMSPlacesClientApiKey)"
        
        let baseURL = URL(string: "https://maps.googleapis.com/maps/api/place/")!
        
        bakeryCell.bakeryImageView?.layer.cornerRadius = 10
        bakeryCell.bakeryImageView?.layer.masksToBounds = true
        
        bakeryCell.bakeryNameLabel.textColor = Appearance.Colors.label
        bakeryCell.bakeryNameLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: Appearance.tableViewFontTitles!)
        bakeryCell.bakeryNameLabel.adjustsFontForContentSizeCategory = true
        
        bakeryCell.bakeryDistanceLabel.textColor = Appearance.Colors.label
        bakeryCell.bakeryDistanceLabel.font = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: Appearance.thinSmallFont!)
        bakeryCell.bakeryDistanceLabel.adjustsFontForContentSizeCategory = true
        
        bakeryCell.bakeryAddressLabel.textColor = Appearance.Colors.label
        bakeryCell.bakeryAddressLabel.font = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: Appearance.thinSmallFont!)
        bakeryCell.bakeryAddressLabel.adjustsFontForContentSizeCategory = true
        
        // SEARCHED-FOR BAKERIES
        if searchBarIsEmpty() == false {
            
            // Clear image when loading new images
            bakeryCell.bakeryImageView.image = nil
            
            // Name Label
            bakeryCell.bakeryNameLabel.text = BakeryListTableViewController.bakeryNameSpecifications(bakery: filteredBakeries[indexPath.row])
            
            // Address Label
            if let splitAddressArray = filteredBakeries[indexPath.row].formattedAddress?.components(separatedBy: ", ") {
                bakeryCell.bakeryAddressLabel.text = determineAddressFormatting(array: splitAddressArray)
            } else {
                bakeryCell.bakeryAddressLabel.text = "Address unavailable"
            }
            
            // Distance Label
            if let lat = filteredBakeries[indexPath.row].lat,
                let lng = filteredBakeries[indexPath.row].lng {
                
                let bakeryLocation = CLLocation(latitude: lat, longitude: lng)
                
                // If the userSearchLocation is not nil
                if userSearchLocation != nil {
                    
                    // Return the distance in meters
                    let distanceFromTarget = bakeryLocation.distance(from: userSearchLocation!)
                    
                    // Display the distance in miles from the search target
                    bakeryCell.bakeryDistanceLabel.text = "\(BakeryMapViewController.self.convertMetersToMiles(of: distanceFromTarget)) miles from \(bakerySearchBar.text?.capitalized ?? "")"
                    
                // If userSearchLocation is nil, just display the distance from the user
                } else {
                    if let unwrappedDistance = filteredBakeries[indexPath.row].distanceFromUser {
                        bakeryCell.bakeryDistanceLabel.text = "\(BakeryMapViewController.self.convertMetersToMiles(of: unwrappedDistance)) miles from you"
                        
                    // If user has not supplied location, label will display "-- miles away"
                    } else {
                        print("\(String(describing: filteredBakeries[indexPath.row].name)) does not have a distance from user")
                    }
                }
            }
            
            // Photos
            if filteredBakeries[indexPath.row].photos == nil {
                bakeryCell.bakeryImageView.image = UIImage(named: "no_image_available")
            } else {
                let imageURLString = "\(baseURL)photo?maxwidth=400&photoreference=\(filteredBakeries[indexPath.row].photos![0])&key=\(GMSPlacesClientApiKey)"
                
                bakeryCell.bakeryImageView.loadImage(urlString: imageURLString)
            }
            
        // FULL LIST OF BAKERIES
        } else {
            
            // Name Label
            bakeryCell.bakeryNameLabel.text = BakeryListTableViewController.bakeryNameSpecifications(bakery: firebaseBakeries[indexPath.row])
            
            // Address Label
            if let splitAddressArray = firebaseBakeries[indexPath.row].formattedAddress?.components(separatedBy: ", ") {
                bakeryCell.bakeryAddressLabel.text = determineAddressFormatting(array: splitAddressArray)
            } else {
                bakeryCell.bakeryAddressLabel.text = "Address unavailable"
            }

            // Distance Label
            if let unwrappedDistance = firebaseBakeries[indexPath.row].distanceFromUser {
                bakeryCell.bakeryDistanceLabel.text = "\(BakeryMapViewController.self.convertMetersToMiles(of: unwrappedDistance)) miles from you"
            } else {
                print("\(String(describing: firebaseBakeries[indexPath.row].name)) does not have a distance from user")
            }

            // Photos
            if firebaseBakeries[indexPath.row].photos == nil {
                bakeryCell.bakeryImageView.image = UIImage(named: "no_image_available")
                
            } else {
                let imageURLString = "\(baseURL)photo?maxwidth=400&photoreference=\(firebaseBakeries[indexPath.row].photos![0])&key=\(GMSPlacesClientApiKey)"
                
                bakeryCell.bakeryImageView.loadImage(urlString: imageURLString)
                
            }
        }
        return bakeryCell
    }
    
    // MARK: - Helper Methods for formatting
    
    // Adjust address formatting to account for European/Global address lengths
    func determineAddressFormatting(array: [String]) -> String {
        
        switch array.count {
        case 2:
            return "\(array[0])\n\(array[1])"
        case 3:
            return """
            \(array[0])
            \(array[1]), \(array[2])
            """
        case 4:
            return """
            \(array[0])
            \(array[1]), \(array[2]), \(array[3])
            """
        case 5:
            return """
            \(array[0]), \(array[1])
            \(array[2]), \(array[3]), \(array[4])
            """
        default:
            return array.joined(separator: ", ")
        }
    }
    
    // Account for bakeries that use the same name in Google for their different locations
    // which don't match with their website/signage
    static func bakeryNameSpecifications(bakery: FirebaseBakery) -> String {
        
        if bakery.formattedAddress != nil && bakery.name != nil {
            if bakery.name == "Manresa Bread" {
                if bakery.formattedAddress!.contains("Los Gatos") {
                    return "Manresa Bread - Los Gatos"
                } else if bakery.formattedAddress!.contains("Los Altos") {
                    return "Manresa Bread - Los Altos"
                } else if bakery.formattedAddress!.contains("Campbell") {
                    return "Manresa Bread - Campbell All Day"
                }
            } else if bakery.name == "Lodge Bread Company" {
                if bakery.formattedAddress!.contains("Woodland Hills") {
                    return "Lodge Bread Company - Woodland Hills"
                }
            } else if bakery.name == "Tartine" {
                if bakery.formattedAddress!.contains("Los Angeles") {
                    return "Tartine - The Manufactory"
                }
            }
            return bakery.name!
        } else {
            return ""
        }
    }
    
    // MARK: - Segue Preparation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destinationVC = segue.destination as? BakeryDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
        
        var firebaseBakery: FirebaseBakery
        
        if searchBarIsEmpty() == false {
            firebaseBakery = filteredBakeries[indexPath.row]
            destinationVC.firebaseBakery = firebaseBakery

        } else {
            
            firebaseBakery = firebaseBakeries[indexPath.row]
            destinationVC.firebaseBakery = firebaseBakery
        }

        // If bakery was selected from the map view, Detail View Controller uses currentBakeryName
        // to confirm which bakery to show - it needs to be reset to reflect the correct bakery
        // after a detail view screen has been shown via map view selection
        BakeryModelController.shared.currentBakeryName = firebaseBakery.name
        BakeryModelController.shared.currentBakeryAddress = firebaseBakery.formattedAddress
    }
    
    // MARK: - UI Search Bar
    
    // Tell the delegate that the search button was tapped
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        filterBakeries()
        
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        self.tableView.reloadData()
    }
    
    func filterBakeries() {
        
        // Set filteredBakeries to none so that new searches don't get added on to the old ones
        filteredBakeries = []
        
        DispatchQueue.main.async {
            
            // Grab the text, make sure it's not empty
            guard let searchTerm = self.bakerySearchBar.text?.lowercased(), !searchTerm.isEmpty else {
                // If no search term, display all of the bakeries
                self.filteredBakeries = self.firebaseBakeries
                return
            }
            
            // IF THE SEARCH TERM IS A NAME
            // Not allowing search by name because it changes the distance to measure from a place it tries to find with the same name as the search term
            
            // Filter through the array of bakeries to see if name of bakery or address contain the text entered by user
//            let matchingBakeries = self.firebaseBakeries.filter({ $0.name?.lowercased().contains(searchTerm) ?? false })
                // || $0.formattedAddress?.lowercased().contains(searchTerm) ?? false })
//
//            // Set the value of the filteredBakeries to the results of the filter
//            self.filteredBakeries = self.filteredBakeries + matchingBakeries
            
            // IF THE SEARCH TERM IS A LOCATION
            // Geocode the searchTerm in case it is a location
            self.geocoder.geocodeAddressString(searchTerm) { (placemarks, error) in
                // Process response - this appends to filteredBakeries
                self.processResponse(withPlacemarks: placemarks, error: error)
                
                // Sort the order of the array based on distance from the target
                if let userSearchLocation = self.userSearchLocation {
                    self.filteredBakeries.sort { (l1, l2) -> Bool in
                        return Double( CLLocation(latitude: l1.lat!, longitude: l1.lng!)
                            .distance(from: userSearchLocation) )
                            < Double( CLLocation(latitude: l2.lat!, longitude: l2.lng!)
                                .distance(from: userSearchLocation) )
                    }
                }
                
                self.tableView.reloadData()
                
                // If there are no results for the searched-for bakery, display an alert controller
                if self.filteredBakeries.count == 0 {
                    
                    let ac = UIAlertController(title: "Sorry, I'm not aware of any real bread within 100 miles of that location! Please submit a bakery if you know of one.", message: nil, preferredStyle: .alert)
                    
                    ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                        self?.bakerySearchBar.text = ""
                        self?.tableView.reloadData()
                    })
                    
                    self.present(ac, animated: true)
                    
                }
            }
            
         self.tableView.reloadData()
        }
        
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return bakerySearchBar.text?.isEmpty ?? true
    }

    // Forward Geocoding
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
            
        } else {
            var location: CLLocation?
            
            // Select the first CLPlacemark instance
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            // Access the coordinate property - an instance of CLLocationCoordinate2D
            if let location = location {
                let coordinate = location.coordinate
                print("\(coordinate.latitude), \(coordinate.longitude)")
                
                userSearchLocation = location
                
                // Get distance from entered location to other bakeries, adding to the filteredBakeries
                // array if within 50 miles
                findDistance(target: location)
                
            } else {
                print("No matching location found")
            }
        }
    }
    
    // Finds distance from all bakeries to the target location
    // If within 50 miles, adds it to the filteredBakery array
    func findDistance(target: CLLocation) {
        
        for eachBakery in firebaseBakeries {
            
            guard let lat = eachBakery.lat, let lng = eachBakery.lng else { return }
            
            let bakeryLocation = CLLocation(latitude: lat, longitude: lng)
            
            // Returns the distance in meters
            let distanceFromTarget = bakeryLocation.distance(from: target)
            
            // If the bakery is within 100 miles == 160934 meters
            if distanceFromTarget < 160934 {
                // print("Adding \(eachBakery.name) to filtered array because it is \(distanceFromTarget) away from the searched place")
                
                filteredBakeries.append(eachBakery)
            }
            
        }
        
    }
    
}
