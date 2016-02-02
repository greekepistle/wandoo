//
//  AcceptOrRejectViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Brian Kwon on 1/2/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class AcceptOrRejectViewController: UITableViewController {
    
    @IBOutlet var interestedTable: UITableView!
    var allInterestedInfo: Array<NSMutableDictionary>?
    var interestedModel = InterestedModel.sharedInterestedInstance
    var userModel = UserModel.sharedUserInstance
    
    var myWandooInfo: NSDictionary?
    
    @IBOutlet var acceptRejectTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let acceptOrRejectList = userDefaults.objectForKey("acceptOrRejectList") {
            let auxAcceptOrRejectList = acceptOrRejectList.mutableCopy()
            userModel.acceptOrRejectList = auxAcceptOrRejectList as! Dictionary<String, Dictionary<String, Int>>
        }
        
        getInterestedPeople { () -> Void in

//            for (index, interestedPeople) in self.allInterestedInfo!.enumerate() {
//                if(interestedPeople["selected"] as! Int == 1) {
//                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
//                    let cell = self.interestedTable.cellForRowAtIndexPath(indexPath) as! InterestedCell
//                    cell.accept.backgroundColor = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 0.5)
//                }
//            }
        }
        print("view did load all the time?")
    }
    
    @IBAction func rejectButton(sender: UIButton) {
        if(sender.backgroundColor != UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 0.5)){
            let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
            let cell = interestedTable.cellForRowAtIndexPath(indexPath)
            let wandooID = allInterestedInfo![sender.tag]["wandooID"] as! Int
            let userID = allInterestedInfo![sender.tag]["userID"] as! Int
//            interestedModel.acceptedOrRejected(wandooID, userID: userID, accepted: false)
            sender.backgroundColor = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 0.5)
            cell!.userInteractionEnabled = false
            
            userModel.acceptOrRejectList[String(wandooID)]![String(userID)] = 1
            userModel.userDefaults.setObject(userModel.acceptOrRejectList, forKey: "acceptOrRejectList")
        }
    }
    
    @IBAction func acceptButton(sender: UIButton) {
        if(sender.backgroundColor != UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 0.5)){
            let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
            let cell = interestedTable.cellForRowAtIndexPath(indexPath)
            let wandooID = allInterestedInfo![sender.tag]["wandooID"] as! Int
            let userID = allInterestedInfo![sender.tag]["userID"] as! Int
            interestedModel.acceptedOrRejected(wandooID, userID: userID, accepted: true)
            sender.backgroundColor = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 0.5)
            
            userModel.acceptOrRejectList[String(wandooID)]![String(userID)] = 2
            print(userModel.acceptOrRejectList[String(wandooID)]!)
            print(userModel.acceptOrRejectList[String(wandooID)]![String(userID)])
            userModel.userDefaults.setObject(userModel.acceptOrRejectList, forKey: "acceptOrRejectList")
            
            //PUT YOUR PUSH CODE HERE FOR ACCEPT AND REJECT
            print(allInterestedInfo![sender.tag]["objectID"])
            //----------------------------
            cell!.userInteractionEnabled = false
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let interestedCell = tableView.dequeueReusableCellWithIdentifier("interestedCell", forIndexPath: indexPath) as! InterestedCell
        if self.allInterestedInfo![indexPath.row]["selected"] as! Int == 1 {
            interestedCell.accept.backgroundColor = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 0.5)
        }
        interestedCell.name.text = self.allInterestedInfo![indexPath.row]["name"] as? String
        interestedCell.ageSex.text = String(self.allInterestedInfo![indexPath.row]["sex"]!) + ", " + String(self.allInterestedInfo![indexPath.row]["age"]!)
        
        if let employer = self.allInterestedInfo![indexPath.row]["employer"]! as? String {
            if let jobTitle = self.allInterestedInfo![indexPath.row]["job_title"]! as? String {
                interestedCell.employerAndOrEdu.text = jobTitle
                interestedCell.employerAndOrEdu.text! += " at " + employer
            } else {
                interestedCell.employerAndOrEdu.text = employer
            }
            
            if let edu = self.allInterestedInfo![indexPath.row]["education"]! as? String {
                interestedCell.employerAndOrEdu.text! += "\n" + edu
            }
        } else {
            if let edu = self.allInterestedInfo![indexPath.row]["education"]! as? String {
                interestedCell.employerAndOrEdu.text = edu
            }
        }
    
        interestedCell.reject.tag = indexPath.row
        interestedCell.accept.tag = indexPath.row
        
        interestedCell.picture.image = self.allInterestedInfo![indexPath.row]["profile_picture"] as? UIImage
        interestedCell.picture.layer.borderWidth = 1
        interestedCell.picture.layer.masksToBounds = false
        interestedCell.picture.layer.borderColor = UIColor.whiteColor().CGColor
        interestedCell.picture.layer.cornerRadius = interestedCell.picture.frame.height/2
        interestedCell.picture.layer.cornerRadius = interestedCell.picture.frame.width/2
        interestedCell.picture.clipsToBounds = true
        
        interestedCell.cardView.layer.borderWidth = 1
        interestedCell.cardView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        interestedCell.reject.layer.borderWidth = 1
        interestedCell.reject.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        interestedCell.accept.layer.borderWidth = 1
        interestedCell.accept.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        print(allInterestedInfo![indexPath.row])
        
        let wandooID = self.myWandooInfo!["wandooID"] as! Int
        let userID = self.allInterestedInfo![indexPath.row]["userID"] as! Int
        print(wandooID)
        print(userID)
        
        if let acceptOrRejectList = userModel.acceptOrRejectList[String(wandooID)] {
            print(acceptOrRejectList)
            if let decision = acceptOrRejectList[String(userID)] {
                print(decision)
                if decision == 1 {
                    interestedCell.reject.backgroundColor = UIColor(red: 100.0/255.0, green: 181.0/255.0, blue: 246.0/255.0, alpha: 0.5)
                    interestedCell.reject.userInteractionEnabled = false
                    interestedCell.accept.userInteractionEnabled = false
                } else if decision == 2 {
                    interestedCell.accept.backgroundColor = UIColor(red: 100.0/255.0, green: 181.0/255.0, blue: 246.0/255.0, alpha: 0.5)
                    interestedCell.accept.userInteractionEnabled = false
                    interestedCell.reject.userInteractionEnabled = false
                } else {
                    interestedCell.reject.backgroundColor = UIColor(white:0.88, alpha:1.0)
                    interestedCell.reject.userInteractionEnabled = true
                    interestedCell.accept.backgroundColor = UIColor(white:0.88, alpha:1.0)
                    interestedCell.accept.userInteractionEnabled = true
                }
            }
        }
        
//        interestedCell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return interestedCell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if allInterestedInfo == nil {
            return 0
        } else {
            return allInterestedInfo!.count
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toAcceptRejectProfile" {
            let selectedIndex = acceptRejectTable.indexPathForCell(sender as! InterestedCell)
            
            let interestedInfo = allInterestedInfo![selectedIndex!.row]
            let destinationVC = segue.destinationViewController as! AcceptRejectProfileViewController
            destinationVC.interestedInfo = interestedInfo
        }
    }
    
    func getInterestedPeople(completion: () -> Void) {
        let wandooID = self.myWandooInfo!["wandooID"] as! Int
        
        if let _ = userModel.acceptOrRejectList[String(wandooID)] {
            print("available")
        } else {
            userModel.acceptOrRejectList[String(wandooID)] = [:]
        }
        
        interestedModel.getInterestedPeople(wandooID, completion: { (result) -> Void in

            self.allInterestedInfo = result as? Array<NSMutableDictionary>
            var count = 0
//            dispatch_async(dispatch_get_main_queue()){
                for interestedPeople in self.allInterestedInfo! {
                    if let _ = self.userModel.acceptOrRejectList[String(wandooID)]![String(interestedPeople["userID"]!)] {
                        print("userID already exists")
                    } else {
                        self.userModel.acceptOrRejectList[String(wandooID)]![String(interestedPeople["userID"]!)] = 0
                    }
                    self.userModel.getUserInfoByUserID(interestedPeople["userID"] as! Int, completion: { (result) -> Void in
                        let fullName = result["name"] as? String
                        let fullNameArr = fullName!.characters.split{$0 == " "}.map(String.init)
                        interestedPeople["name"] = fullNameArr[0]
                        interestedPeople["age"] = String(result["age"]!)
                        if result["sex"] as! String == "m" {
                            interestedPeople["sex"] = "Male"
                        } else if result["sex"] as! String == "f"{
                            interestedPeople["sex"] = "Female"
                        }
                        interestedPeople["employer"] = result["employer"]
                        interestedPeople["job_title"] = result["job_title"]
                        interestedPeople["education"] = result["institution_name"]
                        interestedPeople["objectID"] = result["objectID"]
                        let picString = result["profile_picture"] as! String
                        let picURL = NSURL(string: picString)
                        if let pic = NSData(contentsOfURL: picURL!) {
                            interestedPeople["profile_picture"] = UIImage(data: pic)
                            count++
                            if count == self.allInterestedInfo!.count {
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.interestedTable.reloadData()
                                }
                                let acceptOrRejectList = self.userModel.acceptOrRejectList as NSDictionary
                                self.userModel.userDefaults.setObject(acceptOrRejectList, forKey: "acceptOrRejectList")
                                self.userModel.userDefaults.synchronize()
                            }
                            
                        }
                        
                    })
                }
//            }
        })
    }
    
}
