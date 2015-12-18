//
//  ProfileViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Brian Kwon on 12/9/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class ProfileViewController: UIViewController {
    let user = UserModel()

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    
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
        
        self.name.numberOfLines = 6
        getInfo()
        
    }
    
    func getInfo() {
        let fbID = FBSDKAccessToken.currentAccessToken().userID
            self.user.getUserInfo (fbID) { (result) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    self.name.text = result["name"]! as! String
                    
                    if let age = result["age"] {
                        self.name.text! += "\n" + String(result["age"]!)
                    }
                    
                    if let sex = result["sex"] {
                        self.name.text! += "\n" + (result["sex"]! as! String)
                    }
                    
                    if let employer = result["employer"] {
                        self.name.text! += "\n" + (result["employer"]! as! String)
                    }
                    
                    if let jobTitle = result["jobTitle"] {
                        self.name.text! += "\n" + (result["jobTitle"]! as! String)
                    }
                    
                    if let edu = result["educationInstitution"] {
                        self.name.text! += "\n" + (result["educationInstitution"]! as? String)!
                    }
                    
//                    print(result)
//                    
//                    let picString = result["profile_picture"] as! String
//                    
//                    
//                    print(picString)
                    

//                    var picData = NSData(base64EncodedString: picString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
//                    
//                    print(picData)
//                    self.profileImage.image = UIImage(data: picData!)
                    
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
