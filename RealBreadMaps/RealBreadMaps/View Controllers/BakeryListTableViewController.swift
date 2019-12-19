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

    var firebaseBakeries: [FirebaseBakery] = []
    
    var filteredBakeries: [FirebaseBakery] = []
    
    lazy var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bakerySearchBar.delegate = self
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.view.backgroundColor = Appearance.Colors.tabBarTint
        bakerySearchBar.isTranslucent = false
        bakerySearchBar.barTintColor = Appearance.Colors.tabBarTint
        
        // Remove bottom border from navigation bar and search bar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backIndicatorImage = UIImage()
        bakerySearchBar.backgroundImage = UIImage()
        
        
        
        // Cells should determine their own height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        
        self.firebaseBakeries = BakeryModelController.shared.firebaseBakeries
        
        sortByDistance()
 
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
        
        if searchBarIsEmpty() == false {
            return filteredBakeries.count
        }

        return self.firebaseBakeries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bakeryCell", for: indexPath)
            
        guard let bakeryCell = cell as? BakeryTableViewCell else { return cell }
        
        // Clear image when loading new images
        bakeryCell.bakeryImageView.image = nil
        
        let defaultImageURL = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=CmRZAAAAKXl1BpFclUAmGrcHUZC1nmBk5Gu6SSrbegXHbrSJ2xSDKr13jDIpKAEQpTvJjU5u0IyITt0S5apoGvv5dL5IBdy1ET8Y2ccXpImRpP4xvWuwiD85fTb9i0_IWYjbpnzUEhDrSacgBovoAs-V4RHh3UsvGhQWHhbDYuBSid5EFV7bJ49sRqwL_g&key=\(GMSPlacesClientApiKey)"
        
        let baseURL = URL(string: "https://maps.googleapis.com/maps/api/place/")!
        
        bakeryCell.bakeryDistanceLabel.adjustsFontForContentSizeCategory = true
        bakeryCell.bakeryImageView?.layer.cornerRadius = 10
        bakeryCell.bakeryImageView?.layer.masksToBounds = true
        bakeryCell.bakeryNameLabel.textColor = Appearance.Colors.label
        bakeryCell.bakeryDistanceLabel.textColor = Appearance.Colors.label
        bakeryCell.bakeryAddressLabel.textColor = Appearance.Colors.label
        
        // Searched-for bakeries
        if searchBarIsEmpty() == false {
            
            // Clear image when loading new images
            bakeryCell.bakeryImageView.image = nil
            
            bakeryCell.bakeryNameLabel.text = BakeryListTableViewController.bakeryNameSpecifications(bakery: filteredBakeries[indexPath.row])
            
            if let splitAddressArray = filteredBakeries[indexPath.row].formattedAddress?.components(separatedBy: ", ") {
                bakeryCell.bakeryAddressLabel.text = determineAddressFormatting(array: splitAddressArray)
            } else {
                bakeryCell.bakeryAddressLabel.text = "Address unavailable"
            }
            
            if let unwrappedDistance = filteredBakeries[indexPath.row].distanceFromUser {
                bakeryCell.bakeryDistanceLabel.text = "\(BakeryMapViewController.self.convertMetersToMiles(of: unwrappedDistance)) miles away"
            } else {
                print("\(filteredBakeries[indexPath.row].name) does not have a distance from user")
                //bakeryCell.bakeryDistanceLabel.isHidden = true
            }
            
            if filteredBakeries[indexPath.row].photos == nil {
                bakeryCell.bakeryImageView.image = UIImage(named: "no_image_available")
            } else {
                let imageURLString = "\(baseURL)photo?maxwidth=400&photoreference=\(filteredBakeries[indexPath.row].photos![0])&key=\(GMSPlacesClientApiKey)"
                
                bakeryCell.bakeryImageView.loadImage(urlString: imageURLString)
                
                //print(imageURLString)
                //bakeryCell.bakeryImageView.load(url: URL(string: imageURLString)!)
            }
        
        // Full list of bakeries
        } else {
            
            bakeryCell.bakeryNameLabel.text = BakeryListTableViewController.bakeryNameSpecifications(bakery: firebaseBakeries[indexPath.row])
            
            if let splitAddressArray = firebaseBakeries[indexPath.row].formattedAddress?.components(separatedBy: ", ") {
                bakeryCell.bakeryAddressLabel.text = determineAddressFormatting(array: splitAddressArray)
            } else {
                bakeryCell.bakeryAddressLabel.text = "Address unavailable"
            }

            if let unwrappedDistance = firebaseBakeries[indexPath.row].distanceFromUser {
                bakeryCell.bakeryDistanceLabel.text = "\(BakeryMapViewController.self.convertMetersToMiles(of: unwrappedDistance)) miles away"
            } else {
                print("\(firebaseBakeries[indexPath.row].name) does not have a distance from user")
                //bakeryCell.bakeryDistanceLabel.isHidden = true
            }

            if firebaseBakeries[indexPath.row].photos == nil {
                bakeryCell.bakeryImageView.image = UIImage(named: "no_image_available")
                
            } else {
                let imageURLString = "\(baseURL)photo?maxwidth=400&photoreference=\(firebaseBakeries[indexPath.row].photos![0])&key=\(GMSPlacesClientApiKey)"
                
                bakeryCell.bakeryImageView.loadImage(urlString: imageURLString)
                
                //bakeryCell.bakeryImageView.load(url: URL(string: imageURLString)!)
                
            }
        }
        return bakeryCell
    }
    
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

        // Detail View Controller uses currentBakeryName to confirm which bakery to show - it needs to be reset to reflect the correct bakery after a detail view screen has been shown via map view selection
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
        self.tableView.reloadData()
    }
    
    func filterBakeries() {
        
        DispatchQueue.main.async {
            
            // Grab the text, make sure it's not empty
            guard let searchTerm = self.bakerySearchBar.text?.lowercased(), !searchTerm.isEmpty else {
                // If no search term, display all of the bakeries
                self.filteredBakeries = self.firebaseBakeries
                return
            }
            
            self.geocoder.geocodeAddressString(searchTerm) { (placemarks, error) in
                self.processResponse(withPlacemarks: placemarks, error: error)
            }
            
            // Filter through the array of bakeries to see if name of bakery or address contain the text entered by user
            let matchingBakeries = self.firebaseBakeries.filter({ $0.name?.lowercased().contains(searchTerm) ?? false || $0.formattedAddress?.lowercased().contains(searchTerm) ?? false })
            
            // Set the value of the filteredBakeries to the results of the filter
            self.filteredBakeries = matchingBakeries
            
         self.tableView.reloadData()
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return bakerySearchBar.text?.isEmpty ?? true
    }

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
            } else {
                print("No matching location found")
            }
        }
    }
    
}
