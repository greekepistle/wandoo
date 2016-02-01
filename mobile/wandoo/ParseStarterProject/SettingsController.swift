//
//  SettingsController.swift
//  ParseStarterProject-Swift
//
//  Created by Brian Kwon on 12/9/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import ParseFacebookUtilsV4
import LayerKit

class SettingsController: UITableViewController {
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var layerClient: LYRClient!
    
    var settings = ["About Us", "Contact Us", "Delete Account", "Log Out"]

    override func viewDidLoad() {
        super.viewDidLoad()
        layerClient = delegate.layerClient

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return settings.count
    }

    @IBAction func logoutButton() {
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = settings[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.row == 3) {
//            print("Current user token=\(FBSDKAccessToken.currentAccessToken().tokenString)")
            
            self.tabBarController!.tabBar.hidden = true
            self.tabBarController!.tabBar.translucent = true
            PFUser.logOut()
            layerClient.deauthenticateWithCompletion({ (success, error) -> Void in
                print("successfully logged out of layer")
            })
            
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            print("User Logged Out!")
            performSegueWithIdentifier("backToLogin", sender: nil)
        } else if (indexPath.row == 0) {
            
        } else if (indexPath.row == 1) {
            
        } else if (indexPath.row == 2) {
            
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
