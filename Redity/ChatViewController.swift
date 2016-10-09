//
//  ChatViewController.swift
//  Redity
//
//  Created by Vano on 20.09.16.
//  Copyright © 2016 Vanoproduction. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    let OUTGOING_MESSAGE_BG_COLOR:UIColor = UIColor(red: 107/255, green: 61/255, blue: 255/255, alpha: 1.0)
    let INCOMING_MESSAGE_BG_COLOR:UIColor = UIColor(red: 230/255, green: 229/255, blue: 234/255, alpha: 1.0)
    let MIN_DATE_DIF_DISPLAY_DATE:NSTimeInterval = 4.5 * 60.0 * 60.0
    
    var avatar_me_bg_color:UIColor!
    var avatar_companion_bg_color:UIColor!
    var my_nick = ""
    var companion_nick = ""
    var cardId = -1
    var messages:[JSQMessage] = []
    var ingoing_bubble_image:JSQMessagesBubbleImage!
    var outgoing_bubble_image:JSQMessagesBubbleImage!
    var chats_list_vc:ChatsListViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "go_post_icon")!, style: UIBarButtonItemStyle.Plain, target: self, action: "goPostButtonPressed:")
        self.senderId = my_nick
        self.senderDisplayName = my_nick
        ingoing_bubble_image = JSQMessagesBubbleImageFactory(bubbleImage: UIImage.jsq_bubbleRegularTaillessImage(), capInsets: UIEdgeInsetsZero).incomingMessagesBubbleImageWithColor(INCOMING_MESSAGE_BG_COLOR)
        outgoing_bubble_image = JSQMessagesBubbleImageFactory(bubbleImage: UIImage.jsq_bubbleRegularTaillessImage(), capInsets: UIEdgeInsetsZero).incomingMessagesBubbleImageWithColor(OUTGOING_MESSAGE_BG_COLOR)
        inputToolbar!.contentView!.leftBarButtonItem = nil
    }
    
    func prepareMessagesWithChat(chatData:NSDictionary, myAvatarBgColor:UIColor,companionAvatarBgColor:UIColor, chatsListVc:ChatsListViewController) {
        chats_list_vc = chatsListVc
        my_nick = NSUserDefaults().stringForKey("my_nick")!
        companion_nick = chatData["nick"] as! String
        navigationItem.title = companion_nick
        messages = []
        avatar_me_bg_color = myAvatarBgColor
        avatar_companion_bg_color = companionAvatarBgColor
        let data_messages = chatData["messages"] as! [NSDictionary]
        for data_message in data_messages {
            let msg = JSQMessage(senderId: data_message["nick"] as! String == "000" ? my_nick : companion_nick, senderDisplayName: data_message["nick"] as! String == "000" ? my_nick : companion_nick, date: data_message["date"] as! NSDate, text: data_message["text"] as! String)
            messages.append(msg)
        }
        cardId = chatData["cardId"] as! Int
    }
    
    func shouldPresentDateAtIndexPath(indexPath:NSIndexPath) -> Bool {
        let this_date = messages[indexPath.row].date
        var prev_date:NSDate?
        var present_date = true
        if indexPath.row > 0 {
            prev_date = messages[indexPath.row - 1].date
        }
        if let prev_date_un = prev_date {
            present_date = this_date.timeIntervalSinceDate(prev_date_un) > MIN_DATE_DIF_DISPLAY_DATE
        }
        return present_date
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        return messages[indexPath.item].senderId == self.senderId ? outgoing_bubble_image : ingoing_bubble_image
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        (cell as! JSQMessagesCollectionViewCell).textView?.textColor = messages[indexPath.item].senderId == self.senderId ? UIColor.whiteColor() : UIColor.blackColor()
    }
    
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let msg = JSQMessage(senderId: my_nick, senderDisplayName: my_nick, date: NSDate(), text: text)
        messages.append(msg)
        finishSendingMessageAnimated(true)
        print("before did send")
        chats_list_vc.didSendMessageToCardId(cardId, withText: text)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let avatar_image = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(messages[indexPath.item].senderId, backgroundColor: self.senderId == messages[indexPath.row].senderId ? avatar_me_bg_color : avatar_companion_bg_color, textColor: UIColor.blackColor(), font: UIFont(name: "SFUIText-Regular", size: 14)!, diameter: 34)
        return avatar_image
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString? {
        let this_date = messages[indexPath.row].date
        var show_time = false
        if NSCalendar.currentCalendar().startOfDayForDate(NSDate()).compare(this_date) == NSComparisonResult.OrderedAscending {
            show_time = true
        }
        if shouldPresentDateAtIndexPath(indexPath) {
            let date_formatter = NSDateFormatter()
            if show_time {
                date_formatter.timeStyle = .ShortStyle
                date_formatter.dateStyle = .NoStyle
            }
            else {
                date_formatter.timeStyle = .ShortStyle
                date_formatter.dateStyle = .MediumStyle
            }
            return NSAttributedString(string: date_formatter.stringFromDate(this_date))
        }
        else {
            return nil
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if shouldPresentDateAtIndexPath(indexPath) {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        else {
            return 0.0
        }
    }
    
    func goPostButtonPressed(sender:UIBarButtonItem) {
        chats_list_vc.main_vc.openOnePostWithCardId(cardId, pressedIn: "chat")
    }
    
}
