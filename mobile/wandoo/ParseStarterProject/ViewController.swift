/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    var locationManager = CLLocationManager()
    var userModel = UserModel.sharedUserInstance
    var wandooModel = WandooModel()
    var count: Int = 0
    var counter: Int = 0
    var allWandoosArray = [NSDictionary]()
    var profilePicture: UIImage?
    
    //Feed button to move to top of feed
    @IBAction func toTopPost(sender: UIButton) {
     wandooTable.setContentOffset(CGPointMake(0, -wandooTable.contentInset.top), animated: true)
    }
    @IBOutlet weak var wandooTable: UITableView!
    
    var offset: Int = 1
    var limit: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //location manager - request for user location only when in use
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //http GET request for all wandoos
        self.retrieveWandoos()
        
        self.navigationItem.hidesBackButton = true
        
//        print(allWandoosArray)
        
    }
    //continually spits out user location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        
        userModel.latitude = userLocation.coordinate.latitude
        userModel.longitude = userLocation.coordinate.longitude
    }
    
    //renders wandoos into table view
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let wandooCell = tableView.dequeueReusableCellWithIdentifier("wandooCell", forIndexPath: indexPath) as! WandooCell
//        print(wandooModel.checkAndFormatWandooDate((allWandoosArray[indexPath.row]["start_time"] as? String)!))
        wandooCell.profileImage.image = profilePicture
        wandooCell.message.text = self.allWandoosArray[indexPath.row]["text"] as? String
        wandooCell.startDate.text = wandooModel.checkAndFormatWandooDate((allWandoosArray[indexPath.row]["start_time"] as? String)!)
//        wandooCell.startDate.text = self.allWandoosArray[indexPath.row]["start_time"] as? String
        
        return wandooCell
    }
    
    //number of sections in table.. we only have 1 section of wandoos
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //number of rows in our section.. depends on how many wandoos we get from our http request
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allWandoosArray.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "lookAtWandoo" {
        let selectedIndex = wandooTable.indexPathForCell(sender as! WandooCell)
        
        let wandooInfo = allWandoosArray[selectedIndex!.row]
        let destinationVC = segue.destinationViewController as! DetailsViewController
        destinationVC.wandooInfo = wandooInfo
        }
        
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("segueing")
//        performSegueWithIdentifier("lookAtWandoo", sender: nil)
//    }
    
    //gets all wandoos using UserModel
    //UserModel is able to get the user's info (e.g. name, photo) via facebook id
    func retrieveWandoos() {
        
        getAllWandoos { (allWandoos) -> Void in
            let fbID = FBSDKAccessToken.currentAccessToken().userID
            self.userModel.getUserInfo(fbID, completion: { (userInfo) -> Void in
                
                self.profilePicture = userInfo["profile_picture"] as? UIImage
                self.allWandoosArray = allWandoos as! [NSDictionary]
                
                dispatch_async(dispatch_get_main_queue()){
                    self.wandooTable.reloadData()
                }
            })
            
        }
    }
    
    func getAllWandoos(completion: (result: NSArray) -> Void) {
        wandooModel.getAllWandoos { (allWandoos) -> Void in
            completion(result: allWandoos)
        }
    }
    
    func getWandoos(offset: Int, limit: Int, completion: (result: NSArray) -> Void) {
        wandooModel.getWandoos(1, limit: 3) { (result) -> Void in
            completion(result: result)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


