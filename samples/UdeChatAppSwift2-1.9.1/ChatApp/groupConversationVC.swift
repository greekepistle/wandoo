//
//  groupConversationVC.swift
//  chatapp
//
//  Created by Valsamis Elmaliotis on 5/29/15.
//  Copyright (c) 2015 Valsamis Elmaliotis. All rights reserved.
//

import UIKit

var groupConversationVC_title = ""

class groupConversationVC: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
    
    @IBOutlet weak var resultsScrollView: UIScrollView!
    @IBOutlet weak var frameMessageView: UIView!
    @IBOutlet weak var lineLbl: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    var scrollViewOriginalY:CGFloat = 0
    var frameMessageOriginalY:CGFloat = 0
    
    var myImg:UIImage? = UIImage()
    
    var resultsImageFiles = [PFFile]()
    var resultsImageFiles2 = [PFFile]()
    
    let mLbl = UILabel(frame: CGRectMake(5, 10, 200, 20))
    
    var messageX:CGFloat = 37.0
    var messageY:CGFloat = 26.0
    var frameX:CGFloat = 32.0
    var frameY:CGFloat = 21.0
    var imgX:CGFloat = 3
    var imgY:CGFloat = 3

    var messageArray = [String]()
    var senderArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        resultsScrollView.frame = CGRectMake(0, 64, theWidth, theHeight-114)
        resultsScrollView.layer.zPosition = 20
        frameMessageView.frame = CGRectMake(0, resultsScrollView.frame.maxY, theWidth, 50)
        lineLbl.frame = CGRectMake(0, 0, theWidth, 1)
        messageTextView.frame = CGRectMake(2, 1, self.frameMessageView.frame.size.width-52, 48)
        sendBtn.center = CGPointMake(frameMessageView.frame.size.width-30, 24)
        
        scrollViewOriginalY = self.resultsScrollView.frame.origin.y
        frameMessageOriginalY = self.frameMessageView.frame.origin.y
        
        mLbl.text = "Type a message..."
        mLbl.backgroundColor = UIColor.clearColor()
        mLbl.textColor = UIColor.lightGrayColor()
        messageTextView.addSubview(mLbl)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        let tapScrollViewGesture = UITapGestureRecognizer(target: self, action: "didTapScrollView")
        tapScrollViewGesture.numberOfTapsRequired = 1
        resultsScrollView.addGestureRecognizer(tapScrollViewGesture)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getGroupMessageFunc", name: "getGroupMessage", object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getGroupMessageFunc() {
        
        refreshResults()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.title = groupConversationVC_title
        
        let query = PFQuery(className: "_User")
        
        query.whereKey("username", equalTo: userName)
        
        let objects = try! query.findObjects()  //UPDATE THIS
        
        self.resultsImageFiles.removeAll(keepCapacity: false)
        
        for object in objects { //UPDATE THIS
            
            self.resultsImageFiles.append(object["photo"] as! PFFile)
            
            self.resultsImageFiles[0].getDataInBackgroundWithBlock({
                (imageData:NSData?, error:NSError?) -> Void in
                
                if error == nil {
                    
                    self.myImg = UIImage(data: imageData!)
                    
                    self.refreshResults()
                    
                    
                }
                
            })
            
            
        }
        
    }
    
    func refreshResults() {
        
        let theWidth = view.frame.size.width
        //let theHeight = view.frame.size.height
        
        messageX = 37.0
        messageY = 26.0
        frameX = 32.0
        frameY = 21.0
        imgX = 3
        imgY = 3
        
        messageArray.removeAll(keepCapacity: false)
        senderArray.removeAll(keepCapacity: false)
        
        let query = PFQuery(className: "GroupMessages")
        
        
        query.whereKey("group", equalTo: groupConversationVC_title)
        query.addAscendingOrder("createdAt")
        
        query.findObjectsInBackgroundWithBlock {
            (objects:[PFObject]?, error:NSError?) -> Void in  //UPDATE THIS
            
            if error == nil {
                
                for object in objects! {
                    
                    self.senderArray.append(object.objectForKey("sender") as! String)
                    self.messageArray.append(object.objectForKey("message") as! String)
                    
                }
                
                for subView in self.resultsScrollView.subviews {
                    subView.removeFromSuperview()
                    
                }
                
                for var i = 0; i <= self.messageArray.count-1; i++ {
                    
                    if self.senderArray[i] == userName {
                        
                        let messageLbl:UILabel = UILabel()
                        messageLbl.frame = CGRectMake(0, 0, self.resultsScrollView.frame.size.width-94, CGFloat.max)
                        messageLbl.backgroundColor = UIColor.blueColor()
                        messageLbl.lineBreakMode = NSLineBreakMode.ByWordWrapping
                        messageLbl.textAlignment = NSTextAlignment.Left
                        messageLbl.numberOfLines = 0
                        messageLbl.font = UIFont(name: "Helvetica Neuse", size: 17)
                        messageLbl.textColor = UIColor.whiteColor()
                        messageLbl.text = self.messageArray[i]
                        messageLbl.sizeToFit()
                        messageLbl.layer.zPosition = 20
                        messageLbl.frame.origin.x = (self.resultsScrollView.frame.size.width - self.messageX) - messageLbl.frame.size.width
                        messageLbl.frame.origin.y = self.messageY
                        self.resultsScrollView.addSubview(messageLbl)
                        self.messageY += messageLbl.frame.size.height + 30
                        
                        let frameLbl:UILabel = UILabel()
                        frameLbl.frame.size = CGSizeMake(messageLbl.frame.size.width+10, messageLbl.frame.size.height+10)
                        frameLbl.frame.origin.x = (self.resultsScrollView.frame.size.width - self.frameX) - frameLbl.frame.size.width
                        frameLbl.frame.origin.y = self.frameY
                        frameLbl.backgroundColor = UIColor.blueColor()
                        frameLbl.layer.masksToBounds = true
                        frameLbl.layer.cornerRadius = 10
                        self.resultsScrollView.addSubview(frameLbl)
                        self.frameY += frameLbl.frame.size.height + 20
                        
                        let img:UIImageView = UIImageView()
                        img.image = self.myImg
                        img.frame.size = CGSizeMake(34, 34)
                        img.frame.origin.x = (self.resultsScrollView.frame.size.width - self.imgX) - img.frame.size.width
                        img.frame.origin.y = self.imgY
                        img.layer.zPosition = 30
                        img.layer.cornerRadius = img.frame.size.width/2
                        img.clipsToBounds = true
                        self.resultsScrollView.addSubview(img)
                        self.imgY += frameLbl.frame.size.height + 20
                        
                        self.resultsScrollView.contentSize = CGSizeMake(theWidth, self.messageY)
                        
                    } else {
                        
                        let messageLbl:UILabel = UILabel()
                        messageLbl.frame = CGRectMake(0, 0, self.resultsScrollView.frame.size.width-94, CGFloat.max)
                        messageLbl.backgroundColor = UIColor.groupTableViewBackgroundColor()
                        messageLbl.lineBreakMode = NSLineBreakMode.ByWordWrapping
                        messageLbl.textAlignment = NSTextAlignment.Left
                        messageLbl.numberOfLines = 0
                        messageLbl.font = UIFont(name: "Helvetica Neuse", size: 17)
                        messageLbl.textColor = UIColor.blackColor()
                        messageLbl.text = self.messageArray[i]
                        messageLbl.sizeToFit()
                        messageLbl.layer.zPosition = 20
                        messageLbl.frame.origin.x = self.messageX
                        messageLbl.frame.origin.y = self.messageY
                        self.resultsScrollView.addSubview(messageLbl)
                        self.messageY += messageLbl.frame.size.height + 30
                        
                        let frameLbl:UILabel = UILabel()
                        frameLbl.frame = CGRectMake(self.frameX, self.frameY, messageLbl.frame.size.width+10, messageLbl.frame.size.height+10)
                        frameLbl.backgroundColor = UIColor.groupTableViewBackgroundColor()
                        frameLbl.layer.masksToBounds = true
                        frameLbl.layer.cornerRadius = 10
                        self.resultsScrollView.addSubview(frameLbl)
                        self.frameY += frameLbl.frame.size.height + 20
                        
                        let img:UIImageView = UIImageView()
                        
                        let query = PFQuery(className: "_User")
                        
                        query.whereKey("username", equalTo: self.senderArray[i])
                        let objects = try! query.findObjects()  //UPDATE THIS
                        
                        self.resultsImageFiles2.removeAll(keepCapacity: false)
                        
                        for object in objects {  //UPDATE THIS
                            
                            self.resultsImageFiles2.append(object["photo"] as! PFFile)
                            
                            self.resultsImageFiles2[0].getDataInBackgroundWithBlock({
                                (imageData:NSData?, error:NSError?) -> Void in
                                
                                if error == nil {
                                    
                                    img.image = UIImage(data: imageData!)
                                    
                                }
                                
                            })
                            
                        }
                        
                        img.frame = CGRectMake(self.imgX, self.imgY, 34, 34)
                        img.layer.zPosition = 30
                        img.layer.cornerRadius = img.frame.size.width/2
                        img.clipsToBounds = true
                        self.resultsScrollView.addSubview(img)
                        self.imgY += frameLbl.frame.size.height + 20
                        
                        self.resultsScrollView.contentSize = CGSizeMake(theWidth, self.messageY)
                        
                    }
                    
                    let bottomOffset:CGPoint = CGPointMake(0, self.resultsScrollView.contentSize.height - self.resultsScrollView.bounds.size.height)
                    self.resultsScrollView.setContentOffset(bottomOffset, animated: false)
                    
                }
                
            }
            
        }

        
    }
    
    func keyboardWasShown(notification:NSNotification) {
        
        let dict:NSDictionary = notification.userInfo!
        let s:NSValue = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let rect:CGRect = s.CGRectValue()
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
            
            self.resultsScrollView.frame.origin.y = self.scrollViewOriginalY - rect.height
            self.frameMessageView.frame.origin.y = self.frameMessageOriginalY - rect.height
            
            let bottomOffset:CGPoint = CGPointMake(0, self.resultsScrollView.contentSize.height - self.resultsScrollView.bounds.size.height)
            self.resultsScrollView.setContentOffset(bottomOffset, animated: false)
            
            }, completion: {
                (finished:Bool) in
                
        })
        
    }
    
    func keyboardWillHide(notification:NSNotification) {
        
        //let dict:NSDictionary = notification.userInfo!
        //let s:NSValue = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        //let rect:CGRect = s.CGRectValue()
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
            
            self.resultsScrollView.frame.origin.y = self.scrollViewOriginalY
            self.frameMessageView.frame.origin.y = self.frameMessageOriginalY
            
            let bottomOffset:CGPoint = CGPointMake(0, self.resultsScrollView.contentSize.height - self.resultsScrollView.bounds.size.height)
            self.resultsScrollView.setContentOffset(bottomOffset, animated: false)
            
            }, completion: {
                (finished:Bool) in
                
        })
        
        
    }

    func didTapScrollView() {
        
        self.view.endEditing(true)
    }
    
    func textViewDidChange(textView: UITextView) {
    
        if !messageTextView.hasText() {
    
            self.mLbl.hidden = false
        } else {
    
            self.mLbl.hidden = true
        }
    
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        if !messageTextView.hasText() {
            self.mLbl.hidden = false
        }
    }

    @IBAction func sendBtn_click(sender: AnyObject) {
        
        if messageTextView.text == "" {
            
            print("no text")
            
            
        } else {
            
            let groupMessageTable = PFObject(className: "GroupMessages")
            
            groupMessageTable["group"] = groupConversationVC_title
            groupMessageTable["sender"] = userName
            groupMessageTable["message"] = self.messageTextView.text
            
            groupMessageTable.saveInBackgroundWithBlock({
                (success:Bool, error:NSError?) -> Void in
                
                if success == true {
                    
                    var senderSet = Set([""])
                    senderSet.removeAll(keepCapacity: false)
                    
                    for var i = 0; i <= self.senderArray.count - 1; i++ {
                        
                        if self.senderArray[i] != userName {
                            
                            senderSet.insert(self.senderArray[i])
                            
                        }
                        
                    }
                    
                    let senderSetArray: NSArray = Array(senderSet)
                    
                    for var i2 = 0; i2 <= senderSetArray.count - 1; i2++ {
                        
                        print(senderSetArray[i2])
                        
                        let uQuery:PFQuery = PFUser.query()!
                        uQuery.whereKey("username", equalTo: senderSetArray[i2])
                        
                        let pushQuery:PFQuery = PFInstallation.query()!
                        pushQuery.whereKey("user", matchesQuery: uQuery)
                        
                        let push:PFPush = PFPush()
                        push.setQuery(pushQuery)
                        push.setMessage("New Group Message")
                        push.sendPushInBackgroundWithBlock({
                            (success:Bool, error:NSError?) -> Void in
                            
                        })
                        print("push sent")

                    }
                    
                    
                    print("message sent")
                    
                    self.messageTextView.text = ""
                    self.mLbl.hidden = false
                    self.refreshResults()
                    
                }
                
            })
            
        }
        
    }

}
