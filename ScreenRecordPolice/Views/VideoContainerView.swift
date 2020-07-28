//
//  VideoContainerView.swift
//  ScreenRecordPolice
//
//  Created by Mina Abdelfady on 7/28/20.
//  Copyright © 2020 Shafy. All rights reserved.
//

import AVFoundation
import UIKit

class VideoContainerView: UIView {
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
