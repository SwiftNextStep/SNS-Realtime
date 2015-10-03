//
//  ViewController.swift
//  SNS-Realtime
//
//  Created by Icaro Barreira Lavrador on 3/10/15.
//  Copyright © 2015 Icaro Barreira Lavrador. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var textLabel: UILabel!
    let firebase = Firebase(url: "https://sns-realtimeapp.firebaseio.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        firebase.observeEventType(FEventType.Value) { (snapshot:FDataSnapshot!) -> Void in
            self.textLabel.text = snapshot.value as? String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

