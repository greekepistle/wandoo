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
    
    static let sharedInterestedInstance = InterestedModel()
    
    //POST request for interested
    func showInterest(wandooID: Int) {
//        let url = NSURL(string: "http://localhost:8000/api/interested/?wandooID=" + String(wandooID))
//        
//        let request = NSMutableURLRequest(URL: url!)
//        
//        let session = NSURLSession.sharedSession()
//        request.HTTPMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(userLocation, options: [])
//        
//        let task = session.dataTaskWithRequest(request) { data, response, error in
//            print("success")
//        }
//        task.resume()
    }
    
}