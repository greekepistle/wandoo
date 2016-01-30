//
//  TabBarViewController.swift
//  Wandoo
//
//  Created by Brian Kwon on 1/29/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Atlas

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var layerClient: LYRClient!
    
    let sb = UIStoryboard(name: "Main", bundle: nil)
    var feedController: UINavigationController!
    
    var conversationListViewController: ConversationListViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layerClient = appDelegate.layerClient
        
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        UITabBar.appearance().barTintColor = UIColor(red:0.204, green:0.596, blue:0.859, alpha:1.0)
        UITabBar.appearance().translucent = false
        
        
        feedController = sb.instantiateViewControllerWithIdentifier("initialNav") as! UINavigationController
        feedController.navigationBar.translucent = false
        feedController.navigationBar.barTintColor = UIColor(red:0.204, green:0.596, blue:0.859, alpha:1.0)
        let feedIcon = UITabBarItem(title: "", image: UIImage(named: "feed"), selectedImage: UIImage(named: "feed"))
        feedIcon.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0)
        feedController.tabBarItem = feedIcon
       
        let myWandoosController = sb.instantiateViewControllerWithIdentifier("myWandoosNav") as! UINavigationController
        myWandoosController.navigationBar.translucent = false
        myWandoosController.navigationBar.barTintColor = UIColor(red:0.204, green:0.596, blue:0.859, alpha:1.0)
        let myWandoosIcon = UITabBarItem(title: "", image: UIImage(named: "myWandoos"), selectedImage: UIImage(named: "myWandoos"))
        myWandoosIcon.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0)
        myWandoosController.tabBarItem = myWandoosIcon
        
        self.conversationListViewController = ConversationListViewController(layerClient: self.layerClient)
        self.conversationListViewController.displaysAvatarItem = true
        let chatController = UINavigationController()
        chatController.viewControllers = [self.conversationListViewController]
        chatController.navigationBar.translucent = false
        chatController.navigationBar.barTintColor = UIColor(red:0.204, green:0.596, blue:0.859, alpha:1.0)
        let chatIcon = UITabBarItem(title: "", image: UIImage(named: "chat"), selectedImage: UIImage(named: "chat"))
        chatIcon.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0)
        chatController.tabBarItem = chatIcon
        
        let profileController = sb.instantiateViewControllerWithIdentifier("profileNav") as! UINavigationController
        profileController.navigationBar.translucent = false
        profileController.navigationBar.barTintColor = UIColor(red:0.204, green:0.596, blue:0.859, alpha:1.0)
        let profileIcon = UITabBarItem(title: "", image: UIImage(named: "userProfile"), selectedImage: UIImage(named: "userProfile"))
        profileIcon.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0)
        profileController.tabBarItem = profileIcon
        
        self.viewControllers = [feedController, myWandoosController, chatController, profileController]

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        print("VIEW WILL APPEAR")
        
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
        return true;
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        print("wtf!!!!!")
        print(viewController)
        feedController.pushViewController(viewController, animated: true)
        
        
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
