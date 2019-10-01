//
//  LandingViewController.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 9/27/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class LandingViewController: UIViewController {
    
    @IBOutlet weak var findBreadButton: UIButton!
    
    @IBOutlet weak var transparencyLabel: UILabel!
    
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        view.backgroundColor = UIColor.breadColor
        
        transparencyLabel.backgroundColor = .roseRed
        transparencyLabel.alpha = 0.5
        
        findBreadButton.backgroundColor = .clear
//        findBreadButton.backgroundColor = UIColor.roseRed
        findBreadButton.tintColor = UIColor.white
        findBreadButton.layer.borderColor = UIColor.white.cgColor
        findBreadButton.layer.borderWidth = 0.5
//        findBreadButton.layer.cornerRadius = 5
        
        self.view.bringSubviewToFront(findBreadButton)
        
        // Load the video from the app bundle
        let videoURL: NSURL = Bundle.main.url(forResource: "bread-art-edit", withExtension: "mp4")! as NSURL
        
        player = AVPlayer(url: videoURL as URL)
        player?.actionAtItemEnd = .none
        player?.isMuted = true
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        playerLayer.zPosition = -1
        
        playerLayer.frame = view.frame
        
        view.layer.addSublayer(playerLayer)
        
        player?.play()
        
        // Loop video
        NotificationCenter.default.addObserver(self, selector: #selector(loopVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for eachFirebaseBakery in BakeryModelController.shared.firebaseBakeries {
            BakeryModelController.shared.searchForBakery(with: eachFirebaseBakery.placeID) { (error) in
                    
                
            }
        }
    }
    
    @objc func loopVideo() {
        player?.seek(to: CMTime.zero)
        player?.play()
    }
    
    @IBAction func findBreadTapped(_ sender: Any) {
    }
    
    
    
}
