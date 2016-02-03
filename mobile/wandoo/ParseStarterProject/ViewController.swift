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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UITabBarControllerDelegate {

    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let sb = UIStoryboard(name: "Main", bundle: nil)
    let priority = DISPATCH_QUEUE_PRIORITY_HIGH

    var layerClient: LYRClient!
    var conversationListViewController: ConversationListViewController!

    var userModel = UserModel.sharedUserInstance
    var wandooModel = WandooModel.sharedWandooInstance
    var count: Int = 0
    var counter: Int = 0
    var allWandoosArray = [NSDictionary]()
    var profilePicture: UIImage?
    var interestedModel = InterestedModel()

    var ignoreFlag = false
    var feedButtonFlag = true
    var updateCount = 0
    
    var locationManager = CLLocationManager()

    @IBOutlet weak var editIcon: UIImageView!
    @IBAction func whatDoYouWantToDo(sender: UIButton) {
        
        
    }
    @IBOutlet weak var wandooButton: UIButton!
    @IBAction func presentChat(sender: UIButton) {
        self.presentConversationListViewController()
    }
    //Feed button to move to top of feed
    @IBAction func toTopPost(sender: UIButton) {
        self.retrieveWandoos()
        sender.userInteractionEnabled = false
        refreshDataAfterTwoSec()

        self.wandooTable.reloadData()
        self.retrieveWandoos()
        wandooTable.setContentOffset(CGPointMake(0, -wandooTable.contentInset.top), animated: true)
    }
    
    func toTopAndRefresh() {
        print("SHOULD BE 2 SEC DELAY")
        self.retrieveWandoos()
//        self.tabBarController!.tabBar.selectedItem!.enabled = false
        refreshDataAfterTwoSec()
//        sender.userInteractionEnabled = false
//        refreshDataAfterTwoSec(sender)
        self.retrieveWandoos()
        wandooTable.setContentOffset(CGPointMake(0, -wandooTable.contentInset.top), animated: true)
    }
    
    @IBOutlet weak var wandooTable: UITableView!

    var offset: Int = 1
    var limit: Int = 1
    var refreshControl:UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setBackgroundColor(UIColor.clearColor())
        SVProgressHUD.show()
        
        self.tabBarController!.delegate = self
        self.tabBarController!.tabBar.layer.borderWidth = 0.5
        self.tabBarController!.tabBar.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.tabBarController?.tabBar.clipsToBounds = true
        
        let selectedColor = UIColor(red:0.204, green:0.596, blue:0.859, alpha:1.0)
        editIcon.image = editIcon.image!.imageWithColor(selectedColor).imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        
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
        SVProgressHUD.show()

        navigationItem.titleView = UIImageView(image: UIImage(named: "Wandoo"))
        
        self.navigationItem.hidesBackButton = true
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .NotDetermined, .Restricted, .Denied:
                print("No access")
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                print("Access")
            default:
                print("...")
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController!.tabBar.hidden = false
        self.tabBarController!.tabBar.translucent = false
        
        feedButtonFlag = false
    }
    
    override func viewDidAppear(animated: Bool) {
        feedButtonFlag = true
    }
    
    override func viewWillDisappear(animated: Bool) {
//        self.tabBarController!.tabBar.items![0].enabled = true
    }
    
    func refresh(sender:AnyObject)
    {
        userModel.postLocation { () -> Void in
            print("refreshing data")
            self.retrieveWandoos()
        }
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
                    let fullName = result["name"] as? String
                    let fullNameArr = fullName!.characters.split{$0 == " "}.map(String.init)
                    wandooCell.name.text = fullNameArr[0]
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
        
        let wandooID = allWandoosArray[indexPath.row]["wandooID"] as! Int
        
        if let _ = userModel.interestedWandooIDs.objectForKey(String(wandooID)) {
            wandooCell.showInterestButton.backgroundColor = UIColor(red: 100.0/255.0, green: 181.0/255.0, blue: 246.0/255.0, alpha: 0.5)
            wandooCell.showInterestButton.userInteractionEnabled = false
        } else {
            wandooCell.showInterestButton.backgroundColor = UIColor(white:0.88, alpha:1.0)
            wandooCell.showInterestButton.userInteractionEnabled = true
        }

        wandooCell.cardView.layer.borderWidth = 1
        wandooCell.cardView.layer.borderColor = UIColor.lightGrayColor().CGColor
        wandooCell.interestedView.layer.borderWidth = 1
        wandooCell.interestedView.layer.borderColor = UIColor.lightGrayColor().CGColor

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
        
        if updateCount == 0 {
            getWandoosTheFirstTime()
        }
        
        if updateCount >= 2500 {
            updateCount = 0
            return
        }
        
        updateCount++
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
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        
        if !ignoreFlag && feedButtonFlag && viewController.childViewControllers.first! is ViewController {
            self.userModel.postLocation({ () -> Void in
                self.toTopAndRefresh()
            })
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
        
        if self.allWandoosArray.count == 0 {
            SVProgressHUD.show()
        }
        
        if String(self.view.subviews.last).containsString("No Wandoos in Your Area!") {
            dispatch_async(dispatch_get_main_queue()) {
                self.view.subviews.last!.removeFromSuperview()
            }
        }

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
                    self.refreshControl.endRefreshing()
                    if self.allWandoosArray.count == 0 {
                        let noWandoos = UILabel(frame: CGRect(x: self.view.bounds.width/2 - 150, y: self.view.bounds.height/2 - 100, width: 300, height: 200))
                        noWandoos.text = "No Wandoos in Your Area!"
                        noWandoos.textAlignment = .Center
                        noWandoos.font = UIFont(name: noWandoos.font.fontName, size: 20)
                        noWandoos.textColor = UIColor.blackColor()
                        self.view.addSubview(noWandoos)
                    }
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
    
    func getWandoosTheFirstTime () {
        let fbID = FBSDKAccessToken.currentAccessToken().userID
        self.userModel.getUserInfo(fbID, completion: { (result) -> Void in
            print(result)
            self.userModel.userID = result["userID"]! as? Int
            dispatch_async(dispatch_get_main_queue()){
                self.userModel.postLocation { () -> Void in
                    self.retrieveWandoos()
                }
            }
        })
    }

    func refreshDataAfterTwoSec() {
        let delta: Int64 = 2 * Int64(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, delta)
        ignoreFlag = true

        dispatch_after(time, dispatch_get_main_queue(), {
            self.ignoreFlag = false
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
