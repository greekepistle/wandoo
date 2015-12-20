//
//  FacebookLoginController.swift
//  ParseStarterProject-Swift
//
//  Created by Brian Kwon on 12/8/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import ParseFacebookUtilsV4
import Parse

class FacebookLoginController: UIViewController {

    var userModel = UserModel.sharedUserInstance
    
    //Signup and Login button:
        //Signup will send POST request for user's info and GET request for userID to be used in our userModel
        //Login will only send GET request for userID
    @IBAction func loginFacebookButtonThatTakesUsToTheLoginAtSafari(sender: AnyObject) {
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile","user_education_history","user_birthday", "user_work_history","user_friends","user_likes", "email"], block: { (user:PFUser?, error:NSError?) -> Void in
            
            if(error == nil)
            {
                if let user = user {
                    if user.isNew {
                        let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                        self.userModel.storeFBDataIntoParse(user.objectId!, accessToken: accessToken) { () -> Void in
                            
                            let fbID = FBSDKAccessToken.currentAccessToken().userID
                            self.userModel.getUserInfo(fbID, completion: { (result) -> Void in
                                
                                self.userModel.userID = result["userID"]! as! Int
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.performSegueWithIdentifier("LoginFacebook", sender: self)
                                    
                                }

                            })

                        }
                        //segue into profile editing page
                        print("New user signed up")
                    } else {
                        let fbID = FBSDKAccessToken.currentAccessToken().userID
                        self.userModel.getUserInfo(fbID, completion: { (result) -> Void in
                            
                            self.userModel.userID = result["userID"]! as! Int
                            dispatch_async(dispatch_get_main_queue()) {
                                self.performSegueWithIdentifier("LoginFacebook", sender: self)
                                
                            }
                        })
                        print("Already a user")
                    }
                }
                
            }
            else
            {
                print(error!.localizedDescription)
            }
            
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if self.navigationController != nil {
            self.navigationController!.navigationBarHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


