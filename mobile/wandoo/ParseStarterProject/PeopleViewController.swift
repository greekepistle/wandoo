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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        
        StepCounter.autorepeat = true
        StepCounter.maximumValue = 10.0
        StepCounter.minimumValue = 1.0
        print(StepCounter.value)
        quantity.text = "\(Int(StepCounter.value))"
        StepCounter.addTarget(self, action: "stepperValueDidChange:", forControlEvents: .ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonAction(send: UIButton!) {
        self.performSegueWithIdentifier("toPostViewController", sender: self)
    }
    
    @IBOutlet weak var quantity: UILabel!
    
    @IBOutlet weak var StepCounter: UIStepper!
    
    func stepperValueDidChange(stepper: UIStepper) {
        
        let stepperMapping: [UIStepper: UILabel] = [StepCounter: quantity]
        
        stepperMapping[stepper]!.text = "\(Int(stepper.value))"
    }
    
    @IBAction func CancelButton(sender: UIButton) {
    }

    @IBAction func SubmitButton(sender: UIButton) {
        wandooModel.numPeople = Int(quantity.text!)
        print(quantity.text)
    }
}
