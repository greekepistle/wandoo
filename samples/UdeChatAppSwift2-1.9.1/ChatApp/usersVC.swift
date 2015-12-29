//
//  usersVC.swift
//  ChatApp
//
//  Created by Valsamis Elmaliotis on 11/5/14.
//  Copyright (c) 2014 Valsamis Elmaliotis. All rights reserved.
//

import UIKit

var userName = ""

class usersVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var resultsTable: UITableView!
    
    var resultsUsernameArray = [String]()
    var resultsProfileNameArray = [String]()
    var resultsImageFiles = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _ = view.frame.size.width
        let theHeight = view.frame.size.height
        
        resultsTable.frame = CGRectMake(0, 0, theHeight, theHeight-64)
        
        let messagesBarBtn = UIBarButtonItem(title: "Messages", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("messagesBtn_click"))
        
        let groupBarBtn = UIBarButtonItem(title: "Group", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("groupBtn_click"))
        
        let buttonArray = NSArray(objects: messagesBarBtn,groupBarBtn)
        self.navigationItem.rightBarButtonItems = buttonArray as? [UIBarButtonItem]
        
        userName = PFUser.currentUser()!.username!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func messagesBtn_click() {
        
        print("messages")
        
        self.performSegueWithIdentifier("goToMessagesVC_FromUsersVC", sender: self)
        
    }
    
    func groupBtn_click() {
        
        print("group")
        
        self.performSegueWithIdentifier("goToGroupVC_FromUsersVC", sender: self)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        resultsUsernameArray.removeAll(keepCapacity: false)
        resultsProfileNameArray.removeAll(keepCapacity: false)
        resultsImageFiles.removeAll(keepCapacity: false)
        
        let predicate = NSPredicate(format: "username != '"+userName+"'")
        let query = PFQuery(className: "_User", predicate: predicate)
        let objects = try! query.findObjects()  //UPDATE THIS
        
        //let objects = objects! as [PFObject]
        for object in objects {  //UPDATE THIS
            
            let us:PFUser = object as! PFUser //UPDATE THIS ADD IT
            self.resultsUsernameArray.append(us.username!)   //UPDATE THIS
            self.resultsProfileNameArray.append(object["profileName"] as! String)
            self.resultsImageFiles.append(object["photo"] as! PFFile)
            
            self.resultsTable.reloadData()
            
            
        }
        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! resultsCell
        
        otherName = cell.usernameLbl.text!
        otherProfileName = cell.profileNameLbl.text!
        self.performSegueWithIdentifier("goToConversationVC", sender: self)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsUsernameArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:resultsCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! resultsCell
        
        cell.usernameLbl.text = self.resultsUsernameArray[indexPath.row]
        cell.profileNameLbl.text = self.resultsProfileNameArray[indexPath.row]
        
        resultsImageFiles[indexPath.row].getDataInBackgroundWithBlock {
            (imageData: NSData?, error:NSError?) -> Void in
            
            if error == nil {
                
                let image = UIImage(data: imageData!)
                cell.profileImg.image = image
                
            }
        }
        
        return cell
        
    }
    
    
    @IBAction func logoutBtn_click(sender: AnyObject) {
        
        PFUser.logOut()
        self.navigationController?.popToRootViewControllerAnimated(true)
        
        
    }
    

}
