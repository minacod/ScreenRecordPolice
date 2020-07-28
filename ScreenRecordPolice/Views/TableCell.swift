//
//  TableCell.swift
//  ScreenRecordPolice
//
//  Created by Mina Abdelfady on 7/22/20.
//  Copyright © 2020 Shafy. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    func initCell(str: String){
        label.text = str
    }

}
