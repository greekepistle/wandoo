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
    @IBOutlet weak var nameSexAge: UILabel!
    @IBOutlet weak var employer: UILabel!
    @IBOutlet weak var school: UILabel!
    @IBOutlet weak var location: UILabel!
    
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
        
//        self.nameSexAge.numberOfLines = 0
//        self.nameSexAge.frame = CGRectMake(20,20,200,800)
//        self.nameSexAge.sizeToFit()
        getInfo()
        
    }
    
    //GET request to render user info on profile page
    func getInfo() {
        let fbID = FBSDKAccessToken.currentAccessToken().userID
            self.user.getUserInfo (fbID) { (result) -> Void in
                print(result)
                dispatch_async(dispatch_get_main_queue()) {
                    self.nameSexAge.text = result["name"]! as! String
                    
                    if let sex = result["sex"]! as? String {
                        self.nameSexAge.text! += ", " + (result["sex"]! as! String)
                    }
                    
                    if let age = result["age"]! as? Int {
                        self.nameSexAge.text! += ", " + String(result["age"]!)
                    }
                    
                    if let employer = result["employer"]! as? String {
                        if let jobTitle = result["job_title"]! as? String {
                            self.employer.text! += result["job_title"]! as! String
                            self.employer.text! += "at " + (result["employer"]! as! String)
                        } else {
                            self.employer.text! += "at " + (result["employer"]! as! String)
                        }
                    }
                    
//                    if let edu = result["institution_name"]! as? String {
//                        self.school.text! += result["institution_name"]! as? String
//                    }

                    if let profilePicture = result["profile_picture"]! as? UIImage {
                        self.profileImage.image = profilePicture as! UIImage
                    }
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
