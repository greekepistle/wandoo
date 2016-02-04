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
import CoreLocation
import SVProgressHUD
import Atlas
import ParseUI
import LayerKit

class FacebookLoginController: UIViewController, CLLocationManagerDelegate {
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate

    var userModel = UserModel.sharedUserInstance
    var locationManager = CLLocationManager()
//    var conversation: LYRConversation!
    var layerClient: LYRClient!
    var conversationListViewController: ConversationListViewController!
    
    @IBOutlet weak var titleWandoo: UIImageView!
    
    @IBAction func loginFacebookButtonThatTakesUsToTheLoginAtSafari(sender: AnyObject?) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile","user_education_history","user_birthday", "user_work_history","user_friends", "email"], block: { (user:PFUser?, error:NSError?) -> Void in
            
            SVProgressHUD.show()
            
            
            //PF Push - Start
//            let defaultACL: PFACL = PFACL()
////            print("Yo PFUser",PFUser.currentUser()!)
//            defaultACL.setReadAccess(true, forUser: PFUser.currentUser()!)
//            
//            
//            defaultACL.publicReadAccess = true
//            //        defaultACL.setPublicReadAccess(true)
//            PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser: true)
            
            let installation:PFInstallation = PFInstallation.currentInstallation()
            installation["user"] = PFUser.currentUser()
            installation.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                
            })
            
            
            //PF Push - End
            
            
            if(error == nil)
            {
                if let user = user {
                    if user.isNew {
                        let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                        self.userModel.storeFBDataIntoParse(user.objectId!, accessToken: accessToken) { () -> Void in
                            
                            let fbID = FBSDKAccessToken.currentAccessToken().userID
                            self.userModel.getUserInfo(fbID) { (result) -> Void in
                                self.userModel.userID = result["userID"]! as? Int
                                self.loginLayer()
                            }

                        }
                        //segue into profile editing page
                        print("New user signed up")
                    } else {
                        let fbID = FBSDKAccessToken.currentAccessToken().userID
                        print("reaching here")
                        self.userModel.getUserInfo(fbID, completion: { (result) -> Void in
                            print(result)
                            self.userModel.userID = result["userID"]! as? Int
                            self.loginLayer()
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
        SVProgressHUD.setBackgroundColor(UIColor.clearColor())

        layerClient = delegate.layerClient
        print("this needs to print ", layerClient)
        print("THE PFUSER", PFUser.currentUser())
        
        //location manager - request for user location only when in use
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.titleWandoo.transform = CGAffineTransformMakeScale(0.1, 0.1)
        UIView.animateWithDuration(2.0,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 6.0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: {
                self.titleWandoo.transform = CGAffineTransformIdentity
            }, completion: nil)
        

        if self.navigationController != nil {
            self.navigationController!.navigationBarHidden = true
        }
        print(FBSDKAccessToken.currentAccessToken() != nil)
    }
    
    //continually spits out user location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        
        userModel.latitude = userLocation.coordinate.latitude
        userModel.longitude = userLocation.coordinate.longitude
        
    }
    
    func loginLayer() {
//        SVProgressHUD.show()
        print("logging in", layerClient)
        
        // Connect to Layer
        // See "Quick Start - Connect" for more details
        // https://developer.layer.com/docs/quick-start/ios#connect
        self.layerClient.connectWithCompletion { success, error in
            if (!success) {
                print("Failed to connect to Layer: \(error)")
            } else {
                let userID: String = PFUser.currentUser()!.objectId!
                // Once connected, authenticate user.
                // Check Authenticate step for authenticateLayerWithUserID source
                self.authenticateLayerWithUserID(userID, completion: { success, error in
                    if (!success) {
                        print("Failed Authenticating Layer Client with error:\(error)")
                    } else {
                        print("Authenticated")
                        dispatch_async(dispatch_get_main_queue()) {
                            SVProgressHUD.dismiss()
                            self.performSegueWithIdentifier("LoginFacebook", sender: self)
                        }
                    }
                })
            }
        }
    }
    
    func authenticateLayerWithUserID(userID: NSString, completion: ((success: Bool , error: NSError!) -> Void)!) {
        // Check to see if the layerClient is already authenticated.
        if self.layerClient.authenticatedUserID != nil {
            // If the layerClient is authenticated with the requested userID, complete the authentication process.
            if self.layerClient.authenticatedUserID == userID {
                print("Layer Authenticated as User \(self.layerClient.authenticatedUserID)")
                if completion != nil {
                    completion(success: true, error: nil)
                }
                return
            } else {
                //If the authenticated userID is different, then deauthenticate the current client and re-authenticate with the new userID.
                self.layerClient.deauthenticateWithCompletion { (success: Bool, error: NSError?) in
                    if error != nil {
                        self.authenticationTokenWithUserId(userID, completion: { (success: Bool, error: NSError?) in
                            if (completion != nil) {
                                completion(success: success, error: error)
                            }
                        })
                    } else {
                        if completion != nil {
                            completion(success: true, error: error)
                        }
                    }
                }
            }
        } else {
            // If the layerClient isn't already authenticated, then authenticate.
            self.authenticationTokenWithUserId(userID, completion: { (success: Bool, error: NSError!) in
                if completion != nil {
                    completion(success: success, error: error)
                }
            })
        }
    }
    
    func authenticationTokenWithUserId(userID: NSString, completion:((success: Bool, error: NSError!) -> Void)!) {
        /*
        * 1. Request an authentication Nonce from Layer
        */
        self.layerClient.requestAuthenticationNonceWithCompletion { (nonceString: String?, error: NSError?) in
            guard let nonce = nonceString else {
                if (completion != nil) {
                    completion(success: false, error: error)
                }
                return
            }
            
            if (nonce.isEmpty) {
                if (completion != nil) {
                    completion(success: false, error: error)
                }
                return
            }
            
            /*
            * 2. Acquire identity Token from Layer Identity Service
            */
            PFCloud.callFunctionInBackground("generateToken", withParameters: ["nonce": nonce, "userID": userID]) { (object:AnyObject?, error: NSError?) -> Void in
                if error == nil {
                    let identityToken = object as! String
                    self.layerClient.authenticateWithIdentityToken(identityToken) { authenticatedUserID, error in
                        guard let userID = authenticatedUserID else {
                            if (completion != nil) {
                                completion(success: false, error: error)
                            }
                            return
                        }
                        
                        if (userID.isEmpty) {
                            if (completion != nil) {
                                completion(success: false, error: error)
                            }
                            return
                        }
                        
                        if (completion != nil) {
                            completion(success: true, error: nil)
                        }
                        print("Layer Authenticated as User: \(userID)")
                    }
                } else {
                    print("Parse Cloud function failed to be called to generate token with error: \(error)")
                }
            }
        }
    }
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        if FBSDKAccessToken.currentAccessToken() != nil {
            var overlay = UIView(frame: view.frame)
            overlay.backgroundColor = UIColor.blackColor()
            overlay.alpha = 0.8
            
            view.addSubview(overlay)
        }
    }
}


