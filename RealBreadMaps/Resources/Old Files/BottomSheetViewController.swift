//
//  BottomSheetViewController.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 10/30/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

//import UIKit
//
//class BottomSheetViewController: UIViewController {
//    
//    @IBOutlet weak var bakeryNameLabel: UILabel!
//    @IBOutlet weak var bakeryDistanceLabel: UILabel!
//    @IBOutlet weak var bakeryAddressLabel: UILabel!
//    @IBOutlet weak var bakeryImageView: UIImageView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        //self.view.backgroundColor = .clear
//        
//        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomSheetViewController.panGesture))
//        view.addGestureRecognizer(gesture)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        prepareBackgroundView()
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        UIView.animate(withDuration: 0.3) { [weak self] in
//            let frame = self?.view.frame
//            let yComponent = UIScreen.main.bounds.height - 200
//            self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
//        }
//    }
//    
//    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
//        let translation = recognizer.translation(in: self.view)
//        let y = self.view.frame.minY
//        self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
//        recognizer.setTranslation(CGPoint.zero, in: self.view)
//    }
//    
//    func prepareBackgroundView() {
//        let blurEffect = UIBlurEffect.init(style: .extraLight)
//        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
//        let blurredView = UIVisualEffectView.init(effect: blurEffect)
//        blurredView.contentView.addSubview(visualEffect)
//        
//        visualEffect.frame = UIScreen.main.bounds
//        blurredView.frame = UIScreen.main.bounds
//        
//        view.insertSubview(blurredView, at: 0)
//    }
//}
