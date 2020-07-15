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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(preventScreenRecording), name: UIScreen.capturedDidChangeNotification, object: nil)
        
    }

    @objc func preventScreenRecording() {
        label.text = "You have Been Caught Video Stoped"
    }

}

