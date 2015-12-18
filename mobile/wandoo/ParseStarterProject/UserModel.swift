//
//  UserModel.swift
//  ParseStarterProject-Swift
//
//  Created by Brian Kwon on 12/9/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import ParseFacebookUtilsV4
import CoreLocation


/*
Create a model class

Add http requests to FB parse database
*/

class UserModel {
    
    var name: String?
    var gender: String?
    var photo: PFFile?
    var age: Int?
    var employer: String?
    var jobTitle: String?
    var education: String?
    var id: String?
    var email: String?
    var latitude: Double?
    var longitude: Double?
    
    static let sharedUserInstance = UserModel()

    //function -> void
     //name = from api request
    func getName() ->String {
        return self.name!
    }
    func storeFBDataIntoParse(objectId: String, accessToken: String, completion: (() -> Void)!) {
        
        let request = FBSDKGraphRequest(graphPath:"me?fields=id,name,gender,education,picture,work,birthday,email", parameters:nil)
        
        // Send request to Facebook
        request.startWithCompletionHandler {
            
            (connection, result, error) in
            
            if error != nil {
                // Some error checking here
            }
            else if let userData = result as? [String:AnyObject] {
                
                // Access user data
                self.id = userData["id"] as! String
                self.name = userData["name"] as? String
                self.age = self.getAgeFromFBBirthday(userData["birthday"] as! String) as? Int
                self.email = userData["email"] as? String
                
                var gender = userData["gender"]! as! String
                self.gender = String(gender[gender.startIndex])
                
                
                if userData["work"] != nil && userData["work"]![0]["employer"]! != nil {
                    self.employer = userData["work"]![0]["employer"]!!["name"] as! String
                }
                
                if userData["work"] != nil && userData["work"]![0]["position"]! != nil {
                    self.jobTitle = userData["work"]![0]["position"]!!["name"] as? String
                }
                
                if userData["education"] != nil {
                    for var i = 0; i < userData["education"]!.count; i++ {
                        if userData["education"]![i]["type"]! as! String == "College" {
                            self.education = userData["education"]![i]["school"]!!["name"] as! String
                        }
                    }
                }
                
                var userInfo : [String: AnyObject] = [
                    "name": self.name!,
                    "facebookID": self.id!,
                    "email": self.email!,
                    "age": self.age!,
                    "sex": self.gender!,
                    "latitude": NSNull(),
                    "longitude": NSNull()
                ]
                
                if self.employer != nil {
                    userInfo["employer"] = self.employer!
                }
                
                if self.jobTitle != nil {
                    userInfo["jobTitle"] = self.jobTitle!
                }
                
                if self.education != nil {
                    userInfo["educationInstitution"] = self.education!
                }
                
                let url = NSURL(string: "http://localhost:8000/api/users")
                
                let request = NSMutableURLRequest(URL: url!)
                
                let session = NSURLSession.sharedSession()
                request.HTTPMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")

                let FBurl = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token="+String(accessToken))
                
                //photo data
                if let data = NSData(contentsOfURL: FBurl!) {
                    
                    userInfo["profilePic"] = data.base64EncodedStringWithOptions([])
                    
                    request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(userInfo, options: [])
                    
                    let task = session.dataTaskWithRequest(request) { data, response, error in
                        print("success")
                    }
                    task.resume()
                }
                completion()
                    
//                    let query = PFQuery(className:"_User")
//                    query.getObjectInBackgroundWithId(objectId) {
//                        (user: PFObject?, error: NSError?) -> Void in
//                        if error != nil {
//                            print(error)
//                        } else if let user = user {
//                            user["name"] = self.name!
//                            user["gender"] = self.gender!
//                            user["education"] = self.education!
//                            user["age"] = self.age!
////                            user["photo"] = self.photo
//
//                            user.saveInBackground()
//                        }
//                    }
            }
        }
    }
    
    func getUserInfo(facebookID: String, completion: (result: NSDictionary) -> Void) {
        let url = NSURL(string: "http://localhost:8000/api/users/?facebookID=" + facebookID)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            
            if let data = data {
                do {
                    let parsedData = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary
                    let unwrappedData = parsedData!["data"]![0] as! NSDictionary
                    completion(result: unwrappedData)
                } catch {
                    print("Something went wrong")
                }
            }
        }
        
        task.resume()
        
    }
    
    func getAgeFromFBBirthday(birthdate: String) -> Int {
        
        let formatter: NSDateFormatter = NSDateFormatter()
        
        formatter.dateFormat = "MM/dd/yyyy"
        let dt = formatter.dateFromString(birthdate)
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()

        let components = calendar.components(NSCalendarUnit.Year, fromDate: dt!, toDate: date, options: NSCalendarOptions.WrapComponents)
        
        return components.year
    }
}