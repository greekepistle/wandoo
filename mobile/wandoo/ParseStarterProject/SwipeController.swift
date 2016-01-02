//
//  SwipeController.swift
//  ParseStarterProject-Swift
//
//  Created by Brian Kwon on 12/8/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class SwipeController: UIViewController {
    
    var interestedModel = InterestedModel()
    var userModel = UserModel.sharedUserInstance
    var myWandooInfo: NSDictionary?
    var interested: [NSDictionary]?
    var interestedPeoplesInfo: [NSDictionary]?
    var pictures: [UIImage] = []
    
    var photo: UIImageView?
    var userInfo: UILabel?
    var userIDs: [Int] = []
    var photoAndUserInfo: UIView?
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getInterestedPeople { () -> Void in
            if self.pictures.count > 0 {
                self.updateImage()
            }
            self.index = self.pictures.count - 1
        }
        
    }
    
    func updateImage() {
        print("this works")

        for var i = 0; i < pictures.count; i++ {
            print("not rejected")
            self.userIDs.append(self.interested![i]["userID"]! as! Int)
            
//            let shadowView = UIView(frame: CGRect(x: self.view.bounds.width/2 - 100, y: self.view.bounds.height/2 - 50, width: 200, height: 100))
//            shadowView.layer.shadowColor = UIColor.blackColor().CGColor
//            shadowView.layer.shadowOffset = CGSizeZero
//            shadowView.layer.shadowOpacity = 0.5
//            shadowView.layer.shadowRadius = 5
//            shadowView.tintColor = UIColor.blueColor()
            
            self.photoAndUserInfo = UIView(frame: CGRect(x: self.view.bounds.width/2 - 200, y: self.view.bounds.height/2 - 500, width: 400, height: 400))
//            self.photoAndUserInfo = UIView(frame: shadowView.bounds)
            self.photo = UIImageView(frame: CGRect(x: self.photoAndUserInfo!.bounds.width/2 - 185, y: self.photoAndUserInfo!.bounds.height/2, width: 370, height: 300))
            self.photo!.image = self.pictures[i]
            self.userInfo = UILabel(frame: CGRect(x: self.photoAndUserInfo!.bounds.width/2 - 185, y: self.photoAndUserInfo!.bounds.height/2 - 100, width: 370, height: 100))
//            shadowView.addSubview(self.photo!)
            self.photoAndUserInfo!.addSubview(self.photo!)
            self.photoAndUserInfo!.addSubview(self.userInfo!)
            self.view.addSubview(self.photoAndUserInfo!)

            let gesture = UIPanGestureRecognizer(target: self, action: "wasDragged:")
            self.photoAndUserInfo!.addGestureRecognizer(gesture)
            self.photoAndUserInfo!.userInteractionEnabled = true
        }
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        let wandooID = self.myWandooInfo!["wandooID"] as! Int
            
        let translation = gesture.translationInView(self.view)
        let photo = gesture.view!
        let xFromCenter = photo.center.x - self.view.bounds.width/2
        var rotation = CGAffineTransformMakeRotation(xFromCenter/200)
        let scale = min(100/abs(xFromCenter), 1)
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        
        photo.transform = stretch
            
        photo.center = CGPoint(x: self.view.bounds.width/2 + translation.x, y: self.view.bounds.height/2 + translation.y)
        
        if gesture.state == UIGestureRecognizerState.Ended {
            if photo.center.x < 100 {
                print("Not Chosen")
                interestedModel.acceptedOrRejected(wandooID, userID: self.userIDs[self.index], accepted: false)
                photo.center = CGPoint(x: self.view.bounds.width - 1000, y: self.view.bounds.height/2)
                self.index--
            
            } else if photo.center.x > self.view.bounds.width - 100 {
                print("Chosen")
                interestedModel.acceptedOrRejected(wandooID, userID: self.userIDs[self.index], accepted: true)
                photo.center = CGPoint(x: self.view.bounds.width + 1000, y: self.view.bounds.height/2)
                self.index--
            } else {
                photo.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2)
                rotation = CGAffineTransformMakeRotation(0)
                stretch = CGAffineTransformScale(rotation, 1, 1)
            }
            
            photo.transform = stretch
        }
        
    }
    
    func getInterestedPeople(completion: () -> Void) {
        let wandooID = self.myWandooInfo!["wandooID"] as! Int
        
        interestedModel.getInterestedPeople(wandooID, completion: { (result) -> Void in
            dispatch_async(dispatch_get_main_queue()){
                self.interested = result
            }
            
            var count = 0;
            for var i = 0; i < result.count; i++ {
                let userID = result[i]["userID"]! as! Int
                
                if result[i]["selected"]! as! Int != 1 && result[i]["rejected"]! as! Int != 1 {
                    let interestedCount = result.count
                    self.userModel.getUserInfoByUserID(userID, completion: { (result) -> Void in
                        let picString = result["profile_picture"] as! String
                        let picURL = NSURL(string: picString)
                        if let pic = NSData(contentsOfURL: picURL!) {
                            dispatch_async(dispatch_get_main_queue()){
                                self.pictures.append(UIImage(data: pic)!)
                                count++
                                if count == interestedCount {
                                    completion()
                                }
                            }
                        }
                    })
                }
                
            }
        })
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
