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
    @IBOutlet weak var photo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        updateImage()
        
    }
    
    func updateImage() {
        getInterestedPeople { () -> Void in
            print(self.interested![0]["selected"])
            for var i = 0; i < self.pictures.count; i++ {
                if self.interested![i]["selected"]! as! Int != 1 && self.interested![i]["rejected"]! as! Int != 1 {
                    self.photo.image = self.pictures[i]
                    self.view.addSubview(self.photo)
                }
                
                let gesture = UIPanGestureRecognizer(target: self, action: "wasDragged:")
                self.photo.addGestureRecognizer(gesture)
                self.photo.userInteractionEnabled = true
            }
        }
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
            
        let translation = gesture.translationInView(self.view)
        let label = gesture.view!
        let xFromCenter = label.center.x - self.view.bounds.width/2
        var rotation = CGAffineTransformMakeRotation(xFromCenter/200)
        let scale = min(100/abs(xFromCenter), 1)
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        
        label.transform = stretch
            
        label.center = CGPoint(x: self.view.bounds.width/2 + translation.x, y: self.view.bounds.height/2 + translation.y)
        
        if gesture.state == UIGestureRecognizerState.Ended {
            if label.center.x < 100 {
                print("Not Chosen")
            } else if label.center.x > self.view.bounds.width - 100 {
                print("Chosen")
            }
            label.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2)
            rotation = CGAffineTransformMakeRotation(0)
            stretch = CGAffineTransformScale(rotation, 1, 1)
            
            label.transform = stretch
        }
        
    }
    
    func getInterestedPeople(completion: () -> Void) {
        let wandooID = self.myWandooInfo!["wandooID"] as! Int
        
        interestedModel.getInterestedPeople(17, completion: { (result) -> Void in
            dispatch_async(dispatch_get_main_queue()){
                self.interested = result
            }
            
            var count = 0;
            for var i = 0; i < result.count; i++ {
                let userID = result[i]["userID"]! as! Int
                
                let interestedCount = result.count
                self.userModel.getUserInfoByUserID(userID, completion: { (result) -> Void in
                    let picString = result["profile_picture"] as! String
                    let picURL = NSURL(string: "http://localhost:8000" + picString)
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
