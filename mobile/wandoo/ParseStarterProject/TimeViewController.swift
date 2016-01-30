//
//  TimeViewController.swift
//  ParseStarterProject-Swift
//
//  Created by William Lee on 12/15/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class TimeViewController: UIViewController {
    
    let userModel = UserModel.sharedUserInstance
    let wandooModel = WandooModel.sharedWandooInstance
    
    let sb = UIStoryboard(name: "Main", bundle: nil)

    @IBOutlet weak var timeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        
        let calendar = NSCalendar.currentCalendar()
        datePicker.date = calendar.dateByAddingUnit(.Minute, value: 30, toDate: NSDate(), options: [])!
        datePicker.minimumDate = NSDate()
        datePicker.maximumDate = calendar.dateByAddingUnit(.Minute, value: 10080, toDate: NSDate(), options: [])!
        datePicker.addTarget(self, action: Selector("startDatePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
         self.timeButton.tintColor = UIColor(red: 41.0/255.0, green: 121.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    
    func buttonAction(send: UIButton!) {
        self.performSegueWithIdentifier("toPostViewController", sender: self)
    }

    @IBAction func postButton(sender: UIButton) {
        self.navigationController?.navigationBarHidden = true
        self.tabBarController!.tabBar.translucent = true
        self.tabBarController!.tabBar.hidden = true
        wandooModel.startTime = timePickerToString(datePicker)
        userModel.postLocation { () -> Void in
            print("usermodel postLocation it")
            self.wandooModel.postWandoo({ () -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    
                }
//                let backToFeed = self.sb.instantiateViewControllerWithIdentifier("tabBar")
//                self.navigationController?.pushViewController(backToFeed, animated: true)
                
//                self.presentViewController(self.wandooModel.backToFeed, animated: true, completion: nil)
                
            })
        }
            
//        wandooModel.postWandoo { (result) -> Void in
////            dispatch_async(dispatch_get_main_queue()) {
////                self.performSegueWithIdentifier("toWandooController", sender: self)
////            }
//        }
    }
   
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var endTimeDatePicker: UIDatePicker!
   
    func startDatePickerChanged(datePicker:UIDatePicker) {
        _ = NSDateFormatter()

    }
    
//    func endDatePickerChanged(datePicker:UIDatePicker) {
//        let dateFormatter = NSDateFormatter()
//        
//    }
    
    func timePickerToString(sender: UIDatePicker) -> String {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let stringDate = timeFormatter.stringFromDate(sender.date)
        
        return stringDate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
