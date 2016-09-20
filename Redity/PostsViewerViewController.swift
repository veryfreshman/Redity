//
//  PostsViewerViewController.swift
//  Redity
//
//  Created by Admin on 16.09.16.
//  Copyright © 2016 Vanoproduction. All rights reserved.
//

import UIKit
import CoreLocation

class PostsViewerViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let BG_OPACITY:CGFloat = 0.356
    let TABLE_MARGIN_TOP:CGFloat = 7
    let FEED_EMPTY_ICON_WIDTH_RELATIVE:CGFloat = 0.515
    let FEED_EMPTY_LABEL_TEXT_SIZE:CGFloat = 20
    let FEED_EMPTY_LABEL_MARGIN_TOP:CGFloat = 27
    let FEED_FOOTER_LABEL_TEXT_COLOR:UIColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1.0)
    let FEED_TABLE_CELLS_SPACING:CGFloat = 14
    let ANIMATION_EMPTY_SHOW_DURATION:CFTimeInterval = 0.4
    
    @IBOutlet var bg_view:UIView!
    
    var main_vc:MainViewController!
    var posts_empty_icon:UIImageView!
    var posts_empty_label:UILabel!
    var posts_table_view:UITableView!
    var navBarHeight:CGFloat = 0.0
    var current_posts_type = ""
    var current_posts_data:[Int:NSMutableDictionary] = [Int:NSMutableDictionary]()
    var posts_section_to_card_id:[Int:Int] = [Int:Int]()
    var posts_cells_frames:[Int:[String:CGRect]] = [Int:[String:CGRect]]()
    var posts_cells_heights:[Int:CGFloat] = [Int:CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bg_view.backgroundColor = UIColor(patternImage: UIImage(named: "bg_pattern")!)
        bg_view.alpha = BG_OPACITY
    }
    
    func preConfigureWithNavBarHeight(navBarHeight:CGFloat, mainVC:MainViewController) {
        self.main_vc = mainVC
        main_vc.posts_vc = self
        self.navBarHeight = navBarHeight
        posts_table_view = UITableView(frame: CGRect(x: 0, y: navBarHeight + TABLE_MARGIN_TOP, width: view.bounds.width, height: view.bounds.height - TABLE_MARGIN_TOP - navBarHeight), style: .Plain)
        posts_table_view.backgroundColor = UIColor.clearColor()
        posts_table_view.registerClass(FeedCellPlain.self, forCellReuseIdentifier: "feed_cell")
        posts_table_view.registerClass(FeedCellImages.self, forCellReuseIdentifier: "feed_cell_images")
        posts_table_view.delegate = self
        posts_table_view.dataSource = self
        posts_table_view.separatorColor = UIColor.clearColor()
        posts_table_view.showsHorizontalScrollIndicator = false
        view.addSubview(posts_table_view)
        posts_empty_label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 40))
        posts_empty_label.text = "No saved posts!"
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
        view.addSubview(posts_empty_icon)
        view.addSubview(posts_empty_label)
    }
    
    //type = saved or = my
    func configureWithPostsType(type:String) {
        navigationItem.title = type == "saved" ? "Saved posts" : "My posts"
        current_posts_type = type
        current_posts_data = [Int:NSMutableDictionary]()
        posts_section_to_card_id = [Int:Int]()
        posts_cells_frames = [Int:[String:CGRect]]()
        posts_cells_heights = [Int:CGFloat]()
        var section_id = 0
        let docs_url = try? NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false)
        var archive_path = ""
        if let docs = docs_url {
            if type == "saved" {
                archive_path = docs.URLByAppendingPathComponent("saved_posts_archive.arch").path!
                let unarchived_dict = NSMutableDictionary(dictionary: NSKeyedUnarchiver.unarchiveObjectWithFile(archive_path) as! NSDictionary)
                for (key,value) in unarchived_dict {
                    if value["map_present"] as! Bool {
                        let new_value = NSMutableDictionary(dictionary: value as! NSDictionary)
                        let map_lat = CLLocationDegrees(value["map_lat"] as! Double)
                        let map_long = CLLocationDegrees(value["map_long"] as! Double)
                        let map_coords_value = NSValue(MKCoordinate: CLLocationCoordinate2DMake(map_lat, map_long))
                        new_value.removeObjectForKey("map_lat")
                        new_value.removeObjectForKey("map_long")
                        new_value["map_coords"] = map_coords_value
                        unarchived_dict[key as! Int] = new_value
                    }
                }
                for (key,value) in unarchived_dict {
                    current_posts_data[key as! Int] = value as! NSMutableDictionary
                }
                let all_cards_ids = (unarchived_dict.allKeys as! [Int]).sort({$0 > $1})
                for cardId in all_cards_ids {
                    posts_section_to_card_id[section_id++] = cardId
                    let cell_dimensions = main_vc.getCardDimensionsWithCardData(current_posts_data[cardId] as! NSDictionary)
                    posts_cells_heights[cardId] = cell_dimensions.cellHeight
                    posts_cells_frames[cardId] = cell_dimensions.finalFrames
                }
            }
            else {
                //loading cards from the internet
                //archive_path = docs.URLByAppendingPathComponent("my_posts_archive.arch").path!
                print("loading my cards from the internet...")
            }
        }
        posts_table_view.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if current_posts_type == "saved" {
            let saved_cards_amount = (NSUserDefaults().arrayForKey("cards_bookmarks") as! [Int]).count
            setEmptyStateShown(saved_cards_amount == 0)
            return saved_cards_amount
        }
        else if current_posts_type == "my" {
            let my_cards_amount = (NSUserDefaults().arrayForKey("my_posts_cards_ids") as! [Int]).count
            setEmptyStateShown(my_cards_amount == 0)
            return my_cards_amount
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if current_posts_data[posts_section_to_card_id[indexPath.section]!]!["images_present"] as! Bool {
            let feed_cell_img = tableView.dequeueReusableCellWithIdentifier("feed_cell_images") as! FeedCellImages
            feed_cell_img.setCardIdWithId(posts_section_to_card_id[indexPath.section]!)
            feed_cell_img.setHandlersWithMenuHandler(cardMenuPressed, replyHandler: cardReplyPressed, shareHandler: cardSharePressed)
            feed_cell_img.setFrames(posts_cells_frames[posts_section_to_card_id[indexPath.section]!]!)
            return feed_cell_img
        }
        else {
            let feed_cell = tableView.dequeueReusableCellWithIdentifier("feed_cell") as! FeedCellPlain
            feed_cell.setCardIdWithId(posts_section_to_card_id[indexPath.section]!)
            feed_cell.setHandlersWithMenuHandler(cardMenuPressed, replyHandler: cardReplyPressed, shareHandler: cardSharePressed)
            feed_cell.setFrames(posts_cells_frames[posts_section_to_card_id[indexPath.section]!]!)
            return feed_cell
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if current_posts_data[posts_section_to_card_id[indexPath.section]!]!["images_present"] as! Bool {
            (cell as! FeedCellImages).setContent(current_posts_data[posts_section_to_card_id[indexPath.section]!]!)
            main_vc.startLoadingImagesForCardId(posts_section_to_card_id[indexPath.section]!, withAssigningType: "feed_sep")
            if current_posts_data[posts_section_to_card_id[indexPath.section]!]!["map_present"] as! Bool {
                main_vc.startLoadingMapSnapshotForCardId(posts_section_to_card_id[indexPath.section]!, withStyle: "feed_sep", withAssigning: true)
            }
        }
        else {
            (cell as! FeedCellPlain).setContent(current_posts_data[posts_section_to_card_id[indexPath.section]!]!)
            if current_posts_data[posts_section_to_card_id[indexPath.section]!]!["map_present"] as! Bool {
                main_vc.startLoadingMapSnapshotForCardId(posts_section_to_card_id[indexPath.section]!, withStyle: "feed_sep", withAssigning: true)
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        main_vc.openOnePostWithCardId(posts_section_to_card_id[indexPath.section]!, pressedIn: "posts_feed")
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return posts_cells_heights[posts_section_to_card_id[indexPath.section]!]!
    }
    
    func cardMenuPressed(cardId:Int) {
        print("card \(cardId) pressed in posts_vc")
        presentViewController(main_vc.getCardMenuForCardId(cardId, pressedIn: "posts_feed"), animated: true, completion: nil)
    }
    
    func cardReplyPressed(cardId:Int) {
        
    }
    
    func cardSharePressed(sender:Int) {
        
    }
    
    func getSectionForCardId(cardId:Int) -> Int {
        var section = -1
        for (key,value) in posts_section_to_card_id {
            if value == cardId {
                section = key
                break
            }
        }
        if section == -1 {
            print("FATAL ERROR: no such cardID in postsVc!")
        }
        return section
    }
    
    func deletePostWithCardId(cardId:Int) {
        let section_posts = getSectionForCardId(cardId)
        var new_mapping:[Int:Int] = [Int:Int]()
        var current_section = 0
        let all_posts_sections = ((posts_section_to_card_id as! NSDictionary).allKeys as! [Int]).sort()
        for key in all_posts_sections {
            if key == section_posts {
                continue
            }
            new_mapping[current_section++] = posts_section_to_card_id[key]
        }
        posts_section_to_card_id = new_mapping
        posts_table_view.deleteSections(NSIndexSet(index: section_posts), withRowAnimation: UITableViewRowAnimation.Fade)
        if (NSUserDefaults().arrayForKey("cards_bookmarks") as! [Int]).count == 0 {
            setEmptyStateShown(true)
        }
        main_vc.updateSettingsTableNumbers()
    }
    
    func setEmptyStateShown(shown:Bool) {
        if shown {
            UIView.animateWithDuration(ANIMATION_EMPTY_SHOW_DURATION, animations: {
                self.posts_empty_label.alpha = 1.0
                self.posts_empty_icon.alpha = 1.0
            })
            navigationItem.setRightBarButtonItem(nil, animated: true)
        }
        else {
            posts_empty_icon.alpha = 0.0
            posts_empty_label.alpha = 0.0
            navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "deleteAllPostsButtonPressed:"), animated: true)
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == (posts_section_to_card_id as! NSDictionary).allKeys.count - 1 {
            return 0
        }
        return FEED_TABLE_CELLS_SPACING
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer_view = UIView()
        footer_view.backgroundColor = UIColor.clearColor()
        return footer_view
    }
    
    func deleteAllPostsButtonPressed(sender:UIBarButtonItem) {
        let saved_cards_ids = NSMutableArray(array: NSUserDefaults().arrayForKey("cards_bookmarks") as! [Int])
        current_posts_data = [Int:NSMutableDictionary]()
        posts_section_to_card_id = [Int:Int]()
        for cardId in saved_cards_ids {
            let post_card_id = cardId as! Int
            let section_main_feed = main_vc.feedSectionForCardId(post_card_id)
            if section_main_feed != -1 {
                var images_present = false
                if main_vc.current_feed_cells_data[post_card_id]!["images_present"] as! Bool {
                    images_present = true
                }
                if images_present {
                    if let card_cell = main_vc.feed_table_view.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section_main_feed)) as? FeedCellImages {
                        card_cell.bookmark_icon.image = UIImage(named: "bookmark_card_icon_off")!
                    }
                }
                else {
                    if let card_cell = main_vc.feed_table_view.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section_main_feed)) as? FeedCellPlain {
                        card_cell.bookmark_icon.image = UIImage(named: "bookmark_card_icon_off")!
                    }
                }
            }
        }
        saved_cards_ids.removeAllObjects()
        NSUserDefaults().setObject(saved_cards_ids, forKey: "cards_bookmarks")
        posts_table_view.reloadData()
        main_vc.updateSettingsTableNumbers()
    }
    
}
