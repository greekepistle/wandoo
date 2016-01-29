//
//  DetailsViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Brian Kwon on 12/26/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var wandooInfo: NSDictionary!
    var userModel = UserModel()
    var wandooModel = WandooModel()
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var education: UILabel!
    @IBOutlet weak var job: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        getInfo()
    }
    
    func getInfo() {
        let userID = self.wandooInfo["userID"] as! Int
        self.userModel.getUserInfoByUserID(userID) { (result) -> Void in
            print(result)
            dispatch_async(dispatch_get_main_queue()) {
                let fullName = result["name"] as? String
                let fullNameArr = fullName!.characters.split{$0 == " "}.map(String.init)
                self.name.text = fullNameArr[0] + ", " + String(result["sex"]!).uppercaseString
                self.age.text = "Age: " + String(result["age"]!)
                
                if let employer = result["employer"]! as? String {
                    if let jobTitle = result["job_title"]! as? String {
                        self.job.text = jobTitle + " at " + employer
                    } else {
                        self.job.text = ""
                    }
                } else {
                    self.job.text = ""
                }
                
                if let edu = result["institution_name"]! as? String {
                    self.education.text! = edu
                } else {
                    self.education.text = ""
                }
                
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
