//
//  ProfileViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Brian Kwon on 12/9/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class ProfileViewController: UIViewController, UITableViewDelegate {
    let user = UserModel()
    
    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var profileInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "profile"))
        
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "setting"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 30, 30)
        btnName.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)

        //.... Set Right/Left Bar Button item
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnName
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        
        //INSERT code for post request test
        getInfo()
        
    }
    
    //GET request to render user info on profile page
    func getInfo() {
        let fbID = FBSDKAccessToken.currentAccessToken().userID
            self.user.getUserInfo (fbID) { (result) -> Void in
                print(result)
                dispatch_async(dispatch_get_main_queue()) {
                    self.profileInfo.text = result["name"]! as? String
                    
                    if let sex = result["sex"]! as? String {
                        self.profileInfo.text! += ", " + sex.uppercaseString
                    }
                    
                    if let age = result["age"]! as? Int {
                        self.profileInfo.text! += ", " + String(age)
                    }
                    
                    if let employer = result["employer"]! as? String {
                        self.profileInfo.text! += "\n"
                        if let jobTitle = result["job_title"]! as? String {
                            self.profileInfo.text! += jobTitle 
                            self.profileInfo.text! += " at " + employer
                        } else {
                            self.profileInfo.text! += " at " + employer
                        }
                    }
                    
                    if let edu = result["institution_name"]! as? String {
                        self.profileInfo.text! += "\n" + edu
                    }

                    if let profilePicture = result["profile_picture"]! as? UIImage {
                        self.profileImage.image = profilePicture
                        self.profileImage.layer.borderWidth = 1
                        self.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
                        self.profileImage.layer.cornerRadius = self.profileImage.frame.width/2
                        self.profileImage.layer.cornerRadius = self.profileImage.frame.height/2
                        self.profileImage.clipsToBounds = true
                    }
                    self.profileInfo.numberOfLines = 0
                    self.profileInfo.frame = CGRectMake(20,20,200,800)
                    self.profileInfo.sizeToFit()
                }
            }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func buttonAction(send: UIButton!) {
        self.performSegueWithIdentifier("toSettingsController", sender: self)
    }

    
    @IBOutlet weak var userName: UILabel!



}
