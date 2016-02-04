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
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationItem.titleView = UIImageView(image: UIImage(named: "my wandoos"))
        
    }
    
    override func viewWillAppear(animated: Bool) {
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
                    let fullName = result["name"] as? String
                    let fullNameArr = fullName!.characters.split{$0 == " "}.map(String.init)
                    wandooCell.wandooNumber.text = fullNameArr[0]
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
        wandooCell.userButton.layer.borderWidth = 1
        wandooCell.userButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        
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
        
        if String(self.view.subviews.last).containsString("You Don't Have Any Active Wandoos!") {
            dispatch_async(dispatch_get_main_queue()) {
                self.view.subviews.last!.removeFromSuperview()
            }
        }
        
        getMyWandoos { (allMyWandoos) -> Void in
            self.myWandoosArray = allMyWandoos as! [NSDictionary]
            dispatch_async(dispatch_get_main_queue()){
                self.wandooTable.reloadData()
                if self.myWandoosArray.count == 0 {
                    let noWandoos = UILabel(frame: CGRect(x: self.view.bounds.width/2 - 175, y: self.view.bounds.height/2 - 100, width: 350, height: 200))
                    noWandoos.text = "You Don't Have Any Active Wandoos!"
                    noWandoos.textAlignment = .Center
                    noWandoos.font = UIFont(name: noWandoos.font.fontName, size: 18)
                    noWandoos.textColor = UIColor.blackColor()
                    self.view.addSubview(noWandoos)
                }
            }
        }
    }
    
    func getMyWandoos(completion: (result: NSArray) -> Void) {
        wandooModel.getUserWandoo { (allMyWandoos) -> Void in
            completion(result: allMyWandoos)
        }
    }


}
