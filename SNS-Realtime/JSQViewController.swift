//
//  JSQViewController.swift
//  SNS-Realtime
//
//  Created by Icaro Barreira Lavrador on 11/02/16.
//  Copyright © 2016 Icaro Barreira Lavrador. All rights reserved.
//

import UIKit

class JSQViewController: JSQMessagesViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = "uidFromFirebase"
        self.senderDisplayName = "UserName"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
