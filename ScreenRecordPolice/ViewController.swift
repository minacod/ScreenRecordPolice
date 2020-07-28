//
//  ViewController.swift
//  ScreenRecordPolice
//
//  Created by Mina Abdelfady on 7/15/20.
//  Copyright © 2020 Shafy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var videoView: VideoPlayerWithControlsView!
    @IBOutlet weak var qrScanner: QRScannerView!
    
    var orignalFrame : CGRect = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(preventScreenRecording), name: UIScreen.capturedDidChangeNotification, object: nil)
        //videoView.url =  URL(string: "http://techslides.com/demos/sample-videos/small.mp4")!
        videoView.url =  URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4")!
        videoView.playerDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        DownloadManger.shared.calculateProgress(completionHandler: {
            _ in
        })
        qrScanner.startScanning()
        qrScanner.delegate = self
    }
    
    @objc func presentAV() {
        
    }
    
    @IBAction func moveToTableView(_ sender: Any) {
        navigationController?.pushViewController(TableViewController(), animated: true)
    }
    
    
    @objc func preventScreenRecording() {
        label.text = "You have Been Caught Video Stoped"
        //VideoView.isEnabled = false
        UIView.transition(with: self.view, duration: 0.5, options:.transitionCrossDissolve,
                                  animations: {
                                      self.view.viewWithTag(1000)?.removeFromSuperview()}, completion: nil)
        videoView.stopVideo()
    }
    
 
//    @IBAction func downloadVideo(_ sender: Any) {
//        let videoUrl = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4"
//        
//        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//
//        let destinationUrl = docsUrl.appendingPathComponent("1.mp4")
//        if(FileManager().fileExists(atPath: destinationUrl.path)){
//            print("\n\nfile already exists\n\n \(destinationUrl)")
//            let avAssest = AVAsset(url: destinationUrl)
//            let playerItem = AVPlayerItem(asset: avAssest)
//
//            let player = AVPlayer(playerItem: playerItem)
//            let playerViewController = AVPlayerViewController()
//            playerViewController.setValue(true, forKey: "requiresLinearPlayback")
//            playerViewController.player = player
//
//            self.present(playerViewController, animated: true, completion: {
//                player.play()
//            })
//        }
//        else{
//            //DispatchQueue.global(qos: .background).async {
//            var request = URLRequest(url: URL(string: videoUrl)!)
//            request.httpMethod = "GET"
//
//            DownloadManger.shared.urlSession.downloadTask(with: request).resume()
//
//
//        }
//    }
    
}

extension ViewController: QRScannerViewDelegate {
    func qrScanningDidStop() {
    }
    
    func qrScanningDidFail() {
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        self.label.text = str
    }
    
    
    
}

extension ViewController {
    var fullScreenAnimationDuration: TimeInterval {
         return 0.15
     }

     func minimizeToFrame() {
         UIView.animate(withDuration: fullScreenAnimationDuration) {
            self.videoView.snp.remakeConstraints{
                maker in
                let safeArea = self.view.safeAreaLayoutGuide
                maker.leading.equalTo(safeArea).offset(20)
                maker.trailing.equalTo(safeArea).offset(-20)
                maker.bottom.equalTo(safeArea)
                maker.height.equalTo(243)
            }
         }
     }

     func goFullscreen() {
         UIView.animate(withDuration: fullScreenAnimationDuration) {
            self.videoView.snp.remakeConstraints{
                maker in
                maker.bottom.top.leading.trailing.equalToSuperview()
            }
         }
    }
}

extension ViewController : PlayerDelegate {
    
    func rotateView(isToFullScreen: Bool) {
        if isToFullScreen {
            goFullscreen()
        }else{
            minimizeToFrame()
        }
    }

}
