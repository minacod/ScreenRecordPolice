//
//  AVPlayerView.swift
//  ScreenRecordPolice
//
//  Created by Mina Abdelfady on 7/26/20.
//  Copyright © 2020 Shafy. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import SnapKit

protocol PlayerDelegate {
    func rotateView(isToFullScreen:Bool)
}

class VideoPlayerWithControlsView : UIView{
    
    var url: URL! {
        didSet{
            player = AVPlayer(url: url)
            self.videoContainer.playerLayer.player = player
            addPeriodicTimeObserver()
        }
    }
    var playerDelegate : PlayerDelegate?
    var player : AVPlayer? = nil
    var playerLayer : AVPlayerLayer?
    
    let videoContainer = VideoContainerView()
    let play = UIButton()
    let seekBack = UIButton()
    let fullscreen = UIButton()
    
    
    var hasGoneFullScreen = false
    var isPlaying : Bool = false {
        didSet{
            if isPlaying {
                play.setTitle("pause", for: .normal)
            }
            else{
                play.setTitle("play", for: .normal)
            }
        }
    }
    
    var timeBeforeSeeking : Double?
    var seekBackIntervalInSec : Int = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViews()
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    override var layer: AVPlayerLayer {
        return super.layer as! AVPlayerLayer
    }
    
    func initViews(){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
        self.backgroundColor = .black
        
        self.addSubview(videoContainer)
        videoContainer.snp.makeConstraints{
            (maker) -> Void in
            maker.bottom.top.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(play)
        play.setTitle("play", for: .normal)
        play.setTitleColor(.systemBlue, for: .normal)
        play.setTitleColor(.systemGray, for: .highlighted)
        play.snp.makeConstraints{
            (maker) -> Void in
            maker.width.height.equalTo(50)
            maker.center.equalTo(self)
        }
        play.addTarget(self, action: #selector(playVideo), for: .touchDown)
        
        self.addSubview(seekBack)
        seekBack.setTitle("Back", for: .normal)
        seekBack.setTitleColor(.systemBlue, for: .normal)
        seekBack.setTitleColor(.systemGray, for: .highlighted)
        seekBack.snp.makeConstraints{
            (maker) -> Void in
            maker.width.height.equalTo(50)
            maker.centerY.leading.equalToSuperview()
        }
        seekBack.addTarget(self, action: #selector(seekVideoBack), for: .touchDown)
        
        self.addSubview(fullscreen)
        fullscreen.setTitle("full", for: .normal)
        fullscreen.setTitleColor(.systemBlue, for: .normal)
        fullscreen.setTitleColor(.systemGray, for: .highlighted)
        fullscreen.snp.makeConstraints{
            (maker) -> Void in
            maker.width.height.equalTo(50)
            maker.bottom.trailing.equalToSuperview()
        }
        fullscreen.addTarget(self, action: #selector(togglefullscreen), for: .touchDown)
        
        
        
    }
    
    
    func updateViews() {
        if hasGoneFullScreen{
            videoContainer.snp.remakeConstraints{
                (maker) -> Void in
                maker.height.equalTo(UIScreen.main.bounds.width)
                maker.width.equalTo(UIScreen.main.bounds.height)
                maker.center.equalTo(self)
            }
            
            play.snp.remakeConstraints{
                (maker) -> Void in
                maker.width.height.equalTo(50)
                if #available(iOS 11, *) {
                    maker.center.equalTo(safeAreaLayoutGuide)
                } else {
                    maker.center.equalTo(self)
                }
            }
            seekBack.snp.remakeConstraints{
                (maker) -> Void in
                maker.width.height.equalTo(50)
                if #available(iOS 11, *) {
                    maker.centerX.top.equalTo(safeAreaLayoutGuide)
                } else {
                    maker.centerX.top.equalTo(self)
                }
            }
            fullscreen.snp.remakeConstraints{
                (maker) -> Void in
                maker.width.height.equalTo(50)
                if #available(iOS 11, *) {
                    maker.bottom.leading.equalTo(safeAreaLayoutGuide)
                } else {
                    maker.bottom.leading.equalTo(self)
                }
            }
        }else{
            videoContainer.snp.remakeConstraints{
                (maker) -> Void in
                maker.height.width.equalTo(self)
                maker.center.equalTo(self)
            }
            
            play.snp.remakeConstraints{
                (maker) -> Void in
                maker.width.height.equalTo(50)
                maker.center.equalTo(self)
            }
            seekBack.snp.remakeConstraints{
                (maker) -> Void in
                maker.width.height.equalTo(50)
                maker.centerY.leading.equalTo(self)
            }
            fullscreen.snp.remakeConstraints{
                (maker) -> Void in
                maker.width.height.equalTo(50)
                maker.bottom.trailing.equalTo(self)
            }
        }
    }
    
    func addPeriodicTimeObserver() {
        // Invoke callback every half second
        let interval = CMTime(seconds: 0.5,
                              preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) {
            [weak self] time in
            // update player transport UI
            print("timeNow \(CMTimeGetSeconds(time))")
            if self?.timeBeforeSeeking != nil {
                if (self?.timeBeforeSeeking)! < CMTimeGetSeconds(time) {
                    self?.seekBack.isHidden = false
                    self?.timeBeforeSeeking = 0
                }
                
            }
        }
        
    }
    
    @objc func playVideo() {
        if(!isPlaying){
            if(player == nil){
                player = AVPlayer(url: url)
                self.videoContainer.playerLayer.player = player
                addPeriodicTimeObserver()
            }
            player?.play()
            isPlaying = true
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
            
        }
        else{
            stopVideo()
        }
    }
    
    func stopVideo(){
        if let player = player {
            player.pause()
            isPlaying = false
        }
    }
    
    @objc func playerDidFinishPlaying() {
        player = nil
        isPlaying = false
    }
    
    @objc func seekVideoBack() {
        if let currentTime = (player?.currentItem?.currentTime()){
            timeBeforeSeeking = CMTimeGetSeconds(currentTime) + 0.2
            print("timeBeforeSeeking \(timeBeforeSeeking ?? 0)")
            player?.seek(to: currentTime - CMTimeMake(value: Int64(seekBackIntervalInSec * 1000000000), timescale: 1000000000))
            seekBack.isHidden = true
        }
    }
    
    @objc func togglefullscreen() {
        if !hasGoneFullScreen {
            hasGoneFullScreen = true
            goFullscreen()
            playerDelegate?.rotateView(isToFullScreen: hasGoneFullScreen)
            updateViews()
        }else{
            hasGoneFullScreen = false
            playerDelegate?.rotateView(isToFullScreen: hasGoneFullScreen)
            minimizeToFrame()
            updateViews()
        }
        
    }
    
}


// MARK: - FullScreen transation

extension CGAffineTransform {
    static let ninetyDegreeRotation = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
}

extension VideoPlayerWithControlsView {
    
    var fullScreenAnimationDuration: TimeInterval {
        return 0.15
    }
    
    func minimizeToFrame() {
        UIView.animate(withDuration: fullScreenAnimationDuration) {
            for layer in self.layer.sublayers ?? []{
                layer.setAffineTransform(.identity)
            }
        }
    }
    
    func goFullscreen() {
        UIView.animate(withDuration: fullScreenAnimationDuration) {
            for layer in self.layer.sublayers ?? []{
                layer.setAffineTransform(.ninetyDegreeRotation)
            }
        }
    }
}
