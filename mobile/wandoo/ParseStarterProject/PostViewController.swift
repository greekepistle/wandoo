//
//  PostViewController.swift
//  ParseStarterProject-Swift
//
//  Created by William Lee on 12/15/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    var wandooModel = WandooModel.sharedWandooInstance
    var userModel = UserModel.sharedUserInstance
    
    @IBOutlet weak var wandooMessage: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let postButton : UIBarButtonItem = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.Done, target: self, action: "buttonAction:")
        self.navigationItem.rightBarButtonItem = postButton
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Upon tapping Post button: PUT request for user location and POST request for user's wandoo
    func buttonAction(send: UIButton!) {
        wandooModel.text = wandooMessage.text
        print(wandooModel.text!)
        userModel.postLocation()
        

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