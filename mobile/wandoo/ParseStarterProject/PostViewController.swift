//
//  PostViewController.swift
//  ParseStarterProject-Swift
//
//  Created by William Lee on 12/15/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITextFieldDelegate {

    var wandooModel = WandooModel.sharedWandooInstance
    var userModel = UserModel.sharedUserInstance
    var keyboardHeight:CGFloat = 0
    
    
    @IBOutlet weak var wandooMessage: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var selectingView: UIToolbar!
    @IBOutlet weak var postView: UIView!
    
    @IBOutlet weak var selectingViewHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageTextField.delegate = self
        let postButton : UIBarButtonItem = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.Done, target: self, action: "buttonAction:")
        self.navigationItem.rightBarButtonItem = postButton

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)

        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tableViewTapped")
        self.postView.addGestureRecognizer(tapGesture)
    }
    
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        keyboardHeight = keyboardRectangle.height
    }
    
    func tableViewTapped() {
        self.messageTextField.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.view.layoutIfNeeded()
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            UIView.animateWithDuration(0.5) { () -> Void in
                self.selectingViewHeight.constant = self.keyboardHeight
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.5) { () -> Void in
            self.selectingViewHeight.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Upon tapping Post button: PUT request for user location and POST request for user's wandoo
    func buttonAction(send: UIButton!) {
        wandooModel.text = wandooMessage.text
        print(wandooModel.text!)
        userModel.postLocation { () -> Void in
            print("suck it")
        }
        

        wandooModel.postWandoo { (result) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("toWandooController", sender: self)
            }
        }
    }

    @IBAction func cancelPeopleUnwind(segue:UIStoryboardSegue) {
    }    
    
    @IBAction func submitPeopleUnwind(segue:UIStoryboardSegue) {
    }
    
    @IBAction func cancelTimeUnwind(segue:UIStoryboardSegue) {
    }
    
    @IBAction func submitTimeUnwind(segue:UIStoryboardSegue) {
    }
    
    @IBAction func cancelLocationUnwind(segue:UIStoryboardSegue) {
    }
    
    @IBAction func submitLocationUnwind(segue:UIStoryboardSegue) {
    }
    
    
}