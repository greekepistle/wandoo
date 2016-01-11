import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import ParseFacebookUtilsV4
import Atlas
import SVProgressHUD
import LayerKit


//let hostname = "http://localhost:8000"
let hostname = "https://wandoo-hs5abf-5804.herokuapp.com"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var layerClient: LYRClient!
    var controller: FacebookLoginController!
    var feedController: ViewController!
    
    var userModel = UserModel.sharedUserInstance
    
    // MARK TODO: Before first launch, update LayerAppIDString, ParseAppIDString or ParseClientKeyString values
    // TODO:If LayerAppIDString, ParseAppIDString or ParseClientKeyString are not set, this app will crash"
    let LayerAppIDString: NSURL! = NSURL(string: "layer:///apps/staging/35cf31e8-ac52-11e5-be54-e99ef71601e8")
    
    let ParseAppIDString: String = "HS5AbFE2AykpVi7QD2vBwutQJcytqHSPpaWAriy5"
    
    let ParseClientKeyString: String = "sxoaYg2v8qUk2Vz2Xu1HTkRVoH9VL0avcSd9aRwv"
    
    //Please note, You must set `LYRConversation *conversation` as a property of the ViewController.
    var conversation: LYRConversation!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setupParse()
        layerClient = LYRClient(appID: LayerAppIDString)
        layerClient.autodownloadMIMETypes = NSSet(objects: ATLMIMETypeImagePNG, ATLMIMETypeImageJPEG, ATLMIMETypeImageJPEGPreview, ATLMIMETypeImageGIF, ATLMIMETypeImageGIFPreview, ATLMIMETypeLocation) as? Set<String>
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        // Show View Controller
//        controller = FacebookLoginController()
//        controller.layerClient = layerClient
//        print(layerClient)
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        PFFacebookUtils.facebookLoginManager().loginBehavior = FBSDKLoginBehavior.SystemAccount
        
        // Register for push
        self.registerApplicationForPushNotifications(application)
        
        //MARK for change PF PUSH Settings - Start
        
        let notificationTypes:UIUserNotificationType = [.Alert, .Badge, .Sound]
        let notificationSettings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        print(self.window!.backgroundColor)
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //MARK for change PF PUSH Settings - End
        print("------------",FBSDKAccessToken.currentAccessToken() != nil)
        if FBSDKAccessToken.currentAccessToken() != nil {
            loginLayer()
            
            
            
            var feedController = storyboard.instantiateViewControllerWithIdentifier("initialNav") as! UINavigationController
            
            self.window?.rootViewController = feedController
            self.window?.makeKeyAndVisible()
            SVProgressHUD.dismiss()
        } else {
            
            var initialViewController = storyboard.instantiateViewControllerWithIdentifier("facebookLogin") as! FacebookLoginController
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            SVProgressHUD.dismiss()
        }
        
        
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("facebookLogin")
//        UIApplication.sharedApplication().keyWindow?.rootViewController = viewController;
//        self.window!.rootViewController = controller
//        self.window!.backgroundColor = UIColor.whiteColor()
//        self.window!.makeKeyAndVisible()
    
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK:- Push Notification Registration
    
    func registerApplicationForPushNotifications(application: UIApplication) {
        // Set up push notifications
        // For more information about Push, check out:
        // https://developer.layer.com/docs/guides/ios#push-notification
        
        // Register device for iOS8
        let notificationSettings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Store the deviceToken in the current installation and save it to Parse.
        let currentInstallation: PFInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.saveInBackground()
        
        // Send device token to Layer so Layer can send pushes to this device.
        // For more information about Push, check out:
        // https://developer.layer.com/docs/ios/guides#push-notification
        assert(self.layerClient != nil, "The Layer client has not been initialized!")
        do {
            try! self.layerClient.updateRemoteNotificationDeviceToken(deviceToken)
            print("Application did register for remote notifications: \(deviceToken)")
        } catch let error as NSError {
            print("Failed updating device token with error: \(error)")
        }
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        if userInfo["layer"] == nil {
            PFPush.handlePush(userInfo)
            completionHandler(UIBackgroundFetchResult.NewData)
            return
        }
        
        let userTappedRemoteNotification: Bool = application.applicationState == UIApplicationState.Inactive
        var conversation: LYRConversation? = nil
        if userTappedRemoteNotification {
            SVProgressHUD.show()
            conversation = self.conversationFromRemoteNotification(userInfo)
            if conversation != nil {
                self.navigateToViewForConversation(conversation!)
            }
        }
        
        let success: Bool = self.layerClient.synchronizeWithRemoteNotification(userInfo, completion: { (changes, error) in
            completionHandler(self.getBackgroundFetchResult(changes, error: error))
            
            if userTappedRemoteNotification && conversation == nil {
                // Try navigating once the synchronization completed
                self.navigateToViewForConversation(self.conversationFromRemoteNotification(userInfo))
            }
        })
        
        if !success {
            // This should not happen?
            completionHandler(UIBackgroundFetchResult.NoData)
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("getMessage", object: nil)
    }
    
    func getBackgroundFetchResult(changes: [AnyObject]!, error: NSError!) -> UIBackgroundFetchResult {
        if changes?.count > 0 {
            return UIBackgroundFetchResult.NewData
        }
        return error != nil ? UIBackgroundFetchResult.Failed : UIBackgroundFetchResult.NoData
    }
    
    func conversationFromRemoteNotification(remoteNotification: [NSObject : AnyObject]) -> LYRConversation {
        let layerMap = remoteNotification["layer"] as! [String: String]
        let conversationIdentifier = NSURL(string: layerMap["conversation_identifier"]!)
        return self.existingConversationForIdentifier(conversationIdentifier!)!
    }
    
    func navigateToViewForConversation(conversation: LYRConversation) {
        if self.controller.conversationListViewController != nil {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                SVProgressHUD.dismiss()
                if (self.controller.navigationController!.topViewController as? ConversationViewController)?.conversation != conversation {
                    self.controller.conversationListViewController.presentConversation(conversation)
                }
            });
        } else {
            SVProgressHUD.dismiss()
        }
    }
    
    func existingConversationForIdentifier(identifier: NSURL) -> LYRConversation? {
        let query: LYRQuery = LYRQuery(queryableClass: LYRConversation.self)
        query.predicate = LYRPredicate(property: "identifier", predicateOperator: LYRPredicateOperator.IsEqualTo, value: identifier)
        query.limit = 1
        do {
            return try self.layerClient.executeQuery(query).firstObject as? LYRConversation
        } catch {
            // This should never happen?
            return nil
        }
    }
    
    func setupParse() {
        // Enable Parse local data store for user persistence
        Parse.enableLocalDatastore()
        Parse.setApplicationId(ParseAppIDString, clientKey: ParseClientKeyString)
        
        // Set default ACLs
        let defaultACL: PFACL = PFACL()
//        print("Yo", PFUser.currentUser());
//        defaultACL.setReadAccess(true, forUser: PFUser.currentUser()!)
        //PF push - Add
//        let installation:PFInstallation = PFInstallation.currentInstallation()
//        installation["user"] = PFUser.currentUser()
//        installation.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
//        
//        })
        //PF push - Remove
        
        
        defaultACL.publicReadAccess = true
//        defaultACL.setPublicReadAccess(true)
        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser: true)
    }
    
    func setupLayer() {
        layerClient = LYRClient(appID: LayerAppIDString)
        layerClient.autodownloadMIMETypes = NSSet(objects: ATLMIMETypeImagePNG, ATLMIMETypeImageJPEG, ATLMIMETypeImageJPEGPreview, ATLMIMETypeImageGIF, ATLMIMETypeImageGIFPreview, ATLMIMETypeLocation) as? Set<String>
    }
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
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
}

