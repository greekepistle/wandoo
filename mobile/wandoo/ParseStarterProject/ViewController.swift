/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4
//import SVProgressHUD
import Atlas



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var layerClient: LYRClient!
    var conversationListViewController: ConversationListViewController!

    var userModel = UserModel.sharedUserInstance
    var wandooModel = WandooModel()
    var count: Int = 0
    var counter: Int = 0
    var allWandoosArray = [NSDictionary]()
    var profilePicture: UIImage?
    var interestedModel = InterestedModel()
    
    @IBAction func presentChat(sender: UIButton) {
        self.presentConversationListViewController()
    }
    //Feed button to move to top of feed
    @IBAction func toTopPost(sender: UIButton) {
        self.retrieveWandoos()
     wandooTable.setContentOffset(CGPointMake(0, -wandooTable.contentInset.top), animated: true)
    }
    @IBOutlet weak var wandooTable: UITableView!
    
    var offset: Int = 1
    var limit: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layerClient = delegate.layerClient
        // Do any additional setup after loading the view, typically from a nib.
        
        userModel.postLocation { () -> Void in
            self.retrieveWandoos()
        }

        self.navigationItem.hidesBackButton = true
    }
    
    //renders wandoos into table view
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let wandooCell = tableView.dequeueReusableCellWithIdentifier("wandooCell", forIndexPath: indexPath) as! WandooCell
        let userID = self.allWandoosArray[indexPath.row]["userID"] as! Int
        userModel.getUserInfoByUserID(userID) { (result) -> Void in
            let picString = result["profile_picture"] as! String
            let picURL = NSURL(string: hostname + picString)
            if let pic = NSData(contentsOfURL: picURL!) {
                dispatch_async(dispatch_get_main_queue()){
                    wandooCell.profileImage.image = UIImage(data: pic)
                    wandooCell.profileImage.layer.borderWidth = 1
                    wandooCell.profileImage.layer.masksToBounds = false
                    wandooCell.profileImage.layer.borderColor = UIColor.blackColor().CGColor
                    wandooCell.profileImage.layer.cornerRadius = wandooCell.profileImage.frame.height/2
                    wandooCell.profileImage.clipsToBounds = true
                    wandooCell.name.text = result["name"] as? String
                    wandooCell.location.text = String(self.allWandoosArray[indexPath.row]["distance"]!) + " miles away"
                    wandooCell.message.text = self.allWandoosArray[indexPath.row]["text"] as? String
                    wandooCell.time.text = self.wandooModel.checkAndFormatWandooDate((self.allWandoosArray[indexPath.row]["start_time"] as? String)!)
                    wandooCell.numPeople.text = String(self.allWandoosArray[indexPath.row]["num_people"]!) + " people"
                }
            }
            
        }
        
        wandooCell.showInterestButton.tag = indexPath.row
        wandooCell.showInterestButton.layer.borderWidth = 1
        wandooCell.showInterestButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        wandooCell.showInterestButton.addTarget(self, action: "toggleInterest:", forControlEvents: .TouchUpInside)
        
        wandooCell.cardView.layer.borderWidth = 1
        wandooCell.cardView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        return wandooCell
    }
    
    @IBAction func toggleInterest(sender: UIButton) {
        if(sender.backgroundColor != UIColor(red: 81.0/255.0, green: 255.0/255.0, blue: 85.0/255.0, alpha: 0.5)) {
            let wandooID = allWandoosArray[sender.tag]["wandooID"] as! Int
            interestedModel.showInterest(wandooID)
            sender.backgroundColor = UIColor(red: 81.0/255.0, green: 255.0/255.0, blue: 85.0/255.0, alpha: 0.5)
        } else {
            sender.backgroundColor = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        }

    }
    
    //number of sections in table.. we only have 1 section of wandoos
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //number of rows in our section.. depends on how many wandoos we get from our http request
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allWandoosArray.count > 0 {
            return allWandoosArray.count
        } else {
            return 0
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "lookAtWandoo" {
            let selectedIndex = wandooTable.indexPathForCell(sender as! WandooCell)
        
            let wandooInfo = allWandoosArray[selectedIndex!.row]
            let destinationVC = segue.destinationViewController as! DetailsViewController
            destinationVC.wandooInfo = wandooInfo
        }
    }
    
    func presentConversationListViewController() {
//        SVProgressHUD.dismiss()
        self.conversationListViewController = ConversationListViewController(layerClient: self.layerClient)
        self.conversationListViewController.displaysAvatarItem = true
        self.navigationController!.pushViewController(self.conversationListViewController, animated: true)
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("segueing")
//        performSegueWithIdentifier("lookAtWandoo", sender: nil)
//    }
    
    //gets all wandoos using UserModel
    //UserModel is able to get the user's info (e.g. name, photo) via facebook id
    func retrieveWandoos() {
        
        getAllWandoos { (allWandoos) -> Void in
            let fbID = FBSDKAccessToken.currentAccessToken().userID
            self.userModel.getUserInfo(fbID, completion: { (userInfo) -> Void in
                
                self.profilePicture = userInfo["profile_picture"] as? UIImage
                self.allWandoosArray = allWandoos as! [NSDictionary]
                
                dispatch_async(dispatch_get_main_queue()){
                    self.wandooTable.reloadData()
                }
            })
            
        }
    }
    
    func getAllWandoos(completion: (result: NSArray) -> Void) {
        wandooModel.getAllWandoos { (allWandoos) -> Void in
            completion(result: allWandoos)
        }
    }
    
    func getWandoos(offset: Int, limit: Int, completion: (result: NSArray) -> Void) {
        wandooModel.getWandoos(1, limit: 3) { (result) -> Void in
            completion(result: result)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


