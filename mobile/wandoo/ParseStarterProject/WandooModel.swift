//
//  WandooModel.swift
//  ParseStarterProject-Swift
//
//  Created by Brian Kwon on 12/15/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import FBSDKCoreKit

class WandooModel {
    
    var userID: String?
    var text: String?
    var startTime: String?
    var endTime: String?
    var postTime: String?
    var latitude: Double?
    var longitude: Double?
    var numPeople: Int?
    var userModel = UserModel.sharedUserInstance
    
    var timeViewController: TimeViewController!
    var backToFeed: TabBarViewController!
    //shared wandoo instance.. multiple view controllers can use the same instance of this model
    static let sharedWandooInstance = WandooModel()
    
    func postWandoo(completion: () -> Void) {
        self.latitude = userModel.latitude
        self.longitude = userModel.longitude
        
        let userID = userModel.userID
            let postInfo: [String: AnyObject] = [
                "userID": userID!,
                "text": self.text!,
                "startTime": convertTimeToUTC(self.startTime!),
//                "endTime": self.endTime!,
//                "postTime": self.postTime!,
                "latitude": self.latitude!,
                "longitude": self.longitude!,
                "numPeople": self.numPeople!
            ]
        
            let url = NSURL(string: hostname + "/api/wandoos")
            
            let request = NSMutableURLRequest(URL: url!)
            
            let session = NSURLSession.sharedSession()
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(postInfo, options: [])
        
            let task = session.dataTaskWithRequest(request) { data, response, error in
                print("success")
                completion()
            }
            task.resume()
    }
    
    //GET request for a specific user's wandoos
    func getUserWandoo(completion: (result: NSArray) -> Void) {
        let url = NSURL(string: hostname + "/api/wandoos?hostID=" + String(userModel.userID!))
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            
            if let data = data {
                do {
                    let parsedData = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary
                    let unwrappedData = parsedData!["data"] as! NSArray
                    completion(result: unwrappedData)
//                    print(unwrappedData)
                } catch {
                    print("getUserWandoo Something went wrong")
                }
            }
        }
        
        task.resume()
        
    }
    
    //GET request for wandoos with offset and limit
    func getWandoos(offset: Int, limit: Int, completion: (result: NSArray) -> Void) {
        let url = NSURL(string: hostname + "/api/wandoos/?offset=" + String(offset) + "&limit=" + String(limit))
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            
            if let data = data {
                do {
                    let parsedData = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary
                    let unwrappedData = parsedData!["data"] as! NSArray
                    completion(result: unwrappedData)
                } catch {
                    print("getWandoos Something went wrong")
                }
            }
        }
        
        task.resume()
    }
    
    //GET requet for all wandoos
    func getAllWandoos(completion: (result: NSArray) -> Void) {
        let url = NSURL(string: hostname + "/api/wandoos?userID=" + String(userModel.userID!))
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            
            if let data = data {
                do {
                    let parsedData = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSMutableDictionary
                    let unwrappedData = parsedData!["data"] as! [NSDictionary]
//                    print("------------", unwrappedData)
                    completion(result: unwrappedData)
                } catch {
                    print("getAllWandoos Something went wrong")
                }
            } else {
                print("Can't get all Wandoos")
            }
        }
        
        task.resume()
    }
    
    func convertTimeToUTC (time: String) -> String {
        var result: String = ""
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        timeFormatter.timeZone = NSTimeZone.localTimeZone()
        
        let toUTCFormatter = NSDateFormatter()
        toUTCFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        toUTCFormatter.timeZone = NSTimeZone(name: "UTC")
        
        result = toUTCFormatter.stringFromDate(timeFormatter.dateFromString(time)!)
        
        return result
    }
    
    func checkAndFormatWandooDate (wandooDate: String) -> String {
        
//        print(wandooDate)
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.timeZone = NSTimeZone.localTimeZone()
        let dateToString = NSDateFormatter()
        dateToString.dateFormat = "dd"
        dateToString.timeZone = NSTimeZone.localTimeZone()
        let stringToDate = NSDateFormatter()
        stringToDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        stringToDate.timeZone = NSTimeZone(name: "UTC")
        
        var result: String = ""
        let todayDate = NSDate()
        let todayIntDay = Int(dateToString.stringFromDate(todayDate))
        let wandooIntDay = Int(dateToString.stringFromDate(stringToDate.dateFromString(wandooDate)!))
        let wandooFormattedDate = timeFormatter.stringFromDate(stringToDate.dateFromString(wandooDate)!)
        
        if  todayIntDay < wandooIntDay {
            result = "Tomorrow at " + wandooFormattedDate
        } else {
            result = "Today at " + wandooFormattedDate
        }
        
        return result
        
    }
}
