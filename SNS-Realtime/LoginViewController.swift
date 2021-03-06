//
//  LoginViewController.swift
//  SNS-Realtime
//
//  Created by Icaro Barreira Lavrador on 11/10/15.
//  Copyright © 2015 Icaro Barreira Lavrador. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var firebase = Firebase(url: "https://sns-realtimeapp.firebaseio.com")
    var username = String()
    var newUser = false
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBAction func LoginButton(sender: UIButton) {
        logUser()
    }
    
    @IBAction func Signup(sender: UIButton) {
        if checkFields(){
            firebase.createUser(emailTextfield.text, password: passwordTextfield.text) { (error:NSError!) -> Void in
                if (error != nil){
                    print(error.localizedDescription)
                    self.displayMessage(error)
                } else{
                    print("New user created")
                    self.requestUsername()
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        emailTextfield.text = ""
        passwordTextfield.text = ""
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firebase.authData != nil{
            self.retriveUserName()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func logUser(){
        if checkFields(){
            print("Start loggin user")
            firebase.authUser(emailTextfield.text, password: passwordTextfield.text) { (error:NSError!, authData:FAuthData!) -> Void in
                if (error != nil){
                    print(error.localizedDescription)
                    self.displayMessage(error)
                } else{
                    print("user logged \(authData.description)")
                    let uid = authData.uid
                    if self.newUser{
                        self.firebase.childByAppendingPath("users").childByAppendingPath(uid).setValue(["isOnline":true, "name":self.username])
                        self.performSegueWithIdentifier("segueJSQ", sender: self)
                    } else{
                        self.firebase.childByAppendingPath("users").childByAppendingPath(uid).updateChildValues(["isOnline":true])
                        self.retriveUserName()
                    }
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueJSQ"{
            let uid = self.firebase.authData.uid
            if let viewController = segue.destinationViewController as? JSQViewController{
                firebase.childByAppendingPath("users").childByAppendingPath(uid).updateChildValues(["isOnline":true])
                viewController.senderId = uid
                viewController.senderDisplayName = self.username
            }
        }
    }
    
    func retriveUserName(){
        self.firebase.childByAppendingPath("users").childByAppendingPath(firebase.authData.uid).observeSingleEventOfType(.Value) { (snapshot: FDataSnapshot!) -> Void in
            self.username = (snapshot.value as! NSDictionary)["name"] as! String
            self.performSegueWithIdentifier("segueJSQ", sender: self)
        }
    }
    
    func checkFields()->Bool{
        if ((!emailTextfield.text!.isEmpty) && (!passwordTextfield.text!.isEmpty)){
            return true
        } else{
            print("Empty field was found")
            return false
        }
    }
    
    func displayMessage(error:NSError){
        let titleMessage = "Error"
        let alert = UIAlertController(title: titleMessage, message: error.localizedDescription, preferredStyle: .Alert)
        let actionOk = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(actionOk)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func requestUsername(){
        var usernameTextfield: UITextField?
        let titleMessage = "Enter a Username"
        let bodyMessage = "Please enter a username for your new account:"
        let usernameEntry = UIAlertController(title: titleMessage, message: bodyMessage, preferredStyle: .Alert)
        let actionOk = UIAlertAction(title: "Ok", style: .Default) { (UIAlertAction) -> Void in
            if let user = usernameTextfield?.text{
                print(user)
                self.username = user
                self.newUser = true
                self.logUser()
            }
        }
        usernameEntry.addAction(actionOk)
        usernameEntry.addTextFieldWithConfigurationHandler { (username:UITextField) -> Void in
            usernameTextfield = username
        }
        self.presentViewController(usernameEntry, animated: true, completion: nil)
    }
}
