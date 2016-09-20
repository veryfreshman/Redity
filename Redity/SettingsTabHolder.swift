//
//  SettingsTabHolder.swift
//  Redity
//
//  Created by Admin on 15.09.16.
//  Copyright © 2016 Vanoproduction. All rights reserved.
//

import UIKit

class SettingsTabHolder: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let PRICE_PRO:Double = 1.99
    let CELL_REGULAR_HEIGHT:CGFloat = 45
    let CELL_BIG_HEIGHT:CGFloat = 70
    
    var main_vc:MainViewController!
    var posts_viewer_vc:PostsViewerViewController!
    
    init(mainVC:MainViewController) {
        super.init()
        main_vc = mainVC
        posts_viewer_vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("posts_viewer_vc") as! PostsViewerViewController
        posts_viewer_vc.preConfigureWithNavBarHeight(65, mainVC: main_vc)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0...3:
            let cell = tableView.dequeueReusableCellWithIdentifier("settings_cell_big") as! SettingsCellBig
            var title_head = "", title_description = ""
            switch indexPath.row {
            case 0:
                let total_chats = NSUserDefaults().integerForKey("chats_total")
                title_head = "Chats"
                title_description = "\(total_chats) total"
            case 1:
                let total_saved = (NSUserDefaults().arrayForKey("cards_bookmarks") as! [Int]).count
                title_head = "Saved posts"
                title_description = "\(total_saved) saved"
            case 2:
                let total_my = (NSUserDefaults().arrayForKey("my_posts_cards_ids") as! [Int]).count
                title_head = "My posts"
                title_description = "\(total_my) total"
            case 3:
                title_head = "Pro version"
                title_description = "$ \(PRICE_PRO)"
            default:
                break
            }
            cell.title_head.text = title_head
            cell.title_description.text = title_description
            cell.icon_image.image = UIImage(named: "settings_icon_\(indexPath.row)")!
            return cell
        case 4:
            let cell = tableView.dequeueReusableCellWithIdentifier("settings_cell_text") as! SettingsCellPlainText
            cell.plain_text.text = "Allows you to view all meetings, as time-distant as possible, not limiting just by 45 days. Who knows, maybe someone is still looking for you..."
            return cell
        case 5...7:
            let cell = tableView.dequeueReusableCellWithIdentifier("settings_cell_regular") as! SettingsCellRegular
            var title = ""
            switch indexPath.row {
            case 5:
                title = "Notifications on"
                cell.switch_control.selected = NSUserDefaults().boolForKey("settings_notifications")
                cell.switch_control.hidden = false
                cell.disclosure_icon.hidden = true
                cell.setSwitchHandlerWithHandler(notificationsSwitchPressed)
            case 6:
                title = "Rate app"
                cell.switch_control.hidden = true
                cell.disclosure_icon.hidden = false
            case 7:
                title = "E-mail support"
                cell.switch_control.hidden = true
                cell.disclosure_icon.hidden = false
            default:
                break
            }
            cell.title.text = title
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0...3:
            return CELL_BIG_HEIGHT
        case 4:
            return -1
        case 5:
            return -1
        case 6...7:
            return CELL_REGULAR_HEIGHT
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        switch indexPath.row {
        case 0:
            print("opening chats...")
        case 1:
            posts_viewer_vc.configureWithPostsType("saved")
            main_vc.navigationController!.pushViewController(posts_viewer_vc, animated: true)
        case 2:
            posts_viewer_vc.configureWithPostsType("my")
            main_vc.navigationController!.pushViewController(posts_viewer_vc, animated: true)
        case 3:
            print("buying pro version...")
        case 6:
            print("rating app...")
        case 7:
            print("e-mail support required...")
        default:
            break
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 4 {
            cell.backgroundColor = UIColor.clearColor()
        }
        else {
            cell.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func notificationsSwitchPressed(sender:UISwitch) {
        print("notifications are now \(sender.on)")
    }
    
}
