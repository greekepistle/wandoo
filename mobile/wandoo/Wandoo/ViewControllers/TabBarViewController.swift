//
//  TabBarViewController.swift
//  Wandoo
//
//  Created by Brian Kwon on 1/29/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Atlas
import QuartzCore

extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var layerClient: LYRClient!
    var locationManager = CLLocationManager()
    var userModel = UserModel.sharedUserInstance
    
    let sb = UIStoryboard(name: "Main", bundle: nil)
    var feedController: UINavigationController!
    
    var conversationListViewController: ConversationListViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        layerClient = appDelegate.layerClient
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        print("VIEW WILL APPEAR")
        
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        UITabBar.appearance().barTintColor = UIColor.whiteColor()
        UITabBar.appearance().translucent = false
        
        feedController = sb.instantiateViewControllerWithIdentifier("initialNav") as! UINavigationController
        feedController.navigationBar.translucent = false
        feedController.navigationBar.barTintColor = UIColor(red:0.204, green:0.596, blue:0.859, alpha:1.0)
        let feedIcon = UITabBarItem(title: "Wandoo Feed", image: UIImage(named: "feed"), selectedImage: UIImage(named: "feed"))
        feedIcon.imageInsets = UIEdgeInsetsMake(3, 0, -3, 0)
        feedController.tabBarItem = feedIcon
        feedController.tabBarItem.selectedImage = UIImage(named: "feed")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        let myWandoosController = sb.instantiateViewControllerWithIdentifier("myWandoosNav") as! UINavigationController
        myWandoosController.navigationBar.translucent = false
        myWandoosController.navigationBar.barTintColor = UIColor(red:0.204, green:0.596, blue:0.859, alpha:1.0)
//        let myWandoosIcon = UITabBarItem(title: "", image: UIImage(named: "myWandoos")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "myWandoos"))
        let myWandoosIcon = UITabBarItem(title: "My Wandoos", image: UIImage(named: "myWandoos"), selectedImage: UIImage(named: "myWandoos"))
        myWandoosIcon.imageInsets = UIEdgeInsetsMake(3, 0, -3, 0)
        myWandoosController.tabBarItem = myWandoosIcon
        
        self.conversationListViewController = ConversationListViewController(layerClient: self.layerClient)
        self.conversationListViewController.displaysAvatarItem = true
        let chatController = UINavigationController()
        chatController.viewControllers = [self.conversationListViewController]
        chatController.navigationBar.translucent = false
        chatController.navigationBar.barTintColor = UIColor(red:0.204, green:0.596, blue:0.859, alpha:1.0)
        let chatIcon = UITabBarItem(title: "Messages", image: UIImage(named: "chat"), selectedImage: UIImage(named: "chat"))
        chatIcon.imageInsets = UIEdgeInsetsMake(3, 0, -3, 0)
        chatController.tabBarItem = chatIcon
        
        let profileController = sb.instantiateViewControllerWithIdentifier("profileNav") as! UINavigationController
        profileController.navigationBar.translucent = false
        profileController.navigationBar.barTintColor = UIColor(red:0.204, green:0.596, blue:0.859, alpha:1.0)
        let profileIcon = UITabBarItem(title: "My Profile", image: UIImage(named: "userProfile"), selectedImage: UIImage(named: "userProfile"))
        profileIcon.imageInsets = UIEdgeInsetsMake(3, 0, -3, 0)
        profileController.tabBarItem = profileIcon
        
        self.viewControllers = [feedController, myWandoosController, chatController, profileController]
        
        let selectedColor = UIColor(red:0.204, green:0.596, blue:0.859, alpha:1.0)
        let unselectedColor = UIColor(white:0.80, alpha:1.0)
        
        for item in self.tabBar.items! {
            item.selectedImage = item.selectedImage?.imageWithColor(selectedColor).imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            
            item.image = item.selectedImage?.imageWithColor(unselectedColor).imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            
        }
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: selectedColor], forState: .Selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: unselectedColor], forState: .Normal)
        
        
//        var nav1 = UINavigationController()
//        var myWandoosVC = MyWandooViewController()
//        var myWandooIcon = UITabBarItem(title: "Title", image: UIImage(named: "icon_ios_chat_filled.png"), selectedImage: UIImage(named: "icon_ios_chat_filled.png"))
//        nav1.tabBarItem = myWandooIcon
//        nav1.viewControllers = [myWandoosVC]
//        
//        
//        
//        var nav2 = UINavigationController()
//        var chatVC = ConversationListViewController()
//        nav2.viewControllers = [chatVC]
//        
//        self.viewControllers = [nav1, nav2]
        
//        let item1 = Item1ViewController()
//        let icon1 = UITabBarItem(title: "Title", image: UIImage(named: "someImage.png"), selectedImage: UIImage(named: "otherImage.png"))
//        item1.tabBarItem = icon1
//        let controllers = [item1]  //array of the root view controllers displayed by the tab bar interface
//        self.viewControllers = controllers
    }
    
    //Delegate methods
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title) ?")
        
//        let vcMirror = Mirror(reflecting: viewController)
        if viewController.childViewControllers.first! is ViewController {
            
            
        }
        return true;
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        
        userModel.latitude = userLocation.coordinate.latitude
        userModel.longitude = userLocation.coordinate.longitude
        print(userModel.latitude)
        
    }
    
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
    }
    
    func presentConversationListViewController() {
        //        SVProgressHUD.dismiss()
        self.conversationListViewController = ConversationListViewController(layerClient: self.layerClient)
        self.conversationListViewController.displaysAvatarItem = true
        self.navigationController!.pushViewController(self.conversationListViewController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
