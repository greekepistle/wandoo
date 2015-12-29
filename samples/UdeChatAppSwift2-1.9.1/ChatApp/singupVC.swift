//
//  singupVC.swift
//  ChatApp
//
//  Created by Valsamis Elmaliotis on 11/4/14.
//  Copyright (c) 2014 Valsamis Elmaliotis. All rights reserved.
//

import UIKit

class singupVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var addImgBtn: UIButton!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var profileNameTxt: UITextField!
    @IBOutlet weak var singupBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let theWidth = view.frame.size.width
        _ = view.frame.size.height
        
        profileImg.center = CGPointMake(theWidth/2, 140)
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        profileImg.clipsToBounds = true
        
        addImgBtn.center = CGPointMake(self.profileImg.frame.maxX+50, 140)
        usernameTxt.frame = CGRectMake(16, 230, theWidth-32, 30)
        passwordTxt.frame = CGRectMake(16, 270, theWidth-32, 30)
        profileNameTxt.frame = CGRectMake(16, 310, theWidth-32, 30)
        singupBtn.center = CGPointMake(theWidth/2, 380)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func addImgBtn_click(sender: AnyObject) {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        profileImg.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        usernameTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        profileNameTxt.resignFirstResponder()
        return true
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        if (UIScreen.mainScreen().bounds.height == 568) {
            
            if (textField == self.profileNameTxt) {
                
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
                    
                    self.view.center = CGPointMake(theWidth/2, (theHeight/2)-40)
                
                    }, completion: {
                        (finished:Bool) in
                        
                        //
                })
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        if (UIScreen.mainScreen().bounds.height == 568) {
            
            if (textField == self.profileNameTxt) {
                
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
                    
                    self.view.center = CGPointMake(theWidth/2, (theHeight/2))
                    
                    }, completion: {
                        (finished:Bool) in
                        
                        //
                        
                })
            }
        }
    }
    
    @IBAction func singupBtn_click(sender: AnyObject) {
        
        let user = PFUser()
        user.username = usernameTxt.text
        user.password = passwordTxt.text
        user.email = usernameTxt.text
        user["profileName"] = profileNameTxt.text
        
        let imageData = UIImagePNGRepresentation(self.profileImg.image!)
        let imageFile = PFFile(name: "profilePhoto.png", data: imageData!)
        user["photo"] = imageFile
        
        user.signUpInBackgroundWithBlock {
            (succeeded:Bool, signUpError:NSError?) -> Void in
            
            if signUpError == nil {
                
                print("signup")
                
                let installation:PFInstallation = PFInstallation.currentInstallation()
                installation["user"] = PFUser.currentUser()
                installation.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                    
                })
                
                self.performSegueWithIdentifier("goToUsersVC2", sender: self)
            } else {
                
                print("can't signup")
            }
            
        }
    }
    
    
}
