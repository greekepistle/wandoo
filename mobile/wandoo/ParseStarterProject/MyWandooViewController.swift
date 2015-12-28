//
//  MyWandooViewController.swift
//  ParseStarterProject-Swift
//
//  Created by William Lee on 12/27/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class MyWandooViewController: UITableViewController {

    
    @IBOutlet weak var wandooTable: UITableView!
    
    var myWandoosArray = [NSDictionary]()
    var userModel = UserModel.sharedUserInstance
    var wandooModel = WandooModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "wandoos"))
        
        self.retrieveMyWandoos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("hello")
        let wandooCell = tableView.dequeueReusableCellWithIdentifier("myWandooCell", forIndexPath: indexPath) as! MyWandooCell
        
        wandooCell.myWandooTitle.text = self.myWandoosArray[indexPath.row]["text"] as? String
        
        return wandooCell
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myWandoosArray.count
    }

    func retrieveMyWandoos() {
        getMyWandoos { (allMyWandoos) -> Void in
            self.myWandoosArray = allMyWandoos as! [NSDictionary]
            print(self.myWandoosArray)
            dispatch_async(dispatch_get_main_queue()){
                self.wandooTable.reloadData()
            }
        }
    }
    
    func getMyWandoos(completion: (result: NSArray) -> Void) {
        wandooModel.getWandoo { (allMyWandoos) -> Void in
            completion(result: allMyWandoos)
        }
    }


}
