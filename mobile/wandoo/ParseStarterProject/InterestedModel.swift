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
        
        let url = NSURL(string: "http://localhost:8000/api/interested")
        
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
        
        let url = NSURL(string: "http://localhost:8000/api/interested/?wandooID=" + String(wandooID))
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) -> Void in
            
            if let data = data {
                do {
                    let parsedData = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
                    completion(result: parsedData as! [NSDictionary])
                    
                } catch {
                    print("Something went wrong")
                }
            }
        }
        task.resume()
    }
    
}