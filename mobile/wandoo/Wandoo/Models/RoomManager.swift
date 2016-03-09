//
//  RoomManager.swift
//  ParseStarterProject-Swift
//
//  Created by Brian Kwon on 12/30/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import LayerKit

class RoomManager {
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var layerClient: LYRClient!
    var layerQuery: LYRQuery!
    
    init() {
        layerClient = delegate.layerClient
    }
    
    func getRoomByWandooID (wandooID: String, completion: (result: String) -> Void) {
        var query = LYRQuery(queryableClass: LYRConversation.self)
    }
    
    func printRoomID () {

    }
}