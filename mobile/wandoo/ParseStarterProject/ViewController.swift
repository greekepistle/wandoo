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

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate {

    var locationManager = CLLocationManager()
    var userModel = UserModel.sharedUserInstance
    var wandooModel = WandooModel()
    var count: Int = 0
    
    var offset: Int = 1
    let limit: Int = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.navigationItem.hidesBackButton = true
        
        getAllWandoos { (allWandoos) -> Void in
            print(allWandoos[0])
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
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        
        userModel.latitude = userLocation.coordinate.latitude
        userModel.longitude = userLocation.coordinate.longitude

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return limit
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let wandooCell = tableView.dequeueReusableCellWithIdentifier("wandooCell", forIndexPath: indexPath) as! WandooCell
        
        getAllWandoos { (allWandoos) -> Void in
            dispatch_async(dispatch_get_main_queue()){
                wandooCell.message.text = allWandoos[indexPath.row]["text"] as? String
                wandooCell.startDate.text = allWandoos[indexPath.row]["start_time"] as? String
                
                
            }
        }
        
        return wandooCell
    }
}
