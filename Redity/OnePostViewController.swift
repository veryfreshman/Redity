//
//  OnePostViewController.swift
//  Redity
//
//  Created by Admin on 30.06.16.
//  Copyright © 2016 Vanoproduction. All rights reserved.
//

import UIKit
import CoreGraphics
import CoreLocation
import MapKit

class OnePostViewController:UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate {
    
    let TITLE_FONT_SIZE:CGFloat = 15
    let ENCOUNTER_FONT_SIZE:CGFloat = 14
    let BODY_FONT_SIZE:CGFloat = 14
    let BUTTON_BOTTOM_FONT_SIZE:CGFloat = 17
    let POSTING_DATE_TEXT_SIZE:CGFloat = 15
    
    let START_BUTTONS_TEXT_SIZE:CGFloat = 16.0
    let TOOLBAR_HEIGHT_RELATIVE:CGFloat = 0.074 //from total height
    let SCROLL_VIEW_MARGIN_TOP:CGFloat = 8 //from bottom of navigationbar
    let SCROLL_VIEW_MARGIN_BOTTOM:CGFloat = 3 //from bottom of navigationbar
    let TITLE_MARGIN_TOP:CGFloat = 5
    let TITLE_MARGIN_LEFT:CGFloat = 14
    let TITLE_WIDTH_RELATIVE:CGFloat = 0.77 // relative to cell's width
    let TITLE_TEXT_COLOR:UIColor = UIColor(red: 50/255, green: 9/255, blue: 134/255, alpha: 1.0)
    let ENCOUNTER_TEXT_COLOR:UIColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1.0)
    let POSTING_DATE_TEXT_COLOR:UIColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1.0)
    let BUTTON_TEXT_COLOR:UIColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0)
    let BUTTON_TEXT_COLOR_SELECTED:UIColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
    let MENU_BUTTON_WIDTH_RELATIVE:CGFloat = 0.068
    let MENU_BUTTON_IMAGE_ASPECT:CGFloat = 0.185
    let MENU_BUTTON_HEIGHT:CGFloat = 25
    let IMAGE_ENCOUNTER_MARGIN_TOP:CGFloat = 8 //margin from title label
    let IMAGE_ENCOUNTER_MARGIN_LEFT:CGFloat = 22
    let IMAGE_ENCOUNTER_WIDTH_RELATIVE:CGFloat = 0.0405
    let IMAGE_ENCOUNTER_ASPECT:CGFloat = 0.96
    let ENCOUNTER_LABEL_MARGIN_LEFT:CGFloat = 9 // from encounter image
    let IMAGE_SEARCH_MARGIN_TOP:CGFloat = 5.5 //from title label
    let IMAGE_SEARCH_WIDTH_RELATIVE:CGFloat = 0.152
    let IMAGE_SEARCH_MARGIN_LEFT_RELATIVE:CGFloat = 0.48 //from total contentview width
    let IMAGE_SEARCH_MARGIN_LEFT_ENCOUNTER_LABEL:CGFloat = 20 //from encounter label in px
    let IMAGE_SEARCH_ASPECT:CGFloat = 0.35
    let BODY_MARGIN_LEFT:CGFloat = 14
    let BODY_MARGIN_TOP:CGFloat = 10
    let BODY_MAX_HEIGHT:CGFloat = 120
    let BODY_MARGIN_RIGHT:CGFloat = 14
    let IMAGE_CENTER_TRANSPORT_OPACITY:CGFloat = 0.2
    let IMAGE_CENTER_TRANSPORT_MAX_HEIGHT_RELATIVE:CGFloat = 0.7 // transport icon will be positioned in the back of body text, relative to it's height
    let IMAGE_CENTER_TRANSPORT_MAX_WIDTH_RELATIVE:CGFloat = 0.8
    let IMAGE_CENTER_MAP_TOP_MARGIN:CGFloat = -15 // it's gonna be gradient, so that's ok
    let IMAGE_CENTER_MAP_HEIGHT:CGFloat = 130
    let CONTENT_IMAGE_PLACEHOLDER_BG:UIColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    let CONTENT_IMAGES_MARGIN_TOP:CGFloat = 6 //from bottom of map or transport
    let CONTENT_IMAGES_MARGIN_LEFT:CGFloat = 14
    let CONTENT_IMAGES_MARGIN_RIGHT:CGFloat = 14
    let CONTENT_IMAGES_MIN_SPACING:CGFloat = 25 //between each other if 2 images
    let CONTENT_IMAGES_MAX_HEIGHT:CGFloat = 150
    let CONTENT_IMAGES_ANIMATION_DELAY:CFTimeInterval = 0.6 //to wait before starting fade in anim if required
    let CONTENT_IMAGES_ANIMATION_DURATION:CFTimeInterval = 0.4
    let POSTING_DATE_MARGIN_TOP:CGFloat = 9 //from map or body
    let POSTING_DATE_MARGIN_LEFT:CGFloat = 16
    let BG_VIEW_BOTTOM_MARGIN:CGFloat = 7 // bg view acts as a wrapper around data - so how much more space do we need?
    let NAVIGATION_BAR_TINT_COLOR:UIColor = UIColor(red: 216/255, green: 213/255, blue: 242/255, alpha: 1.0)
    let BUTTONS_TEXT_MARGIN_LEFT:CGFloat = 10 // px from the right of img on button
    let BUTTONS_TEXT_MARGIN_RIGHT:CGFloat = 5 // from the end of the button itself
    let BUTTON_SHARE_IMAGE_RIGHT_RELATIVE:CGFloat = 0.296 // the end of the image on button - relative to whole button width
    let BUTTON_REPLY_IMAGE_RIGHT_RELATIVE:CGFloat = 0.255
    let BUTTON_SAVE_IMAGE_RIGHT_RELATIVE:CGFloat = 0.241
    let MAP_PLACEHOLDER_BG_COLOR:UIColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
    let ANIMATION_IMAGE_VIEWER_DURATION:CFTimeInterval = 0.4
    let IMAGE_PAN_TO_CLOSE_RELATIVE:CGFloat = 0.2
    let ANIMATION_MAP_APPEARS_DURATION:CFTimeInterval = 0.36
    let ANIMATION_CONTENT_IMAGES_DURATION:CFTimeInterval = 0.4
    let ANIMATION_MAP_EXPANDS_DURATION:CFTimeInterval = 0.55
    let MAP_POINT_WIDTH_RELATIVE:CGFloat = 0.082
    let MAP_POINT_ASPECT:CGFloat = 1.333
    let MAP_SNAPSHOT_METERS_PER_WIDTH_FULL:Double = 1250.0
    let CLOSE_MAP_ICON_MARGIN_TOP:CGFloat = 15
    let CLOSE_MAP_ICON_MARGIN_RIGHT:CGFloat = 8
    let CLOSE_MAP_ICON_WIDTH_RELATIVE:CGFloat = 0.115
    
    @IBOutlet var reply_button:UIButton!
    @IBOutlet var save_button:UIButton!
    @IBOutlet var share_button:UIButton!
    
    var close_map_button:UIButton!
    var post_scroll_view:UIScrollView!
    var title_label:UILabel!
    var encounter_image:UIImageView!
    var encounter_label:UILabel!
    var search_image:UIImageView!
    var image_center:UIImageView!
    var body_label:UILabel!
    var content_image_1:UIImageView!
    var content_image_2:UIImageView!
    var posting_date_label:UILabel!
    var navBarHeight:CGFloat = 0
    var post_bg_view:UIView!
    var image_viewer_scroll_view:UIScrollView!
    var scroll_image_view:UIImageView!
    var gesture_image_pan:UIPanGestureRecognizer!
    var gesture_image_twin_tap:UITapGestureRecognizer!
    var large_image_presented = false
    var current_center_image_transport_size:CGSize!
    var current_center_image_transport = false
    var current_content_images_amount:Int = 0
    var current_content_image_1_size = CGSizeZero
    var current_content_image_2_size = CGSizeZero
    var img_1_viewer_size = CGSizeZero, img_2_viewer_size = CGSizeZero
    var current_content_images:[UIImage] = []
    var this_card_id:Int = -1
    var current_zooming_image = -1
    var this_coords:CLLocationCoordinate2D!
    var pressed_in = ""
    var main_map_vc:MapViewController!
    var main_vc:MainViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu_button_icon_navBar")!, style: .Plain, target: self, action: "menuButtonPressed:")
        share_button.setTitleColor(BUTTON_TEXT_COLOR_SELECTED, forState: .Highlighted)
        save_button.setTitleColor(BUTTON_TEXT_COLOR_SELECTED, forState: .Highlighted)
        reply_button.setTitleColor(BUTTON_TEXT_COLOR_SELECTED, forState: .Highlighted)
    }
    
    override func viewDidDisappear(animated: Bool) {
        if !current_center_image_transport {
            hideMapImage()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        recalculateButtonsLabels()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scroll_image_view
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        var top_edge:CGFloat = 0
        var sides_edge:CGFloat = 0
        let base_img_size = current_zooming_image == 1 ? img_1_viewer_size : img_2_viewer_size
        let now_img_size = CGSizeMake(base_img_size.width * scrollView.zoomScale, base_img_size.height * scrollView.zoomScale)
        let max_img_size = CGSizeMake(view.bounds.width, view.bounds.height * (1.0 - TOOLBAR_HEIGHT_RELATIVE) - navBarHeight)
        //we can not even check this but add inset to all aoomscales, and when the real image occupies less space than max image then we should change offset so that to center it
        if now_img_size.height > max_img_size.height {
            let base_top_padding = (max_img_size.height - base_img_size.height) * 0.5
            top_edge = base_top_padding * scrollView.zoomScale
        }
        if now_img_size.width > max_img_size.width {
            let base_sides_padding = (max_img_size.width - base_img_size.width) * 0.5
            sides_edge = base_sides_padding * scrollView.zoomScale
        }
        scrollView.contentInset = UIEdgeInsetsMake(-top_edge, -sides_edge, -top_edge, -sides_edge)
    }
    
    func imagePanned(sender:UIPanGestureRecognizer) {
        switch sender.state {
        case .Changed:
            scroll_image_view.transform = CGAffineTransformMakeTranslation(0, sender.translationInView(scroll_image_view).y)
        case .Ended:
            var should_finish = false
            if abs(sender.translationInView(scroll_image_view).y) > view.bounds.height * IMAGE_PAN_TO_CLOSE_RELATIVE {
                should_finish = true
            }
            animateLargeImageShouldFinish(should_finish)
        default:
            break
        }
    }
    
    func animateLargeImageShouldFinish(shouldFinish:Bool) {
        UIView.animateWithDuration(ANIMATION_IMAGE_VIEWER_DURATION, animations: {
            if shouldFinish {
                self.image_viewer_scroll_view.alpha = 0.0
            }
            else {
                self.scroll_image_view.transform = CGAffineTransformIdentity
            }
            }, completion: {
                (fin:Bool) in
                if shouldFinish{
                    self.image_viewer_scroll_view.hidden = true
                    self.scroll_image_view.transform = CGAffineTransformIdentity
                    self.large_image_presented = false
                }
        })
    }
    
    func imageTappedTwice(sender:UITapGestureRecognizer) {
        let currentScale = image_viewer_scroll_view.zoomScale
        var targetScale:CGFloat = 1.0
        if currentScale == 1.0 {
            targetScale = 1.89
        }
        image_viewer_scroll_view.setZoomScale(targetScale, animated: true)
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return image_viewer_scroll_view.zoomScale == 1.0
    }
    
    func recalculateButtonsLabels() {
        share_button.titleLabel!.font = UIFont(name: "SFUIText-Medium", size: START_BUTTONS_TEXT_SIZE)!
        save_button.titleLabel!.font = UIFont(name: "SFUIText-Medium", size: START_BUTTONS_TEXT_SIZE)!
        reply_button.titleLabel!.font = UIFont(name: "SFUIText-Medium", size: START_BUTTONS_TEXT_SIZE)!
        let share_text_max_width = share_button.bounds.width * (1.0 - BUTTON_SHARE_IMAGE_RIGHT_RELATIVE) - BUTTONS_TEXT_MARGIN_LEFT - BUTTONS_TEXT_MARGIN_RIGHT
        let reply_text_max_width = reply_button.bounds.width * (1.0 - BUTTON_REPLY_IMAGE_RIGHT_RELATIVE) - BUTTONS_TEXT_MARGIN_LEFT - BUTTONS_TEXT_MARGIN_RIGHT
        let save_text_max_width = save_button.bounds.width * (1.0 - BUTTON_SAVE_IMAGE_RIGHT_RELATIVE) - BUTTONS_TEXT_MARGIN_LEFT - BUTTONS_TEXT_MARGIN_RIGHT
        var real_share_text_width = (share_button.titleForState(.Normal) as! NSString).sizeWithAttributes([NSFontAttributeName:UIFont(name: "SFUIText-Medium", size: START_BUTTONS_TEXT_SIZE)!]).width
        var real_reply_text_width = (reply_button.titleForState(.Normal) as! NSString).sizeWithAttributes([NSFontAttributeName:UIFont(name: "SFUIText-Medium", size: START_BUTTONS_TEXT_SIZE)!]).width
        var real_save_text_width = (save_button.titleForState(.Normal) as! NSString).sizeWithAttributes([NSFontAttributeName:UIFont(name: "SFUIText-Medium", size: START_BUTTONS_TEXT_SIZE)!]).width
        if real_share_text_width > share_text_max_width {
            real_share_text_width = share_text_max_width
            share_button.titleLabel!.font = UIFont(name: "SFUIText-Medium", size: General.getFontSizeToFitWidth(real_share_text_width, forString: share_button.titleForState(.Normal)!, withFontName: "SFUIText-Medium"))!
        }
        if real_reply_text_width > reply_text_max_width {
            real_reply_text_width = reply_text_max_width
            reply_button.titleLabel!.font = UIFont(name: "SFUIText-Medium", size: General.getFontSizeToFitWidth(real_reply_text_width, forString: reply_button.titleForState(.Normal)!, withFontName: "SFUIText-Medium"))!
        }
        if real_save_text_width > save_text_max_width {
            real_save_text_width = save_text_max_width
            save_button.titleLabel!.font = UIFont(name: "SFUIText-Medium", size: General.getFontSizeToFitWidth(real_save_text_width, forString: save_button.titleForState(.Normal)!, withFontName: "SFUIText-Medium"))!
        }
        print("real share button text width = \(real_share_text_width)")
        print("share button width = \(share_button.bounds.width)")
        let share_shift = (share_button.bounds.width * BUTTON_SHARE_IMAGE_RIGHT_RELATIVE + BUTTONS_TEXT_MARGIN_LEFT - (0.5 * share_button.bounds.width - 0.5 * real_share_text_width))
        let reply_shift = (reply_button.bounds.width * BUTTON_REPLY_IMAGE_RIGHT_RELATIVE + BUTTONS_TEXT_MARGIN_LEFT - (0.5 * reply_button.bounds.width - 0.5 * real_reply_text_width))
        let save_shift = (save_button.bounds.width * BUTTON_SAVE_IMAGE_RIGHT_RELATIVE + BUTTONS_TEXT_MARGIN_LEFT - (0.5 * save_button.bounds.width - 0.5 * real_save_text_width))
        share_button.titleEdgeInsets = UIEdgeInsetsMake(0, share_shift, 0, 0)
        reply_button.titleEdgeInsets = UIEdgeInsetsMake(0,reply_shift, 0, 0)
        save_button.titleEdgeInsets = UIEdgeInsetsMake(0, save_shift, 0, 0)
        print("save shift = \(save_shift)")
    }
    
    func preloadViewsWithNavigationBarHeight(navBarHeight:CGFloat) {
        print("preloading")
        self.navBarHeight = navBarHeight
        close_map_button = UIButton(type: .Custom)
        close_map_button.layer.zPosition = 669
        close_map_button.frame = CGRect(x: view.bounds.width * (1.0 - CLOSE_MAP_ICON_WIDTH_RELATIVE) - CLOSE_MAP_ICON_MARGIN_RIGHT, y: navBarHeight + CLOSE_MAP_ICON_MARGIN_TOP, width: CLOSE_MAP_ICON_WIDTH_RELATIVE * view.bounds.width, height: CLOSE_MAP_ICON_WIDTH_RELATIVE * view.bounds.width)
        close_map_button.setBackgroundImage(UIImage(named: "close_icon_transparent")!, forState: .Normal)
        close_map_button.addTarget(self, action: "closeMapButtonPressed:", forControlEvents: .TouchUpInside)
        close_map_button.alpha = 0.0
        close_map_button.hidden = true
        post_scroll_view = UIScrollView(frame: CGRect(x: 0, y: navBarHeight + SCROLL_VIEW_MARGIN_TOP, width: view.bounds.width, height: (view.bounds.height - TOOLBAR_HEIGHT_RELATIVE * view.bounds.height - navBarHeight - SCROLL_VIEW_MARGIN_TOP - SCROLL_VIEW_MARGIN_BOTTOM)))
        image_viewer_scroll_view = UIScrollView(frame: CGRect(x: 0, y: navBarHeight, width: view.bounds.width, height: view.bounds.height * (1.0 - TOOLBAR_HEIGHT_RELATIVE) - navBarHeight))
        image_viewer_scroll_view.delegate = self
        image_viewer_scroll_view.minimumZoomScale = 1.0
        image_viewer_scroll_view.maximumZoomScale = 2.5
        image_viewer_scroll_view.backgroundColor = UIColor.whiteColor()
        scroll_image_view = UIImageView(frame: image_viewer_scroll_view.bounds)
        scroll_image_view.contentMode = .ScaleAspectFit
        scroll_image_view.userInteractionEnabled = true
        gesture_image_pan = UIPanGestureRecognizer(target: self, action: "imagePanned:")
        gesture_image_pan.delegate = self
        gesture_image_twin_tap = UITapGestureRecognizer(target: self, action: "imageTappedTwice:")
        gesture_image_twin_tap.numberOfTapsRequired = 2
        scroll_image_view.addGestureRecognizer(gesture_image_twin_tap)
        scroll_image_view.addGestureRecognizer(gesture_image_pan)
        image_viewer_scroll_view.addSubview(scroll_image_view)
        image_viewer_scroll_view.alpha = 0.0
        image_viewer_scroll_view.hidden = true
        title_label = UILabel()
        title_label.numberOfLines = 0
        title_label.font = UIFont(name: "SFUIText-Semibold", size: TITLE_FONT_SIZE)
        title_label.textColor = TITLE_TEXT_COLOR
        title_label.textAlignment = NSTextAlignment.Left
        encounter_image = UIImageView(image: UIImage(named: "encounter_card_icon")!)
        encounter_image.contentMode = .ScaleAspectFit
        encounter_label = UILabel()
        //encounter_label.text = "today, 15th June"
        encounter_label.font = UIFont(name: "SFUIText-Regular", size: ENCOUNTER_FONT_SIZE)
        encounter_label.textColor = ENCOUNTER_TEXT_COLOR
        encounter_label.textAlignment = .Left
        body_label = UILabel()
        body_label.font = UIFont(name: "SFUIText-Medium", size: BODY_FONT_SIZE)
        body_label.numberOfLines = 0
        search_image = UIImageView()
        search_image.contentMode = .ScaleAspectFit
        image_center = UIImageView()
        image_center.contentMode = .ScaleAspectFit
        image_center.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "mapImagePressed:"))
        image_center.userInteractionEnabled = true
        content_image_1 = UIImageView()
        content_image_1.userInteractionEnabled = true
        content_image_1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "imageTapped:"))
        content_image_2 = UIImageView()
        content_image_2.userInteractionEnabled = true
        content_image_2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "imageTapped:"))
        content_image_1.frame = CGRectZero
        content_image_2.frame = CGRectZero
        content_image_1.backgroundColor = CONTENT_IMAGE_PLACEHOLDER_BG
        content_image_2.backgroundColor = CONTENT_IMAGE_PLACEHOLDER_BG
        content_image_2.hidden = true
        content_image_1.hidden = true
        content_image_1.contentMode = .ScaleAspectFit
        content_image_2.contentMode = .ScaleAspectFit
        post_bg_view = UIView()
        post_bg_view.backgroundColor = UIColor.whiteColor()
        posting_date_label = UILabel()
        posting_date_label.font = UIFont(name: "SFUIText-Regular", size: POSTING_DATE_TEXT_SIZE)!
        posting_date_label.textColor = POSTING_DATE_TEXT_COLOR
        post_scroll_view.addSubview(post_bg_view)
        post_scroll_view.addSubview(posting_date_label)
        post_scroll_view.addSubview(title_label)
        post_scroll_view.addSubview(encounter_image)
        post_scroll_view.addSubview(encounter_label)
        post_scroll_view.addSubview(search_image)
        post_scroll_view.addSubview(image_center)
        post_scroll_view.addSubview(body_label)
        post_scroll_view.addSubview(content_image_1)
        post_scroll_view.addSubview(content_image_2)
        view.addSubview(post_scroll_view)
        view.addSubview(image_viewer_scroll_view)
        view.addSubview(close_map_button)
    }
    
    @IBAction func replyButtonPressed(sender:UIButton) {
        
    }
    
    @IBAction func shareButtonPressed(sender:UIButton) {
        
    }
    
    @IBAction func saveButtonPressed(sender:UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName("save_notification", object: nil, userInfo: ["cardId":this_card_id,"pressedIn":pressed_in])
        var new_title = "Save"
        var new_image_icon_name = "bookmark_button_bg_one_post_off"
        if save_button.titleForState(.Normal)! == "Save" {
            new_title = "Unsave"
            new_image_icon_name = "bookmark_button_bg_one_post_on"
        }
        save_button.setTitle(new_title, forState: .Normal)
        save_button.setBackgroundImage(UIImage(named: new_image_icon_name)!, forState: .Normal)
        recalculateButtonsLabels()
    }
    
    func menuButtonPressed(sender:UIBarButtonItem) {
        let my_posts_cards_ids = NSUserDefaults().arrayForKey("my_posts_cards_ids") as! [Int]
        let menu_vc = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        menu_vc.addAction(UIAlertAction(title: "Report an issue", style: .Default, handler: {
            (act:UIAlertAction) in
            NSNotificationCenter.defaultCenter().postNotificationName("report_notification", object: nil, userInfo: ["cardId":self.this_card_id])
            menu_vc.dismissViewControllerAnimated(true, completion: nil)
        }))
        if my_posts_cards_ids.contains(self.this_card_id) {
            menu_vc.addAction(UIAlertAction(title: "Delete my own post", style: UIAlertActionStyle.Destructive, handler: {
                (act:UIAlertAction) in
                let deletion_alert = UIAlertController(title: "Delete your post?", message: "This process is irreversible", preferredStyle: UIAlertControllerStyle.Alert)
                deletion_alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
                    (act:UIAlertAction) in
                    deletion_alert.dismissViewControllerAnimated(true, completion: nil)
                }))
                deletion_alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: {
                    (act:UIAlertAction) in
                    self.main_vc.deleteOwnPostWithCardId(self.this_card_id)
                    deletion_alert.dismissViewControllerAnimated(true, completion: nil)
                }))
                self.presentViewController(deletion_alert, animated: true, completion: nil)
            }))
        }
        menu_vc.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (act:UIAlertAction) in
            menu_vc.dismissViewControllerAnimated(true, completion: nil)
        }))
        presentViewController(menu_vc, animated: true, completion: nil)
    }
    
    func setContent(data:NSDictionary) {
        print("one post view width = \(view.bounds.width)")
        title_label.text = data["title_text"] as! String
        encounter_label.text = data["date_text"] as! String
        let body_par = NSMutableParagraphStyle()
        body_par.alignment = .Left
        body_par.lineSpacing = 1.7
        body_par.lineBreakMode = .ByTruncatingTail
        let body_text_attr = NSMutableAttributedString(string: data["description_text"] as! String)
        body_text_attr.setAttributes([NSFontAttributeName:UIFont(name: "SFUIText-Medium", size: BODY_FONT_SIZE)!,NSParagraphStyleAttributeName:body_par], range: NSMakeRange(0, body_text_attr.length))
        body_label.attributedText = body_text_attr
        var per_1 = data["person_1"] as? String
        var per_2 = data["person_2"] as? String
        if per_1! == "m" {
            per_1 = "b"
        }
        else {
            per_1 = "g"
        }
        if per_2! == "m" {
            per_2 = "b"
        }
        else {
            per_2 = "g"
        }
        search_image.image = UIImage(named: "gender_card_icon_\(per_1!)\(per_2!)")
        current_center_image_transport = data["transport_icon_present"] as! Bool
        if current_center_image_transport {
            let transport_id = data["transport_icon_type"] as! Int
            let transport_image_name = "transport_icon_full_\(transport_id)"
            image_center.image = UIImage(named: transport_image_name)!
            current_center_image_transport_size = image_center.image!.size
            image_center.backgroundColor = UIColor.clearColor()
            image_center.layer.mask = nil
        }
        else {
            image_center.backgroundColor = MAP_PLACEHOLDER_BG_COLOR
            image_center.image = UIImage(named: "map_placeholder")!
            this_coords = (data["map_coords"] as! NSValue).MKCoordinateValue
        }
        content_image_2.image = nil
        content_image_1.image = nil
        let images_sizes = data["images_sizes"] as! [NSValue]
        if data["images_present"] as! Bool {
            current_content_images_amount = data["images_count"] as! Int
            content_image_1.hidden = false
            current_content_image_1_size = images_sizes[0].CGSizeValue()
            if current_content_images_amount == 2 {
                content_image_2.hidden = false
                current_content_image_2_size = images_sizes[1].CGSizeValue()
            }
        }
        else {
            current_content_images_amount = 0
            content_image_1.hidden = true
            content_image_2.hidden = true
        }
        posting_date_label.text = datePostingTextFromDate(data["posting_date"] as! NSDate)
        let cards_bookmarks = NSUserDefaults().arrayForKey("cards_bookmarks") as! [Int]
        if cards_bookmarks.contains(this_card_id) {
            save_button.setBackgroundImage(UIImage(named: "bookmark_button_bg_one_post_on")!, forState: .Normal)
            save_button.setTitle("Unsave", forState: .Normal)
        }
        else {
            save_button.setBackgroundImage(UIImage(named: "bookmark_button_bg_one_post_off")!, forState: .Normal)
            save_button.setTitle("Save", forState: .Normal)
        }
        //now setting frames
        title_label.frame = CGRect(x: TITLE_MARGIN_LEFT, y: TITLE_MARGIN_TOP, width: view.bounds.width * TITLE_WIDTH_RELATIVE, height: 50)
        let text_rect = title_label.textRectForBounds(title_label.bounds, limitedToNumberOfLines: 0)
        title_label.frame = CGRect(x: title_label.frame.minX, y: TITLE_MARGIN_TOP, width: title_label.bounds.width, height: text_rect.height)
        let menu_width = view.bounds.width * MENU_BUTTON_WIDTH_RELATIVE
        let menu_x = (view.bounds.width - title_label.frame.maxX) * 0.5 - 0.5 * menu_width + title_label.frame.maxX
        encounter_image.frame = CGRect(x: IMAGE_ENCOUNTER_MARGIN_LEFT, y: (title_label.frame.maxY + IMAGE_ENCOUNTER_MARGIN_TOP), width: IMAGE_ENCOUNTER_WIDTH_RELATIVE * view.bounds.width, height: IMAGE_ENCOUNTER_WIDTH_RELATIVE * view.bounds.width * IMAGE_ENCOUNTER_ASPECT)
        encounter_label.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        let enc_text_rect = encounter_label.textRectForBounds(encounter_label.bounds, limitedToNumberOfLines: 1)
        encounter_label.frame = CGRect(x: encounter_image.frame.maxX + ENCOUNTER_LABEL_MARGIN_LEFT, y: (encounter_image.center.y - enc_text_rect.height * 0.5), width: enc_text_rect.width, height: enc_text_rect.height)
        search_image.frame = CGRect(x: IMAGE_SEARCH_MARGIN_LEFT_ENCOUNTER_LABEL + encounter_label.frame.maxX, y: title_label.frame.maxY + IMAGE_SEARCH_MARGIN_TOP, width: IMAGE_SEARCH_WIDTH_RELATIVE * view.bounds.width, height: IMAGE_SEARCH_WIDTH_RELATIVE * view.bounds.width * IMAGE_SEARCH_ASPECT)
        body_label.frame = CGRect(x: BODY_MARGIN_LEFT, y: BODY_MARGIN_TOP + encounter_image.frame.maxY, width: view.bounds.width - BODY_MARGIN_LEFT - BODY_MARGIN_RIGHT, height: BODY_MAX_HEIGHT)
        body_label.sizeToFit()
        print("Having view one post width \(view.bounds.width)")
        if current_center_image_transport {
            let img_aspect = current_center_image_transport_size.height / current_center_image_transport_size.width
            var real_height = body_label.bounds.height * IMAGE_CENTER_TRANSPORT_MAX_HEIGHT_RELATIVE
            var real_width = real_height / img_aspect
            if real_width > body_label.bounds.width * IMAGE_CENTER_TRANSPORT_MAX_WIDTH_RELATIVE {
                real_width = body_label.bounds.width * IMAGE_CENTER_TRANSPORT_MAX_WIDTH_RELATIVE
                real_height = real_width * img_aspect
            }
            image_center.frame = CGRect(x: body_label.center.x - 0.5 * real_width, y: body_label.frame.minY + (body_label.bounds.height - real_height) * 0.5, width: real_width, height: real_height)
            image_center.alpha = IMAGE_CENTER_TRANSPORT_OPACITY
        }
        else {
            image_center.alpha = 1.0
            image_center.frame = CGRect(x: 0, y: body_label.frame.maxY + IMAGE_CENTER_MAP_TOP_MARGIN, width: view.bounds.width, height: IMAGE_CENTER_MAP_HEIGHT)
        }
        if current_content_images_amount != 0 {
            content_image_1.hidden = false
            let content_images_top_y = max(image_center.frame.maxY,body_label.frame.maxY) + CONTENT_IMAGES_MARGIN_TOP
            if current_content_images_amount == 1 {
                let max_width = view.bounds.width - CONTENT_IMAGES_MARGIN_LEFT - CONTENT_IMAGES_MARGIN_RIGHT
                var real_height = CONTENT_IMAGES_MAX_HEIGHT
                let img_aspect = current_content_image_1_size.height / current_content_image_1_size.width
                var real_width = real_height / img_aspect
                if real_width > max_width {
                    real_width = max_width
                    real_height = real_width * img_aspect
                }
                let img_margin = (max_width - real_width) * 0.5
                content_image_1.frame = CGRect(x: CONTENT_IMAGES_MARGIN_LEFT + img_margin, y: content_images_top_y, width: real_width, height: real_height)
            }
            else {
                content_image_2.hidden = false
                let img_1_aspect = current_content_image_1_size.height / current_content_image_1_size.width
                let img_2_aspect = current_content_image_2_size.height / current_content_image_2_size.width
                let max_width = view.bounds.width - CONTENT_IMAGES_MARGIN_LEFT - CONTENT_IMAGES_MARGIN_RIGHT - CONTENT_IMAGES_MIN_SPACING
                var real_height = max_width * img_1_aspect * img_2_aspect / (img_1_aspect + img_2_aspect)
                if real_height > CONTENT_IMAGES_MAX_HEIGHT {
                    real_height = CONTENT_IMAGES_MAX_HEIGHT
                }
                let img_1_real_width = real_height / img_1_aspect
                let img_2_real_width = real_height / img_2_aspect
                var sp_1:CGFloat = 0
                var sp_2:CGFloat = 0
                var sp_3:CGFloat = 0
                let equal_sp = (view.bounds.width - CONTENT_IMAGES_MARGIN_LEFT - CONTENT_IMAGES_MARGIN_RIGHT - img_1_real_width - img_2_real_width) / 3.0
                if equal_sp < CONTENT_IMAGES_MIN_SPACING {
                    sp_2 = CONTENT_IMAGES_MIN_SPACING
                    sp_1 = (max_width - img_1_real_width - img_2_real_width) / 2.0
                    sp_3 = sp_1
                }
                else {
                    sp_1 = equal_sp
                    sp_2 = sp_1
                    sp_3 = sp_1
                }
                content_image_1.frame = CGRect(x: CONTENT_IMAGES_MARGIN_LEFT + sp_1, y: content_images_top_y, width: img_1_real_width, height: real_height)
                content_image_2.frame = CGRect(x: CONTENT_IMAGES_MARGIN_LEFT + sp_1 + img_1_real_width + sp_2, y: content_images_top_y, width: img_2_real_width, height: real_height)
            }
        }
        let posting_date_top_y = (current_content_images_amount != 0 ? content_image_1.frame.maxY : max(image_center.frame.maxY,body_label.frame.maxY)) + POSTING_DATE_MARGIN_TOP
        posting_date_label.frame = CGRect(x: POSTING_DATE_MARGIN_LEFT, y: posting_date_top_y, width: 200, height: 30)
        let real_date_text_size = posting_date_label.textRectForBounds(posting_date_label.bounds, limitedToNumberOfLines: 1)
        posting_date_label.frame = CGRect(x: POSTING_DATE_MARGIN_LEFT, y: posting_date_top_y, width: real_date_text_size.width, height: real_date_text_size.height)
        post_bg_view.frame = CGRect(x: 0, y: 1, width: view.bounds.width, height: posting_date_label.frame.maxY + BG_VIEW_BOTTOM_MARGIN)
        post_scroll_view.contentSize = CGSizeMake(view.bounds.width, post_bg_view.bounds.height)
        if !current_center_image_transport {
            let mask_gradient_layer = CAGradientLayer()
            mask_gradient_layer.frame = image_center.bounds
            mask_gradient_layer.colors = [UIColor(white: 0.0, alpha: 0.0).CGColor,UIColor(white: 0.0, alpha: 1.0).CGColor]
            mask_gradient_layer.startPoint = CGPointMake(0.5, 0.0)
            mask_gradient_layer.endPoint = CGPointMake(0.5, 2.6 * abs(IMAGE_CENTER_MAP_TOP_MARGIN) / IMAGE_CENTER_MAP_HEIGHT)
            image_center.layer.mask = mask_gradient_layer
        }
        recalculateButtonsLabels()
        if current_content_images_amount == 1 {
            img_1_viewer_size = getRealImageSizeForImageViewerWithImage(1)
        }
        if current_content_images_amount == 2 {
            img_1_viewer_size = getRealImageSizeForImageViewerWithImage(1)
            img_2_viewer_size = getRealImageSizeForImageViewerWithImage(2)
        }
    }
    
    func datePostingTextFromDate(date:NSDate) -> String {
        let date_comp = NSCalendar.currentCalendar().components([NSCalendarUnit.Day,NSCalendarUnit.Month,NSCalendarUnit.Year], fromDate: date)
        return "Posted on \(date_comp.day).\(date_comp.month).\(date_comp.year)"
    }
    
    func setImages(images:[UIImage]) {
        current_content_images = images
        for (var i = 0;i < current_content_images_amount;i++) {
            UIView.transitionWithView((i == 0 ? content_image_1 : content_image_2), duration: ANIMATION_CONTENT_IMAGES_DURATION, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                (i == 0 ? self.content_image_1 : self.content_image_2).image = images[i]
                }, completion: nil)
        }
    }
    
    func setCardIdWithId(c_id:Int) {
        this_card_id = c_id
    }
    
    func imageTapped(sender:UITapGestureRecognizer) {
        var img_present_id = 1
        if current_content_images_amount == 2 {
            if content_image_2.bounds.contains(sender.locationInView(content_image_2)) {
                img_present_id = 2
            }
        }
        presentImageViewerForImage(img_present_id)
        current_zooming_image = img_present_id
    }
    
    func getRealImageSizeForImageViewerWithImage(no:Int) -> CGSize {
        let zone_size = CGSizeMake(view.bounds.width, (view.bounds.height * (1.0 - TOOLBAR_HEIGHT_RELATIVE) - navBarHeight))
        let image_real_size = no == 1 ? current_content_image_1_size : current_content_image_2_size
        let width_ratio = image_real_size.width / view.bounds.width
        let height_ratio = image_real_size.height / zone_size.height
        let compress_ratio = max(width_ratio,height_ratio)
        let image_final_size = CGSizeMake(image_real_size.width / compress_ratio, image_real_size.height / compress_ratio)
        return image_final_size
    }
    
    func presentImageViewerForImage(no:Int) {
        scroll_image_view.image = no == 1 ? content_image_1.image! : content_image_2.image!
        image_viewer_scroll_view.hidden = false
        UIView.animateWithDuration(ANIMATION_IMAGE_VIEWER_DURATION, animations: {
            self.image_viewer_scroll_view.alpha = 1.0
        })
        large_image_presented = true
    }
    
    func setMapImageWithImage(image:UIImage) {
        UIView.transitionWithView(image_center, duration: ANIMATION_MAP_APPEARS_DURATION, options: .TransitionCrossDissolve, animations: {
            self.image_center.image = image
            }, completion: nil)
    }
    
    func hideMapImage() {
        image_center.image = UIImage(named: "map_placeholder")!
    }
    
    func mapImagePressed(sender:UITapGestureRecognizer) {
        if !current_center_image_transport {
            let new_map_view_frame_size = CGSizeMake(self.view.bounds.width, self.view.bounds.height * (1.0 - self.TOOLBAR_HEIGHT_RELATIVE) - self.navBarHeight)
            if General.map.isDescendantOfView(self.view) {
                General.map.hidden = false
                close_map_button.hidden = false
            }
            else {
                main_map_vc.removeMap()
                if General.map == nil {
                    General.map = MKMapView()
                }
                close_map_button.hidden = false
                let location_annotation = MKPointAnnotation()
                location_annotation.coordinate = this_coords
                let location_map_point = MKMapPointForCoordinate(this_coords)
                let map_width = MAP_SNAPSHOT_METERS_PER_WIDTH_FULL * MKMetersPerMapPointAtLatitude(this_coords.latitude) * 2.0
                let map_height = map_width * Double(new_map_view_frame_size.height / new_map_view_frame_size.width)
                General.map.alpha = 0.0
                General.map.layer.zPosition = 600
                General.map.userInteractionEnabled = true
                General.map.delegate = self
                General.map.frame = image_center.convertRect(image_center.bounds, toView: self.view)
                view.addSubview(General.map)
                //view.bringSubviewToFront(General.map)
                view.bringSubviewToFront(close_map_button)
                General.map.addAnnotation(location_annotation)
                General.map.visibleMapRect = MKMapRect(origin: MKMapPointMake(location_map_point.x - 0.5 * map_width, location_map_point.y - 0.5 * map_height), size: MKMapSizeMake(map_width, map_height))
            }
            UIView.animateWithDuration(ANIMATION_MAP_EXPANDS_DURATION, animations: {
                General.map.frame = CGRect(x: 0, y: self.navBarHeight, width: new_map_view_frame_size.width, height: new_map_view_frame_size.height)
                General.map.alpha = 1.0
                self.close_map_button.alpha = 1.0
                }, completion: nil)
        }
    }
    
    func closeMapButtonPressed(sender:UIButton) {
        UIView.animateWithDuration(ANIMATION_MAP_EXPANDS_DURATION, animations: {
            General.map.frame = self.image_center.convertRect(self.image_center.bounds, toView: self.view)
            General.map.alpha = 0.0
            self.close_map_button.alpha = 0.0
            }, completion: {
                (fin:Bool) in
                General.map.hidden = true
                self.close_map_button.hidden = true
        })
    }
    
    func removeMap() {
        General.map.removeFromSuperview()
        General.map.removeAnnotations(General.map.annotations)
        General.map.alpha = 1.0
        General.map.hidden = false
        General.map.delegate = nil
        close_map_button.alpha = 0.0
        close_map_button.hidden = true
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var annotation_view = mapView.dequeueReusableAnnotationViewWithIdentifier("map_point_view_pin") as? MapPinView
        if annotation_view == nil {
            annotation_view = MapPinView(annotation: annotation, reuseIdentifier: "map_point_view_pin")
            let map_point_width = view.bounds.width * MAP_POINT_WIDTH_RELATIVE
            annotation_view!.setFrameWith(CGRect(x: 0, y: 0, width: map_point_width, height: map_point_width * MAP_POINT_ASPECT))
        }
        return annotation_view
    }

}