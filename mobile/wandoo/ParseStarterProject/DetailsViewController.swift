//
//  DetailsViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Brian Kwon on 12/26/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {

    var wandooInfo: NSDictionary!
    var interestedModel = InterestedModel()
    var userModel = UserModel()
    var wandooModel = WandooModel()
    
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var numPeople: UILabel!
    
    @IBAction func showInterestButton(sender: UIButton) {
        let wandooID = wandooInfo["wandooID"] as! Int
        interestedModel.showInterest(wandooID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let gesture = UITapGestureRecognizer(target: self, action: "segueToProfile:")
        profileView.addGestureRecognizer(gesture)
        
        self.profilePicture.image = wandooInfo["profile_picture"] as? UIImage
        self.message.text = wandooInfo["text"] as? String
        self.location.text = String(wandooInfo["distance"]!) + " miles away"
        self.time.text = wandooModel.checkAndFormatWandooDate((wandooInfo["start_time"] as? String)!)
        self.numPeople.text = String(wandooInfo["num_people"]!) + " people"
        
        
    }
    
    
    
    func segueToProfile(sender:UITapGestureRecognizer) {
        performSegueWithIdentifier("fromDetails", sender: nil)
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "fromDetails" {
//            _ = segue.destinationViewController as! HostProfileViewController
//        }
//    }

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
