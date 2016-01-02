//
//  InterestedModel.swift
//  ParseStarterProject-Swift
//
//  Created by Brian Kwon on 12/25/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation

class InterestedModel {
    
    var interestedPeople: Array<Int>?
    var userModel = UserModel.sharedUserInstance
    
    static let sharedInterestedInstance = InterestedModel()
    
    //POST request for interested
    func showInterest(wandooID: Int) {
        
        print(userModel.userID!)
        let interestedInfo: [String: AnyObject] = [
            "wandooID": wandooID,
            "userID": userModel.userID!
        ]
        
        let url = NSURL(string: hostname + "/api/interested")
        
        let request = NSMutableURLRequest(URL: url!)
        
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(interestedInfo, options: [])
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            print("success")
        }
        task.resume()
    }
    
    func getInterestedPeople(wandooID: Int, completion: (result: [NSDictionary]) -> Void) {
        
        let url = NSURL(string: hostname + "/api/interested/?wandooID=" + String(wandooID))
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) -> Void in
            
            if let data = data {
                do {
                    let parsedData = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
                    completion(result: parsedData as! [NSDictionary])
                    
                } catch {
                    print("getInterestedPeople InSomething went wrong")
                }
            }
        }
        task.resume()
    }
    
    func acceptedOrRejected(wandooID: Int, userID: Int, accepted: Bool) {
        
        var nayOrYay : [String: AnyObject] = [
            "hostID": userModel.userID!,
            "selected": 0,
            "rejected": 0,
            "userID": userID
        ]
        
        if accepted {
            nayOrYay["selected"] = 1
            print("accepted")
        } else {
            nayOrYay["rejected"] = 1
            print("rejected")
        }
        
        let url = NSURL(string: hostname + "/api/interested/" + String(wandooID) + "/" + String(userID))
        
        let request = NSMutableURLRequest(URL: url!)
        
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(nayOrYay, options: [])
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            print("success for acceptedOrRejected HTTP method update")
        }
        task.resume()
    }
    
}