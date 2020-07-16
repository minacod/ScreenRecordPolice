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
        let url = URL(string: "http://techslides.com/demos/sample-videos/small.mp4")!
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
    
    @IBAction func downloadVideo(_ sender: Any) {
        let videoUrl = "http://techslides.com/demos/sample-videos/small.mp4"
        
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let destinationUrl = docsUrl.appendingPathComponent("vid.mp4")
        if(FileManager().fileExists(atPath: destinationUrl.path)){
            print("\n\nfile already exists\n\n")
            let avAssest = AVAsset(url: destinationUrl)
            let playerItem = AVPlayerItem(asset: avAssest)
            
            let player = AVPlayer(playerItem: playerItem)
            let playerViewController = AVPlayerViewController()
            playerViewController.setValue(true, forKey: "requiresLinearPlayback")
            playerViewController.player = player
            
            self.present(playerViewController, animated: true, completion: {
                player.play()
            })
        }
        else{
            //DispatchQueue.global(qos: .background).async {
            var request = URLRequest(url: URL(string: videoUrl)!)
            request.httpMethod = "GET"
            _ = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if(error != nil){
                    print("\n\nsome error occured\n\n")
                    return
                }
                if let response = response as? HTTPURLResponse{
                    if response.statusCode == 200{
                        DispatchQueue.main.async {
                            if let data = data{
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic){
                                    print("\n\nurl data written\n\n")
                                    let baseUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

                                    let assetUrl = baseUrl.appendingPathComponent("vid.mp4")

                                    let url = assetUrl
                                    print(url)
                                    let avAssest = AVAsset(url: url)
                                    let playerItem = AVPlayerItem(asset: avAssest)


                                    let player = AVPlayer(playerItem: playerItem)
                                    let playerViewController = AVPlayerViewController()
                                    playerViewController.setValue(true, forKey: "requiresLinearPlayback")
                                    playerViewController.player = player

                                    self.present(playerViewController, animated: true, completion: {
                                        player.play()
                                    })
                                }
                                else{
                                    print("\n\nerror again\n\n")
                                }
                            }//end if let data
                        }//end dispatch main
                    }//end if let response.status
                }
            }).resume()
        }
    }
}

