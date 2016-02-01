//
//  MessagesTableViewController.swift
//  SNS-Realtime
//
//  Created by Icaro Barreira Lavrador on 9/11/15.
//  Copyright © 2015 Icaro Barreira Lavrador. All rights reserved.
//

import UIKit

struct User {
    let uid: String?
    let name: String?
}

struct Messages {
    let message: String?
    let uid: String?
}

class MessagesTableViewController: UITableViewController {
    
    var firebase = Firebase(url: "https://sns-realtimeapp.firebaseio.com/")
    var chieldAddedHandler = FirebaseHandle()
    var listOfMessages = Array<Messages>()
    
    let uid = String?()

    @IBAction func logout(sender: AnyObject) {
        firebase.unauth()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func addMesssage(sender: AnyObject) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        chieldAddedHandler = firebase.observeEventType(.ChildAdded, withBlock: { (snapshot:FDataSnapshot!) -> Void in
            if let newMessages = snapshot.value as? NSDictionary{
                print(newMessages)
                for newMessage in newMessages{
                    let message = newMessage.value
                    print(message)
                    let appMessage = Messages(message: message["message"] as? String, uid: message["sender"] as? String)
                    self.listOfMessages.append(appMessage)
                }
                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                    self.tableView.reloadData()
                }
            }
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfMessages.count - 1
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let messageController = segue.destinationViewController as? MessageViewController {
            messageController.onMessageAvailable = {[weak self]
                (data) in
                if let weakSelf = self {
                    weakSelf.receiveMessageToSend(data)
                }
            }
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let message = listOfMessages[indexPath.row]
        cell.textLabel?.text = message.message
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func receiveMessageToSend(message:String){
        self.firebase.childByAppendingPath("postID").childByAutoId().setValue(["message":message, "sender":firebase.authData.uid])
    }

}
