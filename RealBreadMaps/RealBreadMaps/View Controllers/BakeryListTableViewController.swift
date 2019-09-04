//
//  BakeryListTableViewController.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/19/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit

class BakeryListTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var bakerySearchBar: UISearchBar!
    
    let bakeryMapViewController = BakeryMapViewController()
    
    var bakeries: [Bakery] = []
    
    var filteredBakeries: [Bakery] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bakerySearchBar.delegate = self
        
        for eachBakeryID in bakeryMapViewController.bakeries {
            BakeryModelController.shared.searchForBakery(with: eachBakeryID.rawValue) { (error) in

                self.bakeries = BakeryModelController.shared.bakeries
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBarIsEmpty() == false {
            return filteredBakeries.count
        }
        return bakeries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bakeryCell", for: indexPath)
        
        if searchBarIsEmpty() == false {
            cell.textLabel?.text = filteredBakeries[indexPath.row].name
            cell.detailTextLabel?.text = filteredBakeries[indexPath.row].formattedAddress
        } else {
            cell.textLabel?.text = bakeries[indexPath.row].name
            cell.detailTextLabel?.text = bakeries[indexPath.row].formattedAddress
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? BakeryDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
        
        if searchBarIsEmpty() == false {
            let bakery = filteredBakeries[indexPath.row]
            destinationVC.bakery = bakery
        }
        
        let bakery = bakeries[indexPath.row]
        destinationVC.bakery = bakery  
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
            guard let searchTerm = self.bakerySearchBar.text, !searchTerm.isEmpty else {
                // If no search term, display all of the bakeries
                self.filteredBakeries = self.bakeries
                return
            }
            
            // Filter through the array of bakeries to see if name of bakery or address contain the text entered by user
            let matchingBakeries = self.bakeries.filter({ $0.name.contains(searchTerm) || $0.formattedAddress.contains(searchTerm) })
            
            // Set the value of the filteredBakeries to the results of the filter
            self.filteredBakeries = matchingBakeries
            
         self.tableView.reloadData()
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return bakerySearchBar.text?.isEmpty ?? true
    }

}
