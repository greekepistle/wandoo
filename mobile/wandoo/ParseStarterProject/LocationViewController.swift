//
//  LocationViewController.swift
//  ParseStarterProject-Swift
//
//  Created by William Lee on 12/15/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func buttonAction(send: UIButton!) {
        self.performSegueWithIdentifier("toPostViewController", sender: self)
    }

   
    @IBAction func CancelLocationButton(sender: UIButton) {
    }
    
    @IBAction func SubmitLocationButton(sender: UIButton) {
    }
}
