//
//  InterestedCell.swift
//  ParseStarterProject-Swift
//
//  Created by Brian Kwon on 1/2/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class InterestedCell: UITableViewCell {
  

    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var ageSex: UILabel!
    
    @IBOutlet weak var employerAndOrEdu: UILabel!
    
    @IBOutlet weak var picture: UIImageView!
    
    @IBOutlet weak var reject: UIButton!
    @IBOutlet weak var accept: UIButton!
}
