//
//  MyWandooViewController.swift
//  ParseStarterProject-Swift
//
//  Created by William Lee on 12/27/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class MyWandooViewController: UITableViewController {

    
    @IBOutlet weak var wandooTable: UITableView!
    
    var myWandoosArray = [NSDictionary]()
    var userModel = UserModel.sharedUserInstance
    var wandooModel = WandooModel()
    var interestedModel = InterestedModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "my wandoos"))
        
        self.retrieveMyWandoos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let wandooCell = tableView.dequeueReusableCellWithIdentifier("myWandooCell", forIndexPath: indexPath) as! MyWandooCell
        
        
        let userID = self.myWandoosArray[indexPath.row]["userID"] as! Int

        userModel.getUserInfoByUserID(userID) { (result) -> Void in
            let picString = result["profile_picture"] as! String
            let picURL = NSURL(string: picString)
            if let pic = NSData(contentsOfURL: picURL!) {
                dispatch_async(dispatch_get_main_queue()){
                    wandooCell.profileImage.image = UIImage(data: pic)
                    wandooCell.profileImage.layer.borderWidth = 1
                    wandooCell.profileImage.layer.masksToBounds = false
                    wandooCell.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
                    wandooCell.profileImage.layer.cornerRadius = wandooCell.profileImage.frame.height/2
                    wandooCell.profileImage.layer.cornerRadius = wandooCell.profileImage.frame.width/2
                    wandooCell.profileImage.clipsToBounds = true
                    wandooCell.myWandooTitle.text = self.myWandoosArray[indexPath.row]["text"] as? String
                    wandooCell.myWandooTime.text = self.wandooModel.checkAndFormatWandooDate((self.myWandoosArray[indexPath.row]["start_time"] as? String)!)
                    wandooCell.myWandooPeople.text = String(self.myWandoosArray[indexPath.row]["num_people"]!) + " people"
                }
            }
        }
        
        wandooCell.cardView.layer.borderWidth = 1
        wandooCell.cardView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        return wandooCell
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myWandoosArray.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toSelection" {
            let selectedIndex = wandooTable.indexPathForCell(sender as! MyWandooCell)
            
            let myWandooInfo = myWandoosArray[selectedIndex!.row]
            let destinationVC = segue.destinationViewController as! AcceptOrRejectViewController
            destinationVC.myWandooInfo = myWandooInfo
            
        }
    }

    func retrieveMyWandoos() {
        getMyWandoos { (allMyWandoos) -> Void in
            self.myWandoosArray = allMyWandoos as! [NSDictionary]
            dispatch_async(dispatch_get_main_queue()){
                self.wandooTable.reloadData()
            }
        }
    }
    
    func getMyWandoos(completion: (result: NSArray) -> Void) {
        wandooModel.getUserWandoo { (allMyWandoos) -> Void in
            completion(result: allMyWandoos)
        }
    }


}
