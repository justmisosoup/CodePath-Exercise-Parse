//
//  ViewController.swift
//  Something
//
//  Created by Sara on 10/22/14.
//  Copyright (c) 2014 Sara Menefee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var messages : [ [String:String] ] = []
    
    var firebaseRef = Firebase(url: "https://luminous-heat-7826.firebaseio.com")
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        firebaseRef.observeEventType(FEventType.Value, withBlock:  { (snapshot:FDataSnapshot!) -> Void in
            // Something here
            println("Database changed! \(snapshot)")
        })
        
        let messagesRef = firebaseRef.childByAppendingPath("messages")
        messagesRef.observeEventType(FEventType.ChildAdded, withBlock: { (snapshot: FDataSnapshot!) -> Void in
            
            let messageID = snapshot.name
            let message = snapshot.value as [ String:String ]
            
            self.messages.insert([
                "content" : message["content"],
                "name" : message["name"]!
                ], atIndex: 0)
            
            self.tableView.reloadData()
            
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Right)
            
        })
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatCell") as ChatCell
        
        let messageContent = messages[indexPath.row]["content"]
        let userName = messages[indexPath.row]["name"]
        
        cell.chatLabel.text = "\(userName):\(messageContent)"
        
        return cell
    }
    
    @IBAction func onTextSend(sender: UITextField) {
        
        let messagesRef = firebaseRef.childByAppendingPath("messages").childByAutoId()
        messagesRef.setValue([
            "content" : sender.text,
            "name" : "Sara"
            ])
//        
//        messages.insert([
//            "content" : sender.text,
//            "name" : "Sara"
//            ], atIndex: 0)
//        
//        tableView.reloadData()
        
        sender.text = ""
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }


}

