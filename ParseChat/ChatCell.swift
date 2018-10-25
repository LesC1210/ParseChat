//
//  ChatCell.swift
//  ParseChat
//
//  Created by Leslie  on 10/24/18.
//  Copyright © 2018 Leslie . All rights reserved.
//

import UIKit
import Parse

class ChatCell: UITableViewCell {
    
    
    @IBOutlet weak var userLabel: UILabel!
  
    @IBOutlet weak var messageLabel: UILabel!
    
    
    var messages: PFObject! {
        didSet {
            messageLabel.text = messages.object(forKey: "text") as? String
            
            //let username = messages.object(forKey: "user")
            let user = messages.object(forKey: "user") as? PFUser
            if (user != nil) {
                userLabel.text = user?.username
            }
            else {
                userLabel.text = ""
            }
        }
    }
}
