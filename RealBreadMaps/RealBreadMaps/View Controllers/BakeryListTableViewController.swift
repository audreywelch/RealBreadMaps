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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bakerySearchBar.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bakeryCell", for: indexPath)
        
        return cell
    }
    
    // MARK: - UI Search Bar
    
    // Tell the delegate that the search button was tapped
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Grab the text, make sure it's not empty
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        
        // Run the search
    }
    
}
