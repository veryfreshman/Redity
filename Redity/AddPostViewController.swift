//
//  AddPostViewController.swift
//  Redity
//
//  Created by Admin on 08.08.16.
//  Copyright © 2016 Vanoproduction. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreLocation
import MapKit

class AddPostViewController: UIViewController, UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    let BG_OPACITY:CGFloat = 0.36
    let HEAD_LABEL_MARGIN_LEFT:CGFloat = 22
    let HEAD_LABEL_MARGIN_TOP_BETWEEN:CGFloat = 15 // margin between heads for cells inside the list
    let HEAD_LABEL_MARGIN_TOP:CGFloat = 12 // from the very top of the overlay
    let HEAD_LABEL_FONT_SIZE:CGFloat = 15
    let HEAD_LABEL_FONT_COLOR:UIColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1.0)
    let TEXT_FIELD_MARGIN_SIDES:CGFloat = 6
    let TEXT_FIELD_MARGIN_TOP:CGFloat = 6 // usually from head label
    let TEXT_FIELD_TEXT_NORMAL_SIZE:CGFloat = 14
    let TEXT_FIELD_TEXT_PLACEHOLDER_SIZE:CGFloat = 13
    let TEXT_FIELD_TEXT_NORMAL_COLOR:UIColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1.0)
    let TEXT_FIELD_TEXT_PLACEHODLER_COLOR:UIColor = UIColor(red: 182/255, green: 182/255, blue: 182/255, alpha: 1.0)
    let TEXT_FIELD_BORDER_WIDTH_NORMAL:CGFloat = 1
    let TEXT_FIELD_BORDER_WIDTH_ERROR:CGFloat = 2
    let TEXT_FIELD_BORDER_WIDTH_ACTIVE:CGFloat = 2
    let TEXT_FIELD_BORDER_COLOR_NORMAL:UIColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1.0)
    let TEXT_FIELD_BORDER_COLOR_ACTIVE:UIColor = UIColor(red: 120/255, green: 68/255, blue: 198/255, alpha: 1.0)
    let TEXT_FIELD_BORDER_COLOR_ERROR:UIColor = UIColor(red: 173/255, green: 73/255, blue: 74/255, alpha: 1.0)
    let TEXT_FIELD_MIN_HEIGHT:CGFloat = 38 // initial field height
    let TEXT_FIELD_TITLE_MAX_HEIGHT:CGFloat = 52 // after that height inner scrolling will be applied
    let TEXT_FIELD_BODY_MAX_HEIGHT:CGFloat = 250
    let TEXT_FIELD_CORNER_RADIUS:CGFloat = 7.5
    let GENDER_BUTTON_WIDTH_RELATIVE:CGFloat = 0.2
    let GENDER_BUTTON_ASPECT:CGFloat = 0.54
    let GENDER_BUTTON_MARGIN_TOP:CGFloat = 7
    let MEETING_TIME_FIELD_MIN_WIDTH:CGFloat = 68
    let MEETING_TIME_SPACING:CGFloat = 8
    let TEXT_FIELD_QUESTION_BUTTON_WIDTH:CGFloat = 17
    let TEXT_FIELD_QUESTION_BUTTON_MARGIN_RIGHT:CGFloat = 2
    let TEXT_FIELD_QUESTION_BUTTON_IMAGE_HEIGHT_RELATIVE:CGFloat = 0.445 // the ? sign would not occupy the whole height for sure - just part of it
    let TEXT_FIELD_QUESTION_BUTTON_IMAGE_ASPECT:CGFloat = 1.4444
    let TEXT_FIELD_MAX_CHARACTERS_BODY:Int = 3000
    let TEXT_FIELD_MAX_CHARACTERS_TITLE:Int = 70
    let TEXT_FIELD_MAX_CHARACTERS_DATE:Int = 5
    let MEETING_PLACE_SEGMENTED_COLOR:UIColor = UIColor(red: 88/255, green: 60/255, blue: 191/255, alpha: 1.0)
    let MEETING_PLACE_SEGMENTED_MARGIN_TOP:CGFloat = 6
    let MEETING_PLACE_FRAME_MARGIN_SIDES:CGFloat = 7
    let MEETING_PLACE_FRAME_LOCATION_HEIGHT:CGFloat = 135
    let MEETING_PLACE_FRAME_TRANSPORT_HEIGHT:CGFloat = 95
    let FRAME_BORDER_WIDTH:CGFloat = 2.0
    let FRAME_BORDER_COLOR:UIColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1.0)
    let FRAME_BORDER_COLOR_ERROR:UIColor = UIColor(red: 173/255, green: 73/255, blue: 74/255, alpha: 1.0)
    let FRAME_UNSET_DASH:[NSNumber] = [4,2]
    let MEETING_PLACE_FRAME_CORNER_RADIUS:CGFloat = 12
    let MEETING_PLACE_LOCATION_PLACEHOLDER_IMAGE_MARGIN_TOP:CGFloat = 15
    let MEETING_PLACE_LOCATION_PLACEHOLDER_IMAGE_WIDTH_RELATIVE:CGFloat = 0.21
    let MEETING_PLACE_LOCATION_PLACEHOLDER_IMAGE_ASPECT:CGFloat = 0.8125
    let MEETING_PLACE_LOCATION_TEXT_FONT_SIZE:CGFloat = 16
    let MEETING_PLACE_TRANSPORT_TEXT_ZONE_FONT_SIZE:CGFloat = 14
    let MEETING_PLACE_LOCATION_TEXT_FONT_COLOR:UIColor = UIColor(red: 129/255, green: 129/255, blue: 129/255, alpha: 1.0)
    let TRANSPORT_CELL_HEIGHT_RELATIVE:CGFloat = 0.845 // to frame's height
    let TRANSPORT_CELL_MARGIN_SIDES:CGFloat = 11
    let TRANSPORT_CELL_MARGIN_INTER:CGFloat = 10 //between transport's icons(cells)
    let TRANSPORT_CELL_CORNER_RADIUS:CGFloat = 7
    let MEETING_PLACE_COLLECTION_CELL_MIN_IMAGE_PADDING:CGFloat = 8
    let MEETING_PLACE_TRANSPORT_TEXT_MARGIN_TOP:CGFloat = 7
    let MEETING_PLACE_LOCATION_BUTTON_WIDTH_RELATIVE:CGFloat = 0.648
    let MEETING_PLACE_LOCATION_BUTTON_ASPECT:CGFloat = 0.1608
    let MEETING_PLACE_LOCATION_BUTTON_MARGIN_TOP:CGFloat = 10
    let MEETING_PLACE_LOCATION_BUTTON_MAX_FONT_SIZE:CGFloat = 14
    let ANIMATION_MEETING_PLACE_DURATION:CFTimeInterval = 0.4
    let TRANSPORT_CELL_UNSEL_BG_COLOR:UIColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
    let TRANSPORT_CELL_SEL_BG_COLOR:UIColor = UIColor(red: 199/255, green: 190/255, blue: 225/255, alpha: 1.0)
    let TRANSPORT_CELL_HIGH_BG_COLOR:UIColor = UIColor(red: 216/255, green: 211/255, blue: 233/255, alpha: 1.0)
    let PHOTO_RECT_WIDTH_RELATIVE:CGFloat = 0.25
    let PHOTO_RECT_IMAGE_PLACEHOLDER_WIDTH_RELATIVE:CGFloat = 0.76
    let PHOTO_RECT_MARGIN_TOP:CGFloat = 12
    let PHOTO_RECT_CORNER_RADIUS:CGFloat = 12
    let POST_BUTTON_BG_COLOR_NORMAL:UIColor = UIColor(red: 96/255, green: 90/255, blue: 210/255, alpha: 1.0)
    let POST_BUTTON_BG_COLOR_HIGHLIGHTED:UIColor = UIColor(red: 80/255, green: 76/255, blue: 177/255, alpha: 1.0)
    let POST_BUTTON_FONT_SIZE:CGFloat = 16.5
    let POST_BUTTON_FONT_COLOR:UIColor = UIColor(red: 216/255, green: 213/255, blue: 242/255, alpha: 1.0)
    let POST_BUTTON_MARGIN_TOP:CGFloat = 12
    let POST_BUTTON_HEIGHT:CGFloat = 45
    let MAP_SNAPSHOT_METERS_WIDTH:Double = 1200.0
    let ANIMATION_LOCATION_LOADING_BLINKING_DURATION:CFTimeInterval = 0.85
    let LOCATION_LABEL_MARGIN_TOP:CGFloat = 10
    let TRANSPORT_TEXT_UPDATE_DELAY:CFTimeInterval = 3.0
    
    let TRANSPORT_CELLS_COUNT:Int = 9
    
    let ANIMATION_MINOR_DURATION:CFTimeInterval = 0.2
    
    var prev_title_field_height:CGFloat = 0
    var prev_body_field_height:CGFloat = 0
    var prev_meeting_place_height:CGFloat = 0
    var selected_location_coords:CLLocationCoordinate2D!
    var prev_pin_coords:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: CLLocationDegrees(5.0), longitude: CLLocationDegrees(10.0))
    var title_field_empty = true
    var body_field_empty = true
    var meeting_place_location_set = false
    var meeting_place_transport_set = false
    var current_meeting_place = "location" // location, transport
    var now_meeting_place_transition = false
    var current_transport_cell_selected = -1 //nothing is selected
    var photo_picked_1 = false
    var photo_picked_2 = false
    var currently_picking_photo_1 = false
    var data_errors:[String:Bool] = [String:Bool]()
    var current_editing_frame:CGRect = CGRectZero
    var now_editing_field = false
    var total_view_gest_recog:UITapGestureRecognizer!
    var loc_tap_recog:UITapGestureRecognizer!
    var current_location_added = false
    var should_listen_to_location_updates = false
    var current_area_title = "Title"
    
    var scroll_view:UIScrollView!
    @IBOutlet var bg_view:UIView!
    var title_head_label:UILabel!
    var title_field:UITextView!
    var body_field:UITextView!
    var gender_head_label:UILabel!
    var gender_mw_button:UIButton!
    var gender_ww_button:UIButton!
    var gender_mm_button:UIButton!
    var gender_wm_button:UIButton!
    var body_head_label:UILabel!
    var meeting_time_head_label:UILabel!
    var day_field:UITextView!
    var month_field:UITextView!
    var year_field:UITextView!
    var hour_field:UITextView!
    var minute_field:UITextView!
    var meeting_time_day_label:UILabel!
    var meeting_time_month_label:UILabel!
    var meeting_time_year_label:UILabel!
    var meeting_time_hour_label:UILabel!
    var meeting_time_minute_label:UILabel!
    var meeting_place_head_label:UILabel!
    var meeting_place_segmented_control:UISegmentedControl!
    var meeting_place_frame_location:CAShapeLayer!
    var meeting_place_frame_transport:CAShapeLayer!
    var meeting_place_location_view:UIView!
    var meeting_place_transport_view:UIView!
    var meeting_place_location_map_img:UIImageView!
    var meeting_place_location_add_current_button:UIButton!
    var meeting_place_location_text:UILabel!
    var meeting_place_transport_text:UILabel!
    var meeting_place_transport_text_posting_zone:UILabel!
    var transport_collection:UICollectionView!
    var img_picker:UIImagePickerController!
    var photo_head_label:UILabel!
    var ph_rect_1:CAShapeLayer!
    var ph_rect_2:CAShapeLayer!
    var ph_view_1:UIView!
    var ph_view_2:UIView!
    var ph_img_1:UIImageView!
    var ph_img_2:UIImageView!
    var post_button:UIButton!
    var loc_pin_nc:UINavigationController!
    var loc_pin_vc:PinMapViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.userInteractionEnabled = true
        total_view_gest_recog = UITapGestureRecognizer(target: self, action: "viewTapped:")
        total_view_gest_recog.delegate = self
        view.addGestureRecognizer(total_view_gest_recog)
        loc_pin_nc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("pin_map_nc") as! UINavigationController
        loc_pin_vc = loc_pin_nc.childViewControllers[0] as! PinMapViewController
        loc_pin_vc.send_result_back = true
        loc_pin_vc.parentAddController = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationUpdated:", name: "location_update_notification", object: nil)
    }
    
    func configureHeadLabel(label:UILabel) {
        let real_bounds = label.textRectForBounds(label.bounds, limitedToNumberOfLines: 1)
        label.frame = CGRect(x: label.frame.minX, y: label.frame.minY, width: label.frame.width, height: real_bounds.height)
    }
    
    func createPlaceholderAddPhotoIconWithWidth(n_width:CGFloat) -> UIImageView {
        let ph_ph_img = UIImageView(image: UIImage(named: "add_photo_icon")!)
        ph_ph_img.contentMode = .ScaleAspectFit
        ph_ph_img.backgroundColor = UIColor.clearColor()
        let ph_ph_img_width = PHOTO_RECT_IMAGE_PLACEHOLDER_WIDTH_RELATIVE * n_width
        ph_ph_img.frame = CGRect(x: (n_width - ph_ph_img_width) * 0.5, y: 0, width: ph_ph_img_width, height: n_width)
        return ph_ph_img
    }
    
    func configureView() {
        data_errors["title"] = false
        data_errors["body"] = false
        data_errors["month"] = false
        data_errors["day"] = false
        data_errors["minute"] = false
        data_errors["year"] = false
        data_errors["hour"] = false
        data_errors["meeting_place"] = false
        bg_view.backgroundColor = UIColor(patternImage: UIImage(named: "bg_pattern")!)
        bg_view.alpha = BG_OPACITY
        scroll_view = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        scroll_view.delaysContentTouches = false
        title_head_label = UILabel(frame: CGRect(x: HEAD_LABEL_MARGIN_LEFT, y: HEAD_LABEL_MARGIN_TOP, width: view.bounds.width - HEAD_LABEL_MARGIN_LEFT, height: 40))
        title_head_label.text = "Title"
        title_head_label.font = UIFont(name: "SFUIText-Semibold", size: HEAD_LABEL_FONT_SIZE)!
        title_head_label.textColor = HEAD_LABEL_FONT_COLOR
        configureHeadLabel(title_head_label)
        title_field = UITextView(frame: CGRect(x: TEXT_FIELD_MARGIN_SIDES, y: title_head_label.frame.maxY + TEXT_FIELD_MARGIN_TOP, width: view.bounds.width - 2.0 * TEXT_FIELD_MARGIN_SIDES, height: TEXT_FIELD_MIN_HEIGHT))
        title_field.typingAttributes = [NSFontAttributeName:UIFont(name: "SFUIText-Regular", size: TEXT_FIELD_TEXT_PLACEHOLDER_SIZE)!,NSForegroundColorAttributeName:TEXT_FIELD_TEXT_PLACEHODLER_COLOR]
        title_field.text = "Enter the title...(\(TEXT_FIELD_MAX_CHARACTERS_TITLE) characters max)"
        title_field.layer.borderWidth = TEXT_FIELD_BORDER_WIDTH_NORMAL
        title_field.layer.borderColor = TEXT_FIELD_BORDER_COLOR_NORMAL.CGColor
        title_field.layer.cornerRadius = TEXT_FIELD_CORNER_RADIUS
        title_field.delegate = self
        title_field.frame = CGRect(x: title_field.frame.minX, y: title_field.frame.minY, width: title_field.bounds.width, height: title_field.contentSize.height)
        gender_head_label = UILabel(frame: CGRect(x: HEAD_LABEL_MARGIN_LEFT, y: title_field.frame.maxY + HEAD_LABEL_MARGIN_TOP_BETWEEN, width: view.bounds.width - HEAD_LABEL_MARGIN_LEFT, height: 40))
        gender_head_label.text = "Select gender"
        gender_head_label.font = title_head_label.font
        gender_head_label.textColor = title_head_label.textColor
        configureHeadLabel(gender_head_label)
        gender_mw_button = createGenderButtonWithNo(0)
        gender_ww_button = createGenderButtonWithNo(1)
        gender_mm_button = createGenderButtonWithNo(2)
        gender_wm_button = createGenderButtonWithNo(3)
        body_head_label = UILabel(frame: CGRect(x: HEAD_LABEL_MARGIN_LEFT, y: gender_mm_button.frame.maxY + HEAD_LABEL_MARGIN_TOP_BETWEEN, width: view.bounds.width - HEAD_LABEL_MARGIN_LEFT, height: 40))
        body_head_label.font = gender_head_label.font
        body_head_label.textColor = gender_head_label.textColor
        body_head_label.text = "Body"
        configureHeadLabel(body_head_label)
        body_field = UITextView(frame: CGRect(x: TEXT_FIELD_MARGIN_SIDES, y: body_head_label.frame.maxY + TEXT_FIELD_MARGIN_TOP, width: view.bounds.width - 2.0 * TEXT_FIELD_MARGIN_SIDES, height: TEXT_FIELD_MIN_HEIGHT))
        body_field.typingAttributes = [NSFontAttributeName:UIFont(name: "SFUIText-Regular", size: TEXT_FIELD_TEXT_PLACEHOLDER_SIZE)!,NSForegroundColorAttributeName:TEXT_FIELD_TEXT_PLACEHODLER_COLOR]
        body_field.text = "Enter the body... (\(TEXT_FIELD_MAX_CHARACTERS_BODY) characters max)"
        body_field.layer.borderWidth = TEXT_FIELD_BORDER_WIDTH_NORMAL
        body_field.layer.borderColor = TEXT_FIELD_BORDER_COLOR_NORMAL.CGColor
        body_field.layer.cornerRadius = TEXT_FIELD_CORNER_RADIUS
        body_field.delegate = self
        body_field.frame = CGRect(x: body_field.frame.minX, y: body_field.frame.minY, width: body_field.bounds.width, height: body_field.contentSize.height)
        meeting_time_head_label = UILabel(frame: CGRect(x: HEAD_LABEL_MARGIN_LEFT, y: body_field.frame.maxY + HEAD_LABEL_MARGIN_TOP_BETWEEN, width: view.bounds.width - HEAD_LABEL_MARGIN_LEFT, height: 40))
        meeting_time_head_label.font = body_head_label.font
        meeting_time_head_label.textColor = body_head_label.textColor
        meeting_time_head_label.text = "When did you meet"
        configureHeadLabel(meeting_time_head_label)
        let yesterday_date = NSDate(timeInterval: -24.0 * 60.0 * 60.0, sinceDate: NSDate())
        let yest_date_comp = NSCalendar.currentCalendar().components([NSCalendarUnit.Day,NSCalendarUnit.Month,NSCalendarUnit.Year], fromDate: yesterday_date)
        let total_upper_labels_text = "DayMonthYear"
        let total_times_fields_width = view.bounds.width - 7.0 * MEETING_TIME_SPACING - 3.0 * MEETING_TIME_FIELD_MIN_WIDTH
        let time_label_font_size = General.getFontSizeToFitWidth(total_times_fields_width, forString: total_upper_labels_text, withFontName: "SFUIText-Regular")
        let now_time_labels_total_width = (total_upper_labels_text as! NSString).sizeWithAttributes([NSFontAttributeName:UIFont(name: "SFUIText-Regular", size: time_label_font_size)!]).width
        let final_time_field_width = (view.bounds.width - 7.0 * MEETING_TIME_SPACING - now_time_labels_total_width) / 3.0
        meeting_time_day_label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        meeting_time_day_label.textColor = body_head_label.textColor
        meeting_time_day_label.font = UIFont(name: "SFUIText-Regular", size: time_label_font_size)!
        meeting_time_day_label.text = "Day"
        let final_day_label_size = meeting_time_day_label.textRectForBounds(meeting_time_day_label.bounds, limitedToNumberOfLines: 1)
        day_field = UITextView(frame: CGRect(x: MEETING_TIME_SPACING * 2.0 + final_day_label_size.width, y: meeting_time_head_label.frame.maxY + TEXT_FIELD_MARGIN_TOP, width: final_time_field_width, height: TEXT_FIELD_MIN_HEIGHT))
        day_field.typingAttributes = [NSFontAttributeName:UIFont(name: "SFUIText-Regular", size: TEXT_FIELD_TEXT_NORMAL_SIZE)!,NSForegroundColorAttributeName:TEXT_FIELD_TEXT_NORMAL_COLOR]
        day_field.text = "\(yest_date_comp.day)"
        day_field.layer.borderWidth = TEXT_FIELD_BORDER_WIDTH_NORMAL
        day_field.layer.borderColor = TEXT_FIELD_BORDER_COLOR_NORMAL.CGColor
        day_field.layer.cornerRadius = TEXT_FIELD_CORNER_RADIUS
        day_field.delegate = self
        day_field.frame = CGRect(x: day_field.frame.minX, y: day_field.frame.minY, width: day_field.bounds.width, height: day_field.contentSize.height)
        meeting_time_day_label.frame = CGRect(x: MEETING_TIME_SPACING, y: day_field.frame.midY - 0.5 * final_day_label_size.height, width: final_day_label_size.width, height: final_day_label_size.height)
        meeting_time_month_label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        meeting_time_month_label.text = "Month"
        meeting_time_month_label.textColor = meeting_time_day_label.textColor
        meeting_time_month_label.font = meeting_time_day_label.font
        let final_month_label_size = meeting_time_month_label.textRectForBounds(meeting_time_month_label.bounds, limitedToNumberOfLines: 1)
        meeting_time_month_label.frame = CGRect(x: day_field.frame.maxX + MEETING_TIME_SPACING, y: meeting_time_day_label.frame.midY - 0.5 * final_month_label_size.height, width: final_month_label_size.width, height: final_month_label_size.height)
        meeting_time_year_label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        meeting_time_year_label.text = "Year"
        meeting_time_year_label.font = meeting_time_month_label.font
        meeting_time_year_label.textColor = meeting_time_month_label.textColor
        let final_year_label_size = meeting_time_year_label.textRectForBounds(meeting_time_year_label.bounds, limitedToNumberOfLines: 1)
        meeting_time_year_label.frame = CGRect(x: meeting_time_month_label.frame.maxX + MEETING_TIME_SPACING * 2.0 + final_time_field_width, y: meeting_time_month_label.frame.midY - 0.5 * final_year_label_size.height, width: final_year_label_size.width, height: final_year_label_size.height)
        month_field = UITextView(frame: CGRect(x: day_field.frame.maxX + MEETING_TIME_SPACING * 2.0 + final_month_label_size.width, y: day_field.frame.minY, width: final_time_field_width, height: TEXT_FIELD_MIN_HEIGHT))
        month_field.typingAttributes = day_field.typingAttributes
        month_field.text = "\(yest_date_comp.month)"
        month_field.layer.borderWidth = TEXT_FIELD_BORDER_WIDTH_NORMAL
        month_field.layer.borderColor = TEXT_FIELD_BORDER_COLOR_NORMAL.CGColor
        month_field.layer.cornerRadius = TEXT_FIELD_CORNER_RADIUS
        month_field.delegate = self
        month_field.frame = CGRect(x: month_field.frame.minX, y: month_field.frame.minY, width: month_field.bounds.width, height: month_field.contentSize.height)
        year_field = UITextView(frame: CGRect(x: meeting_time_year_label.frame.maxX + MEETING_TIME_SPACING, y: month_field.frame.minY, width: final_time_field_width, height: TEXT_FIELD_MIN_HEIGHT))
        year_field.typingAttributes = month_field.typingAttributes
        year_field.text = "\(yest_date_comp.year)"
        year_field.layer.borderWidth = TEXT_FIELD_BORDER_WIDTH_NORMAL
        year_field.layer.borderColor = TEXT_FIELD_BORDER_COLOR_NORMAL.CGColor
        year_field.layer.cornerRadius = TEXT_FIELD_CORNER_RADIUS
        year_field.delegate = self
        year_field.frame = CGRect(x: year_field.frame.minX, y: year_field.frame.minY, width: year_field.bounds.width, height: year_field.contentSize.height)
        let bottom_label_total_text = "HoursMinutes"
        let bottom_text_total_width = (bottom_label_total_text as! NSString).sizeWithAttributes([NSFontAttributeName:UIFont(name: "SFUIText-Regular", size: time_label_font_size)!]).width
        let bottom_total_width = bottom_text_total_width + 3.0 * MEETING_TIME_SPACING + final_time_field_width * 2.0
        let left_margin = (view.bounds.width - bottom_total_width) * 0.5
        meeting_time_hour_label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        meeting_time_hour_label.text = "Hours"
        meeting_time_hour_label.font = meeting_time_year_label.font
        meeting_time_hour_label.textColor = meeting_time_year_label.textColor
        let final_hour_label_size = meeting_time_hour_label.textRectForBounds(meeting_time_hour_label.bounds, limitedToNumberOfLines: 1)
        hour_field = UITextView(frame: CGRect(x: left_margin + MEETING_TIME_SPACING + final_hour_label_size.width, y: month_field.frame.maxY + TEXT_FIELD_MARGIN_TOP, width: final_time_field_width, height: TEXT_FIELD_MIN_HEIGHT))
        hour_field.typingAttributes = year_field.typingAttributes
        hour_field.text = "???"
        hour_field.layer.borderWidth = TEXT_FIELD_BORDER_WIDTH_NORMAL
        hour_field.layer.borderColor = TEXT_FIELD_BORDER_COLOR_NORMAL.CGColor
        hour_field.layer.cornerRadius = TEXT_FIELD_CORNER_RADIUS
        hour_field.delegate = self
        hour_field.frame = CGRect(x: hour_field.frame.minX, y: hour_field.frame.minY, width: hour_field.bounds.width, height: hour_field.contentSize.height)
        meeting_time_hour_label.frame = CGRect(x: left_margin, y: hour_field.frame.midY - 0.5 * final_hour_label_size.height, width: final_hour_label_size.width, height: final_hour_label_size.height)
        meeting_time_minute_label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        meeting_time_minute_label.font = meeting_time_hour_label.font
        meeting_time_minute_label.textColor = meeting_time_hour_label.textColor
        meeting_time_minute_label.text = "Minutes"
        let final_minutes_label_size = meeting_time_minute_label.textRectForBounds(meeting_time_minute_label.bounds, limitedToNumberOfLines: 1)
        meeting_time_minute_label.frame = CGRect(x: hour_field.frame.maxX + MEETING_TIME_SPACING, y: meeting_time_hour_label.frame.midY - 0.5 * final_minutes_label_size.height, width: final_minutes_label_size.width, height: final_minutes_label_size.height)
        minute_field = UITextView(frame: CGRect(x: meeting_time_minute_label.frame.maxX + MEETING_TIME_SPACING, y: hour_field.frame.minY, width: final_time_field_width, height: TEXT_FIELD_MIN_HEIGHT))
        minute_field.typingAttributes = hour_field.typingAttributes
        minute_field.text = "???"
        minute_field.layer.borderWidth = TEXT_FIELD_BORDER_WIDTH_NORMAL
        minute_field.layer.borderColor = TEXT_FIELD_BORDER_COLOR_NORMAL.CGColor
        minute_field.layer.cornerRadius = TEXT_FIELD_CORNER_RADIUS
        minute_field.delegate = self
        minute_field.frame = CGRect(x: minute_field.frame.minX, y: minute_field.frame.minY, width: minute_field.bounds.width, height: minute_field.contentSize.height)
        minute_field.keyboardType = .NumberPad
        day_field.keyboardType = .NumberPad
        month_field.keyboardType = .NumberPad
        year_field.keyboardType = .NumberPad
        hour_field.keyboardType = .NumberPad
        configureQuestionButtonWithTextView(day_field)
        configureQuestionButtonWithTextView(month_field)
        configureQuestionButtonWithTextView(hour_field)
        configureQuestionButtonWithTextView(minute_field)
        let loc_button_width = view.bounds.width * MEETING_PLACE_LOCATION_BUTTON_WIDTH_RELATIVE
        meeting_place_head_label = UILabel(frame: CGRect(x: HEAD_LABEL_MARGIN_LEFT, y: hour_field.frame.maxY + HEAD_LABEL_MARGIN_TOP_BETWEEN, width: view.bounds.width - HEAD_LABEL_MARGIN_LEFT, height: 40))
        meeting_place_head_label.text = "Where did you meet"
        meeting_place_head_label.textColor = meeting_time_head_label.textColor
        meeting_place_head_label.font = meeting_time_head_label.font
        configureHeadLabel(meeting_place_head_label)
        meeting_place_segmented_control = UISegmentedControl(items: ["Location" as! NSString, "Transport" as! NSString])
        meeting_place_segmented_control.frame = CGRect(x: 30, y: meeting_place_head_label.frame.maxY + MEETING_PLACE_SEGMENTED_MARGIN_TOP, width: 200, height: 50)
        meeting_place_segmented_control.tintColor = MEETING_PLACE_SEGMENTED_COLOR
        meeting_place_segmented_control.sizeToFit()
        meeting_place_segmented_control.selectedSegmentIndex = 0
        meeting_place_segmented_control.addTarget(self, action: "meetingPlaceSegmentedPressed:", forControlEvents: .ValueChanged)
        meeting_place_transport_text_posting_zone = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 100))
        meeting_place_transport_text_posting_zone.text = "You are going to post to \(current_area_title) zone"
        meeting_place_transport_text_posting_zone.textColor = MEETING_PLACE_LOCATION_TEXT_FONT_COLOR
        meeting_place_transport_text_posting_zone.font = UIFont(name: "SFUIText-Regular", size: MEETING_PLACE_TRANSPORT_TEXT_ZONE_FONT_SIZE)!
        let real_size_tt = meeting_place_transport_text_posting_zone.textRectForBounds(meeting_place_transport_text_posting_zone.bounds, limitedToNumberOfLines: 1)
        meeting_place_transport_text_posting_zone.textAlignment = .Center
        meeting_place_transport_text_posting_zone.frame = CGRect(x: 0, y: meeting_place_segmented_control.frame.maxY + LOCATION_LABEL_MARGIN_TOP, width: view.bounds.width, height: real_size_tt.height)
        meeting_place_segmented_control.center.x = 0.5 * view.bounds.width
        meeting_place_frame_location = CAShapeLayer()
        meeting_place_frame_location.fillColor = UIColor.clearColor().CGColor
        meeting_place_frame_location.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: view.bounds.width - 2.0 * MEETING_PLACE_FRAME_MARGIN_SIDES, height: MEETING_PLACE_FRAME_LOCATION_HEIGHT), cornerRadius: MEETING_PLACE_FRAME_CORNER_RADIUS).CGPath
        meeting_place_frame_location.lineDashPattern = FRAME_UNSET_DASH
        meeting_place_frame_location.frame = CGRect(x: MEETING_PLACE_FRAME_MARGIN_SIDES, y: meeting_place_segmented_control.frame.maxY + MEETING_PLACE_FRAME_MARGIN_SIDES, width: view.bounds.width - 2.0 * MEETING_PLACE_FRAME_MARGIN_SIDES, height: MEETING_PLACE_FRAME_LOCATION_HEIGHT)
        meeting_place_frame_location.lineWidth = FRAME_BORDER_WIDTH
        meeting_place_frame_location.strokeColor = FRAME_BORDER_COLOR.CGColor
        let trans_frame_path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: view.bounds.width - 2.0 * MEETING_PLACE_FRAME_MARGIN_SIDES, height: MEETING_PLACE_FRAME_TRANSPORT_HEIGHT), cornerRadius: MEETING_PLACE_FRAME_CORNER_RADIUS)
        meeting_place_frame_transport = CAShapeLayer()
        //meeting_place_frame_transport.masksToBounds = true
        meeting_place_frame_transport.frame = CGRect(x: meeting_place_frame_location.frame.minX, y: meeting_place_transport_text_posting_zone.frame.maxY + MEETING_PLACE_FRAME_MARGIN_SIDES, width: meeting_place_frame_location.bounds.width, height: MEETING_PLACE_FRAME_TRANSPORT_HEIGHT)
        meeting_place_frame_transport.path = trans_frame_path.CGPath
        meeting_place_frame_transport.lineWidth = meeting_place_frame_location.lineWidth
        meeting_place_frame_transport.lineDashPattern = meeting_place_frame_location.lineDashPattern
        meeting_place_frame_transport.strokeColor = meeting_place_frame_location.strokeColor
        meeting_place_frame_transport.position.x += view.bounds.width
        meeting_place_frame_transport.fillColor = UIColor.clearColor().CGColor
        meeting_place_location_view = UIView(frame: CGRect(x: meeting_place_frame_location.frame.minX, y: meeting_place_frame_location.frame.minY, width: meeting_place_frame_location.bounds.width, height: meeting_place_frame_location.frame.height + loc_button_width * MEETING_PLACE_LOCATION_BUTTON_ASPECT + MEETING_PLACE_LOCATION_BUTTON_MARGIN_TOP))
        meeting_place_location_view.backgroundColor = UIColor.clearColor()
        meeting_place_transport_view = UIView(frame: CGRect(x: meeting_place_frame_transport.frame.minX + FRAME_BORDER_WIDTH, y: meeting_place_frame_transport.frame.minY, width: meeting_place_frame_transport.bounds.width - 2.0 * FRAME_BORDER_WIDTH, height: meeting_place_frame_transport.bounds.height + 60))
        meeting_place_transport_view.backgroundColor = UIColor.clearColor()
        let loc_img = UIImageView(image: UIImage(named: "add_post_location_placeholder_icon")!)
        let loc_img_width = view.bounds.width * MEETING_PLACE_LOCATION_PLACEHOLDER_IMAGE_WIDTH_RELATIVE
        loc_img.frame = CGRect(x: 0.5 * meeting_place_location_view.bounds.width - 0.5 * loc_img_width, y: MEETING_PLACE_LOCATION_PLACEHOLDER_IMAGE_MARGIN_TOP, width: loc_img_width, height: loc_img_width * MEETING_PLACE_LOCATION_PLACEHOLDER_IMAGE_ASPECT)
        meeting_place_location_view.addSubview(loc_img)
        meeting_place_location_text = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        meeting_place_location_text.text = "Tap to pin a location"
        meeting_place_location_text.font = UIFont(name: "SFUIText-Medium", size: MEETING_PLACE_LOCATION_TEXT_FONT_SIZE)!
        meeting_place_location_text.textColor = MEETING_PLACE_LOCATION_TEXT_FONT_COLOR
        let final_loc_text_size = meeting_place_location_text.textRectForBounds(meeting_place_location_text.bounds, limitedToNumberOfLines: 1)
        //meeting_place_location_text.frame = CGRect(x: 0.5 * meeting_place_location_view.bounds.width - 0.5 * final_loc_text_size.width, y: (meeting_place_frame_location.bounds.height - loc_img.frame.maxY) * 0.5 + loc_img.frame.maxY - 0.5 * final_loc_text_size.height, width: final_loc_text_size.width, height: final_loc_text_size.height)
        meeting_place_location_text.textAlignment = .Center
        meeting_place_location_text.frame = CGRect(x: 0, y: (meeting_place_frame_location.bounds.height - loc_img.frame.maxY) * 0.5 + loc_img.frame.maxY - 0.5 * final_loc_text_size.height, width: meeting_place_location_view.bounds.width, height: final_loc_text_size.height)
        meeting_place_location_view.addSubview(meeting_place_location_text)
        meeting_place_location_map_img = UIImageView(frame: meeting_place_frame_location.bounds)
        //meeting_place_location_map_img.backgroundColor = MEETING_PLACE_LOCATION_TEXT_FONT_COLOR
        //meeting_place_location_map_img.alpha = 0.0
        //meeting_place_location_map_img.hidden = true
        meeting_place_location_map_img.layer.cornerRadius = MEETING_PLACE_FRAME_CORNER_RADIUS
        meeting_place_location_map_img.backgroundColor = UIColor.clearColor()
        meeting_place_location_map_img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "meetingPlaceLocationPressed:"))
        meeting_place_location_map_img.userInteractionEnabled = true
        meeting_place_location_view.addSubview(meeting_place_location_map_img)
        loc_tap_recog = UITapGestureRecognizer(target: self, action: "meetingPlaceLocationPressed:")
        loc_tap_recog.delegate = self
        meeting_place_location_view.addGestureRecognizer(loc_tap_recog)
        meeting_place_location_view.userInteractionEnabled = true
        meeting_place_transport_text = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        meeting_place_transport_text.text = "Select an appropriate icon"
        meeting_place_transport_text.textColor = meeting_place_location_text.textColor
        meeting_place_transport_text.font = meeting_place_location_text.font
        let final_trans_text_size = meeting_place_transport_text.textRectForBounds(meeting_place_transport_text.bounds, limitedToNumberOfLines: 1)
        meeting_place_transport_text.frame = CGRect(x: 0.5 * meeting_place_transport_view.bounds.width - 0.5 * final_trans_text_size.width, y: meeting_place_frame_transport.bounds.height + MEETING_PLACE_TRANSPORT_TEXT_MARGIN_TOP, width: final_trans_text_size.width, height: final_trans_text_size.height)
        meeting_place_transport_view.addSubview(meeting_place_transport_text)
        let loc_button = UIButton(type: .Custom)
        loc_button.frame = CGRect(x: 0.5 * meeting_place_location_view.bounds.width - 0.5 * loc_button_width, y: meeting_place_frame_location.bounds.height + MEETING_PLACE_LOCATION_BUTTON_MARGIN_TOP, width: loc_button_width, height: loc_button_width * MEETING_PLACE_LOCATION_BUTTON_ASPECT)
        loc_button.setBackgroundImage(UIImage(named: "add_post_current_location_button_bg"), forState: .Normal)
        loc_button.titleLabel!.font = UIFont(name: "SFUIText-Medium", size: MEETING_PLACE_LOCATION_BUTTON_MAX_FONT_SIZE)!
        loc_button.setTitle("Add current location", forState: .Normal)
        loc_button.setTitleColor(UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1.0), forState: .Normal)
        loc_button.addTarget(self, action: "addCurrentLocationButtonPressed:", forControlEvents: .TouchUpInside)
        meeting_place_location_view.addSubview(loc_button)
        let collection_height = TRANSPORT_CELL_HEIGHT_RELATIVE * meeting_place_frame_transport.bounds.height
        let transport_layout = UICollectionViewFlowLayout()
        transport_layout.scrollDirection = .Horizontal
        transport_layout.itemSize = CGSizeMake(collection_height, collection_height)
        transport_layout.minimumLineSpacing = TRANSPORT_CELL_MARGIN_INTER
        transport_layout.sectionInset = UIEdgeInsetsMake(0, TRANSPORT_CELL_MARGIN_SIDES, 0, TRANSPORT_CELL_MARGIN_SIDES)
        transport_collection = UICollectionView(frame: CGRect(x: 0, y: (meeting_place_frame_transport.bounds.height - collection_height) * 0.5, width: meeting_place_transport_view.bounds.width, height: collection_height), collectionViewLayout: transport_layout)
        transport_collection.backgroundColor = UIColor.clearColor()
        transport_collection.registerClass(TransportCell.self, forCellWithReuseIdentifier: "trans_cell")
        transport_collection.dataSource = self
        transport_collection.delegate = self
        transport_collection.showsHorizontalScrollIndicator = false
        meeting_place_transport_view.addSubview(transport_collection)
        photo_head_label = UILabel(frame: CGRect(x: HEAD_LABEL_MARGIN_LEFT, y: meeting_place_location_view.convertRect(loc_button.frame, toView: scroll_view).maxY + HEAD_LABEL_MARGIN_TOP_BETWEEN, width: view.bounds.width - 2.0 * HEAD_LABEL_MARGIN_LEFT, height: 50))
        photo_head_label.text = "Add photos(optional)"
        photo_head_label.font = meeting_place_head_label.font
        photo_head_label.textColor = meeting_place_head_label.textColor
        configureHeadLabel(photo_head_label)
        let ph_rect_width = view.bounds.width * PHOTO_RECT_WIDTH_RELATIVE
        ph_rect_1 = CAShapeLayer()
        let ph_rect_path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: ph_rect_width, height: ph_rect_width), cornerRadius: MEETING_PLACE_FRAME_CORNER_RADIUS)
        let ph_rect_spacing = (view.bounds.width - 2.0 * ph_rect_width) / 3.0
        ph_rect_1.frame = CGRect(x: ph_rect_spacing, y: photo_head_label.frame.maxY
        + PHOTO_RECT_MARGIN_TOP, width: ph_rect_width, height: ph_rect_width)
        ph_rect_1.path = ph_rect_path.CGPath
        ph_rect_1.lineWidth = FRAME_BORDER_WIDTH
        ph_rect_1.lineDashPattern = FRAME_UNSET_DASH
        ph_rect_1.strokeColor = FRAME_BORDER_COLOR.CGColor
        ph_rect_1.fillColor = UIColor.clearColor().CGColor
        ph_rect_2 = CAShapeLayer()
        ph_rect_2.path = ph_rect_path.CGPath
        ph_rect_2.lineDashPattern = FRAME_UNSET_DASH
        ph_rect_2.lineWidth = FRAME_BORDER_WIDTH
        ph_rect_2.strokeColor = FRAME_BORDER_COLOR.CGColor
        ph_rect_2.fillColor = UIColor.clearColor().CGColor
        ph_rect_2.frame = CGRect(x: ph_rect_1.frame.maxX + ph_rect_spacing, y: ph_rect_1.frame.minY, width: ph_rect_width, height: ph_rect_width)
        ph_view_1 = UIView()
        ph_view_1.layer.cornerRadius = PHOTO_RECT_CORNER_RADIUS
        ph_view_1.layer.masksToBounds = true
        ph_view_1.frame = CGRectInset(ph_rect_1.frame, FRAME_BORDER_WIDTH, FRAME_BORDER_WIDTH)
        ph_view_1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "addPhotoButtonPressed:"))
        ph_view_1.userInteractionEnabled = true
        ph_view_2 = UIView()
        ph_view_2.layer.cornerRadius = PHOTO_RECT_CORNER_RADIUS
        ph_view_2.layer.masksToBounds = true
        ph_view_2.frame = CGRectInset(ph_rect_2.frame, FRAME_BORDER_WIDTH, FRAME_BORDER_WIDTH)
        ph_view_2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "addPhotoButtonPressed:"))
        ph_view_2.userInteractionEnabled = true
        ph_view_1.addSubview(createPlaceholderAddPhotoIconWithWidth(ph_view_1.bounds.width))
        ph_view_2.addSubview(createPlaceholderAddPhotoIconWithWidth(ph_view_2.bounds.width))
        ph_img_1 = UIImageView(frame: ph_view_1.bounds)
        ph_img_1.backgroundColor = UIColor.clearColor()
        ph_img_1.contentMode = .ScaleAspectFill
        ph_img_1.alpha = 0.0
        ph_img_1.hidden = true
        ph_img_2 = UIImageView(frame: ph_view_2.bounds)
        ph_img_2.backgroundColor = UIColor.clearColor()
        ph_img_2.contentMode = .ScaleAspectFill
        ph_img_2.alpha = 0.0
        ph_img_2.hidden = true
        ph_view_1.addSubview(ph_img_1)
        ph_view_2.addSubview(ph_img_2)
        img_picker = UIImagePickerController()
        img_picker.mediaTypes = [kUTTypeImage as String]
        img_picker.delegate = self
        post_button = UIButton(type: .Custom)
        post_button.setBackgroundImage(UIImage(named: "post_button_bg")!, forState: .Normal)
        post_button.setTitle("POST", forState: .Normal)
        post_button.addTarget(self, action: "postButtonPressed:", forControlEvents: .TouchUpInside)
        post_button.frame = CGRect(x: 0, y: ph_view_1.frame.maxY + POST_BUTTON_MARGIN_TOP, width: view.bounds.width, height: POST_BUTTON_HEIGHT)
        meeting_place_transport_text_posting_zone.center.x = meeting_place_transport_view.center.x
        scroll_view.contentSize = CGSizeMake(view.bounds.width, post_button.frame.maxY)
        scroll_view.addSubview(title_head_label)
        scroll_view.addSubview(title_field)
        scroll_view.addSubview(gender_head_label)
        scroll_view.addSubview(gender_mm_button)
        scroll_view.addSubview(gender_mw_button)
        scroll_view.addSubview(gender_ww_button)
        scroll_view.addSubview(gender_wm_button)
        scroll_view.addSubview(body_head_label)
        scroll_view.addSubview(body_field)
        scroll_view.addSubview(meeting_time_head_label)
        scroll_view.addSubview(meeting_time_day_label)
        scroll_view.addSubview(meeting_time_month_label)
        scroll_view.addSubview(meeting_time_year_label)
        scroll_view.addSubview(day_field)
        scroll_view.addSubview(month_field)
        scroll_view.addSubview(year_field)
        scroll_view.addSubview(minute_field)
        scroll_view.addSubview(hour_field)
        scroll_view.addSubview(meeting_time_hour_label)
        scroll_view.addSubview(meeting_time_minute_label)
        scroll_view.addSubview(meeting_place_head_label)
        scroll_view.addSubview(meeting_place_segmented_control)
        scroll_view.addSubview(meeting_place_transport_text_posting_zone)
        scroll_view.layer.addSublayer(meeting_place_frame_location)
        scroll_view.layer.addSublayer(meeting_place_frame_transport)
        scroll_view.addSubview(meeting_place_location_view)
        scroll_view.addSubview(meeting_place_transport_view)
        scroll_view.addSubview(photo_head_label)
        scroll_view.addSubview(ph_view_1)
        scroll_view.addSubview(ph_view_2)
        scroll_view.layer.addSublayer(ph_rect_1)
        scroll_view.layer.addSublayer(ph_rect_2)
        scroll_view.addSubview(post_button)
        view.addSubview(scroll_view)
        prev_title_field_height = title_field.bounds.height
        prev_body_field_height = body_field.bounds.height
        prev_meeting_place_height = meeting_place_location_view.frame.maxY - meeting_place_segmented_control.frame.maxY
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var should_show_image = true
        if currently_picking_photo_1 ? photo_picked_1 : photo_picked_2 {
            should_show_image = false
        }
        if should_show_image {
            if currently_picking_photo_1 {
                ph_img_1.image = info[UIImagePickerControllerOriginalImage] as! UIImage
                ph_img_1.hidden = false
                photo_picked_1 = true
            }
            else {
                ph_img_2.image = info[UIImagePickerControllerOriginalImage] as! UIImage
                ph_img_2.hidden = false
                photo_picked_2 = true
            }
        }
        picker.dismissViewControllerAnimated(true, completion: {
            if should_show_image {
                if self.currently_picking_photo_1 {
                    self.ph_rect_1.lineDashPattern = nil
                }
                else {
                    self.ph_rect_2.lineDashPattern = nil
                }
                UIView.animateWithDuration(self.ANIMATION_MINOR_DURATION, animations: {
                    if self.currently_picking_photo_1 {
                        self.ph_img_1.alpha = 1.0
                    }
                    else {
                        self.ph_img_2.alpha = 1.0
                    }
                })
            }
            else {
                UIView.transitionWithView(self.currently_picking_photo_1 ? self.ph_img_1 : self.ph_img_2, duration: self.ANIMATION_MINOR_DURATION, options: .TransitionCrossDissolve, animations: {
                    if self.currently_picking_photo_1 {
                        self.ph_img_1.image = info[UIImagePickerControllerOriginalImage] as! UIImage
                    }
                    else {
                        self.ph_img_2.image = info[UIImagePickerControllerOriginalImage] as! UIImage
                    }
                    }, completion: nil)
            }
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("trans_cell", forIndexPath: indexPath) as! TransportCell
        cell.layer.cornerRadius = TRANSPORT_CELL_CORNER_RADIUS
        cell.setImage(UIImage(named: "transport_icon_full_\(indexPath.row)")!)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            cell.backgroundColor = TRANSPORT_CELL_HIGH_BG_COLOR
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        meeting_place_transport_set = true
        meeting_place_frame_transport.strokeColor = FRAME_BORDER_COLOR.CGColor
        meeting_place_frame_location.strokeColor = FRAME_BORDER_COLOR.CGColor
        data_errors["meeting_place"] = false
        if current_transport_cell_selected != -1 {
            if let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: current_transport_cell_selected, inSection: 0)) {
                cell.backgroundColor = TRANSPORT_CELL_UNSEL_BG_COLOR
            }
        }
        current_transport_cell_selected = indexPath.item
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            cell.backgroundColor = TRANSPORT_CELL_SEL_BG_COLOR
        }
        UIView.animateWithDuration(ANIMATION_MINOR_DURATION, animations: {
            self.meeting_place_transport_text.alpha = 0.0
            }, completion: {
                (fin:Bool) in
                self.meeting_place_transport_text.hidden = true
                self.updatePositions()
        })
        meeting_place_frame_transport.lineDashPattern = nil
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            cell.backgroundColor = current_transport_cell_selected == indexPath.item ? TRANSPORT_CELL_SEL_BG_COLOR : TRANSPORT_CELL_UNSEL_BG_COLOR
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TRANSPORT_CELLS_COUNT
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == current_transport_cell_selected {
            cell.backgroundColor = TRANSPORT_CELL_SEL_BG_COLOR
        }
        else {
            cell.backgroundColor = TRANSPORT_CELL_UNSEL_BG_COLOR
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func createGenderButtonWithNo(no:Int) -> UIButton {
        let spacing = (view.bounds.width - 4.0 * view.bounds.width * GENDER_BUTTON_WIDTH_RELATIVE) / 5.0
        var gender_text = ""
        switch no {
        case 0:
            gender_text = "mw"
        case 1:
            gender_text = "ww"
        case 2:
            gender_text = "mm"
        case 3:
            gender_text = "wm"
        default:
            break
        }
        let begin_icon_name = "filter_\(gender_text)_icon_"
        let gender_button = UIButton(type: .Custom)
        gender_button.frame = CGRect(x: spacing * CGFloat(1 + no) + CGFloat(no) * view.bounds.width * GENDER_BUTTON_WIDTH_RELATIVE, y: gender_head_label.frame.maxY + GENDER_BUTTON_MARGIN_TOP, width: view.bounds.width * GENDER_BUTTON_WIDTH_RELATIVE, height: view.bounds.width * GENDER_BUTTON_WIDTH_RELATIVE * GENDER_BUTTON_ASPECT)
        gender_button.setBackgroundImage(UIImage(named: "\(begin_icon_name)off"), forState: .Normal)
        gender_button.setBackgroundImage(UIImage(named: "\(begin_icon_name)on"), forState: .Selected)
        if no == 0 {
            gender_button.selected = true
        }
        gender_button.addTarget(self, action: "genderButtonPressed:", forControlEvents: .TouchUpInside)
        return gender_button
    }
    
    func configureQuestionButtonWithTextView(textView:UITextView) {
        let button_q = UIButton(type: .Custom)
        var tag = -1
        switch textView{
        case day_field:
            tag = 1
        case month_field:
            tag = 2
        case hour_field:
            tag = 4
        case minute_field:
            tag = 5
        default:
            break
        }
        button_q.tag = tag
        button_q.frame = CGRect(x: textView.bounds.width - TEXT_FIELD_QUESTION_BUTTON_WIDTH - TEXT_FIELD_QUESTION_BUTTON_MARGIN_RIGHT, y: 0, width: TEXT_FIELD_QUESTION_BUTTON_WIDTH, height: textView.bounds.height)
        button_q.setImage(UIImage(named: "text_field_question_mark_icon")!, forState: .Normal)
        let q_image_height = textView.bounds.height * TEXT_FIELD_QUESTION_BUTTON_IMAGE_HEIGHT_RELATIVE
        let q_image_width = q_image_height / TEXT_FIELD_QUESTION_BUTTON_IMAGE_ASPECT
        let top_edge = (textView.bounds.height - q_image_height) * 0.5
        let sides_edge = (button_q.bounds.width - q_image_width) * 0.5
        button_q.imageEdgeInsets = UIEdgeInsetsMake(top_edge, sides_edge, top_edge, sides_edge)
        button_q.addTarget(self, action: "textViewQuestionButtonPressed:", forControlEvents: .TouchUpInside)
        textView.addSubview(button_q)
    }
    
    func updatePositions() {
        let title_height_dif = title_field.frame.height - prev_title_field_height
        let body_height_dif = body_field.frame.height - prev_body_field_height
        var now_segmented_height:CGFloat = 0
        if meeting_place_segmented_control.selectedSegmentIndex == 0 {
            now_segmented_height = meeting_place_location_view.frame.maxY - meeting_place_segmented_control.frame.maxY
        }
        else {
            if meeting_place_transport_text.hidden {
                now_segmented_height = meeting_place_frame_transport.frame.maxY - meeting_place_segmented_control.frame.maxY
            }
            else {
                now_segmented_height = scroll_view.convertRect(meeting_place_transport_text.frame, fromView: meeting_place_transport_view).maxY - meeting_place_segmented_control.frame.maxY
            }
        }
        let bottom_point_dif = now_segmented_height - prev_meeting_place_height
        prev_meeting_place_height = now_segmented_height
        prev_title_field_height = title_field.frame.height
        prev_body_field_height = body_field.frame.height
        UIView.animateWithDuration(ANIMATION_MINOR_DURATION, animations: {
            self.post_button.center.y += bottom_point_dif + title_height_dif + body_height_dif
            self.ph_view_1.center.y += bottom_point_dif + title_height_dif + body_height_dif
            self.ph_view_2.center.y += bottom_point_dif + title_height_dif + body_height_dif
            self.ph_rect_1.position.y += bottom_point_dif + title_height_dif + body_height_dif
            self.ph_rect_2.position.y += bottom_point_dif + title_height_dif + body_height_dif
            self.photo_head_label.center.y += bottom_point_dif + title_height_dif + body_height_dif
            self.meeting_place_transport_view.center.y += title_height_dif + body_height_dif
            self.meeting_place_frame_transport.position.y += title_height_dif + body_height_dif
            self.meeting_place_transport_text_posting_zone.center.y += title_height_dif + body_height_dif
            self.meeting_place_segmented_control.center.y += title_height_dif + body_height_dif
            self.meeting_place_location_view.center.y += title_height_dif + body_height_dif
            self.meeting_place_frame_location.position.y += title_height_dif + body_height_dif
            self.meeting_place_head_label.center.y += title_height_dif + body_height_dif
            self.day_field.center.y += title_height_dif + body_height_dif
            self.year_field.center.y += title_height_dif + body_height_dif
            self.month_field.center.y += title_height_dif + body_height_dif
            self.minute_field.center.y += title_height_dif + body_height_dif
            self.hour_field.center.y += title_height_dif + body_height_dif
            self.meeting_time_day_label.center.y += title_height_dif + body_height_dif
            self.meeting_time_month_label.center.y += title_height_dif + body_height_dif
            self.meeting_time_year_label.center.y += title_height_dif + body_height_dif
            self.meeting_time_minute_label.center.y += title_height_dif + body_height_dif
            self.meeting_time_hour_label.center.y += title_height_dif + body_height_dif
            self.meeting_time_head_label.center.y += title_height_dif + body_height_dif
            self.body_field.center.y += title_height_dif
            self.body_head_label.center.y += title_height_dif
            self.gender_mm_button.center.y += title_height_dif
            self.gender_mw_button.center.y += title_height_dif
            self.gender_wm_button.center.y += title_height_dif
            self.gender_ww_button.center.y += title_height_dif
            self.gender_head_label.center.y += title_height_dif
            }, completion: nil)
        
        scroll_view.contentSize = CGSizeMake(view.bounds.width, post_button.frame.maxY)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        now_editing_field = true
        current_editing_frame = textView.frame
        textView.layer.borderWidth = TEXT_FIELD_BORDER_WIDTH_ACTIVE
        textView.layer.borderColor = TEXT_FIELD_BORDER_COLOR_ACTIVE.CGColor
        var should_start_normal_text = false
        switch textView {
        case title_field:
            should_start_normal_text = title_field_empty
            title_field_empty = false
        case body_field:
            should_start_normal_text = body_field_empty
            body_field_empty = false
        default:
            break
        }
        if should_start_normal_text {
            textView.text = ""
            textView.typingAttributes = [NSFontAttributeName:UIFont(name: "SFUIText-Medium", size: TEXT_FIELD_TEXT_NORMAL_SIZE)!,NSForegroundColorAttributeName:TEXT_FIELD_TEXT_NORMAL_COLOR]
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        now_editing_field = false
        var should_fire_error = false
        if textView.text == "" {
            if textView == title_field || textView == body_field {
                 textView.typingAttributes = [NSFontAttributeName:UIFont(name: "SFUIText-Regular", size: TEXT_FIELD_TEXT_PLACEHOLDER_SIZE)!,NSForegroundColorAttributeName:TEXT_FIELD_TEXT_PLACEHODLER_COLOR]
            }
            //some localization
            switch textView {
            case title_field:
                title_field_empty = true
                should_fire_error = true
                data_errors["title"] = true
                textView.text = "Enter the title..."
            case body_field:
                body_field_empty = true
                should_fire_error = true
                data_errors["body"] = true
                textView.text = "Enter the body..."
            case year_field:
                should_fire_error = true
                data_errors["year"] = true
            default:
                textView.text = "???"
            }
        }
        else {
            if textView != body_field && textView != title_field {
                //we shoul not allow any character except numbers
                let contains_numbers_only = stringContainsNumbersOnly(textView.text as! NSString)
                if !contains_numbers_only {
                    textView.text = "???"
                    var data_key = ""
                    switch textView {
                    case day_field :
                        data_key = "day"
                    case month_field :
                        data_key = "month"
                    case year_field :
                        data_key = "year"
                    case hour_field :
                        data_key = "hour"
                    case minute_field :
                        data_key = "minute"
                    default:
                        break
                    }
                    data_errors[data_key] = false
                }
                else {
                    let text_string_length = (textView.text as! NSString).length
                    let int_date = (textView.text as! NSString).integerValue
                    switch textView {
                    case day_field:
                        if int_date <= 0 || int_date > 31 {
                            should_fire_error = true
                            data_errors["day"] = true
                        }
                        else {
                            data_errors["day"] = false
                        }
                    case month_field:
                        if int_date <= 0 || int_date > 12 {
                            should_fire_error = true
                            data_errors["month"] = true
                        }
                        else {
                            data_errors["month"] = false
                        }
                    case year_field:
                        if int_date <= 1900 || int_date > NSCalendar.currentCalendar().components([.Year], fromDate: NSDate()).year {
                            should_fire_error = true
                            data_errors["year"] = true
                        }
                        else {
                            data_errors["year"] = false
                        }
                    case hour_field:
                        if int_date > 23 {
                            should_fire_error = true
                            data_errors["hour"] = true
                        }
                        else {
                            data_errors["hour"] = false
                        }
                    case minute_field:
                        if int_date > 59 {
                            should_fire_error = true
                            data_errors["minute"] = true
                        }
                        else {
                            data_errors["minute"] = false
                        }
                    default:
                        break
                    }
                }
            }
            else {
                if textView == body_field {
                    data_errors["body"] = false
                }
                if textView == title_field {
                    data_errors["title"] = false
                }
            }
        }
        setFireErrorAtTextField(textView, fire: should_fire_error)
    }
    
    func setFireErrorAtTextField(textView:UITextView, fire:Bool) {
        if fire {
            textView.layer.borderColor = TEXT_FIELD_BORDER_COLOR_ERROR.CGColor
            textView.layer.borderWidth = TEXT_FIELD_BORDER_WIDTH_ERROR
        }
        else {
            textView.layer.borderWidth = TEXT_FIELD_BORDER_WIDTH_NORMAL
            textView.layer.borderColor = TEXT_FIELD_BORDER_COLOR_NORMAL.CGColor
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        textViewContentChangedInView(textView)
    }
    
    func textViewContentChangedInView(textView:UITextView) {
        var should_change_frame = false
        var new_text_frame = CGRectZero
        var max_field_height:CGFloat = 0
        switch textView {
        case title_field:
            max_field_height = TEXT_FIELD_TITLE_MAX_HEIGHT
        case body_field:
            max_field_height = TEXT_FIELD_BODY_MAX_HEIGHT
        default:
            return
        }
        if textView.contentSize.height < max_field_height {
            if textView.contentSize.height != textView.frame.height {
                should_change_frame = true
                new_text_frame = CGRect(x: textView.frame.minX, y: textView.frame.minY, width: textView.bounds.width, height: textView.contentSize.height)
            }
        }
        else {
            if textView.contentSize.height != max_field_height {
                should_change_frame = true
                new_text_frame = CGRect(x: textView.frame.minX, y: textView.frame.minY, width: textView.bounds.width, height: max_field_height)
            }
        }
        if should_change_frame {
            UIView.animateWithDuration(ANIMATION_MINOR_DURATION, animations: {
                textView.frame = new_text_frame
            })
            updatePositions()
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        var should_allow = true
        if textView == body_field {
            if text != " " && ((text as! NSString).length + (textView.text as! NSString).length) > TEXT_FIELD_MAX_CHARACTERS_BODY {
                should_allow = false
            }
        }
        else if textView == title_field {
            if text != " " && ((text as! NSString).length + (textView.text as! NSString).length) > TEXT_FIELD_MAX_CHARACTERS_TITLE {
                should_allow = false
            }
        }
        else {
            if text != " " && ((text as! NSString).length + (textView.text as! NSString).length) > TEXT_FIELD_MAX_CHARACTERS_DATE {
                should_allow = false
            }
            if text != " " {
                if !stringContainsNumbersOnly(text as! NSString) {
                    should_allow = false
                }
            }
        }
        return should_allow
    }
    
    func genderButtonPressed(sender:UIButton) {
        self.view.endEditing(true)
        if !sender.selected {
            gender_mm_button.selected = false
            gender_mw_button.selected = false
            gender_ww_button.selected = false
            gender_wm_button.selected = false
            sender.selected = true
        }
    }
    
    func textViewQuestionButtonPressed(sender:UIButton) {
        switch sender.tag {
        case 1:
            day_field.text = "???"
            setFireErrorAtTextField(day_field, fire: false)
            data_errors["day"] = false
        case 2:
            month_field.text = "???"
            setFireErrorAtTextField(month_field, fire: false)
            data_errors["month"] = false
        case 4:
            hour_field.text = "???"
            setFireErrorAtTextField(hour_field, fire: false)
            data_errors["hour"] = false
        case 5:
            minute_field.text = "???"
            setFireErrorAtTextField(minute_field, fire: false)
            data_errors["minute"] = false
        default:
            break
        }
    }
    
    func meetingPlaceSegmentedPressed(sender:UISegmentedControl) {
        if now_meeting_place_transition {
            sender.selectedSegmentIndex = sender.selectedSegmentIndex == 0 ? 1 : 0
            return
        }
        now_meeting_place_transition = true
        var center_x_shift = view.bounds.width
        if sender.selectedSegmentIndex == 0 {
            current_meeting_place = "location"
        }
        else {
            current_meeting_place = "transport"
            center_x_shift *= -1.0
        }
        updatePositions()
        UIView.animateWithDuration(ANIMATION_MEETING_PLACE_DURATION, delay: 0.0, options: .CurveLinear, animations: {
            self.meeting_place_transport_view.center.x += center_x_shift
            self.meeting_place_location_view.center.x += center_x_shift
            self.meeting_place_transport_text_posting_zone.center.x += center_x_shift
            }, completion: {
                (fin:Bool) in
                self.meeting_place_frame_transport.position.x = self.meeting_place_transport_view.center.x
                self.meeting_place_frame_location.position.x = self.meeting_place_location_view.center.x
                self.meeting_place_frame_location.removeAllAnimations()
                self.meeting_place_frame_transport.removeAllAnimations()
                self.now_meeting_place_transition = false
                if self.current_meeting_place == "location" && self.current_transport_cell_selected != -1 {
                    self.transport_collection.scrollToItemAtIndexPath(NSIndexPath(forItem: self.current_transport_cell_selected, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: false)
                }
                if self.current_meeting_place == "location" {
                    self.meeting_place_transport_text_posting_zone.text = "You are going to post to \(self.current_area_title) zone"
                }
                else {
                    self.setTransportPostingRecommendationEnabled(true)
                }
        })
        let trans_anim = CABasicAnimation(keyPath: "position.x")
        trans_anim.fromValue = meeting_place_frame_transport.position.x
        trans_anim.toValue = (trans_anim.fromValue as! CGFloat) + center_x_shift
        trans_anim.duration = ANIMATION_MEETING_PLACE_DURATION
        trans_anim.fillMode = kCAFillModeForwards
        trans_anim.removedOnCompletion = false
        let loc_anim = CABasicAnimation(keyPath: "position.x")
        loc_anim.duration = ANIMATION_MEETING_PLACE_DURATION
        loc_anim.fromValue = meeting_place_frame_location.position.x
        loc_anim.toValue = (loc_anim.fromValue as! CGFloat) + center_x_shift
        loc_anim.fillMode = kCAFillModeForwards
        loc_anim.removedOnCompletion = false
        meeting_place_frame_location.addAnimation(loc_anim, forKey: "center_anim")
        meeting_place_frame_transport.addAnimation(trans_anim, forKey: "center_anim")
    }
    
    func meetingPlaceLocationPressed(sender:UITapGestureRecognizer) {
        self.view.endEditing(true)
        should_listen_to_location_updates = false
        (parentViewController as! MainViewController).map_vc.removeMap()
        self.presentViewController(loc_pin_nc, animated: true, completion: nil)
    }
    
    func addCurrentLocationButtonPressed(sender:UIButton) {
        self.view.endEditing(true)
        if !current_location_added {
            let auth_status = CLLocationManager.authorizationStatus()
            if auth_status == CLAuthorizationStatus.Denied || auth_status == .Restricted || !CLLocationManager.locationServicesEnabled() {
                let alert = UIAlertController(title: "Location trouble", message: "Could not determine your location!", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                    (act:UIAlertAction) in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                }))
                presentViewController(alert, animated: true, completion: nil)
            }
            else {
                if General.location_status == "OK" {
                    setPinSelectedWithCoords(General.location_coords)
                }
                else {
                    should_listen_to_location_updates = true
                    if General.location_status != "DETERMINING" {
                        (parentViewController as! MainViewController).updateLocation()
                    }
                }
            }
        }
    }
    
    func locationPinningFinishedWithChanges(changes:Bool) {
        (parentViewController as! MainViewController).map_vc.connectMap()
        if changes {
            current_location_added = false
            selected_location_coords = loc_pin_vc.pin_coords
            if loc_pin_vc.pin_set {
                setShowingLoadingProgressOn(true)
            }
            else {
                UIView.transitionWithView(meeting_place_location_map_img, duration: ANIMATION_LOCATION_LOADING_BLINKING_DURATION, options: .TransitionCrossDissolve, animations: {
                    self.meeting_place_location_map_img.image = nil
                    }, completion: nil)
            }
        }
        if loc_pin_vc.pin_set {
            meeting_place_location_set = true
            meeting_place_frame_location.lineDashPattern = nil
            meeting_place_frame_transport.strokeColor = FRAME_BORDER_COLOR.CGColor
            meeting_place_frame_location.strokeColor = FRAME_BORDER_COLOR.CGColor
            data_errors["meeting_place"] = false
        }
        else {
            meeting_place_location_set = false
            meeting_place_frame_location.lineDashPattern = FRAME_UNSET_DASH
        }
    }
    
    func setShowingLoadingProgressOn(show:Bool) {
        if show {
            if meeting_place_location_map_img.image == nil {
                meeting_place_location_text.text = "Loading..."
            }
            else {
                UIView.animateWithDuration(ANIMATION_MINOR_DURATION, delay: 0.0, options: [.Repeat, .Autoreverse], animations: {
                    self.meeting_place_location_map_img.alpha = 0.65
                    }, completion: {
                        (fin:Bool) in
                        self.meeting_place_location_map_img.alpha = 1.0
                })
            }
        }
        else {
            meeting_place_location_map_img.layer.removeAllAnimations()
            meeting_place_location_text.text = "Tap to pin a location"
        }
    }
    
    func locationUpdated(sender:NSNotification) {
        if should_listen_to_location_updates {
            if General.location_status == "OK" {
                setPinSelectedWithCoords(General.location_coords)
            }
            else {
                let alert = UIAlertController(title: "Location trouble", message: "Could not determine your location!", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                    (act:UIAlertAction) in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                }))
                presentViewController(alert, animated: true, completion: nil)
            }
            should_listen_to_location_updates = false
        }
    }
    
    func setPinSelectedWithCoords(coords:CLLocationCoordinate2D) {
        current_location_added = false
        (parentViewController as! MainViewController).map_vc.removeMap()
        self.presentViewController(loc_pin_nc, animated: true, completion: {
            self.loc_pin_vc.setCustomPinLocationWithCoords(coords)
        })
    }
    
    func startLoadingLocationMapSnapshot() {
        let opts = MKMapSnapshotOptions()
        let mapPointOrigin = MKMapPointForCoordinate(loc_pin_vc.pin_coords)
        let totalWidth = MKMapPointsPerMeterAtLatitude(loc_pin_vc.pin_coords.latitude) * MAP_SNAPSHOT_METERS_WIDTH
        let totalHeight = totalWidth * Double(meeting_place_location_view.frame.size.height / meeting_place_location_view.frame.size.width)
        opts.mapRect = MKMapRect(origin: MKMapPoint(x: mapPointOrigin.x - totalWidth * 0.5, y: mapPointOrigin.y - totalHeight * 0.5), size: MKMapSizeMake(totalWidth, totalHeight))
        opts.size = meeting_place_frame_location.frame.size
        let snapshotter = MKMapSnapshotter(options: opts)
        snapshotter.startWithCompletionHandler({
            (snap:MKMapSnapshot?, error: NSError?) in
            self.setShowingLoadingProgressOn(false)
            if let img = snap?.image {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    let finalImage = General.getGradientMapImageForSize(img.size, originalImage: img, isPlaceholder: false, withStyle: "full")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.assignLocationImage(finalImage)
                    })
                })
            }
            else {
                //should show somehow that location was picked ok but can not demonstrate it due to connectivity problem
                dispatch_async(dispatch_get_main_queue(), {
                    self.meeting_place_location_text.text = "Location picked"
                })
            }
        })
    }
    
    func assignLocationImage(img:UIImage) {
        UIView.transitionWithView(meeting_place_location_map_img, duration: ANIMATION_MINOR_DURATION, options: .TransitionCrossDissolve, animations: {
            self.meeting_place_location_map_img.image = img
            }, completion: nil)
    }
    
    //PRESENTATION IS BASED ON DEVICE FAMILY!!!
    func addPhotoButtonPressed(sender:UITapGestureRecognizer) {
        self.view.endEditing(true)
        var ph_1_pressed = false
        if ph_view_1.bounds.contains(sender.locationInView(ph_view_1)) {
            ph_1_pressed = true
        }
        if ph_1_pressed ? photo_picked_1 : photo_picked_2 {
            let opts_controller = UIAlertController(title: "Choose an image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            opts_controller.addAction(UIAlertAction(title: "Choose new image", style: UIAlertActionStyle.Default, handler: {
                (act:UIAlertAction) in
                self.presentViewController(self.img_picker, animated: true, completion: nil)
            }))
            opts_controller.addAction(UIAlertAction(title: "Remove image", style: UIAlertActionStyle.Destructive, handler: {
                (act:UIAlertAction) in
                UIView.animateWithDuration(self.ANIMATION_MINOR_DURATION, animations: {
                    if ph_1_pressed {
                        self.ph_img_1.alpha = 0.0
                    }
                    else {
                        self.ph_img_2.alpha = 0.0
                    }
                    }, completion: {
                        (fin:Bool) in
                        if ph_1_pressed {
                            self.ph_img_1.hidden = true
                            self.ph_img_1.image = nil
                            self.photo_picked_1 = false
                            self.ph_rect_1.lineDashPattern = self.FRAME_UNSET_DASH
                        }
                        else {
                            self.ph_img_2.hidden = true
                            self.ph_img_2.image = nil
                            self.photo_picked_2 = false
                            self.ph_rect_2.lineDashPattern = self.FRAME_UNSET_DASH
                        }
                })
            }))
            opts_controller.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(opts_controller, animated: true, completion: nil)
        }
        else {
            self.presentViewController(img_picker, animated: true, completion: nil)
            currently_picking_photo_1 = ph_1_pressed
        }
    }
    
    func postButtonPressed(sender:UIButton) {
        view.endEditing(true)
        var error_message = ""
        var date_errors = false
        var entered_date:NSDate!
        var approx:String = "none"
        var future_date_error = false
        let initial_selected_area_id = (parentViewController as! MainViewController).selected_area_id
        if !meeting_place_location_set && !meeting_place_transport_set {
            data_errors["meeting_place"] = true
            meeting_place_frame_location.strokeColor = FRAME_BORDER_COLOR_ERROR.CGColor
            meeting_place_frame_transport.strokeColor = FRAME_BORDER_COLOR_ERROR.CGColor
        }
        if body_field_empty {
            data_errors["body"] = true
            setFireErrorAtTextField(body_field, fire: true)
        }
        if title_field_empty {
            data_errors["title"] = true
            setFireErrorAtTextField(title_field, fire: true)
        }
        for (key,value) in data_errors {
            if value {
                switch key {
                case "title":
                    error_message += "Title field can not be empty!\n"
                case "body":
                    error_message += "Body field can not be empty!\n"
                case "day":
                    error_message += "Enter DAY you met in range [1 - 31]\n"
                    date_errors = true
                case "month" :
                    error_message += "Enter MONTH you met in range [1 - 12]\n"
                    date_errors = true
                case "year" :
                    error_message += "Enter YEAR you met in range [2000 - 2020]\n"
                    date_errors = true
                case "minute" :
                    error_message += "Enter MINUTES you met in range [0 - 59]\n"
                    date_errors = true
                case "hour" :
                    error_message += "Enter HOURS you met in range [0 - 23]\n"
                    date_errors = true
                case "meeting_place" :
                    error_message += "Specify either location you've met at or choose some transport option\n"
                default:
                    break
                }
            }
        }
        if !date_errors {
            let now_date_comp = NSCalendar.currentCalendar().components([.Day,.Month,.Year,.Minute,.Hour], fromDate: NSDate())
            let entered_date_comp = NSDateComponents()
            entered_date_comp.year = (year_field.text as! NSString).integerValue
            entered_date_comp.month = month_field.text == "???" ? Int(ceil((Double(now_date_comp.month) - 1.0) / 2.0)) : (month_field.text as! NSString).integerValue
            if month_field.text == "???" {
                entered_date_comp.day = 1
                approx = "month"
            }
            else {
                entered_date_comp.day = day_field.text == "???" ? 1 : (day_field.text as! NSString).integerValue
                if day_field.text == "???" {
                    approx = "day"
                }
            }
            entered_date = NSCalendar.currentCalendar().dateFromComponents(entered_date_comp)!
            if entered_date.compare(NSDate()) == .OrderedDescending {
                future_date_error = true
            }
        }
        if future_date_error {
            error_message += "The meeting date you specified is from future!\n"
        }
        print("Having date \(entered_date)")
        print("Now date \(NSDate())")
        if error_message != "" {
            let alert_er = UIAlertController(title: "Errors!", message: error_message, preferredStyle: .Alert)
            alert_er.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                (act:UIAlertAction) in
                alert_er.dismissViewControllerAnimated(true, completion: nil)
            }))
            presentViewController(alert_er, animated: true, completion: nil)
        }
        else {
            var send_type = "transport"
            if meeting_place_location_set && meeting_place_transport_set {
                if meeting_place_segmented_control.selectedSegmentIndex == 0 {
                    send_type = "location"
                }
            }
            else if meeting_place_location_set {
                send_type = "location"
            }
            var final_post_areas_ids:[Int] = [] //we can post to many areas(when transport option choosen)
            if send_type == "location" {
                final_post_areas_ids.append(General.getDeepestAreaIdAmongAreas(General.getAreasIdsForCoords(loc_pin_vc.pin_coords)))
            }
            else {
                let children_areas_ids = General.all_areas_info[initial_selected_area_id]!["childrenAreasIds"] as! [Int]
                if children_areas_ids.count == 0 {
                    final_post_areas_ids.append(initial_selected_area_id)
                }
                else {
                    final_post_areas_ids.appendContentsOf(children_areas_ids)
                }
            }
            //let final_post_area_id = General.getDeepestAreaIdAmongAreas(General.getAreasIdsForCoords(loc_pin_vc.pin_coords)) //this one is used with programming reasons
            if loc_pin_vc.point_outside {
                let initial_indent = General.all_areas_info[(parentViewController as! MainViewController).selected_area_id]!["indentLevel"] as! Int
                let areas_ids = General.getAreasIdsForCoords(loc_pin_vc.pin_coords) //all areas at picked point
                //we shall look for area with the same indent as initial one, or the most deep if not available
                var post_area_title = "World - unspecified" //this one will be proposed to user
                if areas_ids.count != 0 {
                    var best_area_id = -1 //this area will be proposed to user - to make a parallel between initial zone and choosen
                    var best_indent = -1
                    for areaId in areas_ids {
                        let this_indent = General.all_areas_info[areaId]!["indentLevel"] as! Int
                        if this_indent > best_indent && this_indent <= initial_indent {
                            best_indent = this_indent
                            best_area_id = areaId
                        }
                        if this_indent == initial_indent {
                            break
                        }
                    }
                    post_area_title = General.all_areas_info[best_area_id]!["title"] as! String
                }
                let alert_point = UIAlertController(title: "Area zone", message: "You are going to post to another location zone - \(post_area_title)", preferredStyle: .Alert)
                alert_point.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                    (act:UIAlertAction) in
                    alert_point.dismissViewControllerAnimated(true, completion: nil)
                    self.proceedPostToAreaId(final_post_areas_ids, withEnteredDate: entered_date, withApproximation: approx)
                }))
                alert_point.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                presentViewController(alert_point, animated: true, completion: nil)
            }
            else {
                proceedPostToAreaId(final_post_areas_ids, withEnteredDate: entered_date, withApproximation: approx)
            }
        }
    }
    
    func stringContainsNumbersOnly(textString:NSString) -> Bool {
        var contains_numbers_only = true
        for (var i = 0; i < textString.length;i++) {
            if (textString.substringWithRange(NSMakeRange(i, 1)) as! NSString).rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet()).location == NSNotFound {
                contains_numbers_only = false
                break
            }
        }
        return contains_numbers_only
    }
    
    func viewTapped(sender:UITapGestureRecognizer) {
        let location = sender.locationInView(self.view)
        if !current_editing_frame.contains(location) {
            self.view.endEditing(true)
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        var should_receive = true
        if gestureRecognizer == loc_tap_recog {
            if !meeting_place_frame_location.frame.contains(touch.locationInView(scroll_view)) {
                should_receive = false
            }
        }
        if gestureRecognizer == total_view_gest_recog {
            if meeting_place_frame_transport.frame.contains(touch.locationInView(scroll_view)) {
                should_receive = false
            }
        }
        return should_receive
    }
    
    func clearForm() {
        data_errors["title"] = false
        data_errors["body"] = false
        data_errors["month"] = false
        data_errors["day"] = false
        data_errors["minute"] = false
        data_errors["year"] = false
        data_errors["hour"] = false
        data_errors["meeting_place"] = false
        meeting_place_frame_transport.strokeColor = FRAME_BORDER_COLOR.CGColor
        meeting_place_frame_location.strokeColor = FRAME_BORDER_COLOR.CGColor
        meeting_place_frame_transport.lineDashPattern = FRAME_UNSET_DASH
        meeting_place_frame_location.lineDashPattern = FRAME_UNSET_DASH
        body_field.typingAttributes = [NSFontAttributeName:UIFont(name: "SFUIText-Regular", size: TEXT_FIELD_TEXT_PLACEHOLDER_SIZE)!,NSForegroundColorAttributeName:TEXT_FIELD_TEXT_PLACEHODLER_COLOR]
        title_field.typingAttributes = [NSFontAttributeName:UIFont(name: "SFUIText-Regular", size: TEXT_FIELD_TEXT_PLACEHOLDER_SIZE)!,NSForegroundColorAttributeName:TEXT_FIELD_TEXT_PLACEHODLER_COLOR]
        body_field.text = "Enter the body... (\(TEXT_FIELD_MAX_CHARACTERS_BODY) characters max)"
        title_field.text = "Enter the title... (\(TEXT_FIELD_MAX_CHARACTERS_TITLE) characters max)"
        title_field_empty = true
        body_field_empty = true
        textViewContentChangedInView(title_field)
        textViewContentChangedInView(body_field)
        genderButtonPressed(gender_mw_button)
        let yesterday_date = NSDate(timeInterval: -24.0 * 60.0 * 60.0, sinceDate: NSDate())
        let yest_date_comp = NSCalendar.currentCalendar().components([NSCalendarUnit.Day,NSCalendarUnit.Month,NSCalendarUnit.Year], fromDate: yesterday_date)
        day_field.text = "\(yest_date_comp.day)"
        month_field.text = "\(yest_date_comp.month)"
        year_field.text = "\(yest_date_comp.year)"
        hour_field.text = "???"
        minute_field.text = "???"
        title_field.layer.borderWidth = TEXT_FIELD_BORDER_WIDTH_NORMAL
        title_field.layer.borderColor = TEXT_FIELD_BORDER_COLOR_NORMAL.CGColor
        body_field.layer.borderWidth = TEXT_FIELD_BORDER_WIDTH_NORMAL
        body_field.layer.borderColor = TEXT_FIELD_BORDER_COLOR_NORMAL.CGColor
        day_field.layer.borderWidth = TEXT_FIELD_BORDER_WIDTH_NORMAL
        day_field.layer.borderColor = TEXT_FIELD_BORDER_COLOR_NORMAL.CGColor
        month_field.layer.borderWidth = TEXT_FIELD_BORDER_WIDTH_NORMAL
        month_field.layer.borderColor = TEXT_FIELD_BORDER_COLOR_NORMAL.CGColor
        year_field.layer.borderWidth = TEXT_FIELD_BORDER_WIDTH_NORMAL
        year_field.layer.borderColor = TEXT_FIELD_BORDER_COLOR_NORMAL.CGColor
        minute_field.layer.borderWidth = TEXT_FIELD_BORDER_WIDTH_NORMAL
        minute_field.layer.borderColor = TEXT_FIELD_BORDER_COLOR_NORMAL.CGColor
        hour_field.layer.borderWidth = TEXT_FIELD_BORDER_WIDTH_NORMAL
        hour_field.layer.borderColor = TEXT_FIELD_BORDER_COLOR_NORMAL.CGColor
        meeting_place_transport_text.hidden = false
        meeting_place_transport_text.alpha = 1.0
        if current_transport_cell_selected != -1 {
            if let cell = transport_collection.cellForItemAtIndexPath(NSIndexPath(forItem: current_transport_cell_selected, inSection: 0)) {
                cell.backgroundColor = TRANSPORT_CELL_UNSEL_BG_COLOR
            }
        }
        current_transport_cell_selected = -1
        meeting_place_transport_set = false
        should_listen_to_location_updates = false
        current_location_added = false
        if meeting_place_location_set {
            loc_pin_vc.clearButtonPressed(loc_pin_vc.button_clear)
            meeting_place_location_map_img.image = nil
        }
        meeting_place_location_set = false
        if meeting_place_segmented_control.selectedSegmentIndex != 0 {
            meeting_place_segmented_control.selectedSegmentIndex = 0
            meetingPlaceSegmentedPressed(meeting_place_segmented_control)
        }
        ph_img_1.hidden = true
        ph_img_1.image = nil
        photo_picked_1 = false
        ph_rect_1.lineDashPattern = FRAME_UNSET_DASH
        ph_img_2.alpha = 0.0
        ph_img_2.hidden = true
        ph_img_2.image = nil
        photo_picked_2 = false
        ph_rect_2.lineDashPattern = FRAME_UNSET_DASH
        ph_img_2.alpha = 0.0
    }
    
    func clearButtonPressed(sender:UIBarButtonItem) {
        clearForm()
    }
    
    func setTransportPostingRecommendationEnabled(enabled:Bool) {
        let initial_area_id = (parentViewController as! MainViewController).selected_area_id
        let children_areas_ids = General.all_areas_info[initial_area_id]!["childrenAreasIds"] as! [Int]
        if children_areas_ids.count != 0 {
            var text = "You better choose subzone(like "
            let rand_child_index = Int(arc4random_uniform(UInt32(children_areas_ids.count)))
            let child_area_title = General.all_areas_info[children_areas_ids[rand_child_index]]!["title"] as! String
            text += "\(child_area_title)) to post"
            let _ = NSTimer.scheduledTimerWithTimeInterval(TRANSPORT_TEXT_UPDATE_DELAY, target: self, selector: "updateTransportText:", userInfo: text, repeats: false)
        }
    }
    
    func updateTransportText(sender:NSTimer) {
        UIView.transitionWithView(meeting_place_transport_text_posting_zone, duration: ANIMATION_MINOR_DURATION, options: .TransitionCrossDissolve, animations: {
            self.meeting_place_transport_text_posting_zone.text = sender.userInfo as! String
            }, completion: nil)
    }
    
    func proceedPostToAreaId(areasIds:[Int], withEnteredDate:NSDate, withApproximation:String) {
        print("Pre-post checks are done; going to compile JSON and post to \(areasIds) areaId")
        var per_1 = "", per_2 = ""
        if gender_mw_button.selected {
            per_1 = "m"
            per_2 = "w"
        }
        else if gender_mm_button.selected {
            per_1 = "m"
            per_2 = "m"
        }
        else if gender_wm_button.selected {
            per_1 = "w"
            per_2 = "m"
        }
        else if gender_ww_button.selected {
            per_1 = "w"
            per_2 = "w"
        }
        var send_type = "transport"
        if meeting_place_location_set && meeting_place_transport_set {
            if meeting_place_segmented_control.selectedSegmentIndex == 0 {
                send_type = "location"
            }
        }
        else if meeting_place_location_set {
            send_type = "location"
        }
        let post_dict = NSMutableDictionary()
        post_dict["areasIds"] = areasIds
        post_dict["title"] = title_field.text
        post_dict["meeting_time"] = "\(withEnteredDate.timeIntervalSince1970)"
        post_dict["meeting_approx"] = withApproximation
        post_dict["person_1"] = per_1
        post_dict["person_2"] = per_2
        post_dict["body"] = body_field.text
        if send_type == "transport" {
            post_dict["transport"] = true
            post_dict["map"] = false
            post_dict["transport_id"] = current_transport_cell_selected
        }
        else {
            post_dict["transport"] = false
            post_dict["map"] = true
            post_dict["lat"] = Double(loc_pin_vc.pin_coords.latitude)
            post_dict["long"] = Double(loc_pin_vc.pin_coords.longitude)
        }
        var images_amount = 0
        var images_sizes:[NSDictionary] = []
        if photo_picked_1 {
            images_amount++
            let size_dict = NSMutableDictionary()
            size_dict["w"] = Int(ph_img_1.image!.size.width)
            size_dict["h"] = Int(ph_img_1.image!.size.height)
            images_sizes.append(size_dict)
        }
        if photo_picked_2 {
            images_amount++
            let size_dict = NSMutableDictionary()
            size_dict["w"] = Int(ph_img_2.image!.size.width)
            size_dict["h"] = Int(ph_img_2.image!.size.height)
            images_sizes.append(size_dict)
        }
        post_dict["images_amount"] = images_amount
        if images_amount > 0 {
            post_dict["images_sizes"] = images_sizes
        }
        let post_json = try? NSJSONSerialization.dataWithJSONObject(post_dict, options: [])
        print("got post_dict")
        print(post_dict)
        print("got json data")
        print(post_json)
    }
    
}