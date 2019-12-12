//
//  OnboardingViewController.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 10/24/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var findRealBreadBtn: UIButton!
    
    var scrollWidth: CGFloat! = 0.0
    var scrollHeight: CGFloat! = 0.0
    
    // Data for the slides
    var titles = ["Find bakeries that make real bread.", "Get the inside scoop.", "Share your favorite bakeries!"]
    
    var descriptions = ["Use the map or the list to find bakeries that make real bread all around the world.", "Learn about each bakery's offerings along with important information about their hours and location.", "If you know of a bakery that makes real bread that isn't on the list, submit it for review."]
    
    var images = ["bread1", "bread4", "bread8"]
    
    // Get dynamic width and height of scrollView and save it
    override func viewDidLayoutSubviews() {
        scrollWidth = scrollView.frame.size.width
        scrollHeight = scrollView.frame.size.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call viewDidLayoutSubviews() and get dynamic width and height of scrollView
        self.view.layoutIfNeeded()
        
        // Assign delegates
        self.scrollView.delegate = self
        
        // Scroll View
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        // Page Control UI
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.9921568627, green: 0.8674790888, blue: 0.7740682373, alpha: 1)
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.9921568627, green: 0.7555645778, blue: 0.6809829309, alpha: 1)
        
        // Button UI
        view.backgroundColor = Appearance.Colors.background
        findRealBreadBtn.setTitleColor(Appearance.Colors.label, for: .normal)
        findRealBreadBtn.backgroundColor = Appearance.Colors.background
        findRealBreadBtn.layer.borderWidth = 0.25
        findRealBreadBtn.layer.borderColor = Appearance.Colors.tint.cgColor // roseRed.cgColor
        
        // Create the slides and add them
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        for index in 0..<titles.count {
            frame.origin.x = scrollWidth * CGFloat(index)
            frame.size = CGSize(width: scrollWidth, height: scrollHeight)
            
            let slide = UIView(frame: frame)
            
            // Subviews
            let imageView = UIImageView.init(image: UIImage.init(named: images[index]))
            imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
            imageView.contentMode = .scaleAspectFit
            imageView.center = CGPoint(x: scrollWidth/2, y: scrollHeight/2 - 50)
            
            let titleText = UILabel.init(frame: CGRect(x: 12, y: imageView.frame.maxY + 30, width: scrollWidth - 24, height: 30))
            titleText.textAlignment = .center
            titleText.numberOfLines = 0
            //titleText.adjustsFontSizeToFitWidth = true
            titleText.font = UIFont(name: "Amiri-Bold", size: 22)
            titleText.text = titles[index]
            if #available(iOS 13.0, *) {
                titleText.textColor = .label
            } else {
                titleText.textColor = .black
            }
            
            let descriptionText = UILabel.init(frame: CGRect(x: 32, y: titleText.frame.maxY + 10, width: scrollWidth - 64, height: 60))
            descriptionText.textAlignment = .center
            descriptionText.numberOfLines = 3
            descriptionText.adjustsFontSizeToFitWidth = true
            descriptionText.font = Appearance.thinFont
            descriptionText.text = descriptions[index]
            if #available(iOS 13.0, *) {
                descriptionText.textColor = .label
            } else {
                descriptionText.textColor = .black
            }
            
            slide.addSubview(imageView)
            slide.addSubview(titleText)
            slide.addSubview(descriptionText)
            scrollView.addSubview(slide)
        }
        
        // Set width of scrollView to accommodate all the slides
        scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(titles.count), height: scrollHeight)
        
        // Disable vertical scroll/bounce
        self.scrollView.contentSize.height = 1.0
        
        // Initial State
        pageControl.numberOfPages = titles.count
        pageControl.currentPage = 0
        
    }
    
    // Indicator
    @IBAction func pageChanged(_ sender: Any) {
        scrollView!.scrollRectToVisible(CGRect(x: scrollWidth * CGFloat ((pageControl?.currentPage)!), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndicatorForCurrentPage()
    }
    
    func setIndicatorForCurrentPage() {
        let page = (scrollView?.contentOffset.x)! / scrollWidth
        
        pageControl?.currentPage = Int(page)
    }
    

    
}


