//
//  PeopleViewController.swift
//  ParseStarterProject-Swift
//
//  Created by William Lee on 12/15/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {
    
    var wandooModel = WandooModel.sharedWandooInstance
    var wandooPostInput = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StepCounter.autorepeat = true
        StepCounter.maximumValue = 5.0
        StepCounter.minimumValue = 2.0
        quantity.text = "\(Int(StepCounter.value))"
        StepCounter.addTarget(self, action: "stepperValueDidChange:", forControlEvents: .ValueChanged)
        self.peopleButton.tintColor = UIColor(red: 41.0/255.0, green: 121.0/255.0, blue: 255.0/255.0, alpha: 1.0)

    }
    
    @IBAction func sendPeopleData(sender: UIButton) {
        wandooModel.numPeople = Int(quantity.text!)
        self.navigationController!.pushViewController(wandooModel.timeViewController, animated: true)
    }
    
    @IBOutlet weak var peopleButton: UIBarButtonItem!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var quantity: UILabel!
    
    @IBOutlet weak var StepCounter: UIStepper!
    
    func stepperValueDidChange(stepper: UIStepper) {
        
        let stepperMapping: [UIStepper: UILabel] = [StepCounter: quantity]
        
        stepperMapping[stepper]!.text = "\(Int(stepper.value))"
    }
    
    @IBAction func CancelButton(sender: UIButton) {
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "toTime" {
//            let wandooPeopleInput = Int(quantity.text!)
//            let wandooMessageInput = wandooPostInput
//            let destinationVC = segue.destinationViewController as! TimeViewController
//            destinationVC.wandooPeopleInput = wandooPeopleInput!
//            destinationVC.wandooMessageInput = wandooMessageInput
//        }
//    }
}
