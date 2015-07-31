//
//  ChatViewController.swift
//  1Again
//
//  Created by Nam Phong on 7/17/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ChatViewController: JSQMessagesViewController, JSQMessagesCollectionViewDelegateFlowLayout {
    
    var imd: String!
    var displayName: String!
    var receiverID: String!
    var senderID: String!

    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    var userName = ""
    var messages = [Message]()
    
    override func loadView() {
        
        let nameSpaceClassName = NSStringFromClass(self.classForCoder)
        let className = nameSpaceClassName.componentsSeparatedByString(".").last! as String
        NSBundle.mainBundle().loadNibNamed(className, owner:self, options:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.displayName
        self.userName = User.sharedUser.userID
        
        self.senderId = self.userName
        self.senderDisplayName = self.displayName ?? ""
        
        self.collectionView.collectionViewLayout.springinessEnabled = true
        self.collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        self.collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
        self.showLoadEarlierMessagesHeader = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        MessageAPI.getChatHistory(self.imd, completion: { (result) -> Void in
            self.messages = result
            self.collectionView.reloadData()
            self.scrollToBottomAnimated(true)
        }) { (error) -> Void in
            self.view.makeToast(error)
        }
    }
    
    func getReceivedID() -> String {
        if self.senderID != self.userName {
            return self.senderID
        } else if self.receiverID != self.userName {
            return self.receiverID
        } else {
            return self.userName
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        var data = self.messages[indexPath.row].jsqMessage
        return data
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        var data = self.messages[indexPath.row].jsqMessage
        if (data.senderId == self.senderId) {
            return self.outgoingBubble
        } else {
            return self.incomingBubble
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = self.messages[indexPath.row].jsqMessage
        return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count;
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {

        MessageAPI.sendNewMessage(self.imd, senderID: self.userName, receiverID: self.getReceivedID(), status: "N", message: text, completion: { (result) -> Void in
            var newMessage = JSQMessage(senderId: self.senderId, displayName: senderDisplayName, text: text);
            var tmpMessage = Message()
            tmpMessage.jsqMessage = newMessage
            self.messages.append(tmpMessage)
            self.finishSendingMessage()
            JSQSystemSoundPlayer.jsq_playMessageSentSound()
        }) { (error) -> Void in
            self.view.makeToast("Message not sent")
        }
    }

    override func didPressAccessoryButton(sender: UIButton!) {
        
    }
}
