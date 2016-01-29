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
import SVProgressHUD
import Atlas
//import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate

    var layerClient: LYRClient!
    var conversationListViewController: ConversationListViewController!

    var userModel = UserModel.sharedUserInstance
    var wandooModel = WandooModel()
    var count: Int = 0
    var counter: Int = 0
    var allWandoosArray = [NSDictionary]()
    var profilePicture: UIImage?
    var interestedModel = InterestedModel()

    var ignoreFlag = true
    
    var locationManager = CLLocationManager()

    @IBOutlet weak var wandooButton: UIButton!
    @IBAction func presentChat(sender: UIButton) {
        self.presentConversationListViewController()
    }
    //Feed button to move to top of feed
    @IBAction func toTopPost(sender: UIButton) {
        self.retrieveWandoos()
        sender.userInteractionEnabled = false
        refreshDataAfterTwoSec(sender)

        self.wandooTable.reloadData()
        self.retrieveWandoos()
        wandooTable.setContentOffset(CGPointMake(0, -wandooTable.contentInset.top), animated: true)
    }
    @IBOutlet weak var wandooTable: UITableView!

    var offset: Int = 1
    var limit: Int = 1
    var refreshControl:UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let interestedWandooIDs = userDefaults.objectForKey("interestedWandooIDs") {
            let auxInterestedWandooIDs = interestedWandooIDs.mutableCopy()
            userModel.interestedWandooIDs = auxInterestedWandooIDs as! NSMutableDictionary
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.wandooTable.addSubview(refreshControl)
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        layerClient = delegate.layerClient
        // Do any additional setup after loading the view, typically from a nib.
        let fbID = FBSDKAccessToken.currentAccessToken().userID
        print("reaching here")
        SVProgressHUD.show()
        self.userModel.getUserInfo(fbID, completion: { (result) -> Void in
            print(result)
            self.userModel.userID = result["userID"]! as? Int
            self.userModel.postLocation { () -> Void in
                self.retrieveWandoos()
            }
        })

        navigationItem.titleView = UIImageView(image: UIImage(named: "Wandoo"))

        userModel.postLocation { () -> Void in
            self.retrieveWandoos()
        }
        self.navigationItem.hidesBackButton = true
    }
    
    func refresh(sender:AnyObject)
    {
        print("refreshing data")
        self.retrieveWandoos()
        self.wandooTable.reloadData()
        self.retrieveWandoos()
        self.refreshControl.endRefreshing()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    //renders wandoos into table view
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let wandooCell = tableView.dequeueReusableCellWithIdentifier("wandooCell", forIndexPath: indexPath) as! WandooCell
        let userID = self.allWandoosArray[indexPath.row]["userID"] as! Int
        userModel.getUserInfoByUserID(userID) { (result) -> Void in
            let picString = result["profile_picture"] as! String
            let picURL = NSURL(string: picString)
            if let pic = NSData(contentsOfURL: picURL!) {
                dispatch_async(dispatch_get_main_queue()){
                    wandooCell.profileImage.image = UIImage(data: pic)
                    wandooCell.profileImage.layer.borderWidth = 1
                    wandooCell.profileImage.layer.masksToBounds = false
                    wandooCell.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
                    wandooCell.profileImage.layer.cornerRadius = wandooCell.profileImage.frame.height/2
                    wandooCell.profileImage.layer.cornerRadius = wandooCell.profileImage.frame.width/2
                    wandooCell.profileImage.clipsToBounds = true
                    wandooCell.name.text = result["name"] as? String
                    wandooCell.location.text = String(self.allWandoosArray[indexPath.row]["distance"]!) + " miles away"
                    wandooCell.message.text = self.allWandoosArray[indexPath.row]["text"] as? String
                    wandooCell.time.text = self.wandooModel.checkAndFormatWandooDate((self.allWandoosArray[indexPath.row]["start_time"] as? String)!)
                    wandooCell.numPeople.text = String(self.allWandoosArray[indexPath.row]["num_people"]!) + " people"
                    wandooCell.objectID = result["objectID"] as? String
                }
            }

        }

        wandooCell.showInterestButton.tag = indexPath.row
        wandooCell.showInterestButton.addTarget(self, action: "toggleInterest:", forControlEvents: .TouchUpInside)
        
//        let request = NSFetchRequest(entityName: "Interested")
//        let context: NSManagedObjectContext = delegate.managedObjectContext
//        request.returnsObjectsAsFaults = false;
//        
//        let results: NSArray = try! context.executeFetchRequest(request)
        let wandooID = allWandoosArray[indexPath.row]["wandooID"] as! Int
        
//        for res in results {
//            print(res.valueForKey("wandooID"))
//            print(res.valueForKey("wandooID") as! Int == wandooID)
//            if res.valueForKey("wandooID") as! Int == wandooID {
//                dispatch_async(dispatch_get_main_queue()) {
//                    wandooCell.showInterestButton.backgroundColor = UIColor(red: 100.0/255.0, green: 181.0/255.0, blue: 246.0/255.0, alpha: 0.5)
//                    wandooCell.showInterestButton.userInteractionEnabled = false
//                }
//            } else {
//                dispatch_async(dispatch_get_main_queue()) {
//                    wandooCell.showInterestButton.backgroundColor = UIColor(white:0.88, alpha:1.0)
//                    wandooCell.showInterestButton.userInteractionEnabled = true
//                }
//            }
//        }
        
        if let _ = userModel.interestedWandooIDs.objectForKey(String(wandooID)) {
            wandooCell.showInterestButton.backgroundColor = UIColor(red: 100.0/255.0, green: 181.0/255.0, blue: 246.0/255.0, alpha: 0.5)
            wandooCell.showInterestButton.userInteractionEnabled = false
        } else {
            wandooCell.showInterestButton.backgroundColor = UIColor(white:0.88, alpha:1.0)
            wandooCell.showInterestButton.userInteractionEnabled = true
        }

//        if let interestedWandooIDs = userDefaults.objectForKey("interestedWandooIDs") {
//            if let _ = interestedWandooIDs.objectForKey(String(wandooID)) {
//                dispatch_async(dispatch_get_main_queue()) {
//                    wandooCell.showInterestButton.backgroundColor = UIColor(red: 100.0/255.0, green: 181.0/255.0, blue: 246.0/255.0, alpha: 0.5)
//                    wandooCell.showInterestButton.userInteractionEnabled = false
//                }
//            } else {
//                dispatch_async(dispatch_get_main_queue()) {
//                    wandooCell.showInterestButton.backgroundColor = UIColor(white:0.88, alpha:1.0)
//                    wandooCell.showInterestButton.userInteractionEnabled = true
//                }
//            }
//        }
//        if let _ = userModel.interestedWandooIDs.objectForKey(wandooID) {
//            wandooCell.showInterestButton.backgroundColor = UIColor(red: 100.0/255.0, green: 181.0/255.0, blue: 246.0/255.0, alpha: 0.5)
//            wandooCell.showInterestButton.userInteractionEnabled = false
//        } else {
//            wandooCell.showInterestButton.backgroundColor = UIColor(white:0.88, alpha:1.0)
//            wandooCell.showInterestButton.userInteractionEnabled = true
//        }

        wandooCell.cardView.layer.borderWidth = 1
        wandooCell.cardView.layer.borderColor = UIColor.lightGrayColor().CGColor

        return wandooCell
    }

    @IBAction func toggleInterest(sender: UIButton) {
        let wandooID = allWandoosArray[sender.tag]["wandooID"] as! Int
        interestedModel.showInterest(wandooID)
        sender.backgroundColor = UIColor(red: 100.0/255.0, green: 181.0/255.0, blue: 246.0/255.0, alpha: 0.5)
        sender.userInteractionEnabled = false
        
        userModel.interestedWandooIDs[String(wandooID)] = true
        let interestedWandooIDs = userModel.interestedWandooIDs as NSDictionary
        self.userModel.userDefaults.setObject(interestedWandooIDs, forKey: "interestedWandooIDs")
        self.userModel.userDefaults.synchronize()

    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        
        userModel.latitude = userLocation.coordinate.latitude
        userModel.longitude = userLocation.coordinate.longitude
        
    }

    //number of sections in table.. we only have 1 section of wandoos
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    //number of rows in our section.. depends on how many wandoos we get from our http request
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allWandoosArray.count > 0 {
            return allWandoosArray.count
        } else {
            return 0
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "lookAtWandoo" {
            let selectedIndex = wandooTable.indexPathForCell(sender as! WandooCell)

            let wandooInfo = allWandoosArray[selectedIndex!.row]
            let destinationVC = segue.destinationViewController as! DetailsViewController
            destinationVC.wandooInfo = wandooInfo
        }
    }

    func presentConversationListViewController() {
//        SVProgressHUD.dismiss()
        self.conversationListViewController = ConversationListViewController(layerClient: self.layerClient)
        self.conversationListViewController.displaysAvatarItem = true
        self.navigationController!.pushViewController(self.conversationListViewController, animated: true)
    }

//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("segueing")
//        performSegueWithIdentifier("lookAtWandoo", sender: nil)
//    }

    //gets all wandoos using UserModel
    //UserModel is able to get the user's info (e.g. name, photo) via facebook id
    func retrieveWandoos() {

        getAllWandoos { (allWandoos) -> Void in
            print("-------GET ALL")
            let fbID = FBSDKAccessToken.currentAccessToken().userID
            self.userModel.getUserInfo(fbID, completion: { (userInfo) -> Void in
                print("------------ARE WE COMING HERE")
                self.profilePicture = userInfo["profile_picture"] as? UIImage
                self.allWandoosArray = allWandoos as! [NSDictionary]

                dispatch_async(dispatch_get_main_queue()){
                    SVProgressHUD.dismiss()
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

    func refreshDataAfterTwoSec(sender: UIButton) {
        let delta: Int64 = 2 * Int64(NSEC_PER_SEC)

        let time = dispatch_time(DISPATCH_TIME_NOW, delta)

        dispatch_after(time, dispatch_get_main_queue(), {
            sender.userInteractionEnabled = true
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
