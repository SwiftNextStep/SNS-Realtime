//
//  JSQViewController.swift
//  SNS-Realtime
//
//  Created by Icaro Barreira Lavrador on 11/02/16.
//  Copyright © 2016 Icaro Barreira Lavrador. All rights reserved.
//

import UIKit

class JSQViewController: JSQMessagesViewController {

    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    
    var avatars = [String:JSQMessagesAvatarImage]()
    
    var messages = [JSQMessage]()
    var keys = [String]()
    
    let firebase = Firebase(url: "https://sns-realtimeapp.firebaseio.com")
    var userConnection = Firebase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectUsers()
        setup()
        
    }
    
    func setupCollectUsers(){
        firebase.childByAppendingPath("users").observeSingleEventOfType(FEventType.Value) { (snapshot:FDataSnapshot!) -> Void in
            print("Single -> \(snapshot)")
        }
        firebase.childByAppendingPath("users").observeSingleEventOfType(FEventType.ChildChanged) { (snapshot:FDataSnapshot!) -> Void in
            print("Observer -> \(snapshot)")
        }
    }
    
    func setup(){
        userConnection = Firebase(url: "https://sns-realtimeapp.firebaseio.com/users/\(senderId)/isOnline")
        userConnection.onDisconnectSetValue("false")
        self.inputToolbar?.contentView?.leftBarButtonItem?.hidden = true
        self.inputToolbar?.contentView?.leftBarButtonItemWidth = 0
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        incomingBubble = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        outgoingBubble = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        
        createAvatar(senderId, senderDisplayName: senderDisplayName, color: UIColor.lightGrayColor())
        
        firebase.childByAppendingPath("JSQNode").queryLimitedToLast(50).queryOrderedByChild("date").observeSingleEventOfType(FEventType.Value) { (snapshot:FDataSnapshot!) -> Void in
            print(snapshot)
            if let values = snapshot.value as? NSDictionary{
                for value in values{
                    if !self.keys.contains(snapshot.key){
                        self.keys.append(value.key as! String)
                        
                        if let message = value.value as? NSDictionary{
                            let date = message["date"] as! NSTimeInterval
                            let receiveSenderID = message["senderId"] as! String
                            let receiveDisplayName = message["senderDisplayName"] as! String
                            self.createAvatar(receiveSenderID, senderDisplayName: receiveDisplayName, color: UIColor.jsq_messageBubbleGreenColor())
                            let jsqMessage = JSQMessage(senderId: receiveSenderID, senderDisplayName: receiveDisplayName, date: NSDate(timeIntervalSince1970: date), text: message["message"] as! String)
                            self.messages.append(jsqMessage)
                            print(message["message"] as! String)
                        }
                    }
                }
                self.messages.sortInPlace({ ($0.date.compare($1.date) == NSComparisonResult.OrderedAscending)})
                self.finishReceivingMessageAnimated(true)
            }
        }
        
        firebase.childByAppendingPath("JSQNode").queryLimitedToLast(1).observeEventType(.ChildAdded) { (snapshot:FDataSnapshot!) -> Void in
            if !self.keys.contains(snapshot.key){
                self.keys.append(snapshot.key)
                if let message = snapshot.value as? NSDictionary{
                    let date = message["date"] as! NSTimeInterval
                    let receiveSenderID = message["senderId"] as! String
                    let receiveDisplayName = message["senderDisplayName"] as! String
                    self.createAvatar(receiveSenderID, senderDisplayName: receiveDisplayName, color: UIColor.jsq_messageBubbleGreenColor())
                    let jsqMessage = JSQMessage(senderId: receiveSenderID, senderDisplayName: receiveDisplayName, date: NSDate(timeIntervalSince1970: date), text: message["message"] as! String)
                    self.messages.append(jsqMessage)
                    if receiveSenderID != self.senderId{
                        JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
                    }
                }
                self.finishReceivingMessageAnimated(true)
            }
        }
    }
    
    func createAvatar(senderId: String, senderDisplayName: String, color: UIColor){
        if avatars[senderId] == nil{
            let initials = senderDisplayName.substringToIndex(senderDisplayName.startIndex.advancedBy(min(2, senderDisplayName.characters.count)))
            let avatar = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(initials, backgroundColor: color, textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(14), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
            avatars[senderId] = avatar
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        //let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        firebase.childByAppendingPath("JSQNode").childByAutoId().setValue(["message":text, "senderId":senderId, "senderDisplayName":senderDisplayName, "date":date.timeIntervalSince1970, "messageType":"txt"])
        //messages.append(message)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
    }
    
    //MARK - Delegates
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        
        return messages[indexPath.row]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let message = messages[indexPath.row]
        
        if message.senderId == senderId{
            return outgoingBubble
        }
        return incomingBubble
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
       
        let message = messages[indexPath.row]
        
        return avatars[message.senderId]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        let message = messages[indexPath.row]
        if indexPath.row <= 1 {
            return NSAttributedString(string: message.senderDisplayName)
        }
        
        return nil
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.row]
        if message.senderId == senderId{
            cell.textView?.textColor = UIColor.blackColor()
        } else{
            cell.textView?.textColor = UIColor.whiteColor()
        }
        
        cell.textView?.linkTextAttributes = [NSForegroundColorAttributeName:(cell.textView?.textColor)!]
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messages.count
    }
}
