//
//  MessageViewController.swift
//  SNS-Realtime
//
//  Created by Icaro Barreira Lavrador on 1/02/16.
//  Copyright © 2016 Icaro Barreira Lavrador. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    var onMessageAvailable : ((data: String) -> ())?
    
    @IBOutlet weak var message: UITextField!
    
    @IBAction func sendMessage(sender: AnyObject) {
        onMessageAvailable!(data: message.text!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelMessage(sender: AnyObject) {
         self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
