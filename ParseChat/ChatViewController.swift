//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Leslie  on 10/24/18.
//  Copyright © 2018 Leslie . All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var chatTableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    var messages: [PFObject]?
    
    @IBAction func onSend(_ sender: Any) {
        let message = PFObject(className: "Message")
        print ("sending message")
        print (messageTextField.text ?? "Nothing")
        if messageTextField.text != "" {
            message["text"] = messageTextField.text
            message["user"] = PFUser.current()
            message.saveInBackground(block: {(success: Bool?, error: Error?) in
                if success == true {
                    print ("message sent")
                }
                else {
                    print ("message not sent")
                }
            })
        }
        messageTextField.text = ""
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let message = self.messages {
            return message.count
        }
        return 0
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        // Auto size row height based on cell autolayout constraints
        chatTableView.rowHeight = UITableView.automaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        chatTableView.estimatedRowHeight = 50
        
        //chatTableView.separatorStyle = .none
        
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatViewController.onTimer), userInfo: nil, repeats: true)
        
        
    }
    
    @objc func onTimer() {
        let query = PFQuery(className:"Message")
        query.whereKeyExists("text").includeKey("user")
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                // The find succeeded.
                self.messages = objects
                self.chatTableView.reloadData()
                
            } else {
                // Log details of the failure
                print("<><><><>Error: \(error?.localizedDescription)")
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        cell.messages = (self.messages?[indexPath.row])!
        if let user = cell.messages["user"] as? PFUser {
            // User found! update username label with username
            cell.userLabel.text = user.username
        } else {
            // No user found, set default username
            cell.userLabel.text = "🤖"
        }
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
