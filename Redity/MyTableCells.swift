//
//  MyTableCells.swift
//  Redity
//
//  Created by Vano on 22.06.16.
//  Copyright © 2016 Vanoproduction. All rights reserved.
//

import UIKit
import MapKit

class TransportCell:UICollectionViewCell {
    
    let TRANSPORT_CELL_PADDING:CGFloat = 8
    
    var trans_img:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        trans_img = UIImageView(frame: CGRect(x: TRANSPORT_CELL_PADDING, y: TRANSPORT_CELL_PADDING, width: frame.width - 2.0 * TRANSPORT_CELL_PADDING, height: frame.height - 2.0 * TRANSPORT_CELL_PADDING))
        trans_img.contentMode = .ScaleAspectFit
        trans_img.backgroundColor = UIColor.clearColor()
        contentView.addSubview(trans_img)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(img:UIImage) {
        trans_img.image = img
    }
    
}

//class for map pin (we need separate class due to image sizing problems)

class MapPinView: MKAnnotationView {
    
    let CALLOUT_TITLE_TEXT_SIZE:CGFloat = 15
    let CALLOUT_TITLE_TEXT_COLOR:UIColor = UIColor(red: 57/255, green: 24/255, blue: 152/255, alpha: 1.0)
    let CALLOUT_TITLE_MARGIN_SIDES:CGFloat = 10 // from left and right
    let CALLOUT_TIME_TEXT_SIZE:CGFloat = 9
    let CALLOUT_TIME_TEXT_COLOR:UIColor = UIColor(red: 216/255, green: 213/255, blue: 242/255, alpha: 1.0)
    let CALLOUT_TIME_BG_COLOR:UIColor = UIColor(red: 96/255, green: 90/255, blue: 210/255, alpha: 1.0)
    let CALLOUT_MAX_WIDTH_RELATIVE:CGFloat = 0.65 // to screen width
    let CALLOUT_MIN_WIDTH_RELATIVE:CGFloat = 0.4 // same applies here
    let CALLOUT_TIME_WIDTH:CGFloat = 50 //absolute value
    let CALLOUT_HEIGHT_BUBBLE:CGFloat = 38 //abs
    let CALLOUT_TAIL_HEIGHT:CGFloat = 18
    let CALLOUT_TAIL_ASPECT:CGFloat = 0.455
    let CALLOUT_MARGIN_TOP:CGFloat = 5
    let CALLOUT_MARGIN_BOTTOM:CGFloat = 5
    let CALLOUT_MARGIN_SIDES:CGFloat = 6
    let CALLOUT_TIME_LABEL_WIDTH_RELATIVE:CGFloat = 0.6 // to callout's time zone width
    let CALLOUT_BUBBLE_PRESSED_COLOR:UIColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
    
    let ANIMATION_CALLOUT_DURATION:CFTimeInterval = 0.6

    var calloutTotalView:UIView!
    var calloutTailView:UIImageView!
    var calloutPressed:((cardId:Int) -> ())!
    var cardId:Int = -1
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.image = UIImage(named: "map_point_set")!
        self.opaque = false
    }
    
    func setFrameWith(newFrame:CGRect) {
        self.frame = newFrame
    }
    
    func setupCalloutViewWithTimeComponents(timeComponents:(periodValue:Int,periodName:String),title:String,parentViewBounds:CGRect, cardId:Int) {
        self.cardId = cardId
        let max_label_width = parentViewBounds.width * CALLOUT_MAX_WIDTH_RELATIVE - CALLOUT_TIME_WIDTH - 2.0 * CALLOUT_TITLE_MARGIN_SIDES
        let title_label = UILabel(frame: CGRect(x: 0, y: 0, width: max_label_width, height: CALLOUT_HEIGHT_BUBBLE))
        title_label.text = title
        title_label.font = UIFont(name: "SFUIText-Medium", size: CALLOUT_TITLE_TEXT_SIZE)!
        title_label.textColor = CALLOUT_TITLE_TEXT_COLOR
        title_label.textAlignment = .Left
        let real_title_size = title_label.textRectForBounds(title_label.bounds, limitedToNumberOfLines: 1)
        let tail_width = CALLOUT_TAIL_HEIGHT / CALLOUT_TAIL_ASPECT
        calloutTailView = UIImageView(frame: CGRect(x: 0, y: 0, width: tail_width, height: CALLOUT_TAIL_HEIGHT))
        calloutTailView.image = UIImage(named: "map_callout_tail")!
        calloutTailView.contentMode = .ScaleAspectFit
        calloutTailView.center.y += 2
        let callout_width = CALLOUT_TIME_WIDTH + CALLOUT_TITLE_MARGIN_SIDES * 2.0 + real_title_size.width
        title_label.frame = CGRect(x: CALLOUT_TIME_WIDTH + CALLOUT_TITLE_MARGIN_SIDES, y: 0, width: real_title_size.width, height: CALLOUT_HEIGHT_BUBBLE)
        let callout_bubble_view = UIView(frame: CGRect(x: 0, y: CALLOUT_TAIL_HEIGHT, width: callout_width, height: CALLOUT_HEIGHT_BUBBLE))
        callout_bubble_view.tag = 69
        callout_bubble_view.backgroundColor = UIColor.whiteColor()
        callout_bubble_view.layer.cornerRadius = 10
        callout_bubble_view.layer.masksToBounds = true
        let all_callout_height = CALLOUT_TAIL_HEIGHT + CALLOUT_HEIGHT_BUBBLE
        let callout_whole_view = UIView(frame: CGRect(x: 0, y: self.frame.height, width: callout_width, height: all_callout_height))
        callout_whole_view.addSubview(calloutTailView)
        callout_bubble_view.addSubview(title_label)
        let time_bg_view = UIView(frame: CGRect(x: 0, y: 0, width: CALLOUT_TIME_WIDTH, height: CALLOUT_HEIGHT_BUBBLE))
        time_bg_view.backgroundColor = CALLOUT_TIME_BG_COLOR
        callout_bubble_view.addSubview(time_bg_view)
        let time_label_font_size = General.getFontSizeToFitWidth(CALLOUT_TIME_WIDTH * CALLOUT_TIME_LABEL_WIDTH_RELATIVE, forString: timeComponents.periodName, withFontName: "SFUIText-Bold")
        //let time_label_font_size:CGFloat = 9
        let time_label = UILabel(frame: CGRect(x: 0, y: 0, width: CALLOUT_TIME_WIDTH, height: CALLOUT_HEIGHT_BUBBLE))
        time_label.numberOfLines = 2
        time_label.font = UIFont(name: "SFUIText-Bold", size: 11)! //time_label_font_size
        time_label.textColor = CALLOUT_TIME_TEXT_COLOR
        time_label.textAlignment = .Center
        time_label.text = "\(timeComponents.periodValue)\n\(timeComponents.periodName)"
        callout_bubble_view.addSubview(time_label)
        callout_whole_view.addSubview(callout_bubble_view)
        callout_whole_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "calloutTapped:"))
        callout_whole_view.userInteractionEnabled = true
        self.calloutTotalView = callout_whole_view
    }
    
    func setCalloutPositions(pos:(calloutWholeCenterX:CGFloat,calloutTailCenterX:CGFloat)) {
        calloutTotalView.center.x = pos.calloutWholeCenterX
        calloutTailView.center.x = pos.calloutTailCenterX
    }
    
    func setCalloutPressedHandlerWith(handler:(cardId:Int) -> ()) {
        calloutPressed = handler
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if cardId == -1 {
            return
        }
        if selected {
            for sub in calloutTotalView.subviews {
                if sub.tag == 69 {
                    sub.backgroundColor = UIColor.whiteColor()
                }
            }
            addSubview(calloutTotalView)
            if animated {
                let bounce_anim = CAKeyframeAnimation(keyPath: "transform.scale")
                bounce_anim.values = [0.05,1.1,0.9,1.0]
                bounce_anim.duration = ANIMATION_CALLOUT_DURATION
                var timing_funcs:[CAMediaTimingFunction] = []
                for _ in 1...3 {
                    timing_funcs.append(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
                }
                bounce_anim.timingFunctions = timing_funcs
                calloutTotalView.layer.addAnimation(bounce_anim, forKey: "bounce")
            }
        }
        else {
            if animated {
                UIView.animateWithDuration(ANIMATION_CALLOUT_DURATION, animations: {
                    self.calloutTotalView.alpha = 0.0
                    }, completion: {
                        (fin:Bool) in
                        self.calloutTotalView.removeFromSuperview()
                        self.calloutTotalView.alpha = 1.0
                })
            }
            else {
                calloutTotalView.removeFromSuperview()
            }
        }
    }
    
    func calloutTapped(sender:UITapGestureRecognizer) {
        for sub in calloutTotalView.subviews {
            if sub.tag == 69 {
                sub.backgroundColor = CALLOUT_BUBBLE_PRESSED_COLOR
            }
        }
        calloutPressed(cardId:self.cardId)
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        var hitView = super.hitTest(point, withEvent: event)
        if cardId == -1 {
            return hitView
        }
        if hitView == nil && self.selected {
            let callout_point = self.convertPoint(point, toView: calloutTotalView)
            hitView = calloutTotalView.hitTest(callout_point, withEvent: event)
        }
        return hitView
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MapPinAnnotation:NSObject, MKAnnotation {
    
    var coordinate:CLLocationCoordinate2D
    var title:String?
    var subtitle:String?
    var cardId:Int = -1
    
    init(coords:CLLocationCoordinate2D) {
        self.coordinate = coords
    }
    
    init(coords:CLLocationCoordinate2D, cardId:Int) {
        self.coordinate = coords
        self.cardId = cardId
    }
    
}

class MapClusterAnnotation:NSObject, MKAnnotation {
    
    var coordinate:CLLocationCoordinate2D
    var title:String?
    var subtitle:String?
    var fraction:CGFloat = 0
    var count:Int = 0
    
    init(coords:CLLocationCoordinate2D, fraction: CGFloat, count:Int) {
        self.fraction = fraction
        self.coordinate = coords
        self.count = count
    }
    
    func getFraction() -> CGFloat {
        return fraction
    }
}


class MapClusterView:MKAnnotationView {
    
    let CLUSTER_BG_COLOR:UIColor = UIColor(red: 108/255, green: 7/255, blue: 87/255, alpha: 1.0)
    let CLUSTER_TEXT_COLOR:UIColor = UIColor(red: 216/255, green: 213/255, blue: 242/255, alpha: 1.0)
    let CLUSTER_TEXT_MAX_WIDTH_RELATIVE:CGFloat = 0.35
    let CLUSTER_BORDER_WIDTH_RELATIVE:CGFloat = 0.088
    
    var count_label:UILabel!
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.opaque = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCountLabelWithCount(count:Int) {
        for subview in subviews {
            subview.removeFromSuperview()
        }
        let desired_font_size = General.getFontSizeToFitWidth(CLUSTER_TEXT_MAX_WIDTH_RELATIVE * self.bounds.width, forString: "\(count)", withFontName: "SFUIText-Semibold")
        count_label = UILabel(frame: self.bounds)
        count_label.font = UIFont(name: "SFUIText-Semibold", size: desired_font_size)!
        count_label.textAlignment = .Center
        count_label.textColor = CLUSTER_TEXT_COLOR
        count_label.text = "\(count)"
        self.addSubview(count_label)
    }
    
    func setFrameWith(frame_set:CGRect) {
        self.frame = frame_set
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, CLUSTER_BG_COLOR.CGColor)
        CGContextFillEllipseInRect(context, self.bounds)
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
        let stroke_width = CLUSTER_BORDER_WIDTH_RELATIVE * self.bounds.width
        CGContextSetLineWidth(context, stroke_width)
        CGContextStrokeEllipseInRect(context, CGRectInset(self.bounds, stroke_width * 0.5, stroke_width * 0.5))
    }
}

//class fro search results in places screen
class SearchAreaCell:UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//cell for displaying at areas screen
class AreaCell:UITableViewCell {
    
    let EXPAND_ICON_MARGIN_LEFT:CGFloat = 15 //not considering indentation
    let EXPAND_ICON_ON_HEIGHT_RELATIVE:CGFloat = 0.18
    let EXPAND_ICON_OFF_HEIGHT_RELATIVE:CGFloat = 0.266
    let EXPAND_ICON_ON_ASPECT:CGFloat = 0.625
    let EXPAND_ICON_OFF_ASPECT:CGFloat = 1.6
    let LOCATION_TITLE_MARGIN_LEFT:CGFloat = 13 // from expand icon
    let LOCATION_TITLE_MARGIN_RIGHT:CGFloat = 15 // title should not overlap radio button or get too close to it
    let RADIO_BUTTON_REGION_WIDTH:CGFloat = 65 //this area can be pressed
    let RADIO_BUTTON_IMAGE_MARGIN_RIGHT:CGFloat = 17
    let RADIO_BUTTON_HEIGHT_RELATIVE:CGFloat = 0.48
    let LOCATION_TEXT_SIZE_NORMAL:CGFloat = 16
    let CELL_TEXT_COLOR_NORMAL:UIColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1.0)
    let TITLE_TEXT_SIZE_NORMAL:CGFloat = 16
    let INDENT_WIDTH:CGFloat = 20 //how much is one indentation?
    
    
    var expand_icon:UIImageView!
    var title_label:UILabel!
    var radio_button:UIButton!
    var cellDataIndex:Int = -1
    var radioHandler:((cellIndex:Int) -> Void)!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        expand_icon = UIImageView()
        expand_icon.contentMode = .ScaleAspectFit
        title_label = UILabel()
        title_label.textColor = CELL_TEXT_COLOR_NORMAL
        title_label.textAlignment = .Left
        title_label.font = UIFont(name: "SFUIText-Medium", size: TITLE_TEXT_SIZE_NORMAL)!
        radio_button = UIButton(type: .Custom)
        radio_button.setImage(UIImage(named: "radiobutton_icon_off")!, forState: .Normal)
        radio_button.addTarget(self, action: "radioButtonPressed:", forControlEvents: .TouchUpInside)
        contentView.addSubview(title_label)
        contentView.addSubview(radio_button)
        contentView.addSubview(expand_icon)
    }
    
    func setRadioHandlerWithHandler(handler:((cellIndex:Int) -> Void)) {
        radioHandler = handler
    }
    
    func setAreaCellIndexWithIndex(index:Int) {
        cellDataIndex = index
    }
    
    func setContentWithData(data:NSDictionary, cellSize:CGSize) {
        var expand_icon_image_name = "expand_icon_off"
        if data["expanded"] as! Bool {
            expand_icon_image_name = "expand_icon_on"
        }
        let total_indent = CGFloat(data["indentLevel"] as! Int) * INDENT_WIDTH
        var radio_button_image_name = "radiobutton_icon_off"
        if data["selected"] as! Bool {
            radio_button_image_name = "radiobutton_icon_on"
        }
        if let semiselected = data["semiSelected"] as? Bool {
            if semiselected {
                radio_button_image_name = "radiobutton_icon_semi"
            }
        }
        if data["expansion_available"] as! Bool {
            expand_icon.image = UIImage(named: expand_icon_image_name)!
            expand_icon.hidden = false
        }
        else {
            expand_icon.hidden = true
        }
        expand_icon.transform = CGAffineTransformIdentity
        title_label.frame = CGRect(x: 0, y: 0, width: cellSize.width, height: cellSize.height)
        title_label.text = data["title"] as! String
        let real_title_size = title_label.textRectForBounds(title_label.bounds, limitedToNumberOfLines: 1)
        radio_button.setImage(UIImage(named: radio_button_image_name)!, forState: .Normal)
        //now setting frames
        let expand_icon_height = cellSize.height * (data["expanded"] as! Bool ? EXPAND_ICON_ON_HEIGHT_RELATIVE : EXPAND_ICON_OFF_HEIGHT_RELATIVE)
        let expand_icon_width = expand_icon_height / (data["expanded"] as! Bool ? EXPAND_ICON_ON_ASPECT : EXPAND_ICON_OFF_ASPECT)
        expand_icon.frame = CGRect(x: EXPAND_ICON_MARGIN_LEFT + total_indent, y: (cellSize.height - expand_icon_height) * 0.5, width: expand_icon_width, height: expand_icon_height)
        radio_button.frame = CGRect(x: cellSize.width - RADIO_BUTTON_REGION_WIDTH, y: 0, width: RADIO_BUTTON_REGION_WIDTH, height: cellSize.height)
        let top_edge_img = (1.0 - RADIO_BUTTON_HEIGHT_RELATIVE) * cellSize.height * 0.5
        radio_button.imageEdgeInsets = UIEdgeInsetsMake(top_edge_img, radio_button.bounds.width - cellSize.height * RADIO_BUTTON_HEIGHT_RELATIVE - RADIO_BUTTON_IMAGE_MARGIN_RIGHT, top_edge_img, RADIO_BUTTON_IMAGE_MARGIN_RIGHT)
        title_label.frame = CGRect(x: expand_icon.frame.maxX + LOCATION_TITLE_MARGIN_LEFT, y: (cellSize.height - real_title_size.height) * 0.5, width: cellSize.width - LOCATION_TITLE_MARGIN_LEFT - LOCATION_TITLE_MARGIN_RIGHT - expand_icon.frame.maxX, height: real_title_size.height)
        
    }
    
    func radioButtonPressed(sender:UIButton) {
        radioHandler(cellIndex:cellDataIndex)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//feed cell with no images
class FeedCellPlain:UITableViewCell {
    
    let TITLE_FONT_SIZE:CGFloat = 15
    let ENCOUNTER_FONT_SIZE:CGFloat = 14
    let BODY_FONT_SIZE:CGFloat = 14
    let BUTTON_BOTTOM_FONT_SIZE:CGFloat = 17
    
    let TITLE_MARGIN_TOP:CGFloat = 5
    let TITLE_MARGIN_LEFT:CGFloat = 14
    let TITLE_WIDTH_RELATIVE:CGFloat = 0.77 // relative to cell's width
    let TITLE_TEXT_COLOR:UIColor = UIColor(red: 50/255, green: 9/255, blue: 134/255, alpha: 1.0)
    let ENCOUNTER_TEXT_COLOR:UIColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1.0)
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
    let BODY_WIDTH_RELATIVE:CGFloat = 0.739
    let IMAGE_RIGHT_TRANSPORT_MAX_WIDTH_RELATIVE:CGFloat = 0.16 // 0.1538
    let IMAGE_RIGHT_TRANSPORT_MARGIN_TOP_SEARCH:CGFloat = 2 //from gender search icon
    let IMAGE_RIGHT_TRANSPORT_HEIGHT:CGFloat = 85
    let IMAGE_RIGHT_MAP_WIDTH_RELATIVE:CGFloat = 0.3
    let IMAGE_RIGHT_MAP_MARGIN_TOP_SEARCH:CGFloat = 0 //from gender search icon
    let IMAGE_RIGHT_MAP_MIN_HEIGHT:CGFloat = 90
    let IMAGE_RIGHT_MAP_MARGIN_BOTTOM:CGFloat = 6 // when putting map, it should be a bit shifted to the bottom - from body label lowest position(maxY)
    let BUTTON_REPLY_WIDTH:CGFloat = 100
    var BUTTONS_BOTTOM_HEIGHT:CGFloat = 0
    var BUTTON_SHARE_WIDTH:CGFloat = 0 //to be calculated...
    let BUTTONS_BOTTOM_MARGIN_TOP:CGFloat = 5
    let BUTTON_REPLY_ICON_HEIGHT_RELATIVE:CGFloat = 0.35 //relative to button's height
    let BUTTON_REPLY_ICON_MARGIN_LEFT_RELATIVE:CGFloat = 0.154 // to button's width
    let BUTTON_REPLY_TEXT_MARGIN_LEFT_RELATIVE:CGFloat = 0.117 //from image
    let BUTTON_REPLY_MARGIN_LEFT:CGFloat = 12
    let BUTTON_SHARE_MARGIN_RIGHT:CGFloat = 12
    let BOOKMARK_ICON_MARGIN_LEFT:CGFloat = 2 //from the left of the screen
    let BOOKMARK_ICON_MARGIN_RIGHT:CGFloat = 2 // from the start of the title
    let BOOKMARK_ICON_ASPECT:CGFloat = 1.162
    let MAP_SNAPSHOT_ANIMATION_DELAY:CFTimeInterval = 0.23
    let MAP_SNAPSHOT_ANIMATION_DURATION:CFTimeInterval = 0.31

    
    var title_label:UILabel!
    var menu_button:UIButton!
    var encounter_image:UIImageView!
    var encounter_label:UILabel!
    var search_image:UIImageView!
    var image_right:UIImageView!
    var body_label:UILabel!
    var button_reply:UIButton!
    var button_share:UIButton!
    var bookmark_icon:UIImageView!
    
    var current_right_image_transport_size:CGSize!
    var current_right_image_transport = false
    var this_card_id:Int = -1
    var menuPressHandler:((cardId:Int)->Void)!
    var replyPressHandler:((cardId:Int)->Void)!
    var sharePressHandler:((cardId:Int)->Void)!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        title_label = UILabel()
        title_label.userInteractionEnabled = true
        //title_label.text = "Some text with a very very liong type, so we need to check how it's all gonna work"
        title_label.font = UIFont(name: "SFUIText-Semibold", size: TITLE_FONT_SIZE)
        title_label.textColor = TITLE_TEXT_COLOR
        title_label.textAlignment = NSTextAlignment.Left
        menu_button = UIButton(type: .Custom)
        menu_button.imageView!.contentMode = .ScaleAspectFit
        menu_button.addTarget(self, action: "menuPressed:", forControlEvents: .TouchUpInside)
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
        image_right = UIImageView()
        image_right.contentMode = .ScaleAspectFit
        button_reply = UIButton(type: .Custom)
        button_reply.addTarget(self, action: "replyButtonPressed:", forControlEvents: .TouchUpInside)
        let reply_button_bg_image = UIImage(named: "reply_button_bg")!
        button_reply.setBackgroundImage(reply_button_bg_image, forState: .Normal)
        BUTTONS_BOTTOM_HEIGHT = BUTTON_REPLY_WIDTH * (reply_button_bg_image.size.height / reply_button_bg_image.size.width)
        button_reply.setTitle("Reply", forState: .Normal)
        button_reply.titleLabel!.font = UIFont(name: "SFUIText-Semibold", size: BUTTON_BOTTOM_FONT_SIZE)!
        button_reply.setTitleColor(BUTTON_TEXT_COLOR, forState: .Normal)
        button_reply.setTitleColor(BUTTON_TEXT_COLOR_SELECTED, forState: .Highlighted)
        //button_reply.layer.borderWidth = 1.0
        let reply_text_size = ("Reply" as! NSString).sizeWithAttributes([NSFontAttributeName:UIFont(name: "SFUIText-Semibold", size: BUTTON_BOTTOM_FONT_SIZE)!])
        let now_reply_text_start = BUTTON_REPLY_WIDTH * 0.5 - reply_text_size.width * 0.5
        let reply_text_shift = (0.3 * BUTTON_REPLY_WIDTH - now_reply_text_start) * 2.0
        button_reply.titleEdgeInsets = UIEdgeInsetsMake(0, reply_text_shift, 0, 0)
        button_share = UIButton(type: .Custom)
        button_share.addTarget(self, action: "shareButtonPressed:", forControlEvents: .TouchUpInside)
        //button_share.layer.borderWidth = 1.0
        let share_image_bg = UIImage(named: "share_button_bg")!
        button_share.setBackgroundImage(share_image_bg, forState: .Normal)
        BUTTON_SHARE_WIDTH = BUTTONS_BOTTOM_HEIGHT / (share_image_bg.size.height / share_image_bg.size.width)
        button_share.setTitle("Share", forState: .Normal)
        button_share.setTitleColor(BUTTON_TEXT_COLOR, forState: .Normal)
        button_share.setTitleColor(BUTTON_TEXT_COLOR_SELECTED, forState: .Highlighted)
        button_share.titleLabel!.font = UIFont(name: "SFUIText-Semibold", size: BUTTON_BOTTOM_FONT_SIZE)
        let share_text_size = ("Share" as! NSString).sizeWithAttributes([NSFontAttributeName:UIFont(name: "SFUIText-Semibold", size: BUTTON_BOTTOM_FONT_SIZE)!])
        let now_share_text_end = BUTTON_SHARE_WIDTH * 0.5 + share_text_size.width * 0.5
        let share_text_edge_shift = (now_share_text_end - 0.626 * BUTTON_SHARE_WIDTH) * 1.0
        button_share.titleEdgeInsets = UIEdgeInsetsMake(0, -share_text_edge_shift, 0, 0)
        bookmark_icon = UIImageView()
        bookmark_icon.contentMode = .ScaleAspectFit
        contentView.addSubview(menu_button)
        contentView.addSubview(title_label)
        contentView.addSubview(encounter_image)
        contentView.addSubview(encounter_label)
        contentView.addSubview(search_image)
        contentView.addSubview(image_right)
        contentView.addSubview(body_label)
        contentView.addSubview(button_reply)
        contentView.addSubview(button_share)
        contentView.addSubview(bookmark_icon)
    }
    
    func setContent(data:NSDictionary) {
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
        current_right_image_transport = data["transport_icon_present"] as! Bool
        if current_right_image_transport {
            let transport_id = data["transport_icon_type"] as! Int
            let transport_image_name = "transport_icon_\(transport_id)"
            image_right.image = UIImage(named: transport_image_name)!
            current_right_image_transport_size = image_right.image!.size
        }
        else {
            image_right.image = General.map_placeholder_gradient
            //image_right.image = General.getGradientMapImageForSize(image_right.frame.size, originalImage: UIImage(named: "map_placeholder")!, isPlaceholder: true, withStyle: "feed")
        }
        let cards_bookmarks = NSUserDefaults().arrayForKey("cards_bookmarks") as! [Int]
        if cards_bookmarks.contains(this_card_id) {
            bookmark_icon.image = UIImage(named: "bookmark_card_icon_on")!
        }
        else {
            bookmark_icon.image = UIImage(named: "bookmark_card_icon_off")!
        }
        let my_cards_ids = NSUserDefaults().arrayForKey("my_posts_cards_ids") as! [Int]
        var menu_image_name = "menu_card_icon"
        if my_cards_ids.contains(this_card_id) {
            menu_image_name = "menu_card_icon_my"
        }
        menu_button.setImage(UIImage(named: menu_image_name)!, forState: .Normal)
    }
    
    func setCardIdWithId(c_id:Int) {
        this_card_id = c_id
    }
    
    func setHandlersWithMenuHandler(menuHandler:((card_id:Int)->Void), replyHandler:((card_id:Int)->Void), shareHandler:((card_id:Int)->Void)) {
        menuPressHandler = menuHandler
        replyPressHandler = replyHandler
        sharePressHandler = shareHandler
    }
    
    //we call this method after setting content while estimating
    func updateFramesWithWidth(now_width:CGFloat) {
        title_label.frame = CGRect(x: TITLE_MARGIN_LEFT, y: TITLE_MARGIN_TOP, width: now_width * TITLE_WIDTH_RELATIVE, height: 30)
        let text_rect = title_label.textRectForBounds(title_label.bounds, limitedToNumberOfLines: 1)
        title_label.frame = CGRect(x: title_label.frame.minX, y: TITLE_MARGIN_TOP, width: title_label.bounds.width, height: text_rect.height)
        let menu_width = now_width * MENU_BUTTON_WIDTH_RELATIVE
        let menu_x = (now_width - title_label.frame.maxX) * 0.5 - 0.5 * menu_width + title_label.frame.maxX
        menu_button.frame = CGRect(x: menu_x, y: (title_label.center.y - MENU_BUTTON_HEIGHT * 0.5 + 2), width: menu_width, height: MENU_BUTTON_HEIGHT)
        encounter_image.frame = CGRect(x: IMAGE_ENCOUNTER_MARGIN_LEFT, y: (title_label.frame.maxY + IMAGE_ENCOUNTER_MARGIN_TOP), width: IMAGE_ENCOUNTER_WIDTH_RELATIVE * now_width, height: IMAGE_ENCOUNTER_WIDTH_RELATIVE * now_width * IMAGE_ENCOUNTER_ASPECT)
        encounter_label.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        let enc_text_rect = encounter_label.textRectForBounds(encounter_label.bounds, limitedToNumberOfLines: 1)
        encounter_label.frame = CGRect(x: encounter_image.frame.maxX + ENCOUNTER_LABEL_MARGIN_LEFT, y: (encounter_image.center.y - enc_text_rect.height * 0.5), width: enc_text_rect.width, height: enc_text_rect.height)
        search_image.frame = CGRect(x: IMAGE_SEARCH_MARGIN_LEFT_ENCOUNTER_LABEL + encounter_label.frame.maxX, y: title_label.frame.maxY + IMAGE_SEARCH_MARGIN_TOP, width: IMAGE_SEARCH_WIDTH_RELATIVE * now_width, height: IMAGE_SEARCH_WIDTH_RELATIVE * now_width * IMAGE_SEARCH_ASPECT)
        body_label.frame = CGRect(x: BODY_MARGIN_LEFT, y: BODY_MARGIN_TOP + encounter_image.frame.maxY, width: BODY_WIDTH_RELATIVE * now_width, height: BODY_MAX_HEIGHT)
        let real_text_rect = body_label.textRectForBounds(body_label.bounds, limitedToNumberOfLines: 0)
        body_label.frame = CGRect(x: BODY_MARGIN_LEFT, y: body_label.frame.minY, width: body_label.bounds.width, height: real_text_rect.height)
        if current_right_image_transport {
            let current_image_aspect = current_right_image_transport_size.height / current_right_image_transport_size.width
            let max_image_width = now_width * IMAGE_RIGHT_TRANSPORT_MAX_WIDTH_RELATIVE
            var real_image_width = max_image_width
            var real_image_height = IMAGE_RIGHT_TRANSPORT_HEIGHT
            let card_image_aspect = IMAGE_RIGHT_TRANSPORT_HEIGHT / max_image_width
            if current_image_aspect > card_image_aspect {
                real_image_width = IMAGE_RIGHT_TRANSPORT_HEIGHT / current_image_aspect
            }
            else {
                real_image_height = current_image_aspect * real_image_width
            }
            image_right.frame = CGRect(x: (now_width - real_image_width), y: (search_image.frame.maxY + IMAGE_RIGHT_TRANSPORT_MARGIN_TOP_SEARCH), width: real_image_width, height: real_image_height)
            if image_right.frame.maxY < body_label.frame.maxY {
                image_right.center.y += (body_label.frame.maxY - image_right.frame.maxY) * 0.5
            }
        }
        else {
            let real_image_height = max(IMAGE_RIGHT_MAP_MIN_HEIGHT,(body_label.frame.maxY + IMAGE_RIGHT_MAP_MARGIN_BOTTOM - search_image.frame.maxY - IMAGE_RIGHT_MAP_MARGIN_TOP_SEARCH))
            let real_image_width = IMAGE_RIGHT_MAP_WIDTH_RELATIVE * now_width
            image_right.frame = CGRect(x: now_width - real_image_width, y: search_image.frame.maxY + IMAGE_RIGHT_MAP_MARGIN_TOP_SEARCH, width: real_image_width, height: real_image_height)
        }
        let buttons_bottom_y = max(image_right.frame.maxY,body_label.frame.maxY) + BUTTONS_BOTTOM_MARGIN_TOP
        button_reply.frame = CGRect(x: body_label.frame.minX, y: buttons_bottom_y, width: BUTTON_REPLY_WIDTH, height: BUTTONS_BOTTOM_HEIGHT)
        button_share.frame = CGRect(x: (now_width - BUTTON_SHARE_WIDTH - BUTTON_SHARE_MARGIN_RIGHT), y: buttons_bottom_y, width: BUTTON_SHARE_WIDTH, height: BUTTONS_BOTTOM_HEIGHT)
        let bookmark_icon_width = title_label.frame.minX - BOOKMARK_ICON_MARGIN_RIGHT - BOOKMARK_ICON_MARGIN_LEFT
        bookmark_icon.frame = CGRect(x: BOOKMARK_ICON_MARGIN_LEFT, y: 1, width: bookmark_icon_width, height: BOOKMARK_ICON_ASPECT * bookmark_icon_width)
    }
    
    func getFinalFrames() -> [String:CGRect] {
        var resulting_frames_dict:[String:CGRect] = [String:CGRect]()
        resulting_frames_dict["title_label"] = title_label.frame
        resulting_frames_dict["encounter_image"] = encounter_image.frame
        resulting_frames_dict["encounter_label"] = encounter_label.frame
        resulting_frames_dict["menu_button"] = menu_button.frame
        resulting_frames_dict["image_right"] = image_right.frame
        resulting_frames_dict["button_share"] = button_share.frame
        resulting_frames_dict["button_reply"] = button_reply.frame
        resulting_frames_dict["body_label"] = body_label.frame
        resulting_frames_dict["search_image"] = search_image.frame
        resulting_frames_dict["bookmark_icon"] = bookmark_icon.frame
        return resulting_frames_dict
    }
    
    func setFrames(frames:[String:CGRect]) {
        title_label.frame = frames["title_label"]!
        encounter_image.frame = frames["encounter_image"]!
        encounter_label.frame = frames["encounter_label"]!
        menu_button.frame = frames["menu_button"]!
        image_right.frame = frames["image_right"]!
        button_share.frame = frames["button_share"]!
        button_reply.frame = frames["button_reply"]!
        body_label.frame = frames["body_label"]!
        search_image.frame = frames["search_image"]!
        bookmark_icon.frame = frames["bookmark_icon"]!
    }

    func menuPressed(sender:UIButton) {
        menuPressHandler(cardId:this_card_id)
    }
    
    func shareButtonPressed(sender:UIButton) {
        sharePressHandler(cardId:this_card_id)
    }
    
    func replyButtonPressed(sender:UIButton) {
        replyPressHandler(cardId:this_card_id)
    }
    
    func setMapImage(image:UIImage, withDelay:Bool) {
        UIView.transitionWithView(image_right, duration: MAP_SNAPSHOT_ANIMATION_DURATION, options: .TransitionCrossDissolve, animations: {
            self.image_right.image = image
            }, completion: nil)
       // let info = NSMutableDictionary()
        //info["image"] = image
       // info["withDelay"] = withDelay
       // let _ = NSTimer.scheduledTimerWithTimeInterval(withDelay ? MAP_SNAPSHOT_ANIMATION_DELAY : 0.0, target: self, selector: "presentMapImage:", userInfo: info, repeats: false)
    }
    
    func presentMapImage(sender:NSTimer) {
        /*
        let delay = (sender.userInfo as! NSDictionary)["withDelay"] as! Bool
        UIView.transitionWithView(image_right, duration: MAP_SNAPSHOT_ANIMATION_DURATION, options: .TransitionCrossDissolve, animations: {
            self.image_right.image = (sender.userInfo as! NSDictionary)["image"] as! UIImage
            }, completion: nil)
        sender.invalidate()
*/
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}

//feed cell with images
class FeedCellImages:UITableViewCell {
    
    let TITLE_FONT_SIZE:CGFloat = 15
    let ENCOUNTER_FONT_SIZE:CGFloat = 14
    let BODY_FONT_SIZE:CGFloat = 14
    let BUTTON_BOTTOM_FONT_SIZE:CGFloat = 17
    
    let TITLE_MARGIN_TOP:CGFloat = 5
    let TITLE_MARGIN_LEFT:CGFloat = 14
    let TITLE_WIDTH_RELATIVE:CGFloat = 0.77 // relative to cell's width
    let TITLE_TEXT_COLOR:UIColor = UIColor(red: 50/255, green: 9/255, blue: 134/255, alpha: 1.0)
    let ENCOUNTER_TEXT_COLOR:UIColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1.0)
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
    let BODY_WIDTH_RELATIVE:CGFloat = 0.739
    let IMAGE_RIGHT_TRANSPORT_MAX_WIDTH_RELATIVE:CGFloat = 0.16 // 0.1538
    let IMAGE_RIGHT_TRANSPORT_MARGIN_TOP_SEARCH:CGFloat = 2 //from gender search icon
    let IMAGE_RIGHT_TRANSPORT_HEIGHT:CGFloat = 85
    let IMAGE_RIGHT_MAP_WIDTH_RELATIVE:CGFloat = 0.3
    let IMAGE_RIGHT_MAP_MARGIN_TOP_SEARCH:CGFloat = 0 //from gender search icon
    let IMAGE_RIGHT_MAP_MIN_HEIGHT:CGFloat = 90
    let IMAGE_RIGHT_MAP_MARGIN_BOTTOM:CGFloat = 6 // when putting map, it should be a bit shifted to the bottom - from body label lowest position(maxY)
    let BUTTON_REPLY_WIDTH:CGFloat = 100
    var BUTTONS_BOTTOM_HEIGHT:CGFloat = 0
    var BUTTON_SHARE_WIDTH:CGFloat = 0 //to be calculated...
    let BUTTONS_BOTTOM_MARGIN_TOP:CGFloat = 5
    let BUTTON_REPLY_ICON_HEIGHT_RELATIVE:CGFloat = 0.35 //relative to button's height
    let BUTTON_REPLY_ICON_MARGIN_LEFT_RELATIVE:CGFloat = 0.154 // to button's width
    let BUTTON_REPLY_TEXT_MARGIN_LEFT_RELATIVE:CGFloat = 0.117 //from image
    let BUTTON_REPLY_MARGIN_LEFT:CGFloat = 12
    let BUTTON_SHARE_MARGIN_RIGHT:CGFloat = 12
    let CONTENT_IMAGE_PLACEHOLDER_BG:UIColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    let CONTENT_IMAGES_MARGIN_TOP:CGFloat = 6 //from bottom of map or transport
    let CONTENT_IMAGES_MARGIN_LEFT:CGFloat = 14
    let CONTENT_IMAGES_MARGIN_RIGHT:CGFloat = 14
    let CONTENT_IMAGES_MIN_SPACING:CGFloat = 25 //between each other if 2 images
    let CONTENT_IMAGES_MAX_HEIGHT:CGFloat = 150
    let CONTENT_IMAGES_ANIMATION_DELAY:CFTimeInterval = 0.6 //to wait before starting fade in anim if required
    let CONTENT_IMAGES_ANIMATION_DURATION:CFTimeInterval = 0.4
    let BOOKMARK_ICON_MARGIN_LEFT:CGFloat = 2 //from the left of the screen
    let BOOKMARK_ICON_MARGIN_RIGHT:CGFloat = 2 // from the start of the title
    let BOOKMARK_ICON_ASPECT:CGFloat = 1.162
    let MAP_SNAPSHOT_ANIMATION_DELAY:CFTimeInterval = 0.23
    let MAP_SNAPSHOT_ANIMATION_DURATION:CFTimeInterval = 0.31
    
    var title_label:UILabel!
    var menu_button:UIButton!
    var encounter_image:UIImageView!
    var encounter_label:UILabel!
    var search_image:UIImageView!
    var image_right:UIImageView!
    var body_label:UILabel!
    var button_reply:UIButton!
    var button_share:UIButton!
    var bookmark_icon:UIImageView!
    var content_image_1:UIImageView!
    var content_image_2:UIImageView!
    
    var current_right_image_transport_size:CGSize!
    var current_right_image_transport = false
    var current_content_images_amount:Int = 1
    var current_content_image_1_size = CGSizeZero
    var current_content_image_2_size = CGSizeZero
    var this_card_id:Int = -1
    var menuPressHandler:((cardId:Int)->Void)!
    var replyPressHandler:((cardId:Int)->Void)!
    var sharePressHandler:((cardId:Int)->Void)!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        title_label = UILabel()
        title_label.userInteractionEnabled = true
        //title_label.text = "Some text with a very very liong type, so we need to check how it's all gonna work"
        title_label.font = UIFont(name: "SFUIText-Semibold", size: TITLE_FONT_SIZE)
        title_label.textColor = TITLE_TEXT_COLOR
        title_label.textAlignment = NSTextAlignment.Left
        menu_button = UIButton(type: .Custom)
        menu_button.imageView!.contentMode = .ScaleAspectFit
        menu_button.addTarget(self, action: "menuPressed:", forControlEvents: .TouchUpInside)
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
        image_right = UIImageView()
        image_right.contentMode = .ScaleAspectFit
        button_reply = UIButton(type: .Custom)
        button_reply.addTarget(self, action: "replyButtonPressed:", forControlEvents: .TouchUpInside)
        let reply_button_bg_image = UIImage(named: "reply_button_bg")!
        button_reply.setBackgroundImage(reply_button_bg_image, forState: .Normal)
        BUTTONS_BOTTOM_HEIGHT = BUTTON_REPLY_WIDTH * (reply_button_bg_image.size.height / reply_button_bg_image.size.width)
        button_reply.setTitle("Reply", forState: .Normal)
        button_reply.titleLabel!.font = UIFont(name: "SFUIText-Semibold", size: BUTTON_BOTTOM_FONT_SIZE)!
        button_reply.setTitleColor(BUTTON_TEXT_COLOR, forState: .Normal)
        button_reply.setTitleColor(BUTTON_TEXT_COLOR_SELECTED, forState: .Highlighted)
        //button_reply.layer.borderWidth = 1.0
        let reply_text_size = ("Reply" as! NSString).sizeWithAttributes([NSFontAttributeName:UIFont(name: "SFUIText-Semibold", size: BUTTON_BOTTOM_FONT_SIZE)!])
        let now_reply_text_start = BUTTON_REPLY_WIDTH * 0.5 - reply_text_size.width * 0.5
        let reply_text_shift = (0.3 * BUTTON_REPLY_WIDTH - now_reply_text_start) * 2.0
        button_reply.titleEdgeInsets = UIEdgeInsetsMake(0, reply_text_shift, 0, 0)
        button_share = UIButton(type: .Custom)
        button_share.addTarget(self, action: "shareButtonPressed:", forControlEvents: .TouchUpInside)
        //button_share.layer.borderWidth = 1.0
        let share_image_bg = UIImage(named: "share_button_bg")!
        button_share.setBackgroundImage(share_image_bg, forState: .Normal)
        BUTTON_SHARE_WIDTH = BUTTONS_BOTTOM_HEIGHT / (share_image_bg.size.height / share_image_bg.size.width)
        button_share.setTitle("Share", forState: .Normal)
        button_share.setTitleColor(BUTTON_TEXT_COLOR, forState: .Normal)
        button_share.setTitleColor(BUTTON_TEXT_COLOR_SELECTED, forState: .Highlighted)
        button_share.titleLabel!.font = UIFont(name: "SFUIText-Semibold", size: BUTTON_BOTTOM_FONT_SIZE)
        let share_text_size = ("Share" as! NSString).sizeWithAttributes([NSFontAttributeName:UIFont(name: "SFUIText-Semibold", size: BUTTON_BOTTOM_FONT_SIZE)!])
        let now_share_text_end = BUTTON_SHARE_WIDTH * 0.5 + share_text_size.width * 0.5
        let share_text_edge_shift = (now_share_text_end - 0.626 * BUTTON_SHARE_WIDTH) * 1.0
        button_share.titleEdgeInsets = UIEdgeInsetsMake(0, -share_text_edge_shift, 0, 0)
        content_image_1 = UIImageView()
        content_image_2 = UIImageView()
        content_image_1.frame = CGRectZero
        content_image_2.frame = CGRectZero
        content_image_1.backgroundColor = CONTENT_IMAGE_PLACEHOLDER_BG
        content_image_2.backgroundColor = CONTENT_IMAGE_PLACEHOLDER_BG
        content_image_2.hidden = true
        content_image_1.contentMode = .ScaleAspectFit
        content_image_2.contentMode = .ScaleAspectFit
        bookmark_icon = UIImageView()
        bookmark_icon.contentMode = .ScaleAspectFit
        contentView.addSubview(menu_button)
        contentView.addSubview(title_label)
        contentView.addSubview(encounter_image)
        contentView.addSubview(encounter_label)
        contentView.addSubview(search_image)
        contentView.addSubview(image_right)
        contentView.addSubview(body_label)
        contentView.addSubview(button_reply)
        contentView.addSubview(button_share)
        contentView.addSubview(content_image_1)
        contentView.addSubview(content_image_2)
        contentView.addSubview(bookmark_icon)
    }
    
    func setContent(data:NSDictionary) {
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
        current_right_image_transport = data["transport_icon_present"] as! Bool
        if current_right_image_transport {
            let transport_id = data["transport_icon_type"] as! Int
            let transport_image_name = "transport_icon_\(transport_id)"
            image_right.image = UIImage(named: transport_image_name)!
            current_right_image_transport_size = image_right.image!.size
        }
        else {
            image_right.image = General.map_placeholder_gradient
            //image_right.image = General.getGradientMapImageForSize(image_right.bounds.size, originalImage: UIImage(named: "map_placeholder")!, isPlaceholder: true,withStyle: "feed")
        }
        content_image_1.image = nil
        content_image_2.image = nil
        current_content_images_amount = 1
        content_image_2.hidden = true
        let images_sizes = data["images_sizes"] as! [NSValue]
        current_content_image_1_size = images_sizes[0].CGSizeValue()
        if data["images_count"] as! Int == 2 {
            current_content_images_amount = 2
            content_image_2.hidden = false
            current_content_image_2_size = images_sizes[1].CGSizeValue()
        }
        let cards_bookmarks = NSUserDefaults().arrayForKey("cards_bookmarks") as! [Int]
        if cards_bookmarks.contains(this_card_id) {
            bookmark_icon.image = UIImage(named: "bookmark_card_icon_on")!
        }
        else {
            bookmark_icon.image = UIImage(named: "bookmark_card_icon_off")!
        }
        let my_cards_ids = NSUserDefaults().arrayForKey("my_posts_cards_ids") as! [Int]
        var menu_image_name = "menu_card_icon"
        if my_cards_ids.contains(this_card_id) {
            menu_image_name = "menu_card_icon_my"
        }
        menu_button.setImage(UIImage(named: menu_image_name)!, forState: .Normal)
    }
    
    func setImages(images:[UIImage],withDelay:Bool) {
        UIView.transitionWithView(content_image_1, duration: CONTENT_IMAGES_ANIMATION_DURATION, options: .TransitionCrossDissolve, animations: {
            self.content_image_1.image = images[0]
            }, completion: nil)
        if images.count == 2 {
            UIView.transitionWithView(content_image_2, duration: CONTENT_IMAGES_ANIMATION_DURATION, options: .TransitionCrossDissolve, animations: {
                self.content_image_2.image = images[1]
                }, completion: nil)
        }
        //let _ = NSTimer.scheduledTimerWithTimeInterval(withDelay ? CONTENT_IMAGES_ANIMATION_DELAY : 0.0, target: self, selector: "presentImages:", userInfo: images, repeats: false)
    }
    
    func setMapImage(image:UIImage, withDelay:Bool) {
        UIView.transitionWithView(image_right, duration: MAP_SNAPSHOT_ANIMATION_DURATION, options: .TransitionCrossDissolve, animations: {
            self.image_right.image = image
            }, completion: nil)
        //let _ = NSTimer.scheduledTimerWithTimeInterval(withDelay ? MAP_SNAPSHOT_ANIMATION_DELAY : 0.0, target: self, selector: "presentMapImage:", userInfo: image, repeats: false)
    }
    
    func presentMapImage(sender:NSTimer) {
        /*
        UIView.transitionWithView(image_right, duration: MAP_SNAPSHOT_ANIMATION_DURATION, options: .TransitionCrossDissolve, animations: {
            self.image_right.image = sender.userInfo as! UIImage
            }, completion: nil)
        sender.invalidate()
*/
    }
    
    func presentImages(sender:NSTimer) {
/*
        let images = sender.userInfo as! [UIImage]
        UIView.transitionWithView(content_image_1, duration: CONTENT_IMAGES_ANIMATION_DURATION, options: [.TransitionCrossDissolve, UIViewAnimationOptions.AllowAnimatedContent], animations: {
            self.content_image_1.image = images[0]
            }, completion: nil)
        if images.count == 2 {
            UIView.transitionWithView(content_image_2, duration: CONTENT_IMAGES_ANIMATION_DURATION, options: .TransitionCrossDissolve, animations: {
                self.content_image_2.image = images[1]
                }, completion: nil)
        }
        sender.invalidate()
*/
    }
    
    func setCardIdWithId(c_id:Int) {
        this_card_id = c_id
    }
    
    func setHandlersWithMenuHandler(menuHandler:((card_id:Int)->Void), replyHandler:((card_id:Int)->Void), shareHandler:((card_id:Int)->Void)) {
        menuPressHandler = menuHandler
        replyPressHandler = replyHandler
        sharePressHandler = shareHandler
    }
    
    //we call this method after setting content while estimating
    func updateFramesWithWidth(now_width:CGFloat) {
        title_label.frame = CGRect(x: TITLE_MARGIN_LEFT, y: TITLE_MARGIN_TOP, width: now_width * TITLE_WIDTH_RELATIVE, height: 30)
        let text_rect = title_label.textRectForBounds(title_label.bounds, limitedToNumberOfLines: 1)
        title_label.frame = CGRect(x: title_label.frame.minX, y: TITLE_MARGIN_TOP, width: title_label.bounds.width, height: text_rect.height)
        let menu_width = now_width * MENU_BUTTON_WIDTH_RELATIVE
        let menu_x = (now_width - title_label.frame.maxX) * 0.5 - 0.5 * menu_width + title_label.frame.maxX
        menu_button.frame = CGRect(x: menu_x, y: (title_label.center.y - MENU_BUTTON_HEIGHT * 0.5 + 2), width: menu_width, height: MENU_BUTTON_HEIGHT)
        encounter_image.frame = CGRect(x: IMAGE_ENCOUNTER_MARGIN_LEFT, y: (title_label.frame.maxY + IMAGE_ENCOUNTER_MARGIN_TOP), width: IMAGE_ENCOUNTER_WIDTH_RELATIVE * now_width, height: IMAGE_ENCOUNTER_WIDTH_RELATIVE * now_width * IMAGE_ENCOUNTER_ASPECT)
        encounter_label.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        let enc_text_rect = encounter_label.textRectForBounds(encounter_label.bounds, limitedToNumberOfLines: 1)
        encounter_label.frame = CGRect(x: encounter_image.frame.maxX + ENCOUNTER_LABEL_MARGIN_LEFT, y: (encounter_image.center.y - enc_text_rect.height * 0.5), width: enc_text_rect.width, height: enc_text_rect.height)
        search_image.frame = CGRect(x: IMAGE_SEARCH_MARGIN_LEFT_ENCOUNTER_LABEL + encounter_label.frame.maxX, y: title_label.frame.maxY + IMAGE_SEARCH_MARGIN_TOP, width: IMAGE_SEARCH_WIDTH_RELATIVE * now_width, height: IMAGE_SEARCH_WIDTH_RELATIVE * now_width * IMAGE_SEARCH_ASPECT)
        body_label.frame = CGRect(x: BODY_MARGIN_LEFT, y: BODY_MARGIN_TOP + encounter_image.frame.maxY, width: BODY_WIDTH_RELATIVE * now_width, height: BODY_MAX_HEIGHT)
        let body_text_bounding = body_label.attributedText!.boundingRectWithSize(body_label.frame.size, options: [NSStringDrawingOptions.UsesLineFragmentOrigin], context: nil)
        let real_text_rect = body_label.textRectForBounds(body_label.bounds, limitedToNumberOfLines: 0)
        body_label.frame = CGRect(x: BODY_MARGIN_LEFT, y: body_label.frame.minY, width: body_label.bounds.width, height: real_text_rect.height)
        if current_right_image_transport {
            let current_image_aspect = current_right_image_transport_size.height / current_right_image_transport_size.width
            let max_image_width = now_width * IMAGE_RIGHT_TRANSPORT_MAX_WIDTH_RELATIVE
            var real_image_width = max_image_width
            var real_image_height = IMAGE_RIGHT_TRANSPORT_HEIGHT
            let card_image_aspect = IMAGE_RIGHT_TRANSPORT_HEIGHT / max_image_width
            if current_image_aspect > card_image_aspect {
                real_image_width = IMAGE_RIGHT_TRANSPORT_HEIGHT / current_image_aspect
            }
            else {
                real_image_height = current_image_aspect * real_image_width
            }
            image_right.frame = CGRect(x: (now_width - real_image_width), y: (search_image.frame.maxY + IMAGE_RIGHT_TRANSPORT_MARGIN_TOP_SEARCH), width: real_image_width, height: real_image_height)
            if image_right.frame.maxY < body_label.frame.maxY {
                image_right.center.y += (body_label.frame.maxY - image_right.frame.maxY) * 0.5
            }
        }
        else {
            let real_image_height = max(IMAGE_RIGHT_MAP_MIN_HEIGHT,(body_label.frame.maxY + IMAGE_RIGHT_MAP_MARGIN_BOTTOM - search_image.frame.maxY - IMAGE_RIGHT_MAP_MARGIN_TOP_SEARCH))
            let real_image_width = IMAGE_RIGHT_MAP_WIDTH_RELATIVE * now_width
            image_right.frame = CGRect(x: now_width - real_image_width, y: search_image.frame.maxY + IMAGE_RIGHT_MAP_MARGIN_TOP_SEARCH, width: real_image_width, height: real_image_height)
            image_right.image = General.map_placeholder_gradient
            //image_right.image = General.getGradientMapImageForSize(CGSize(width: real_image_width, height: real_image_height), originalImage: UIImage(named: "map_placeholder")!, isPlaceholder: true, withStyle: "feed")
        }
        let content_images_top_y = max(image_right.frame.maxY,body_label.frame.maxY) + CONTENT_IMAGES_MARGIN_TOP
        if current_content_images_amount == 1 {
            let max_width = now_width - CONTENT_IMAGES_MARGIN_LEFT - CONTENT_IMAGES_MARGIN_RIGHT
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
            let img_1_aspect = current_content_image_1_size.height / current_content_image_1_size.width
            let img_2_aspect = current_content_image_2_size.height / current_content_image_2_size.width
            let max_width = now_width - CONTENT_IMAGES_MARGIN_LEFT - CONTENT_IMAGES_MARGIN_RIGHT - CONTENT_IMAGES_MIN_SPACING
            var real_height = max_width * img_1_aspect * img_2_aspect / (img_1_aspect + img_2_aspect)
            if real_height > CONTENT_IMAGES_MAX_HEIGHT {
                real_height = CONTENT_IMAGES_MAX_HEIGHT
            }
            let img_1_real_width = real_height / img_1_aspect
            let img_2_real_width = real_height / img_2_aspect
            var sp_1:CGFloat = 0
            var sp_2:CGFloat = 0
            var sp_3:CGFloat = 0
            let equal_sp = (now_width - CONTENT_IMAGES_MARGIN_LEFT - CONTENT_IMAGES_MARGIN_RIGHT - img_1_real_width - img_2_real_width) / 3.0
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
            //print("equal_sp = \(equal_sp), sp1 \(sp_1), sp_2 \(sp_2) sp3 = \(sp_3)")
            content_image_1.frame = CGRect(x: CONTENT_IMAGES_MARGIN_LEFT + sp_1, y: content_images_top_y, width: img_1_real_width, height: real_height)
            content_image_2.frame = CGRect(x: CONTENT_IMAGES_MARGIN_LEFT + sp_1 + img_1_real_width + sp_2, y: content_images_top_y, width: img_2_real_width, height: real_height)
        }
        let bookmark_icon_width = title_label.frame.minX - BOOKMARK_ICON_MARGIN_RIGHT - BOOKMARK_ICON_MARGIN_LEFT
        bookmark_icon.frame = CGRect(x: BOOKMARK_ICON_MARGIN_LEFT, y: 1, width: bookmark_icon_width, height: BOOKMARK_ICON_ASPECT * bookmark_icon_width)
        let buttons_bottom_y = content_image_1.frame.maxY + BUTTONS_BOTTOM_MARGIN_TOP
        button_reply.frame = CGRect(x: body_label.frame.minX, y: buttons_bottom_y, width: BUTTON_REPLY_WIDTH, height: BUTTONS_BOTTOM_HEIGHT)
        button_share.frame = CGRect(x: (now_width - BUTTON_SHARE_WIDTH - BUTTON_SHARE_MARGIN_RIGHT), y: buttons_bottom_y, width: BUTTON_SHARE_WIDTH, height: BUTTONS_BOTTOM_HEIGHT)
    }
    
    func getFinalFrames() -> [String:CGRect] {
        var resulting_frames_dict:[String:CGRect] = [String:CGRect]()
        resulting_frames_dict["title_label"] = title_label.frame
        resulting_frames_dict["encounter_image"] = encounter_image.frame
        resulting_frames_dict["encounter_label"] = encounter_label.frame
        resulting_frames_dict["menu_button"] = menu_button.frame
        resulting_frames_dict["image_right"] = image_right.frame
        resulting_frames_dict["button_share"] = button_share.frame
        resulting_frames_dict["button_reply"] = button_reply.frame
        resulting_frames_dict["body_label"] = body_label.frame
        resulting_frames_dict["search_image"] = search_image.frame
        resulting_frames_dict["content_image_1"] = content_image_1.frame
        resulting_frames_dict["content_image_2"] = content_image_2.frame
        resulting_frames_dict["bookmark_icon"] = bookmark_icon.frame
        return resulting_frames_dict
    }
    
    func setFrames(frames:[String:CGRect]) {
        title_label.frame = frames["title_label"]!
        encounter_image.frame = frames["encounter_image"]!
        encounter_label.frame = frames["encounter_label"]!
        menu_button.frame = frames["menu_button"]!
        image_right.frame = frames["image_right"]!
        button_share.frame = frames["button_share"]!
        button_reply.frame = frames["button_reply"]!
        body_label.frame = frames["body_label"]!
        search_image.frame = frames["search_image"]!
        content_image_1.frame = frames["content_image_1"]!
        content_image_2.frame = frames["content_image_2"]!
        bookmark_icon.frame = frames["bookmark_icon"]!
    }
    
    func menuPressed(sender:UIButton) {
        menuPressHandler(cardId:this_card_id)
    }
    
    func shareButtonPressed(sender:UIButton) {
        sharePressHandler(cardId:this_card_id)
    }
    
    func replyButtonPressed(sender:UIButton) {
        replyPressHandler(cardId:this_card_id)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

class SettingsCellBig:UITableViewCell {
    
    @IBOutlet var icon_image:UIImageView!
    @IBOutlet var title_head:UILabel!
    @IBOutlet var title_description:UILabel!
    
}

class SettingsCellPlainText:UITableViewCell {
    
    @IBOutlet var plain_text:UILabel!
    
}

class SettingsCellRegular:UITableViewCell {
    
    @IBOutlet var title:UILabel!
    @IBOutlet var disclosure_icon:UIImageView!
    @IBOutlet var switch_control:UISwitch!
    var switchHandler:((UISwitch) -> Void)!
    
    @IBAction func switchChanged(sender:UISwitch) {
        switchHandler(sender)
    }
    
    func setSwitchHandlerWithHandler(handler:((UISwitch) -> Void)) {
        switchHandler = handler
    }
    
}

class FilterCellHead:UITableViewCell {
    
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var descriptionLabel:UILabel!
    @IBOutlet var arrow_image:UIImageView!
    @IBOutlet var checkbox_image:UIImageView!
    
    override func layoutSubviews() {
        print("now lay out head cell")
    }
    
    
}

class FilterCellArea:UITableViewCell {
    
    @IBOutlet var areaLabel:UILabel!
    @IBOutlet var checkbox_image:UIImageView!
    
}

class FilterCellGender:UITableViewCell {
    
    @IBOutlet var mw_icon:UIButton!
    @IBOutlet var ww_icon:UIButton!
    @IBOutlet var wm_icon:UIButton!
    @IBOutlet var mm_icon:UIButton!
    var iconPressHandler:((type:String) -> Void)!
    
    @IBAction func mwPressed(sender:UIButton) {
        iconPressHandler(type:"mw")
    }
    
    @IBAction func wwPressed(sender:UIButton) {
        iconPressHandler(type:"ww")
    }
    
    @IBAction func wmPressed(sender:UIButton) {
        iconPressHandler(type:"wm")
    }
    
    @IBAction func mmPressed(sender:UIButton) {
        iconPressHandler(type:"mm")
    }
    
    func setIconHandler(handler:((type:String) -> Void)) {
        iconPressHandler = handler
    }
    
}

class FilterCellTimeframe:UITableViewCell {
    
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var dateLabel:UILabel!
    
}

class FilterCellTimeframePicker:UITableViewCell {
    
    @IBOutlet var datePicker:UIDatePicker!
    var dateHandler:((new_date:NSDate) -> Void)!
    
    @IBAction func dateChanged(sender:UIDatePicker) {
        dateHandler(new_date: sender.date)
    }
    
    func setDateChangedHandler(handler:((new_date:NSDate) -> Void)) {
        dateHandler = handler
    }
    
}

class ChatListCell : UITableViewCell {
    
    @IBOutlet var avatar_image:UIImageView!
    @IBOutlet var chat_text:UILabel!
    @IBOutlet var unread_mark:UIView!
    
    func setMessageRead(read:Bool) {
        unread_mark.hidden = read
    }
    
    func setChatText(text:NSAttributedString) {
        chat_text.attributedText = text
    }
    
}
