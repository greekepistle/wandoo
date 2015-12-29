//
//  messagesVC.swift
//  chatapp
//
//  Created by Valsamis Elmaliotis on 2/4/15.
//  Copyright (c) 2015 Valsamis Elmaliotis. All rights reserved.
//

import UIKit

class messagesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var resultsTable: UITableView!
    
    var resultsNameArray = [String]()
    var resultsImageFiles = [PFFile]()
    
    var senderArray = [String]()
    var otherArray = [String]()
    var messageArray = [String]()
    
    var sender2Array = [String]()
    var other2Array = [String]()
    var message2Array = [String]()
    
    var sender3Array = [String]()
    var other3Array = [String]()
    var message3Array = [String]()
    
    var results = 0
    var currResult = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        resultsTable.frame = CGRectMake(0, 0, theWidth, theHeight - 64)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        resultsNameArray.removeAll(keepCapacity: false)
        resultsImageFiles.removeAll(keepCapacity: false)
        
        senderArray.removeAll(keepCapacity: false)
        otherArray.removeAll(keepCapacity: false)
        messageArray.removeAll(keepCapacity: false)
        
        sender2Array.removeAll(keepCapacity: false)
        other2Array.removeAll(keepCapacity: false)
        message2Array.removeAll(keepCapacity: false)
        
        sender3Array.removeAll(keepCapacity: false)
        other3Array.removeAll(keepCapacity: false)
        message3Array.removeAll(keepCapacity: false)
    
        
        let setPredicate = NSPredicate(format: "sender = %@ OR other = %@", userName, userName)
        let query = PFQuery(className: "Messages", predicate: setPredicate)
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackgroundWithBlock {
            (objects:[PFObject]?, error:NSError?) -> Void in //UPDATE THIS
        
            if error == nil {
                
                for object in objects! {
                    
                    self.senderArray.append(object.objectForKey("sender") as! String)
                    self.otherArray.append(object.objectForKey("other") as! String)
                    self.messageArray.append(object.objectForKey("message") as! String)
                    
                }
                
                for var i = 0; i <= self.senderArray.count - 1; i++ {
                    
                    if self.senderArray[i] == userName {
                        
                        self.other2Array.append(self.otherArray[i])
                    } else {
                        
                        self.other2Array.append(self.senderArray[i])
                    }
                    
                    self.message2Array.append(self.messageArray[i])
                    self.sender2Array.append(self.senderArray[i])
                }
                
                for var i2 = 0; i2 <= self.other2Array.count - 1; i2++ {
                    
                    var isfound = false
                    
                    for var i3 = 0; i3 <= self.other3Array.count - 1; i3++ {
                        
                        if self.other3Array[i3] == self.other2Array[i2] {
                            
                            isfound = true
                        }
                        
                    }
                    
                    if isfound == false {
                        
                        self.other3Array.append(self.other2Array[i2])
                        self.message3Array.append(self.message2Array[i2])
                        self.sender3Array.append(self.sender2Array[i2])
                        
                    }
                    
                }
                
                self.results = self.other3Array.count
                self.currResult = 0
                self.fetchResults()
                
            } else {
                
                //
                
            }
        
        
        }
        
        
    }
    
    func fetchResults() {
        
        if currResult < results {
            
            let queryF = PFUser.query()
            queryF!.whereKey("username", equalTo: self.other3Array[currResult])
            
            let objects = try! queryF!.findObjects()  //UPDATE THIS
            
            for object in objects {   //UPDATE THIS
                
                self.resultsNameArray.append(object.objectForKey("profileName") as! String)
                self.resultsImageFiles.append(object.objectForKey("photo") as! PFFile)
                
                self.currResult = self.currResult + 1
                self.fetchResults()
                
                self.resultsTable.reloadData()
                
            }
            
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: Table
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsNameArray.count
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:messageCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! messageCell
        
        cell.nameLbl.text = self.resultsNameArray[indexPath.row]
        cell.messageLbl.text = self.message3Array[indexPath.row]
        cell.usernameLbl.text = self.other3Array[indexPath.row]
        
        resultsImageFiles[indexPath.row].getDataInBackgroundWithBlock {
            (imageData : NSData? , error : NSError?) -> Void in
            
            if error == nil {
                
                let image = UIImage(data: imageData!)
                cell.profileImageView.image = image
                
            }
            
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! messageCell
        
        otherName = cell.usernameLbl.text!
        otherProfileName = cell.nameLbl.text!
        self.performSegueWithIdentifier("goToConversationVC2", sender: self)
        

        
    }
    
}
