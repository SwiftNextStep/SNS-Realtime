//
//  ViewController.swift
//  SNS-Realtime
//
//  Created by Icaro Barreira Lavrador on 3/10/15.
//  Copyright © 2015 Icaro Barreira Lavrador. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    let firebase = Firebase(url: "https://sns-realtimeapp.firebaseio.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebase.setValue("App started")
        
        firebase.observeEventType(FEventType.Value) { (snapshot:FDataSnapshot!) -> Void in
            print(snapshot.value)
            self.firebase.setValue("Computer says no!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

