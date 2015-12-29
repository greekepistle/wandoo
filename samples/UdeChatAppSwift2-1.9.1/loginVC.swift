//
//  loginVC.swift
//  ChatApp
//
//  Created by Valsamis Elmaliotis on 11/4/14.
//  Copyright (c) 2014 Valsamis Elmaliotis. All rights reserved.
//

import UIKit

class loginVC: UIViewController {
    
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var singupBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        welcomeLbl.center = CGPointMake(theWidth/2, 130)
        usernameTxt.frame = CGRectMake(16, 200, theWidth-32, 30)
        passwordTxt.frame = CGRectMake(16, 240, theWidth-32, 30)
        loginBtn.center = CGPointMake(theWidth/2, 330)
        singupBtn.center = CGPointMake(theWidth/2, theHeight-30)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func loginBtn_click(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(usernameTxt.text!, password: passwordTxt.text!) {
            (user:PFUser?, logInError:NSError?) -> Void in
            
            if logInError == nil {
                
                
                print("log in")
                
                let installation:PFInstallation = PFInstallation.currentInstallation()
                installation["user"] = PFUser.currentUser()
                installation.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                    
                })
                
                self.performSegueWithIdentifier("goToUsersVC", sender: self)
            } else {
                
                
                print("error log in")
            }
        
        }
    }
}
