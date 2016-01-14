//
//  DetailsViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Brian Kwon on 12/26/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {

    var wandooInfo: NSDictionary!
    var userModel = UserModel()
    var wandooModel = WandooModel()
    
    @IBOutlet weak var profilePicture: UIImageView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(wandooInfo)
        
        let userID = self.wandooInfo["userID"] as! Int
        userModel.getUserInfoByUserID(userID) { (result) -> Void in
            let picString = result["profile_picture"] as! String
            let picURL = NSURL(string: picString)
            if let pic = NSData(contentsOfURL: picURL!) {
                 dispatch_async(dispatch_get_main_queue()){
                    self.profilePicture.image = UIImage(data: pic)
                    self.profilePicture.layer.borderWidth = 1
                    self.profilePicture.layer.masksToBounds = false
                    self.profilePicture.layer.borderColor = UIColor.whiteColor().CGColor
                    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.height/2
                    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.width/2
                    self.profilePicture.clipsToBounds = true
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
