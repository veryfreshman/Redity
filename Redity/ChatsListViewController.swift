//
//  ChatsListViewController.swift
//  Redity
//
//  Created by Admin on 20.09.16.
//  Copyright © 2016 Vanoproduction. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatsListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let CHAT_TEXT_FONT_SIZE:CGFloat = 14
    let CHAT_TEXT_COLOR_UNREAD:UIColor = UIColor(red: 60/255, green: 27/255, blue: 152/255, alpha: 1.0)
    let CHAT_AVATAR_BG_SAT:CGFloat = 0.06
    let CHAT_AVATAR_BG_BR:CGFloat = 0.94
    let CHAT_ROW_HEIGHT:CGFloat = 60
    let FEED_EMPTY_ICON_WIDTH_RELATIVE:CGFloat = 0.515
    let FEED_EMPTY_LABEL_TEXT_SIZE:CGFloat = 20
    let FEED_EMPTY_LABEL_MARGIN_TOP:CGFloat = 27
    let FEED_FOOTER_LABEL_TEXT_COLOR:UIColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1.0)
    let ANIMATION_EMPTY_SHOW_DURATION:CFTimeInterval = 0.4
    
    @IBOutlet var bg_view:UIView!
    
    var chatslist_tableview:UITableView!
    var chats_data:NSMutableArray!
    var avatars_colors:[Int:UIColor] = [Int:UIColor]()
    var main_vc:MainViewController!
    var posts_empty_label:UILabel!
    var posts_empty_icon:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded chats list vc")
        navigationItem.title = "Chats"
        bg_view.backgroundColor = UIColor(patternImage: UIImage(named: "bg_pattern")!)
        bg_view.alpha = 0.35
        self.edgesForExtendedLayout = UIRectEdge.None
        bg_view.backgroundColor = UIColor(patternImage: UIImage(named: "bg_pattern")!)
        bg_view.alpha = 0.35
        prepareChatsListWithReloading(false)
        posts_empty_label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 40))
        posts_empty_label.text = "No chats! Reply to someone"
        posts_empty_label.textColor = FEED_FOOTER_LABEL_TEXT_COLOR
        posts_empty_label.font = UIFont(name: "SFUIText-Bold", size: FEED_EMPTY_LABEL_TEXT_SIZE)!
        posts_empty_label.textAlignment = .Center
        let real_empty_size = posts_empty_label.textRectForBounds(posts_empty_label.bounds, limitedToNumberOfLines: 1)
        let real_empty_icon_width = view.bounds.width * FEED_EMPTY_ICON_WIDTH_RELATIVE
        let total_empty_height = real_empty_size.height + real_empty_icon_width + FEED_EMPTY_LABEL_MARGIN_TOP
        let top_image_margin = (view.bounds.height - total_empty_height) * 0.5
        posts_empty_icon = UIImageView(image: UIImage(named: "feed_empty_icon")!)
        posts_empty_icon.contentMode = .ScaleAspectFit
        posts_empty_icon.frame = CGRect(x: 0.5 * view.bounds.width - real_empty_icon_width * 0.5, y: top_image_margin, width: real_empty_icon_width, height: real_empty_icon_width)
        posts_empty_label.frame = CGRect(x: 0, y: posts_empty_icon.frame.maxY + FEED_EMPTY_LABEL_MARGIN_TOP, width: view.bounds.width, height: real_empty_size.height)
        posts_empty_icon.alpha = 0
        posts_empty_label.alpha = 0
        chatslist_tableview = UITableView(frame: view.bounds, style: UITableViewStyle.Plain)
        chatslist_tableview.registerNib(UINib(nibName: "ChatListCell", bundle: nil), forCellReuseIdentifier: "chat_list_cell")
        chatslist_tableview.backgroundColor = UIColor.clearColor()
        chatslist_tableview.delegate = self
        chatslist_tableview.dataSource = self
        chatslist_tableview.showsVerticalScrollIndicator = false
        chatslist_tableview.tableFooterView = UIView()
        chatslist_tableview.rowHeight = CHAT_ROW_HEIGHT
        view.addSubview(bg_view)
        view.addSubview(posts_empty_icon)
        view.addSubview(posts_empty_label)
        view.addSubview(chatslist_tableview)
    }
    
    override func viewWillAppear(animated: Bool) {
        if chatslist_tableview != nil {
            prepareChatsListWithReloading(true)
        }
    }
    
    func updateArchivedChats() {
        let docs_url = try? NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false)
        if let docs = docs_url {
            let chats_path = docs.URLByAppendingPathComponent("chats.arch").path!
            NSKeyedArchiver.archivedDataWithRootObject(chats_data).writeToFile(chats_path, atomically: false)
            let chats_total = chats_data.count
            var unread_chats_count = 0
            for chatData in chats_data {
                if chatData["unread"] as! Bool {
                    unread_chats_count++
                }
            }
            NSUserDefaults().setInteger(chats_total, forKey: "chats_total")
            NSUserDefaults().setInteger(unread_chats_count, forKey: "unread_chats_total")
            main_vc.updateSettingsTableNumbers()
        }
    }
    
    func setMainVc(mainVc:MainViewController) {
        self.main_vc = mainVc
    }
    
    func didSendMessageToCardId(cardId:Int, withText:String) {
        print("finishing sending")
        let new_msg = NSDictionary(dictionary: ["text":withText,"date":NSDate(),"nick":"000"])
        var sought_chat_index = -1
        for (var i = 0;i < chats_data.count;i++) {
            if chats_data[i]["cardId"] as! Int == cardId {
                sought_chat_index = i
                break
            }
        }
        if sought_chat_index != -1 {
            let new_chat_messages = NSMutableArray(array: chats_data[sought_chat_index]["messages"] as! NSArray)
            new_chat_messages.addObject(new_msg)
            let new_chat_data = NSMutableDictionary(dictionary: chats_data[sought_chat_index] as! NSDictionary)
            new_chat_data["messages"] = new_chat_messages
            chats_data[sought_chat_index] = new_chat_data
            
            if let cell = chatslist_tableview?.cellForRowAtIndexPath(NSIndexPath(forRow: sought_chat_index, inSection: 0)) as? ChatListCell {
                cell.setChatText(getTextStringForChat(chats_data[sought_chat_index] as! NSDictionary, unread: false))
            }
            
            updateArchivedChats()
        }
    }
    
    func getTextStringForChat(chat:NSDictionary, unread:Bool) -> NSAttributedString {
        var text_label_text:NSMutableAttributedString!
        let chat_messages = chat["messages"] as! [NSDictionary]
        if chat_messages.count == 0 {
            var str = "To post: "
            let bold_text_length = str.characters.count //languages can be different
            str += chat["cardTitle"] as! String
            text_label_text = NSMutableAttributedString(string: str)
            text_label_text.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, text_label_text.length))
            text_label_text.addAttribute(NSFontAttributeName, value: UIFont(name: "SFUIText-Regular", size: CHAT_TEXT_FONT_SIZE)!, range: NSMakeRange(bold_text_length, (text_label_text.length - bold_text_length)))
            text_label_text.addAttribute(NSFontAttributeName, value: UIFont(name: "SFUIText-Bold", size: CHAT_TEXT_FONT_SIZE)!, range: NSMakeRange(0, bold_text_length))
        }
        else {
            let msg = chat_messages.last!["text"] as! String
            let last_nick = chat_messages.last!["nick"] as! String
            let nick_sender = last_nick == "000" ? "Me" : last_nick
            text_label_text = NSMutableAttributedString(string: "\(nick_sender): \(msg)")
            if unread {
                text_label_text.addAttributes([NSForegroundColorAttributeName:CHAT_TEXT_COLOR_UNREAD, NSFontAttributeName : UIFont(name: "SFUIText-Bold", size: CHAT_TEXT_FONT_SIZE)!], range: NSMakeRange(0, text_label_text.length))
            }
            else {
                text_label_text.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, text_label_text.length))
                text_label_text.addAttribute(NSFontAttributeName, value: UIFont(name: "SFUIText-Regular", size: CHAT_TEXT_FONT_SIZE)!, range: NSMakeRange(nick_sender.characters.count + 1, (text_label_text.length - nick_sender.characters.count - 1)))
                text_label_text.addAttribute(NSFontAttributeName, value: UIFont(name: "SFUIText-Bold", size: CHAT_TEXT_FONT_SIZE)!, range: NSMakeRange(0, nick_sender.characters.count))
            }
        }
        return text_label_text
    }

    func prepareChatsListWithReloading(reload:Bool) {
        let docs_url = try? NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false)
        if let docs = docs_url {
            let chats_archive_path = docs.URLByAppendingPathComponent("chats.arch").path!
            var chats_archive = NSKeyedUnarchiver.unarchiveObjectWithFile(chats_archive_path) as! NSArray
            if chats_archive.count > 0 {
                chats_archive = chats_archive.sortedArrayUsingComparator({
                    (chat_1:AnyObject,chat_2:AnyObject) in
                    let chat_1_messages = chat_1["messages"] as! [NSDictionary]
                    var chat_1_date:NSDate!
                    if chat_1_messages.count == 0 {
                        chat_1_date = chat_1["adding_date"] as! NSDate
                    }
                    else {
                        chat_1_date = chat_1_messages.last!["date"] as! NSDate
                    }
                    let chat_2_messages = chat_2["messages"] as! [NSDictionary]
                    var chat_2_date:NSDate!
                    if chat_2_messages.count == 0 {
                        chat_2_date = chat_2["adding_date"] as! NSDate
                    }
                    else {
                        chat_2_date = chat_2_messages.last!["date"] as! NSDate
                    }
                    return chat_1_date.compare(chat_2_date) == NSComparisonResult.OrderedAscending ? NSComparisonResult.OrderedDescending : NSComparisonResult.OrderedAscending
                })
            }
            chats_data = NSMutableArray(array: chats_archive)
        }
        avatars_colors = [Int:UIColor]()
        for chatData in chats_data {
            let avatar_bg_color = UIColor(hue: CGFloat(arc4random()) / CGFloat(UINT32_MAX), saturation: CHAT_AVATAR_BG_SAT, brightness: CHAT_AVATAR_BG_BR, alpha: 1.0)
            avatars_colors[chatData["cardId"] as! Int] = avatar_bg_color
        }
        if reload {
            chatslist_tableview.reloadData()
        }
    }
    
    func setEmptyStateShown(shown:Bool) {
        if shown {
            UIView.animateWithDuration(ANIMATION_EMPTY_SHOW_DURATION, animations: {
                self.posts_empty_label.alpha = 1.0
                self.posts_empty_icon.alpha = 1.0
            })
        }
        else {
            posts_empty_icon.alpha = 0.0
            posts_empty_label.alpha = 0.0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("chat_list_cell") as? ChatListCell
        let chat = chats_data[indexPath.row] as! NSDictionary
        let unread = chat["unread"] as! Bool
        cell?.setMessageRead(!unread)
        cell?.setChatText(getTextStringForChat(chat, unread: unread))
        cell?.avatar_image.image = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(chat["nick"] as! String, backgroundColor: avatars_colors[chats_data[indexPath.row]["cardId"] as! Int]!, textColor: UIColor.blackColor(), font: UIFont(name: "SFUIText-Regular", size: 12)!, diameter: 34).avatarImage
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let chat_vc = ChatViewController()
        chat_vc.prepareMessagesWithChat(chats_data[indexPath.row] as! NSDictionary, myAvatarBgColor: General.my_avatar_bg_color, companionAvatarBgColor: avatars_colors[chats_data[indexPath.row]["cardId"] as! Int]!, chatsListVc: self)
        navigationController!.pushViewController(chat_vc, animated: true)
        if chats_data[indexPath.row]["unread"] as! Bool {
            let new_chat_dict = NSMutableDictionary(dictionary: (chats_data[indexPath.row] as! NSDictionary))
            new_chat_dict["unread"] = false
            chats_data[indexPath.row] = new_chat_dict
            updateArchivedChats()
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? ChatListCell {
                cell.setMessageRead(true)
                cell.setChatText(getTextStringForChat(chats_data[indexPath.row] as! NSDictionary, unread: false))
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let amount = chats_data.count
        setEmptyStateShown(amount == 0)
        return amount
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let cardId = chats_data[indexPath.row]["cardId"] as! Int
        chats_data.removeObjectAtIndex(indexPath.row)
        avatars_colors.removeValueForKey(cardId)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        updateArchivedChats()
        if chats_data.count == 0 {
            setEmptyStateShown(true)
        }
    }
    
}
