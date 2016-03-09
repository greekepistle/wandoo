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

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet weak var messageTableView: UITableView!
    
    @IBOutlet weak var messageTextView: UIView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    
    @IBOutlet weak var messageSendButton: UIButton!
    
    
    @IBOutlet weak var messageDockViewHeight: NSLayoutConstraint!
    
    
    
    var messagesArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.titleView = UIImageView(image: UIImage(named: "chats"))

        self.messageTableView.dataSource = self
        self.messageTableView.delegate = self
        
        self.messageTextField.delegate = self
        
        //Add sample data;
        //        self.messagesArray.append("Text1")
        //        self.messagesArray.append("Text2")
        
        
        //Add a tap gesture recognizer to tableview
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tableViewTapped")
        self.messageTableView.addGestureRecognizer(tapGesture)
        
        self.retrieveMessages()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func messageSendButtonClicked(sender: UIButton) {
        
        self.messageTextField.endEditing(true)
        
        self.messageTextField.enabled = false;
        self.messageSendButton.enabled = false;
        
        let messagePFObj = PFObject(className:"Messages")
        messagePFObj["textField"] = self.messageTextField.text
        
        messagePFObj.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                print("PF obj saved")
                
                
                self.retrieveMessages()
            } else {
                print("Not saved")
            }
        }
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.messageTextField.text = ""
            self.messageTextField.enabled = true;
            self.messageSendButton.enabled = true;
        }
        
        
    }
    
    
    func tableViewTapped(){
        
        self.messageTextField.endEditing(true)
        
    }
    
    
    
    func retrieveMessages() {
        //Create new PF query
        let query = PFQuery(className: "Messages")
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                
                
                
                // Do save the object.text fields in messageText field
                self.messagesArray = [String]()
                
                if let objects = objects {
                    for object in objects {
                        self.messagesArray.append(object["textField"] as! String)
                        //                        print(object["textField"])
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        
                        self.messageTableView.reloadData()
                    }
                    
                    
                }
                
            } else {
                // Log details of the failure at
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        
    }
    
    
    //MARK: Text Field Delegate Methods
    func textFieldDidBeginEditing(textField: UITextField) {
        
        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.5) { () -> Void in
            
            self.messageDockViewHeight.constant = 350
            self.view.layoutIfNeeded()
        }
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.5) { () -> Void in
            
            self.messageDockViewHeight.constant = 60
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    
    //MARK: Table View Delegate Methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //create a table cell
        let cell = self.messageTableView.dequeueReusableCellWithIdentifier("MessageCell")! as UITableViewCell
        //put value to it
        
        cell.textLabel?.text = self.messagesArray[indexPath.row]
        //return that cell
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    
}
