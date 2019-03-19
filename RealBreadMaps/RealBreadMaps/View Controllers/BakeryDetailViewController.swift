//
//  BakeryDetailViewController.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/19/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit

class BakeryDetailViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Flow properties
    let targetDimension: CGFloat = 120
    let insetAmount: CGFloat = 32
    
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
    }
}

extension BakeryDetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BakeryImageCollectionViewCell.reuseIdentier, for: indexPath) as! BakeryImageCollectionViewCell
        
        //cell.bakeryImageView.image =
        
        return cell
    }
    
}
