//
//  DetailsViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Brian Kwon on 12/26/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var wandooInfo: NSDictionary!
    
    @IBOutlet weak var test: UILabel!
    
    var interestedModel = InterestedModel()
    
    @IBAction func interestedButton(sender: UIButton) {
        let wandooID = wandooInfo["wandooID"] as! Int
        interestedModel.showInterest(wandooID)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let wandooID = wandooInfo["wandooID"] as! Int
        
        print(wandooID + 1000)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
