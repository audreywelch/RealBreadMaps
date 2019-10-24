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
        
        view.backgroundColor = UIColor.videoBlackColor //breadColor
        
        //transparencyLabel.backgroundColor = .black//.brown//.breadColor //.roseRed
        //transparencyLabel.alpha = 0.5
        
        findBreadButton.backgroundColor = .clear
//        findBreadButton.backgroundColor = UIColor.roseRed
        findBreadButton.tintColor = UIColor.white
        findBreadButton.layer.borderColor = UIColor.white.cgColor
        findBreadButton.layer.borderWidth = 0.5
//        findBreadButton.layer.cornerRadius = 5
        
        self.view.bringSubviewToFront(findBreadButton)
        
        // Load the video from the app bundle
        let videoURL: NSURL = Bundle.main.url(forResource: "bread gif v1", withExtension: "mov")! as NSURL
        //let videoURL: NSURL = Bundle.main.url(forResource: "bread-art-v2-edit", withExtension: "mov")! as NSURL
        //let videoURL: NSURL = Bundle.main.url(forResource: "bread-art-edit", withExtension: "mp4")! as NSURL
        
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
        
        //animateButton()
        findBreadButton.blink()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
//    func animateButton() {
//
//        UIView.animate(withDuration: 1.0, delay: 2.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
//
//            // Flicker the logo
//
//            self.findBreadButton.alpha = 0.0
//            self.findBreadButton.alpha = 0
//            self.findBreadButton.alpha = 1.0
//            self.findBreadButton.alpha = 0
//
//        }, completion: nil)
//    }
    
    @objc func loopVideo() {
        player?.seek(to: CMTime.zero)
        player?.play()
    }
    
    @IBAction func findBreadTapped(_ sender: Any) {
    }
    
    
    
}

extension UIView {
    func blink() {
        self.alpha = 0.0
        UIView.animate(withDuration: 1, delay: 2.0, options: [.allowUserInteraction, .curveLinear, .repeat, .autoreverse], animations: {self.alpha = 1.0}, completion: nil)
    }
}
