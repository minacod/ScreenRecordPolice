//
//  ViewController.swift
//  ScreenRecordPolice
//
//  Created by Mina Abdelfady on 7/15/20.
//  Copyright © 2020 Shafy. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var VideoView: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(preventScreenRecording), name: UIScreen.capturedDidChangeNotification, object: nil)
        VideoView.setTitle("Click To Watch", for: .normal)
        VideoView.addTarget(self, action: #selector(presentAV), for: .touchDown)
    }

    @objc func presentAV() {
        let url = URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")!
        let player = AVPlayer(url: url)
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.setValue(true, forKey: "requiresLinearPlayback")
        present(playerViewController, animated: true) {
          player.play()
        }
    }
    
    @objc func preventScreenRecording() {
        label.text = "You have Been Caught Video Stoped"
        VideoView.isEnabled = false
        navigationController?.dismiss(animated: true, completion: nil)
    }

}

