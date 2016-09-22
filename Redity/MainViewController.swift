//
//  ViewController.swift
//  Redity
//
//  Created by Admin on 13.06.16.
//  Copyright © 2016 Vanoproduction. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate {
    
    let FEED_UPDATING_SCREENS_LEFT_COUNT:CGFloat = 1.5 //when this amount of screens left to end of the feed, we should start adding new cards
    let FEED_IMAGE_RIGHT_MAP_WIDTH_RELATIVE:CGFloat = 0.3 //part of cell's width
    let FEED_IMAGE_RIGHT_MAP_HEIGHT:CGFloat = 90 //min height
    let BG_OPACITY:CGFloat = 0.35
    let TAB_LABEL_LEFT_WIDTH_RELATIVE:CGFloat = 0.22 //relative to width
    let TAB_LABEL_RIGHT_WIDTH_RELATIVE:CGFloat = 0.24
    let TAB_SELECTED_BG:UIColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    let TAB_LABEL_SELECTED_COLOR:UIColor = UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 1.0)
    let TAB_LABEL_UNSELECTED_COLOR:UIColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1.0)
    let TABS_ANIMATION_TRANSITION_DURATION:CFTimeInterval = 0.34
    let NAVIGATION_BAR_COLOR:UIColor = UIColor(red: 57/255, green: 24/255, blue: 152/255, alpha: 1.0)
    let NAVIGATION_BAR_TINT_COLOR:UIColor = UIColor(red: 216/255, green: 213/255, blue: 242/255, alpha: 1.0)
    let FILTER_SCREEN_OVERLAYED_PART:CGFloat = 0.14 //part of height from the bottom, which is overlayed when filter is displayed
    let FILTER_OVERLAY_COLOR:UIColor = UIColor(red: 57/255, green: 24/255, blue: 152/255, alpha: 1.0)
    
    let FILTER_OVERLAY_OPACITY:CGFloat = 0.58
    let FILTER_SHOW_DURATION:CFTimeInterval = 0.5
    let DELAY_CHANGE_FILTER_ICONS:CFTimeInterval = 0.15
    let RESET_FILTERS_BUTTON_WIDTH_PART:CGFloat = 0.42
    let RESET_FILTERS_BUTTON_ASPECT_RATIO:CGFloat = 0.25 // height to width
    let RESET_FILTERS_BUTTON_BG:UIColor = UIColor(red: 226/255, green: 224/255, blue: 239/255, alpha: 1.0)
    let RESET_FILTERS_BUTTON_TEXT_PART:CGFloat = 0.74
    let RESET_FILTERS_BUTTON_MARGIN_TOP:CGFloat = 9 //we try this in pixels, so the shift gonna look the same on every phone
    let FILTER_TABLE_TOP_MARGIN:CGFloat = 14
    let FILTER_HEADS_AMOUNT:Int = 5
    let FILTER_ARROW_ANIMATION_DURATION:CFTimeInterval = 0.3
    let FILTER_CHECKBOX_ANIMATION_DURATION:CFTimeInterval = 0.2
    let FILTER_EXPANDED_CELL_BG:UIColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1.0)
    let FILTER_TIMEFRAME_SELECTED_BG:UIColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
    let FILTER_TIMEFRAME_SELECTED_DATE_LABEL_BG:UIColor = UIColor(red: 133/255, green: 121/255, blue: 182/255, alpha: 1.0)
    let FILTER_TIMEFRAME_UNSELECTED_DATE_LABEL_BG:UIColor = UIColor(red: 57/255, green: 24/255, blue: 152/255, alpha: 1.0)
    let FILTER_MAX_TIMEFRAME_DAYS:Int = 45
    let FILTER_HEAD_CELL_OPACITY_UNAVAILABLE:CGFloat = 0.6
    let ROW_HEIGHT_TIMEFRAME_PICKER:CGFloat = 155
    let ROW_HEIGHT_HEAD:CGFloat = 55
    let ROW_HEIGHT_GENDER:CGFloat = 60
    let ROW_HEIGHT_REGULAR:CGFloat = 45
    let NEARBY_AREAS_DESCRIPTION_TEXT_SIZE:CGFloat = 15
    let FEED_TABLE_SCROLLED_START_LOADING:CGFloat = 0.75
    let PLUS_BUTTON_MARGIN_BOTTOM:CGFloat = 8
    let PLUS_BUTTON_WIDTH_RELATIVE:CGFloat = 0.17 // to view's width
    let PLUS_BUTTON_ASPECT:CGFloat = 0.8933
    
    let TABS_HEIGHT_RELATIVE:CGFloat = 0.075
    let FEED_TABLE_MARGIN_TOP:CGFloat = 6
    let FEED_TABLE_MARGIN_BOTTOM_RELATIVE:CGFloat = 0.075 // relative to whole height - this place is occupied by bottom bar
    let FEED_TABLE_MARGIN_BOTTOM:CGFloat = 5 // just like top_margin
    let FEED_TABLE_CELLS_SPACING:CGFloat = 14
    let SETTINGS_TABLE_MARGIN_TOP:CGFloat = 6
    let SETTINGS_TABLE_MARGIN_BOTTOM:CGFloat = 5
    let FEED_FOOTER_HEIGHT:CGFloat = 20
    let FEED_FOOTER_LABEL_WIDTH_RELATIVE:CGFloat = 0.75
    let FEED_FOOTER_LABEL_TEXT_SIZE:CGFloat = 15
    let FEED_FOOTER_LABEL_TEXT_COLOR:UIColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1.0)
    let FEED_FOOTER_LABEL_MARGIN_TOP:CGFloat = 10
    let FEED_FOOTER_LABEL_MARGIN_BOTTOM:CGFloat = 15
    let FEED_FOOTER_LOADING_MARGIN_TOP:CGFloat = 10
    let FEED_FOOTER_LOADING_MARGIN_BOTTOM:CGFloat = 15
    let FEED_FOOTER_ANIMATION_DURATION:CFTimeInterval = 0.3
    let FEED_EMPTY_ICON_WIDTH_RELATIVE:CGFloat = 0.515
    let FEED_EMPTY_LABEL_TEXT_SIZE:CGFloat = 20
    let FEED_EMPTY_LABEL_MARGIN_TOP:CGFloat = 27
    let SETTINGS_TABLE_TEXT_COLOR:UIColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1.0)
    
    let PAN_MAP_GESTURE_BEGIN_ZONE_END_RELATIVE:CGFloat = 0.35 //part of screen's width. if gesture started after it, it won't be considered as the beginning of map view appearance
    let PAN_MAP_GESTURE_MIN_TRANSLATE_RELATIVE:CGFloat = 0.35 // min distance you must move you finger along the screen in order for map view to appear
    let PAN_MAP_GESTURE_TRANSLATE_FULL_APPEARANCE_RELATIVE:CGFloat = 0.75 // which part of screen you should drag so that to make map_vc to appear onscreen completely
    let PAN_MAP_FINISH_ANIMATION_DURATION:CFTimeInterval = 0.3
    let PAN_MAP_GESTURE_INITIAL_POSITION_RELATIVE:CGFloat = 0.35 //how much space does map view initially occupies underneath the feed
    let MAP_SHOW_HIDE_ANIMATION_DURATION:CFTimeInterval = 0.35
    let MAP_BOUNCE_ANIMATION_DURATION:CFTimeInterval = 2.9
    let MAP_BOUNCE_SHOW_ANIMATION_DURATION:CFTimeInterval = 1.5
    let MAP_BOUNCE_SLEEP_ANIMATION_DURATION:CFTimeInterval = 0.4
    let MAP_SHOULD_HIDE_NAVIGATION_BAR:Bool = true //when mapopened, should we hide the navogation bar?
    let MAP_BOUNCE_1:CGFloat = 0.35 // relative to whole animation required for complete map presentation
    let MAP_BOUNCE_2:CGFloat = 0.19
    let MAP_BOUNCE_3:CGFloat = 0.08
    let MAP_SNAPSHOT_METERS_PER_WIDTH_FEED:Double = 200.0 //the size of area which should be covered in map at the right of the card
    let MAP_SNAPSHOT_METERS_PER_WIDTH_FULL:Double = 480.0
    //let MAP_SNAPSHOT_WIDTH_POINTS_FEED:CGFloat = 200 // the width in points of map snapshot output
    
    let ADD_POST_MARGIN_SIDES:CGFloat = 7.0 // from each side(bottom of navBar, left and right screen edges)
    let ADD_POST_SCALE_INITIAL:CGFloat = 0.7 // scale before animation appearing begins
    let ANIMATION_ADD_POST_SCALING_DURATION:CFTimeInterval = 0.45
    let ADD_POST_OVERLAY_COLOR:UIColor = UIColor(red: 158/255, green: 153/255, blue: 145/255, alpha: 1.0)
    let ADD_POST_OVERLAY_OPACITY:CGFloat = 0.88
    
    let FILTERS_LABELS_COLOR_OFF:UIColor = UIColor(red: 197/255, green: 198/255, blue: 242/255, alpha: 1.0)
    let FILTERS_LABELS_COLOR_ON:UIColor = UIColor(red: 57/255, green: 70/255, blue: 168/255, alpha: 1.0)
    let FILTERS_LABELS_BG:UIColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
    let FILTERS_ON_LABELS_TEXT_SIZE:CGFloat = 13
    let FILTERS_ON_LABELS_MARGIN_SIDES:CGFloat = 25
    let FILTERS_ON_LABELS_MARGIN_TOP:CGFloat = 9
    let ANIMATION_FILTERS_ON_LABELS_DURATION:CFTimeInterval = 0.5
    let ANIMATION_FILTER_ON_LABEL_COLOR_CHANGE_DURATION:CFTimeInterval = 0.4
    let ANIMATION_FILTERS_ON_LABELS_DELAY:CFTimeInterval = 0.15
    let TABLE_SCROLLING_DURATION:CFTimeInterval = 0.4
    let ANIMATION_CELL_BLINK_DURATION:CFTimeInterval = 0.4
    let CELL_COLOR_BLINK:UIColor = UIColor.yellowColor()
    let ANIMATION_CELL_BLINK_ON_DELAY:CFTimeInterval = 0.2
    let SWITCH_ON_TINT_COLOR:UIColor = UIColor(red: 73/255, green: 65/255, blue: 149/255, alpha: 1.0)
    
    var posts_vc:PostsViewerViewController!
    var settings_table_protocol:SettingsTabHolder!
    var add_post_overlay:UIView!
    var feed_empty_icon:UIImageView!
    var feed_empty_label:UILabel!
    var feed_footer_view:UIView!
    var feed_footer_label_end:UILabel!
    var feed_footer_loading_view:UIView!
    var map_view_hidden_center_x:CGFloat = 0
    var filters_on_labels_total_height:CGFloat = 0
    var filter_on_left = false
    var filter_on_right = false
    var now_left_tab = true
    var data_filter_present = false
    var now_filter_shown = false
    var now_filter_transition = false
    var now_tab_transition = false
    var map_view_is_on_screen = false
    var map_view_is_dragging = false
    var add_post_screen_animating = false
    var add_post_screen_shown = false
    var areas_keys_to_indices:[Int : String] = [Int:String]()
    var current_start_date_string = ""
    var current_end_date_string = ""
    var min_possible_date:NSDate!
    var max_possible_date:NSDate!
    var current_gender_error = false
    var current_areas_error = false
    var current_place_name = "SF Bay Area"
    var pan_map_gesture_recognizer:UIPanGestureRecognizer!
    var one_post_vc:OnePostViewController!
    var map_vc:MapViewController!
    var places_nc:UINavigationController!
    var places_vc:PlacesViewController!
    var add_post_vc:AddPostViewController!
    var map_filter_present = false
    var filters_on_labels_present = false
    var location_manager:CLLocationManager!
    var current_location_status:String = "IDLE" // IDLE , DETERMINING
    var shown_first = false
    var selected_area_id:Int = 1
    var map_snapshots_to_card_id:[Int:Int] = [Int:Int]()
    var current_map_snapshot = -1
    var map_snapshots_images:[Int:UIImage] = [Int:UIImage]() //index of this array corresponds to map_snaphsot dictionary
    var card_id_to_map_snapshot_image:[Int:UIImage] = [Int:UIImage]()
    var nearby_areas_ids:[Int] = []
    var feed_state:String = "ok" // ok, loading,end
    var feed_footer_state:String = "hidden" //hidden, end,loading
    var current_pins_data:[Int:NSDictionary] = [Int:NSDictionary]()
    var map_filtered_cards_ids:[Int] = []
    
    //!!! IF WE WANT NO SHOWN AREAS - :["empty":true]
    
    var default_filter_data:NSMutableDictionary = ["shown_areas":[["title":"Palo Alto","areaId":1,"checked":true],["title":"San Antonia","areaId":2,"checked":true],["title":"San Bernardino","areaId":3,"checked":true],["title":"Oakland","areaId":4,"checked":true]],"gender":["ww":true,"wm":true,"mm":true,"mw":true],"timeframe_unbounded":true,"timeframe":["start_date":NSCalendar.currentCalendar().startOfDayForDate(NSDate()),"end_date":NSCalendar.currentCalendar().startOfDayForDate(NSDate())],"include_nearby":false,"include_transport":true,"nearby_areas":["Las Vegas","Bakersfield","Salt Lake City"]]
    
    var prev_filter_data:NSMutableDictionary!
    var current_filter_data:NSMutableDictionary!
    
    var current_feed_cells_data:[Int:NSMutableDictionary] = [Int:NSMutableDictionary]()
    
    var current_filter_heads_info:[NSMutableDictionary] = [["headType":"shown_areas","text_left":"SHOWN AREAS","text_right_available":true,"text_right":"All","isExpandable":true,"isExpanded":false,"checkbox_available":false,"checkbox_on":false],
        ["headType":"gender","text_left":"GENDER","text_right_available":true,"text_right":"All","isExpandable":true,"isExpanded":false,"checkbox_available":false,"checkbox_on":false],
        ["headType":"timeframe","text_left":"TIMERAME","text_right_available":true,"text_right":"Last 45 days","isExpandable":true,"isExpanded":false,"nowDateEditing":false,"editingDateId":-1,"checkbox_available":false,"checkbox_on":false],
        ["headType":"include_nearby","text_left":"INCLUDE NEARBY AREAS","text_right_available":false,"text_right":" ","isExpandable":false,"isExpanded":false,"checkbox_available":true,"checkbox_on":false],
        ["headType":"include_transport","text_left":"INCLUDE TRANSPORT","text_right_available":false,"text_right":" ","isExpandable":false,"isExpanded":false,"checkbox_available":true,"checkbox_on":true]
    ]
    
    
    var feed_section_to_card_id:[Int:Int] = [Int:Int]()
    
    //!!!array index is mapped in feed_section_to_card_id!!!
    var feed_cells_frames:[Int:[String:CGRect]] = [Int:[String:CGRect]]()
    var feed_cells_heights:[Int:CGFloat] = [Int:CGFloat]()
    
    var shown_filter_cells:[NSDictionary] = []
    
    @IBOutlet var bg_view:UIView!
    @IBOutlet var white_bg_view:UIView!
    @IBOutlet var tab_button_left:UIButton!
    @IBOutlet var tab_button_right:UIButton!
    @IBOutlet var tab_left_label:UILabel!
    @IBOutlet var tab_right_label:UILabel!
    @IBOutlet var tab_bar_bg:UIView!
    @IBOutlet var tab_right_icon:UIImageView!
    @IBOutlet var tab_left_icon:UIImageView!
    @IBOutlet var tab_label_left:UILabel!
    @IBOutlet var tab_label_right:UILabel!
    @IBOutlet var plus_button:UIButton!
    
    var reset_filters_button:UIButton!
    var filter_view:UIView!
    var filter_overlay_view:UIView!
    var navBar:UINavigationBar!
    var filter_table_view:UITableView!
    var feed_table_view:UITableView!
    var feed_card_estimate_plain:FeedCellPlain!
    var feed_card_estimate_images:FeedCellImages!
    var people_tab_holder_view:UIView!
    var settings_tab_holder_view:UIView!
    var settings_table_view:UITableView!
    var filter_on_left_label:UILabel!
    var filter_on_right_label:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings_table_protocol = SettingsTabHolder(mainVC:self)
        let images_sizes = [NSValue(CGSize:UIImage(named: "sample_1")!.size),NSValue(CGSize:UIImage(named: "sample_2")!.size)]
        General.precalculateMapPlaceholderWithSize(CGSizeMake(view.bounds.width * FEED_IMAGE_RIGHT_MAP_WIDTH_RELATIVE, FEED_IMAGE_RIGHT_MAP_HEIGHT))
        //current_feed_cells_data[4]!["images_sizes"] = images_sizes
        selected_area_id = NSUserDefaults().integerForKey("selected_area_id")
        prepareDefaultFilterData()
        location_manager = CLLocationManager()
        location_manager.delegate = self
        location_manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        white_bg_view.layer.zPosition = -4
        plus_button.layer.zPosition = 990
        //now lowering tab labels font size if required
        if (tab_label_left.text as! NSString).sizeWithAttributes([NSFontAttributeName:UIFont(name: "GothamPro-Medium", size: 17.0)!]).width > view.bounds.width * TAB_LABEL_LEFT_WIDTH_RELATIVE {
            let size = General.getFontSizeToFitWidth(view.bounds.width * TAB_LABEL_LEFT_WIDTH_RELATIVE, forString: tab_label_left.text!, withFontName: "GothamPro-Medium")
            tab_label_left.font = UIFont(name: "GothamPro-Medium", size: size)
        }
        if (tab_label_right.text as! NSString).sizeWithAttributes([NSFontAttributeName:UIFont(name: "GothamPro-Medium", size: 17.0)!]).width > view.bounds.width * TAB_LABEL_RIGHT_WIDTH_RELATIVE {
            let size = General.getFontSizeToFitWidth(view.bounds.width * TAB_LABEL_RIGHT_WIDTH_RELATIVE, forString: tab_label_right.text!, withFontName: "GothamPro-Medium")
            tab_label_right.font = UIFont(name: "GothamPro-Medium", size: size)
        }
        let start_time_interval:NSTimeInterval = -3600.0 * 24.0 * Double(FILTER_MAX_TIMEFRAME_DAYS - 1)
        let mutable_dates = NSMutableDictionary(dictionary: default_filter_data["timeframe"] as! NSDictionary)
        mutable_dates["start_date"] = NSDate(timeInterval: start_time_interval, sinceDate: NSCalendar.currentCalendar().startOfDayForDate(NSDate()))
        default_filter_data["timeframe"] = mutable_dates
        min_possible_date = default_filter_data["timeframe"]!["start_date"] as! NSDate
        max_possible_date = default_filter_data["timeframe"]!["end_date"] as! NSDate
        current_filter_data = NSMutableDictionary(dictionary: default_filter_data)
        prev_filter_data = NSMutableDictionary(dictionary: default_filter_data)
        bg_view.backgroundColor = UIColor(patternImage: UIImage(named: "bg_pattern")!)
        bg_view.alpha = BG_OPACITY
        bg_view.layer.zPosition = -2
        let _ = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "adjustUI:", userInfo: nil, repeats: false)
        navBar = self.navigationController!.navigationBar
        navBar.barTintColor = NAVIGATION_BAR_COLOR
        navBar.tintColor = NAVIGATION_BAR_TINT_COLOR
        navBar.barStyle = UIBarStyle.Black
        setBasicNavigationItemIcons()
        let title_attr = [NSForegroundColorAttributeName:NAVIGATION_BAR_TINT_COLOR]
        navBar.titleTextAttributes = title_attr
        //print("going to load one post vc")
        one_post_vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("one_post_vc") as! OnePostViewController
        one_post_vc.preloadViewsWithNavigationBarHeight(navBar.frame.maxY)
        self.navigationController!.delegate = self
        places_nc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("places_nc") as! UINavigationController
        if places_nc.childViewControllers[0].isKindOfClass(PlacesViewController) {
            places_vc = places_nc.childViewControllers[0] as! PlacesViewController
            print("a child!")
        }
        places_vc.setHandlersWith(placesScreenClosedWithLocationId, locationUpdateHandler: updateLocation)
        add_post_vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("add_vc") as! AddPostViewController
        self.addChildViewController(add_post_vc)
        let plus_button_height = PLUS_BUTTON_MARGIN_BOTTOM + view.bounds.width * PLUS_BUTTON_WIDTH_RELATIVE * PLUS_BUTTON_ASPECT
        add_post_vc.view.frame = CGRect(x: ADD_POST_MARGIN_SIDES, y: navBar.frame.maxY + ADD_POST_MARGIN_SIDES, width: view.bounds.width - 2.0 * ADD_POST_MARGIN_SIDES, height: view.bounds.height - navBar.frame.maxY - plus_button_height - ADD_POST_MARGIN_SIDES * 2.0)
        add_post_vc.view.userInteractionEnabled = true
        add_post_vc.view.layer.cornerRadius = 10.0
        add_post_vc.view.layer.masksToBounds = true
        add_post_vc.view.layer.zPosition = 989
        add_post_vc.view.alpha = 0.0
        add_post_vc.view.hidden = true
        add_post_vc.view.transform = CGAffineTransformMakeScale(ADD_POST_SCALE_INITIAL, ADD_POST_SCALE_INITIAL)
        
        view.addSubview(add_post_vc.view)
        add_post_vc.didMoveToParentViewController(self)
        add_post_overlay = UIView(frame: CGRect(x: 0, y: navBar.frame.maxY, width: view.bounds.width, height: view.bounds.height - navBar.frame.maxY))
        add_post_overlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "addPostScreenOverlayPressed:"))
        add_post_overlay.userInteractionEnabled = true
        add_post_overlay.layer.zPosition = 988
        add_post_overlay.backgroundColor = ADD_POST_OVERLAY_COLOR
        add_post_overlay.alpha = 0.0
        add_post_overlay.hidden = true
        people_tab_holder_view = UIView(frame: CGRect(x: 0, y: navBar.frame.maxY, width: view.bounds.width, height: (view.bounds.height - navBar.frame.maxY - FEED_TABLE_MARGIN_BOTTOM_RELATIVE * view.bounds.height)))
        people_tab_holder_view.backgroundColor = UIColor.clearColor()
        people_tab_holder_view.layer.zPosition = -1
        settings_tab_holder_view = UIView(frame: CGRect(x: 0, y: SETTINGS_TABLE_MARGIN_TOP + navBar.frame.maxY, width: view.bounds.width, height: (view.bounds.height - navBar.frame.maxY - SETTINGS_TABLE_MARGIN_TOP - SETTINGS_TABLE_MARGIN_BOTTOM - FEED_TABLE_MARGIN_BOTTOM_RELATIVE * view.bounds.height)))
        settings_tab_holder_view.layer.zPosition = -1
        settings_tab_holder_view.backgroundColor = UIColor.clearColor()
        settings_tab_holder_view.hidden = true
        settings_tab_holder_view.alpha = 0.0
        settings_tab_holder_view.center.x += view.bounds.width
        view.addSubview(people_tab_holder_view)
        view.addSubview(settings_tab_holder_view)
        view.addSubview(add_post_overlay)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "saveButtonPressedOnePost:", name: "save_notification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reportButtonPressedOnePost:", name: "report_notification", object: nil)
        setupMapView()
        setupFeedTableView()
        print("loaded table feed")
        view.bringSubviewToFront(plus_button)
        //view.bringSubviewToFront(filter_overlay_view)
        view.bringSubviewToFront(add_post_vc.view)
        add_post_vc.configureView()
        setupFilterScrollView()
        setupFiltersOnLabels()
        setupSettingsView()
        //startLoadingNewCardsWithName("origin_data")
        prepareNewAreaId(selected_area_id)
        map_vc.connectPinsData(current_pins_data, withSelectedAreaId: selected_area_id)
        pan_map_gesture_recognizer = UIPanGestureRecognizer(target: self, action: "panDidMove:")
        pan_map_gesture_recognizer.delegate = self
        people_tab_holder_view.addGestureRecognizer(pan_map_gesture_recognizer)
        updateLocation()
        
    }
    
    func updateLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .NotDetermined:
            location_manager.requestWhenInUseAuthorization()
        case .Denied , .Restricted:
            print("location can not be determined due to app's restrictions!")
        default:
            if CLLocationManager.locationServicesEnabled() {
                print("started updating location")
                location_manager.startUpdatingLocation()
                General.location_status = "DETERMINING"
            }
            else {
                print("Location error: location services are disabled!")
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        let location_areas_ids = General.getAreasIdsForCoords(location.coordinate)
        let deepestAreaId = General.getDeepestAreaIdAmongAreas(location_areas_ids)
        var info:[NSObject:AnyObject] = [NSObject:AnyObject]()
        info["location"] = location
        info["locationAreaId"] = deepestAreaId
        info["type"] = "ok"
        location_manager.stopUpdatingLocation()
        General.location_status = "OK"
        General.location_area_id = deepestAreaId
        General.location_coords = location.coordinate
        NSUserDefaults().setInteger(deepestAreaId, forKey: "prev_location_area_id")
        NSUserDefaults().setObject([location.coordinate.latitude,location.coordinate.longitude], forKey: "prev_location_coords")
        NSNotificationCenter.defaultCenter().postNotificationName("location_update_notification", object: nil, userInfo: info)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("location stopped updating with error")
        var info:[NSObject:AnyObject] = [NSObject:AnyObject]()
        info["type"] = "error"
        location_manager.stopUpdatingLocation()
        General.location_status = "ERROR"
        NSNotificationCenter.defaultCenter().postNotificationName("location_update_notification", object: nil, userInfo: info)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            if CLLocationManager.locationServicesEnabled() {
                location_manager.startUpdatingLocation()
                General.location_status = "DETERMINING"
                var info:[NSObject:AnyObject] = [NSObject:AnyObject]()
                info["type"] = "authStatus"
                NSNotificationCenter.defaultCenter().postNotificationName("location_update_notification", object: nil, userInfo: info)
            }
            else {
                print("Location error: location services are disabled!")
            }
        }
    }
    
    func prepareDefaultFilterData() {
        var new_shown_areas:[NSDictionary] = []
        let childrenAreas = General.all_areas_info[selected_area_id]!["childrenAreasIds"] as! [Int]
        for childAreaId in childrenAreas {
            var area_dict = NSMutableDictionary()
            area_dict["title"] = General.all_areas_info[childAreaId]!["title"] as! String
            area_dict["areaId"] = childAreaId
            area_dict["checked"] = true
            new_shown_areas.append(area_dict)
        }
        default_filter_data["shown_areas"] = new_shown_areas
        let areas_ids_near = General.getNearbyAreasForAreaId(selected_area_id)
        nearby_areas_ids = []
        nearby_areas_ids.appendContentsOf(areas_ids_near)
        var areas_array:[String] = []
        for area_id in areas_ids_near {
            areas_array.append(General.all_areas_info[area_id]!["title"] as! String)
        }
        default_filter_data["nearby_areas"] = areas_array
    }
    
    override func viewDidAppear(animated: Bool) {
        //should propose user to enable location services
        
    }
    
    func firedemo(sender:NSTimer) {
        showMapBouncing()
    }
    
    func setupFiltersOnLabels() {
        filter_on_left_label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 60))
        filter_on_left_label.font = UIFont(name: "SFUIText-Bold", size: FILTERS_ON_LABELS_TEXT_SIZE)
        filter_on_left_label.textAlignment = .Left
        filter_on_left_label.textColor = FILTERS_LABELS_COLOR_OFF
        filter_on_left_label.text = "MAP FILTER APPLIED"
        let real_size = filter_on_left_label.textRectForBounds(filter_on_left_label.bounds, limitedToNumberOfLines: 1)
        filter_on_left_label.frame = CGRect(x: FILTERS_ON_LABELS_MARGIN_SIDES, y: FILTERS_ON_LABELS_MARGIN_TOP, width: real_size.width, height: real_size.height)
        filter_on_right_label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 60))
        filter_on_right_label.font = UIFont(name: "SFUIText-Bold", size: FILTERS_ON_LABELS_TEXT_SIZE)
        filter_on_right_label.textAlignment = .Right
        filter_on_right_label.textColor = FILTERS_LABELS_COLOR_OFF
        filter_on_right_label.text = "DATA FILTER APPLIED"
        let real_right_size = filter_on_right_label.textRectForBounds(filter_on_right_label.bounds, limitedToNumberOfLines: 1)
        filter_on_right_label.frame = CGRect(x: view.bounds.width - FILTERS_ON_LABELS_MARGIN_SIDES - real_right_size.width, y: FILTERS_ON_LABELS_MARGIN_TOP, width: real_right_size.width, height: real_right_size.height)
        filters_on_labels_total_height = FILTERS_ON_LABELS_MARGIN_TOP * 2.0 + filter_on_left_label.bounds.height
        filter_on_left_label.hidden = true
        filter_on_right_label.hidden = true
        filter_on_left_label.center.y -= filters_on_labels_total_height
        filter_on_right_label.center.y -= filters_on_labels_total_height
        people_tab_holder_view.addSubview(filter_on_left_label)
        people_tab_holder_view.addSubview(filter_on_right_label)
    }
    
    func setupMapView() {
        map_vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("map_vc") as! MapViewController
        self.addChildViewController(map_vc)
        map_vc.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        map_vc.view.userInteractionEnabled = false
        map_vc.view.hidden = true
        self.view.addSubview(map_vc.view)
        map_view_hidden_center_x = self.view.bounds.width * PAN_MAP_GESTURE_INITIAL_POSITION_RELATIVE - 0.5 * view.bounds.width
        map_vc.view.center = CGPointMake(map_view_hidden_center_x, 0.5 * view.bounds.height)
        map_vc.view.layer.zPosition = -6
        map_vc.didMoveToParentViewController(self)
        map_vc.hideActionButtonsAnimated(false)
        one_post_vc.main_map_vc = map_vc
        one_post_vc.main_vc = self
    }
    
    func setupFilterScrollView() {
        print("helloo")
        let final_filter_height = view.bounds.height - navBar.frame.height - navBar.frame.minY - view.bounds.height * FILTER_SCREEN_OVERLAYED_PART
        filter_view = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: final_filter_height))
        filter_view.backgroundColor = UIColor.whiteColor()
        filter_view.center.y = navBar.frame.height + navBar.frame.minY - 0.5 * filter_view.bounds.height
        filter_view.hidden = true
        //adding reset filters button
        reset_filters_button = UIButton(type: .Custom)
        reset_filters_button.frame = CGRect(x: 0, y: 0, width: filter_view.bounds.width * RESET_FILTERS_BUTTON_WIDTH_PART, height: filter_view.bounds.width * RESET_FILTERS_BUTTON_WIDTH_PART * RESET_FILTERS_BUTTON_ASPECT_RATIO)
        reset_filters_button.layer.cornerRadius = 6
        reset_filters_button.backgroundColor = RESET_FILTERS_BUTTON_BG
        reset_filters_button.setTitle("RESET FILTERS", forState: .Normal)
        reset_filters_button.setTitleColor(UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1.0), forState: .Normal)
        //reset_filters_button.titleLabel!.layer.borderWidth = 1.0
        let text_label_width = RESET_FILTERS_BUTTON_TEXT_PART * reset_filters_button.bounds.width
        reset_filters_button.titleLabel!.frame = CGRect(x: (reset_filters_button.bounds.width - text_label_width) * 0.5, y: 0, width: text_label_width, height: reset_filters_button.bounds.height)
        let font_size = General.apprFontSize("RESET FILTERS", str_attr: nil, fontName: "SFUIText-Medium", ref_value: (reset_filters_button.bounds.width * RESET_FILTERS_BUTTON_TEXT_PART), type: "w", attributed: false)
        reset_filters_button.titleLabel!.font = UIFont(name: "SFUIText-Medium", size: font_size)
        reset_filters_button.center = CGPointMake(0.5 * filter_view.bounds.width, RESET_FILTERS_BUTTON_MARGIN_TOP + reset_filters_button.bounds.height * 0.5)
        reset_filters_button.addTarget(self, action: "resetFiltersButtonPressed:", forControlEvents: .TouchUpInside)
        reset_filters_button.addTarget(self, action: "resetFiltersButtonTouched:", forControlEvents: .TouchDown)
        reset_filters_button.addTarget(self, action: "resetFiltersButtonReleased:", forControlEvents: .TouchUpOutside)
        let final_overlay_height = view.bounds.height - (navBar.frame.height + navBar.frame.minY)
        filter_view.addSubview(reset_filters_button)
        filter_overlay_view = UIView(frame: CGRect(x: 0, y: view.bounds.height
            - final_overlay_height, width: view.bounds.width, height: final_overlay_height))
        filter_overlay_view.backgroundColor = FILTER_OVERLAY_COLOR
        filter_overlay_view.layer.zPosition = 993
        filter_overlay_view.alpha = 0.0
        filter_overlay_view.hidden = true
        view.addSubview(filter_overlay_view)
        view.addSubview(filter_view)
        let close_filter_dialog_tap_recog = UITapGestureRecognizer(target: self, action: "tapCloseFilterDialog:")
        filter_overlay_view.addGestureRecognizer(close_filter_dialog_tap_recog)
        //configuring table view for settings
        let table_view_height = filter_view.bounds.height - FILTER_TABLE_TOP_MARGIN - RESET_FILTERS_BUTTON_MARGIN_TOP - reset_filters_button.bounds.height
        filter_table_view = UITableView(frame: CGRect(x: 0, y: (reset_filters_button.frame.maxY + FILTER_TABLE_TOP_MARGIN), width: filter_view.bounds.width, height: table_view_height), style: UITableViewStyle.Plain)
        filter_view.layer.zPosition = 994
        filter_table_view.tableFooterView = UIView()
        for i in 0...4 {
            updateHeadInfoInSection(i, withReloading: false)
        }
        filter_table_view.delegate = self
        
        filter_table_view.registerNib(UINib(nibName: "FilterCellHead", bundle: nil), forCellReuseIdentifier: "filter_cell_head")
        filter_table_view.registerNib(UINib(nibName: "FilterCellArea", bundle: nil), forCellReuseIdentifier: "filter_cell_area")
        filter_table_view.registerNib(UINib(nibName: "FilterCellGender", bundle: nil), forCellReuseIdentifier: "filter_cell_gender")
        filter_table_view.registerNib(UINib(nibName: "FilterCellTimeframe", bundle: nil), forCellReuseIdentifier: "filter_cell_timeframe")
        filter_table_view.registerNib(UINib(nibName: "FilterCellTimeframePicker", bundle: nil), forCellReuseIdentifier: "filter_cell_timeframe_picker")
        filter_table_view.dataSource = self
        filter_table_view.delegate = self
        //filter_table_view.separatorColor = UIColor.clearColor()
        filter_view.addSubview(filter_table_view)
    }
    
    //assigningtype = feed(for main feed) , feed_sep(for saved/my posts), one (for separate post viewing at OnePostViewController for main feed), one_sep(-//-)
    func startLoadingImagesForCardId(cardId:Int, withAssigningType:String) {
        var images_amount:Int = -1
        if withAssigningType == "feed" || withAssigningType == "one" {
            images_amount = current_feed_cells_data[cardId]!["images_count"] as! Int
        }
        else {
            images_amount = posts_vc.current_posts_data[cardId]!["images_count"] as! Int
        }
        let data_time_begin = CACurrentMediaTime()
        var resultImages:[UIImage] = []
        if images_amount != 0 {
            var images_paths:[String] = []
            let cache_dir = try? NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.CachesDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false)
            if let cache_url = cache_dir {
                let images_folder = cache_url.URLByAppendingPathComponent("imgs")
                for (var i = 0;i < images_amount;i++) {
                    let image_url = images_folder.URLByAppendingPathComponent("img_\(cardId)_\(i).jpeg")
                    let image_string_path = image_url.path!
                    images_paths.append(image_string_path)
                }
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                var started_loading = false
                for (var i = 0; i < images_paths.count;i++) {
                    if let img = UIImage(contentsOfFile: images_paths[i]) {
                        resultImages.append(img)
                    }
                    else {
                        //should load it from server and save to disc
                        let img = UIImage(named: "sample_\(i + 1)")!
                        resultImages.append(img)
                        UIImageJPEGRepresentation(img, 0.6)?.writeToFile(images_paths[i], atomically: true)
                    }
                }
                if !started_loading {
                    dispatch_async(dispatch_get_main_queue(), {
                        if withAssigningType == "feed" {
                            if let cell = self.feed_table_view.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: self.feedSectionForCardId(cardId))) as? FeedCellImages {
                                print("now setting images")
                                cell.setImages(resultImages, withDelay: false)
                            }
                        }
                        else if withAssigningType == "feed_sep" {
                            if let cell = self.posts_vc.posts_table_view.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: self.posts_vc.getSectionForCardId(cardId))) as? FeedCellImages {
                                cell.setImages(resultImages, withDelay: false)
                            }
                        }
                        else {
                            self.one_post_vc.setImages(resultImages)
                        }
                        let cons = CACurrentMediaTime() - data_time_begin
                        print("Data time consumption is \(cons)")
                    })
                }
            })
        }
    }
    
    func getImagesSizesForCardId(cardId:Int) -> [CGSize] {
        if cardId == 4 {
            return [UIImage(named: "sample_1")!.size,UIImage(named: "sample_2")!.size]
        }
        else {
            return [CGSizeZero]
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        checkFeedScrollingUpdating()
    }
    
    func checkFeedScrollingUpdating() {
        if feed_state != "end" {
            let scroll_percent = (feed_table_view.contentOffset.y + feed_table_view.bounds.height) / feed_table_view.contentSize.height
            /*
            if scroll_percent >= FEED_TABLE_SCROLLED_START_LOADING {
                startLoadingNewCardsWithName("add_data")
            }
*/
            if (feed_table_view.contentSize.height - feed_table_view.contentOffset.y ) <= CGFloat(FEED_UPDATING_SCREENS_LEFT_COUNT) * view.bounds.height {
                startLoadingNewCardsWithName("add_data\(selected_area_id)")
            }
        }
    }
    
    func updateFeedFooter() {
        var new_footer_state = "hidden"
        if feed_state == "end" {
            new_footer_state = "end"
        }
        else if feed_state == "loading" {
            new_footer_state = "loading"
        }
        if (feed_section_to_card_id as! NSDictionary).allKeys.count == 0 {
            if feed_state == "loading" {
                //show loading full screen
            }
            else {
                feed_empty_icon.hidden = false
                feed_empty_label.hidden = false
            }
            new_footer_state = "hidden"
        }
        else {
            feed_empty_icon.hidden = true
            feed_empty_label.hidden = true
        }
        if new_footer_state != feed_footer_state {
            feed_footer_state = new_footer_state
            if feed_footer_state == "hidden" {
                UIView.animateWithDuration(FEED_FOOTER_ANIMATION_DURATION, animations: {
                    self.feed_footer_view.alpha = 0.0
                    }, completion: {
                        (fin:Bool) in
                        self.feed_footer_view.hidden = true
                        self.feed_footer_label_end.hidden = true
                        self.feed_footer_loading_view.hidden = true
                })
            }
            else {
                if feed_footer_state == "loading" {
                    feed_footer_view.frame = CGRect(x: feed_footer_view.frame.minX , y: feed_footer_view.frame.minY, width: view.bounds.width, height: feed_footer_loading_view.frame.maxY + FEED_FOOTER_LOADING_MARGIN_BOTTOM)
                    //feed_table_view.layoutSubviews()
                }
                else {
                    feed_footer_view.frame = CGRect(x: feed_footer_view.frame.minX , y: feed_footer_view.frame.minY, width: view.bounds.width, height: feed_footer_label_end.frame.maxY + FEED_FOOTER_LABEL_MARGIN_BOTTOM)
                    //feed_table_view.layoutSubviews()
                }
                var should_show_footer = false
                if feed_footer_view.hidden {
                    should_show_footer = true
                    feed_footer_view.hidden = false
                    if feed_footer_state == "end" {
                        feed_footer_label_end.hidden = false
                        feed_footer_label_end.alpha = 1.0
                    }
                    else {
                        feed_footer_loading_view.hidden = false
                        feed_footer_loading_view.alpha = 1.0
                    }
                }
                UIView.animateWithDuration(FEED_FOOTER_ANIMATION_DURATION, animations: {
                    if should_show_footer {
                        self.feed_footer_view.alpha = 1.0
                    }
                    else if self.feed_footer_state == "end" {
                        self.feed_footer_loading_view.alpha = 0.0
                        self.feed_footer_label_end.alpha = 1.0
                    }
                    else {
                        self.feed_footer_label_end.alpha = 0.0
                        self.feed_footer_loading_view.alpha = 1.0
                    }
                    }, completion: {
                        (fin:Bool) in
                        if !should_show_footer {
                            if self.feed_footer_state == "end"{
                                self.feed_footer_loading_view.hidden = true
                            }
                            else {
                                self.feed_footer_label_end.hidden = true
                            }
                        }
                })
            }
        }
    }
    
    func prepareNewAreaId(areaId:Int) {
        current_place_name = General.all_areas_info[selected_area_id]!["title"] as! String
        navigationItem.title = current_place_name
        //first we should look through the already downloaded cards so that to see whether there are some appropriate cards here already
        let now_cards = (current_feed_cells_data as! NSDictionary).allKeys as! [Int]
        for now_card in now_cards {
            if !General.areaId(areaId, hasChildAreaId: now_card) {
                current_feed_cells_data.removeValueForKey(now_card)
            }
        }
        feed_state = "loading"
        setupCurrentSectionMappingByAppendingCards(nil, withUpdatingTable: true)
        //updateFeedFooter()
        //some time later..
        let json_data = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("origin_data\(areaId)", ofType: "json")!)
        let json = (try? NSJSONSerialization.JSONObjectWithData(json_data!, options: [])) as! NSDictionary
        let new_data = General.generateFeedDataFromJsonData(json)
        current_feed_cells_data = [Int:NSMutableDictionary]()
        for new_data_key in (new_data.cells_add as! NSDictionary).allKeys as! [Int] {
            current_feed_cells_data[new_data_key] = new_data.cells_add[new_data_key]!
        }
        feed_state = "ok"
        if new_data.error == "end" {
            feed_state = "end"
        }
        setupCurrentSectionMappingByAppendingCards(nil, withUpdatingTable: true)
        //updateFeedFooter()
        let pins_json_data = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("geo_pins_data\(areaId)", ofType: "json")!)
        let json_pins = (try? NSJSONSerialization.JSONObjectWithData(pins_json_data!, options: [])) as! NSDictionary
        let new_pins_data = General.generateGeoPinsListForJsonData(json_pins)
        current_pins_data = [Int:NSDictionary]()
        for new_pin_card_id in (new_pins_data as! NSDictionary).allKeys as! [Int] {
            current_pins_data[new_pin_card_id] = new_pins_data[new_pin_card_id]!
        }
    }
    
    //maybe we should specify the amount of cards we want to load --lots for card lookup, less for simple feed scrolling
    func startLoadingNewCardsWithName(jsonName:String) {
        print("started loading new cards")
        //now we should access the internet
        //or  maybe look through our little friendly cache
        //we load new cards, add them to current_feed_cells_data ,then insert new sections mapping
        let json_data = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource(jsonName, ofType: "json")!)!
        let data = (try? NSJSONSerialization.JSONObjectWithData(json_data, options: [])) as! NSDictionary
        let add_result = General.generateFeedDataFromJsonData(data)
        let cards_add:[Int:NSMutableDictionary] = add_result.cells_add
        let result_error = add_result.error
        //assumed now loading and processing finished - should be done on background thread
        let cards_ids_add = (cards_add as! NSDictionary).allKeys as! [Int]
        for cardIdAdd in cards_ids_add {
            current_feed_cells_data[cardIdAdd] = cards_add[cardIdAdd]!
        }
        if result_error == "end" {
            feed_state = "end"
        }
        else {
            //shoul set laoding, now setting ok
            feed_state = "ok"
        }
        setupCurrentSectionMappingByAppendingCards(cards_ids_add,withUpdatingTable: true)
        //let inserted_count = mapping_result.insertSections.count
        //updateFeedFooter()
        //print("was inserted \(inserted_count)")
    }
    
    //if we call it with nil, then only specified cards will be appended and updated - should use it when loading new content
    //otherwise updating all the data - when filter changed, for example
    
    /*
    func setupCurrentSectionMappingByAppendingCards(cardsIds:[Int]?,withUpdatingTable:Bool) -> (insertSections:[Int], deleteSections:[Int], updateSections:[Int]) {

*/
    func setupCurrentSectionMappingByAppendingCards(cardsIds:[Int]?,withUpdatingTable:Bool) -> [Int] {
        var feed_data_keys:[Int] = []
        let prev_section_mapping = NSDictionary(dictionary: feed_section_to_card_id)
        var prev_last_section_id = -1
        var section_id = 0
        if let cards_append = cardsIds {
            //print("having cards to append\(cards_append)")
            section_id = (feed_section_to_card_id as! NSDictionary).allKeys.count
            prev_last_section_id = section_id - 1
            feed_data_keys.appendContentsOf(cards_append)
        }
        else {
            feed_section_to_card_id = [Int:Int]()
            feed_data_keys.appendContentsOf((current_feed_cells_data as! NSDictionary).allKeys as! [Int])
        }
        feed_data_keys = feed_data_keys.sort({$0 > $1})
        let shown_cards_ids:[Int] = (current_feed_cells_data as! NSDictionary).allKeys as! [Int]
        var blocked_cards_ids:[Int] = [] //we'll use it for hiding blocked pins from map in setpinsdata
        //print("beginning section mapping \(feed_section_to_card_id)")
        for feed_data_key in feed_data_keys {
            //checking some required filters...
            let current_area_id = current_feed_cells_data[feed_data_key]!["areaId"] as! Int
            if data_filter_present {
                let p1 = current_feed_cells_data[feed_data_key]!["person_1"] as! String
                let p2 = current_feed_cells_data[feed_data_key]!["person_2"] as! String
                let gender_type = p1 + p2
                if !(current_filter_data["gender"]![gender_type] as! Bool) {
                    blocked_cards_ids.append(feed_data_key)
                    continue
                }
                if !(current_filter_data["include_transport"] as! Bool) && current_feed_cells_data[feed_data_key]!["transport_icon_present"] as! Bool {
                    blocked_cards_ids.append(feed_data_key)
                    continue
                }
                let shown_areas = current_filter_data["shown_areas"] as! [NSDictionary]
                for shown_area in shown_areas {
                    if !(shown_area["checked"] as! Bool) {
                        let switched_off_area_id = shown_area["areaId"] as! Int
                        if General.areaId(switched_off_area_id, hasChildAreaId: current_area_id) {
                            blocked_cards_ids.append(feed_data_key)
                            continue
                        }
                    }
                }
                if current_filter_data["include_nearby"] as! Bool {
                    if !nearby_areas_ids.contains(current_area_id) {
                        blocked_cards_ids.append(feed_data_key)
                        continue
                    }
                }
                let filter_start_date = current_filter_data["timeframe"]!["start_date"] as! NSDate
                let filter_end_date = current_filter_data["timeframe"]!["end_date"] as! NSDate
                let current_date = current_feed_cells_data[feed_data_key]!["posting_date"] as! NSDate
                let start_comp = current_date.compare(filter_start_date)
                let end_comp = current_date.compare(filter_end_date)
                if !((start_comp == NSComparisonResult.OrderedDescending || start_comp == NSComparisonResult.OrderedSame) && (end_comp == NSComparisonResult.OrderedAscending || end_comp == NSComparisonResult.OrderedSame)) {
                    blocked_cards_ids.append(feed_data_key)
                    continue
                }
            }
            if map_filter_present {
                if !map_filtered_cards_ids.contains(feed_data_key) {
                    continue
                }
            }
            feed_section_to_card_id[section_id++] = feed_data_key
        }
        var insertSections:[Int] = []
        var deleteSections:[Int] = []
        var updateSections:[Int] = []
        if cardsIds == nil {
            let new_sections_keys = (feed_section_to_card_id as! NSDictionary).allKeys as! [Int]
            let prev_sections_keys = prev_section_mapping.allKeys as! [Int]
            for new_section_key in new_sections_keys {
                if prev_sections_keys.contains(new_section_key) {
                    if prev_section_mapping[new_section_key] as! Int != feed_section_to_card_id[new_section_key] {
                        updateSections.append(new_section_key)
                    }
                }
                else {
                    insertSections.append(new_section_key)
                }
            }
            for prev_section_key in prev_sections_keys {
                if !new_sections_keys.contains(prev_section_key) {
                    deleteSections.append(prev_section_key)
                }
            }
        }
        else {
            let last_section_id = (feed_section_to_card_id as! NSDictionary).allKeys.count - 1
            if feed_section_to_card_id[prev_last_section_id + 1] != nil {
                for (var i = prev_last_section_id + 1;i <= last_section_id;i++) {
                    insertSections.append(i)
                }
            }
        }
        //print("end section mapping \(feed_section_to_card_id)")
        let all_cards = (current_feed_cells_data as! NSDictionary).allKeys as! [Int]
        let calculated_cards = (feed_cells_heights as! NSDictionary).allKeys as! [Int]
        for card in all_cards {
            if !calculated_cards.contains(card) {
                calculateCardFramesWithCardId(card)
            }
        }
        if withUpdatingTable {
            if insertSections.count != 0 {
                let insertSet = NSMutableIndexSet()
                for insertSection in insertSections {
                    insertSet.addIndex(insertSection)
                }
                feed_table_view.insertSections(insertSet, withRowAnimation: .Fade)
            }
            if deleteSections.count != 0 {
                let deleteSet = NSMutableIndexSet()
                for deleteSection in deleteSections {
                    deleteSet.addIndex(deleteSection)
                }
                feed_table_view.deleteSections(deleteSet, withRowAnimation: .Fade)
            }
            if updateSections.count != 0 {
                let updateSet = NSMutableIndexSet()
                for updateSection in updateSections {
                    updateSet.addIndex(updateSection)
                }
                feed_table_view.reloadSections(updateSet, withRowAnimation: .Fade)
            }
        }
        //should start loading new cards if we're having empty feed or we're close to the end of the feed
        /*
        if (feed_section_to_card_id as! NSDictionary).allKeys.count == 0 {
            startLoadingNewCardsWithName("add_data\(selected_area_id)")
        }
*/
        updateFeedFooter()
        //return (insertSections,deleteSections,updateSections)
        return blocked_cards_ids
    }
    
    func setupSettingsView() {
        settings_table_view = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: settings_tab_holder_view.bounds.height), style: UITableViewStyle.Plain)
        settings_table_view.registerNib(UINib(nibName: "SettingsCellBig", bundle: nil), forCellReuseIdentifier: "settings_cell_big")
        settings_table_view.registerNib(UINib(nibName: "SettingsCellText", bundle: nil), forCellReuseIdentifier: "settings_cell_text")
        settings_table_view.registerNib(UINib(nibName: "SettingsCellRegular", bundle: nil), forCellReuseIdentifier: "settings_cell_regular")
        settings_table_view.estimatedRowHeight = 30
        settings_table_view.backgroundColor = UIColor.clearColor()
        settings_table_view.delegate = settings_table_protocol
        settings_table_view.dataSource = settings_table_protocol
        settings_table_view.tableFooterView = UIView()
        settings_table_view.showsVerticalScrollIndicator = false
        settings_tab_holder_view.addSubview(settings_table_view)
    }
    
    func setupFeedTableView() {
        feed_empty_label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 40))
        feed_empty_label.text = "No posts!"
        feed_empty_label.textColor = FEED_FOOTER_LABEL_TEXT_COLOR
        feed_empty_label.font = UIFont(name: "SFUIText-Bold", size: FEED_EMPTY_LABEL_TEXT_SIZE)!
        feed_empty_label.textAlignment = .Center
        let real_empty_size = feed_empty_label.textRectForBounds(feed_empty_label.bounds, limitedToNumberOfLines: 1)
        let real_empty_icon_width = view.bounds.width * FEED_EMPTY_ICON_WIDTH_RELATIVE
        let total_empty_height = real_empty_size.height + real_empty_icon_width + FEED_EMPTY_LABEL_MARGIN_TOP
        let top_image_margin = (people_tab_holder_view.bounds.height - total_empty_height) * 0.5
        feed_empty_icon = UIImageView(image: UIImage(named: "feed_empty_icon")!)
        feed_empty_icon.contentMode = .ScaleAspectFit
        feed_empty_icon.frame = CGRect(x: 0.5 * view.bounds.width - real_empty_icon_width * 0.5, y: top_image_margin, width: real_empty_icon_width, height: real_empty_icon_width)
        feed_empty_label.frame = CGRect(x: 0, y: feed_empty_icon.frame.maxY + FEED_EMPTY_LABEL_MARGIN_TOP, width: view.bounds.width, height: real_empty_size.height)
        feed_empty_icon.hidden = true
        feed_empty_label.hidden = true
        people_tab_holder_view.addSubview(feed_empty_label)
        people_tab_holder_view.addSubview(feed_empty_icon)
        //now setting up a techical card for estimating future cells' heights
        feed_card_estimate_plain = FeedCellPlain(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 400))
        feed_card_estimate_images = FeedCellImages(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 400))
        feed_footer_view = UIView()
        feed_footer_view.backgroundColor = UIColor.clearColor()
        feed_footer_loading_view = UIView(frame: CGRect(x: FEED_FOOTER_LOADING_MARGIN_TOP, y: 0, width: view.bounds.width, height: 15))
        feed_footer_loading_view.backgroundColor = UIColor.grayColor()
        feed_footer_loading_view.hidden = true
        feed_footer_label_end = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width * FEED_FOOTER_LABEL_WIDTH_RELATIVE, height: 60))
        feed_footer_label_end.hidden = true
        feed_footer_label_end.textAlignment = .Center
        feed_footer_label_end.text = "No more posts"
        feed_footer_label_end.textColor = FEED_FOOTER_LABEL_TEXT_COLOR
        feed_footer_label_end.font = UIFont(name: "SFUIText-Semibold", size: FEED_FOOTER_LABEL_TEXT_SIZE)!
        let footer_label_size = feed_footer_label_end.textRectForBounds(feed_footer_label_end.bounds, limitedToNumberOfLines: 1)
        feed_footer_label_end.frame = CGRect(x: (1.0 - FEED_FOOTER_LABEL_WIDTH_RELATIVE) * 0.5 * view.bounds.width, y: FEED_FOOTER_LABEL_MARGIN_TOP, width: FEED_FOOTER_LABEL_WIDTH_RELATIVE * view.bounds.width, height: footer_label_size.height)
        feed_footer_view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: feed_footer_label_end.frame.maxY + FEED_FOOTER_LABEL_MARGIN_BOTTOM)
        feed_footer_view.addSubview(feed_footer_label_end)
        feed_footer_view.addSubview(feed_footer_loading_view)
        feed_footer_view.alpha = 0.0
        feed_footer_view.hidden = true
        feed_table_view = UITableView(frame: CGRect(x: 0, y: FEED_TABLE_MARGIN_TOP, width: view.bounds.width, height: people_tab_holder_view.bounds.height - FEED_TABLE_MARGIN_TOP - FEED_TABLE_MARGIN_BOTTOM), style: .Plain)
        feed_table_view.registerClass(FeedCellPlain.self, forCellReuseIdentifier: "feed_cell")
        feed_table_view.registerClass(FeedCellImages.self, forCellReuseIdentifier: "feed_cell_images")
        feed_table_view.delegate = self
        feed_table_view.dataSource = self
        feed_table_view.backgroundColor = UIColor.clearColor()
        feed_table_view.separatorColor = UIColor.clearColor()
        feed_table_view.showsHorizontalScrollIndicator = false
        //feed_table_view.showsVerticalScrollIndicator = false
        feed_table_view.tableFooterView = feed_footer_view
        people_tab_holder_view.addSubview(feed_table_view)
    }

    
    //style = full(for map in one_post_vc) , feed(in feed)
    func startLoadingMapSnapshotForCardId(cardId:Int, withStyle:String, withAssigning:Bool) {
        var map_path:String = ""
        let file_manager = NSFileManager.defaultManager()
        if let cache_dir = try? file_manager.URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false) {
            let map_dir = cache_dir.URLByAppendingPathComponent("maps")
            let path_with_style = (withStyle == "feed" || withStyle == "feed_sep") ? "feed" : "full"
            map_path = map_dir.URLByAppendingPathComponent("\(path_with_style)_\(cardId).jpeg").path!
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            if !file_manager.fileExistsAtPath(map_path) {
                self.preloadMapSnapshotForCardId(cardId, withStyle:withStyle,withAssigning:withAssigning)
            }
            else {
                if withAssigning {
                    if let map_img_cache = UIImage(contentsOfFile: map_path) {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.assignMapImage(map_img_cache, withStyle: withStyle, cardId: cardId)
                        })
                    }
                }
            }
        })
    }
    
    func preloadMapSnapshotForCardId(cardId:Int, withStyle:String,withAssigning:Bool) {
        let opts = MKMapSnapshotOptions()
        var final_image_size = CGSizeZero
        if withStyle == "feed_sep" {
            final_image_size = posts_vc.posts_cells_frames[cardId]!["image_right"]!.size
        }
        else if withStyle == "feed" {
            final_image_size = feed_cells_frames[cardId]!["image_right"]!.size
        }
        else {
            final_image_size = CGSizeMake(view.bounds.width, one_post_vc.IMAGE_CENTER_MAP_HEIGHT)
        }
        var map_coords:CLLocationCoordinate2D!
        if withStyle == "feed" || withStyle == "full" {
            map_coords = (current_feed_cells_data[cardId]!["map_coords"] as! NSValue).MKCoordinateValue
        }
        else {
            map_coords = (posts_vc.current_posts_data[cardId]!["map_coords"] as! NSValue).MKCoordinateValue
        }
        let mapPoint = MKMapPointForCoordinate(map_coords)
        let totalWidth = MKMapPointsPerMeterAtLatitude(map_coords.latitude) * ((withStyle == "feed" || withStyle == "feed_sep") ? MAP_SNAPSHOT_METERS_PER_WIDTH_FEED : MAP_SNAPSHOT_METERS_PER_WIDTH_FULL)
        let totalHeight = totalWidth * Double(final_image_size.height) / Double(final_image_size.width)
        opts.mapRect = MKMapRect(origin: MKMapPoint(x: mapPoint.x - totalWidth * 0.5, y: mapPoint.y - totalHeight * 0.5), size: MKMapSizeMake(totalWidth, totalHeight))
        opts.size = final_image_size
        let snapshotter = MKMapSnapshotter(options: opts)
        snapshotter.startWithCompletionHandler({
            (snap:MKMapSnapshot?, error: NSError?) in
            if let img = snap?.image {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    let finalImage = General.getGradientMapImageForSize(img.size, originalImage: img, isPlaceholder: false, withStyle: withStyle)
                    if withAssigning {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.assignMapImage(finalImage, withStyle: withStyle, cardId: cardId)
                        })
                    }
                    if let cache_dir = try? NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false) {
                        let map_folder = cache_dir.URLByAppendingPathComponent("maps")
                        let path_with_style = (withStyle == "feed" || withStyle == "feed_sep") ? "feed" : "full"
                        let map_path = map_folder.URLByAppendingPathComponent("\(path_with_style)_\(cardId).jpeg").path!
                        UIImageJPEGRepresentation(finalImage, 0.6)?.writeToFile(map_path, atomically: true)
                    }
                })
            }
        })
    }
    
    func assignMapImage(image:UIImage, withStyle:String, cardId:Int) {
        if withStyle == "feed" {
            if self.current_feed_cells_data[cardId]!["images_count"] as! Int == 0 {
                if let cell = self.feed_table_view.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: self.feedSectionForCardId(cardId))) as? FeedCellPlain {
                    cell.setMapImage(image, withDelay: false)
                }
            }
            else {
                if let cell = self.feed_table_view.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: self.feedSectionForCardId(cardId))) as? FeedCellImages {
                    cell.setMapImage(image, withDelay: false)
                }
            }
        }
        else if withStyle == "feed_sep" {
            if self.posts_vc.current_posts_data[cardId]!["images_count"] as! Int == 0 {
                if let cell = self.posts_vc.posts_table_view.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: self.posts_vc.getSectionForCardId(cardId))) as? FeedCellPlain {
                    cell.setMapImage(image, withDelay: false)
                }
            }
            else {
                if let cell = self.posts_vc.posts_table_view.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: self.posts_vc.getSectionForCardId(cardId))) as? FeedCellImages {
                    cell.setMapImage(image, withDelay: false)
                }
            }
        }
        else {
            self.one_post_vc.setMapImageWithImage(image)
        }
    }
    
    func constructNearbyAreasText() -> String {
        let areas_included = current_filter_data["nearby_areas"] as! [String]
        var areas_left = areas_included.count
        var result_string = ""
        if areas_left != 0 {
            if areas_left == 1 {
                result_string += areas_included[0]
                areas_left--
            }
            else {
                result_string += (areas_included[0] + ", " + areas_included[1])
                areas_left -= 2
            }
            if areas_left > 0 {
                result_string += " and \(areas_left) more will be included"
            }
            else {
                result_string += " will be included"
            }
        }
        else {
            result_string = "No nearby areas were found"
        }
        return result_string
    }
    
    func feedSectionForCardId(cardId:Int) -> Int {
        var section = -1
        for (key,value) in feed_section_to_card_id {
            if value == cardId {
                section = key
            }
        }
        return section
    }
    
    func mapSnapshotIdForCardId(cardId:Int) -> Int {
        var snapId = -1
        for (key,value) in map_snapshots_to_card_id {
            if value == cardId {
                snapId = key
            }
        }
        return snapId
    }
    
    func getCardDimensionsWithCardData(cardData:NSDictionary) -> (finalFrames:[String:CGRect],cellHeight:CGFloat) {
        if cardData["images_present"] as! Bool {
            feed_card_estimate_images.setContent(cardData)
            feed_card_estimate_images.updateFramesWithWidth(view.bounds.width)
            let final_frames = feed_card_estimate_images.getFinalFrames()
            return (final_frames,final_frames["button_reply"]!.maxY)
        }
        else {
            feed_card_estimate_plain.setContent(cardData)
            feed_card_estimate_plain.updateFramesWithWidth(view.bounds.width)
            let final_frames = feed_card_estimate_plain.getFinalFrames()
            return (final_frames,final_frames["button_reply"]!.maxY)
        }
    }
    
    func calculateCardFramesWithCardId(no:Int) {
        let start_calc_time = CACurrentMediaTime()
        //we're taking info from cells feed, populating our estimate cell with it and wrtinig resulting frames to special aray, the same applies to heights for each row
        let card_dimensions = getCardDimensionsWithCardData(current_feed_cells_data[no] as! NSDictionary)
        feed_cells_frames[no] = card_dimensions.finalFrames
        feed_cells_heights[no] = card_dimensions.cellHeight
        /*
        if current_feed_cells_data[no]!["images_present"] as! Bool {
            feed_card_estimate_images.setContent(current_feed_cells_data[no]!)
            feed_card_estimate_images.updateFramesWithWidth(view.bounds.width)
            feed_cells_frames[no] = feed_card_estimate_images.getFinalFrames()
            feed_cells_heights[no] = feed_cells_frames[no]!["button_reply"]!.maxY
        }
        else {
            feed_card_estimate_plain.setContent(current_feed_cells_data[no]!)
            feed_card_estimate_plain.updateFramesWithWidth(view.bounds.width)
            feed_cells_frames[no] = feed_card_estimate_plain.getFinalFrames()
            feed_cells_heights[no] = feed_cells_frames[no]!["button_reply"]!.maxY
        }
*/
        let cons = CACurrentMediaTime() - start_calc_time
        print("card calc took \(cons)")
    }
    
    
    func cardMenuPressed(cardId:Int) {
        print("\(cardId) pressed")
        presentViewController(getCardMenuForCardId(cardId, pressedIn: "main_feed"), animated: true, completion: nil)
    }
    
    //pressedIn - "main_feed" or "posts_feed"(saved/my)
    func getCardMenuForCardId(cardId:Int,pressedIn:String) -> UIAlertController {
        let bookmarked = (NSUserDefaults().arrayForKey("cards_bookmarks") as! [Int]).contains(cardId)
        let my_posts_cards_ids = NSUserDefaults().arrayForKey("my_posts_cards_ids") as! [Int]
        let menu_vc = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        menu_vc.addAction(UIAlertAction(title: "Report an issue", style: .Default, handler: {
            (act:UIAlertAction) in
            self.reportIssuePressedWithCardId(cardId)
            menu_vc.dismissViewControllerAnimated(true, completion: nil)
        }))
        let save_title = bookmarked ? "Unsave" : "Save"
        menu_vc.addAction(UIAlertAction(title: save_title, style: .Default, handler: {
            (act:UIAlertAction) in
            self.savePressedWithCardId(cardId, pressedIn: pressedIn)
            menu_vc.dismissViewControllerAnimated(true, completion: nil)
        }))
        if my_posts_cards_ids.contains(cardId) {
            menu_vc.addAction(UIAlertAction(title: "Delete my own post", style: UIAlertActionStyle.Destructive, handler: {
                (act:UIAlertAction) in
                let deletion_alert = UIAlertController(title: "Delete your post?", message: "This process is irreversible", preferredStyle: UIAlertControllerStyle.Alert)
                deletion_alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
                    (act:UIAlertAction) in
                    deletion_alert.dismissViewControllerAnimated(true, completion: nil)
                }))
                deletion_alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: {
                    (act:UIAlertAction) in
                    self.deleteOwnPostWithCardId(cardId)
                    deletion_alert.dismissViewControllerAnimated(true, completion: nil)
                }))
                self.presentViewController(deletion_alert, animated: true, completion: nil)
            }))
        }
        menu_vc.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (act:UIAlertAction) in
            menu_vc.dismissViewControllerAnimated(true, completion: nil)
        }))
        return menu_vc
    }
    
    func reportIssuePressedWithCardId(cardId:Int) {
        print("pressed report issue with card id = \(cardId)")
    }
    
    //IMPORTANT!!!
    //When archiving post with map coords, we change structure of dictionary a little: map_lat & map_long instead of cllocationcoordinates2d
    func savePressedWithCardId(cardId:Int, pressedIn:String) {
        print("pressed save with card id = \(cardId)")
        var now_removing = false
        var cards_bookmarks = NSUserDefaults().arrayForKey("cards_bookmarks") as! [Int]
        var bookmark_icon_image_name = "bookmark_card_icon_"
        var saved_posts_path = ""
        var saved_dict_archive_path = ""
        var saved_dict:NSMutableDictionary?
        var saved_dict_archive:NSMutableDictionary?
        let document_folder = try? NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false)
        if let document_folder_url = document_folder {
            //saved_posts_path = (document_folder_url.URLByAppendingPathComponent("saved_posts.plist")).path!
            //saved_dict = NSMutableDictionary(contentsOfFile: saved_posts_path)
            
            //print("just read saved dict")
            //print(saved_dict!)
            saved_dict_archive_path = document_folder_url.URLByAppendingPathComponent("saved_posts_archive.arch").path!
            saved_dict_archive = NSKeyedUnarchiver.unarchiveObjectWithFile(saved_dict_archive_path) as? NSMutableDictionary
        }
        if cards_bookmarks.contains(cardId) {
            now_removing = true
            var index = -1
            for (var i = 0;i < cards_bookmarks.count;i++) {
                if cards_bookmarks[i] == cardId {
                    index = i
                    break
                }
            }
            if index != -1 {
                cards_bookmarks.removeAtIndex(index)
            }
            bookmark_icon_image_name += "off"
            if saved_dict != nil {
                //saved_dict?.removeObjectForKey("\(cardId)")
            }
            if saved_dict_archive != nil {
                saved_dict_archive?.removeObjectForKey(cardId)
            }
        }
        else {
            cards_bookmarks.append(cardId)
            bookmark_icon_image_name += "on"
            if saved_dict_archive != nil {
                //saved_dict?["\(cardId)"] = current_feed_cells_data[cardId]
                let post_dict_for_archiving = NSMutableDictionary(dictionary: current_feed_cells_data[cardId]!)
                if post_dict_for_archiving["map_present"] as! Bool {
                    let map_coords = (post_dict_for_archiving["map_coords"] as! NSValue).MKCoordinateValue
                    post_dict_for_archiving.removeObjectForKey("map_coords")
                    post_dict_for_archiving["map_lat"] = map_coords.latitude as! Double
                    post_dict_for_archiving["map_long"] = map_coords.longitude as! Double
                }
                saved_dict_archive?[cardId] = post_dict_for_archiving
            }
        }
        if saved_dict_archive != nil {
            //let ok = saved_dict?.writeToFile(saved_posts_path, atomically: false)
            //print("saved \(ok!)")
            let saved_dict_data = NSKeyedArchiver.archivedDataWithRootObject(saved_dict_archive!)
            let ok_arch = saved_dict_data.writeToFile(saved_dict_archive_path, atomically: false)
            print("archive saved \(ok_arch)")
        }
        NSUserDefaults().setObject(cards_bookmarks, forKey: "cards_bookmarks")
        let section_main = feedSectionForCardId(cardId)
        var images_present = false
        if pressedIn == "posts_feed" && posts_vc.current_posts_data[cardId]!["images_present"] as! Bool {
            images_present = true
        }
        if pressedIn == "main_feed" && current_feed_cells_data[cardId]!["images_present"] as! Bool {
            images_present = true
        }
        if section_main != -1 {
            if images_present {
                if let card_cell = feed_table_view.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section_main)) as? FeedCellImages {
                    card_cell.bookmark_icon.image = UIImage(named: bookmark_icon_image_name)!
                }
            }
            else {
                if let card_cell = feed_table_view.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section_main)) as? FeedCellPlain {
                    card_cell.bookmark_icon.image = UIImage(named: bookmark_icon_image_name)!
                }
            }
        }
        if now_removing && pressedIn == "posts_feed" {
            posts_vc.deletePostWithCardId(cardId)
        }
        updateSettingsTableNumbers()
        /*
        if pressedIn == "posts_feed" && section_posts != -1 {
            if images_present {
                if let card_cell = posts_vc.posts_table_view.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section_posts)) as? FeedCellImages {
                    card_cell.bookmark_icon.image = UIImage(named: bookmark_icon_image_name)!
                }
            }
            else {
                if let card_cell = feed_table_view.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section_posts)) as? FeedCellPlain {
                    card_cell.bookmark_icon.image = UIImage(named: bookmark_icon_image_name)!
                }
            }
        }
*/
    }
    
    func cardReplyPressed(cardId:Int) {
        let docs_url = try? NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false)
        if let docs = docs_url {
            var should_update_chats_list = false, should_mark_read = false
            let chats_archive_path = docs.URLByAppendingPathComponent("chats.arch").path!
            var chats_archive = NSKeyedUnarchiver.unarchiveObjectWithFile(chats_archive_path) as! NSArray
            let chats_data = NSMutableArray(array: chats_archive)
            var chatIndex = -1
            var chat_show:NSMutableDictionary!
            for (var i = 0;i < chats_data.count;i++) {
                if chats_data[i]["cardId"] as! Int == cardId {
                    chatIndex = i
                    chat_show = NSMutableDictionary(dictionary: chats_data[i] as! NSDictionary)
                    if chat_show["unread"] as! Bool {
                        should_mark_read = true
                    }
                    break
                }
            }
            if should_mark_read {
                chat_show["unread"] = false
                let new_chats_archive = NSMutableArray(array: chats_archive)
                new_chats_archive[chatIndex] = chat_show
                NSKeyedArchiver.archivedDataWithRootObject(new_chats_archive).writeToFile(chats_archive_path, atomically: false)
                let unread_chats_amount = NSUserDefaults().integerForKey("unread_chats_total") - 1
                NSUserDefaults().setInteger(unread_chats_amount, forKey: "unread_chats_total")
                updateSettingsTableNumbers()
            }
            if chatIndex == -1 {
                chatIndex = 0
                let new_chat = NSMutableDictionary()
                new_chat["adding_date"] = NSDate()
                new_chat["cardId"] = cardId
                let title_text = current_feed_cells_data[cardId]?["nick"] as? String
                new_chat["nick"] = title_text
                new_chat["cardTitle"] = current_feed_cells_data[cardId]?["title_text"] as? String
                if title_text == nil {
                    print("FATAl: No data for this card id. Time to build REAL system for retrieveing cards")
                    return
                }
                new_chat["unread"] = false
                let messages = NSArray()
                new_chat["messages"] = messages
                chats_data.addObject(new_chat)
                NSKeyedArchiver.archivedDataWithRootObject(chats_data).writeToFile(chats_archive_path, atomically: false)
                NSUserDefaults().setInteger(chats_data.count, forKey: "chats_total")
                updateSettingsTableNumbers()
                chat_show = NSMutableDictionary(dictionary: new_chat)
            }
            settings_table_protocol.chats_list_vc.prepareChatsListWithReloading(false)
            let chat_vc = ChatViewController()
            chat_vc.prepareMessagesWithChat(chat_show, myAvatarBgColor: General.my_avatar_bg_color, companionAvatarBgColor: settings_table_protocol.chats_list_vc.avatars_colors[cardId]!, chatsListVc: settings_table_protocol.chats_list_vc)
            navigationController!.pushViewController(chat_vc, animated: true)
        }
    }
    
    func cardSharePressed(cardId:Int) {
        
    }
    
    func updateHeadInfoInSection(section_id:Int,withReloading:Bool) {
        switch section_id {
        case 0:
            var active_areas_amount = 0
            var right_text = "None"
            let total_areas = (current_filter_data["shown_areas"] as! [NSDictionary]).count
            let all_areas = current_filter_data["shown_areas"] as! [NSDictionary]
            for area in all_areas {
                if area["checked"] as! Bool {
                    active_areas_amount++
                }
            }
            if total_areas == 0 {
                right_text = "Everything"
                current_filter_heads_info[0]["isExpandable"] = false
                current_filter_heads_info[0]["isExpanded"] = false
            }
            else {
                current_filter_heads_info[0]["isExpandable"] = true
                //current_filter_heads_info[0]["isExpanded"] = false
                current_areas_error = true
                if active_areas_amount == total_areas {
                    right_text = "All"
                    current_areas_error = false
                }
                else if active_areas_amount != 0 {
                    right_text = "\(active_areas_amount)/\(total_areas)"
                    current_areas_error = false
                }
            }
            current_filter_heads_info[0]["text_right"] = right_text
        case 1:
            var gender_icon_on_amount = 0
            for key in current_filter_data["gender"]!.allKeys as! [String] {
                if current_filter_data["gender"]![key] as! Bool {
                    gender_icon_on_amount++
                }
            }
            if gender_icon_on_amount == 0 {
                current_filter_heads_info[1]["text_right"] = "None"
                current_gender_error = true
            }
            else if gender_icon_on_amount == 4 {
                current_filter_heads_info[1]["text_right"] = "All"
                current_gender_error = false
            }
            else {
                current_filter_heads_info[1]["text_right"] = "\(gender_icon_on_amount)/4"
                current_gender_error = false
            }
        case 2:
            let end_date = current_filter_data["timeframe"]!["end_date"] as! NSDate
            let start_date = current_filter_data["timeframe"]!["start_date"] as! NSDate
            let date_formatter = NSDateFormatter()
            date_formatter.dateStyle = .MediumStyle
            date_formatter.timeStyle = .NoStyle
            date_formatter.locale = NSLocale(localeIdentifier: "en_US")
            let start_date_string = date_formatter.stringFromDate(current_filter_data["timeframe"]!["start_date"] as! NSDate)
            let end_date_string = date_formatter.stringFromDate(current_filter_data["timeframe"]!["end_date"] as! NSDate)
            current_start_date_string = start_date_string
            current_end_date_string = end_date_string
            let cal = NSCalendar.currentCalendar()
            var result_text_right = ""
            if cal.isDateInToday(current_filter_data["timeframe"]!["end_date"] as! NSDate) {
                result_text_right = "Last "
                let time_dif = end_date.timeIntervalSinceDate(start_date)
                let days_passed = Int(time_dif / 3600.0 / 24.0) + 1
                result_text_right += "\(days_passed) days"
            }
            else {
                let start_date_comp = NSCalendar.currentCalendar().components([NSCalendarUnit.Day,NSCalendarUnit.Month,NSCalendarUnit.Year], fromDate: start_date)
                let end_date_comp = NSCalendar.currentCalendar().components([NSCalendarUnit.Day,NSCalendarUnit.Month,NSCalendarUnit.Year], fromDate: end_date)
                result_text_right = "\(start_date_comp.day).\(start_date_comp.month).\(start_date_comp.year) - \(end_date_comp.day).\(end_date_comp.month).\(end_date_comp.year)"
            }
            current_filter_heads_info[2]["text_right"] = result_text_right
        case 3:
            if current_filter_data["include_nearby"] as! Bool {
                current_filter_heads_info[3]["checkbox_on"] = true
            }
            else {
                current_filter_heads_info[3]["checkbox_on"] = false
            }
        case 4:
            if current_filter_data["include_transport"] as! Bool {
                current_filter_heads_info[4]["checkbox_on"] = true
            }
            else {
                current_filter_heads_info[4]["checkbox_on"] = false
            }
        default:
            break
        }
        if withReloading {
            filter_table_view.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: section_id)], withRowAnimation: .None)
        }
    }

    
    func genderIconClickedWithType(type:String) {
        var mutable_gender = NSMutableDictionary(dictionary: current_filter_data["gender"] as! NSDictionary)
        var filter_icon_on_off = "off"
        if current_filter_data["gender"]![type] as! Bool {
            mutable_gender[type] = false
        }
        else {
            mutable_gender[type] = true
            filter_icon_on_off = "on"
        }
        let icon_title = "filter_\(type)_icon_\(filter_icon_on_off)"
        current_filter_data["gender"] = mutable_gender
        let gender_cell_opt = filter_table_view.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1)) as? FilterCellGender
        if let gender_cell = gender_cell_opt {
            switch type {
            case "mw":
                gender_cell.mw_icon.setBackgroundImage(UIImage(named: icon_title)!, forState: .Normal)
            case "ww" :
                gender_cell.ww_icon.setBackgroundImage(UIImage(named: icon_title), forState: .Normal)
            case "wm" :
                gender_cell.wm_icon.setBackgroundImage(UIImage(named: icon_title), forState: .Normal)
            case "mm" :
                gender_cell.mm_icon.setBackgroundImage(UIImage(named: icon_title), forState: .Normal)
            default:
                break
            }
        }
        updateHeadInfoInSection(1,withReloading: true)
    }
    
    func dateChangedWithValue(date:NSDate) {
        let addon = (NSUserDefaults().boolForKey("pro_version") ? 0 : 1)
        let editingDateId = current_filter_heads_info[2]["editingDateId"] as! Int
        let mutable_dates = NSMutableDictionary(dictionary: current_filter_data["timeframe"] as! NSDictionary)
        if editingDateId == 0 {
            mutable_dates["start_date"] = NSCalendar.currentCalendar().startOfDayForDate(date)
        }
        else {
            mutable_dates["end_date"] = NSCalendar.currentCalendar().startOfDayForDate(date)
        }
        current_filter_data["timeframe"] = mutable_dates
        updateHeadInfoInSection(2, withReloading: false)
        let cell_timeframe_head = filter_table_view.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2)) as? FilterCellHead
        if let cell = cell_timeframe_head {
            let text_right = current_filter_heads_info[2]["text_right"] as? String
            if text_right! == "Last 0 days" {
                cell.descriptionLabel.textColor = UIColor.redColor()
            }
            else {
                cell.descriptionLabel.textColor = UIColor.blackColor()
            }
            cell.descriptionLabel.text = text_right
        }
        let cell_now_date = filter_table_view.cellForRowAtIndexPath(NSIndexPath(forRow: (editingDateId + 1 + addon), inSection: 2)) as? FilterCellTimeframe
        if let cell = cell_now_date {
            cell.dateLabel.text = editingDateId == 0 ? current_start_date_string : current_end_date_string
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == filter_table_view {
            if indexPath.row == 0 {
                var ret_cell:FilterCellHead
                if let deq_cell = tableView.dequeueReusableCellWithIdentifier("filter_cell_head") as? FilterCellHead {
                    ret_cell = deq_cell
                }
                else {
                    ret_cell = FilterCellHead()
                }
                ret_cell.titleLabel.text = current_filter_heads_info[indexPath.section]["text_left"]! as? String
                if current_filter_heads_info[indexPath.section]["text_right_available"] as! Bool {
                    ret_cell.descriptionLabel.hidden = false
                    let right_text = current_filter_heads_info[indexPath.section]["text_right"] as? String
                    ret_cell.descriptionLabel.text = right_text
                    if right_text == "None" || right_text == "Last 0 days" {
                        ret_cell.descriptionLabel.textColor = UIColor.redColor()
                    }
                    else {
                        ret_cell.descriptionLabel.textColor = UIColor.blackColor()
                    }
                }
                else {
                    ret_cell.descriptionLabel.hidden = true
                }
                if current_filter_heads_info[indexPath.section]["checkbox_available"] as! Bool {
                    ret_cell.checkbox_image.hidden = false
                    if current_filter_heads_info[indexPath.section]["checkbox_on"] as! Bool {
                        ret_cell.checkbox_image.image = UIImage(named: "checkbox_icon_on")!
                    }
                    else {
                        ret_cell.checkbox_image.image = UIImage(named: "checkbox_icon_off")!
                    }
                }
                else {
                    ret_cell.checkbox_image.hidden = true
                }
                if current_filter_heads_info[indexPath.section]["isExpandable"] as! Bool {
                    ret_cell.arrow_image.hidden = false
                    if current_filter_heads_info[indexPath.section]["isExpanded"] as! Bool {
                        ret_cell.arrow_image.image = UIImage(named: "arrow_up_icon")!
                        ret_cell.backgroundColor = FILTER_EXPANDED_CELL_BG
                    }
                    else {
                        ret_cell.arrow_image.image = UIImage(named: "arrow_down_icon")!
                        ret_cell.backgroundColor = UIColor.whiteColor()
                    }
                }
                else {
                    ret_cell.arrow_image.hidden = true
                    let total_areas_amount = (current_filter_data["shown_areas"] as! [NSDictionary]).count
                    if total_areas_amount == 0 {
                        if indexPath.section == 0 && indexPath.row == 0 {
                            ret_cell.contentView.alpha = FILTER_HEAD_CELL_OPACITY_UNAVAILABLE
                        }
                    }
                    else {
                        ret_cell.contentView.alpha = 1.0
                    }
                }
                return ret_cell
            }
            //we're not serving head cell at the moment
            switch indexPath.section {
            case 0:
                let area_id = indexPath.row - 1
                var ret_cell:FilterCellArea
                if let deq_cell = tableView.dequeueReusableCellWithIdentifier("filter_cell_area") as? FilterCellArea {
                    ret_cell = deq_cell
                }
                else {
                    ret_cell = FilterCellArea()
                }
                let all_areas = current_filter_data["shown_areas"] as! [NSDictionary]
                ret_cell.areaLabel.text = all_areas[area_id]["title"] as! String
                //areas_keys_to_indices[area_id] = areas_names[area_id]
                if all_areas[area_id]["checked"] as! Bool {
                    ret_cell.checkbox_image.image = UIImage(named: "checkbox_icon_on")!
                }
                else {
                    ret_cell.checkbox_image.image = UIImage(named: "checkbox_icon_off")!
                }
                return ret_cell
            case 1:
                var ret_cell:FilterCellGender
                if let deq_cell = tableView.dequeueReusableCellWithIdentifier("filter_cell_gender") as? FilterCellGender {
                    ret_cell = deq_cell
                }
                else {
                    ret_cell = FilterCellGender()
                }
                ret_cell.setIconHandler(genderIconClickedWithType)
                if current_filter_data["gender"]!["mw"] as! Bool {
                    ret_cell.mw_icon.setBackgroundImage(UIImage(named: "filter_mw_icon_on"), forState: .Normal)
                }
                else {
                    ret_cell.mw_icon.setBackgroundImage(UIImage(named: "filter_mw_icon_off"), forState: .Normal)
                }
                if current_filter_data["gender"]!["ww"] as! Bool {
                    ret_cell.ww_icon.setBackgroundImage(UIImage(named: "filter_ww_icon_on"), forState: .Normal)
                }
                else {
                    ret_cell.ww_icon.setBackgroundImage(UIImage(named: "filter_ww_icon_off"), forState: .Normal)
                }
                if current_filter_data["gender"]!["wm"] as! Bool {
                    ret_cell.wm_icon.setBackgroundImage(UIImage(named: "filter_wm_icon_on"), forState: .Normal)
                }
                else {
                    ret_cell.wm_icon.setBackgroundImage(UIImage(named: "filter_wm_icon_off"), forState: .Normal)
                }
                if current_filter_data["gender"]!["mm"] as! Bool {
                    ret_cell.mm_icon.setBackgroundImage(UIImage(named: "filter_mm_icon_on"), forState: .Normal)
                }
                else {
                    ret_cell.mm_icon.setBackgroundImage(UIImage(named: "filter_mm_icon_off"), forState: .Normal)
                }
                return ret_cell
            case 2:
                let pro_version = NSUserDefaults().boolForKey("pro_version")
                let row_use = indexPath.row - (pro_version ? 0 : 1)
                if !pro_version && indexPath.row == 1 {
                    var pro_version_cell = tableView.dequeueReusableCellWithIdentifier("pro_version_cell")
                    if pro_version_cell == nil {
                        pro_version_cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "pro_version_cell")
                    }
                    let pro_version_switch = UISwitch()
                    pro_version_switch.setOn(true, animated: false)
                    pro_version_switch.onTintColor = SWITCH_ON_TINT_COLOR
                    pro_version_switch.addTarget(self, action: "proVersionSwitchChanged:", forControlEvents: .ValueChanged)
                    pro_version_cell!.textLabel!.text = "Limit to 45 days"
                    pro_version_cell!.textLabel!.font = UIFont(name: "SFUIText-Medium", size: 17)!
                    pro_version_cell!.textLabel!.textColor = UIColor(red: 74/255, green: 85/255, blue: 109/255, alpha: 1.0)
                    pro_version_cell!.accessoryView = pro_version_switch
                    return pro_version_cell!
                }
                else {
                    if row_use > 2 {
                        var ret_cell:FilterCellTimeframePicker
                        if let deq_cell = tableView.dequeueReusableCellWithIdentifier("filter_cell_timeframe_picker") as? FilterCellTimeframePicker {
                            ret_cell = deq_cell
                        }
                        else {
                            ret_cell = FilterCellTimeframePicker()
                        }
                        ret_cell.setDateChangedHandler(dateChangedWithValue)
                        ret_cell.datePicker.minimumDate = min_possible_date
                        ret_cell.datePicker.maximumDate = max_possible_date
                        ret_cell.datePicker.date = current_filter_heads_info[2]["editingDateId"] as! Int == 0 ? current_filter_data["timeframe"]!["start_date"] as! NSDate : current_filter_data["timeframe"]!["end_date"] as! NSDate
                        return ret_cell
                    }
                    else {
                        var ret_cell:FilterCellTimeframe
                        if let deq_cell = tableView.dequeueReusableCellWithIdentifier("filter_cell_timeframe") as? FilterCellTimeframe {
                            ret_cell = deq_cell
                        }
                        else {
                            ret_cell = FilterCellTimeframe()
                        }
                        ret_cell.titleLabel.text = row_use == 1 ? "Since" : "To"
                        if current_filter_heads_info[2]["nowDateEditing"] as! Bool {
                            if current_filter_heads_info[2]["editingDateId"] as! Int == row_use - 1 {
                                ret_cell.backgroundColor = FILTER_TIMEFRAME_SELECTED_BG
                                ret_cell.dateLabel.textColor = FILTER_TIMEFRAME_SELECTED_DATE_LABEL_BG
                            }
                            else {
                                ret_cell.backgroundColor = UIColor.whiteColor()
                                ret_cell.dateLabel.textColor = FILTER_TIMEFRAME_UNSELECTED_DATE_LABEL_BG
                            }
                        }
                        else {
                            ret_cell.backgroundColor = UIColor.whiteColor()
                            ret_cell.dateLabel.textColor = FILTER_TIMEFRAME_UNSELECTED_DATE_LABEL_BG
                        }
                        ret_cell.dateLabel.text = (row_use - 1) == 0 ? current_start_date_string : current_end_date_string
                        return ret_cell
                    }
                }
            case 3:
                var ret_cell = tableView.dequeueReusableCellWithIdentifier("cell_nearby_detail")
                if ret_cell == nil {
                    ret_cell = UITableViewCell(style: .Default, reuseIdentifier: "cell_nearby_detail")
                }
                ret_cell!.textLabel!.text = constructNearbyAreasText()
                ret_cell!.textLabel!.numberOfLines = 0
                ret_cell!.textLabel!.font = UIFont(name: "SFUIText-Regular", size: NEARBY_AREAS_DESCRIPTION_TEXT_SIZE)!
                return ret_cell!
            default:
                print("Some strange indexPath specified when creating cells in datasource!")
                return UITableViewCell()
            }
        }
        else if tableView == feed_table_view {
            let cell_for_start = CACurrentMediaTime()
            if current_feed_cells_data[feed_section_to_card_id[indexPath.section]!]!["images_present"] as! Bool {
                let feed_cell_img = tableView.dequeueReusableCellWithIdentifier("feed_cell_images") as! FeedCellImages
                feed_cell_img.setCardIdWithId(feed_section_to_card_id[indexPath.section]!)
                feed_cell_img.setHandlersWithMenuHandler(cardMenuPressed, replyHandler: cardReplyPressed, shareHandler: cardSharePressed)
                feed_cell_img.setFrames(feed_cells_frames[feed_section_to_card_id[indexPath.section]!]!)
                let cons = CACurrentMediaTime() - cell_for_start
                print("cell for row took \(cons)")
                return feed_cell_img
            }
            else {
                let feed_cell = tableView.dequeueReusableCellWithIdentifier("feed_cell") as! FeedCellPlain
                feed_cell.setCardIdWithId(feed_section_to_card_id[indexPath.section]!)
                feed_cell.setHandlersWithMenuHandler(cardMenuPressed, replyHandler: cardReplyPressed, shareHandler: cardSharePressed)
                feed_cell.setFrames(feed_cells_frames[feed_section_to_card_id[indexPath.section]!]!)
                let cons = CACurrentMediaTime() - cell_for_start
                print("cell for row took \(cons)")
                return feed_cell
            }
        }
        else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == filter_table_view {
            //additional checks for cells bgs
            if current_filter_heads_info[indexPath.section]["isExpandable"] as! Bool && current_filter_heads_info[indexPath.section]["isExpanded"] as! Bool && indexPath.row == 0 {
                cell.backgroundColor = FILTER_EXPANDED_CELL_BG
            }
            else {
                cell.backgroundColor = UIColor.whiteColor()
            }
            cell.contentView.alpha = 1.0
            if (current_filter_data["shown_areas"] as! [NSDictionary]).count == 0 {
                if indexPath.section == 0 && indexPath.row == 0 {
                    cell.contentView.alpha = FILTER_HEAD_CELL_OPACITY_UNAVAILABLE
                }
            }
            if (current_filter_data["nearby_areas"] as! [String]).count == 0 {
                if indexPath.section == 3 && indexPath.row == 0 {
                    cell.contentView.alpha = FILTER_HEAD_CELL_OPACITY_UNAVAILABLE
                }
            }
        }
        else if tableView == feed_table_view {
            let will_start = CACurrentMediaTime()
            if current_feed_cells_data[feed_section_to_card_id[indexPath.section]!]!["images_present"] as! Bool {
                (cell as! FeedCellImages).setContent(current_feed_cells_data[feed_section_to_card_id[indexPath.section]!]!)
                startLoadingImagesForCardId(feed_section_to_card_id[indexPath.section]!, withAssigningType: "feed")
                if current_feed_cells_data[feed_section_to_card_id[indexPath.section]!]!["map_present"] as! Bool {
                    if let map_img = card_id_to_map_snapshot_image[feed_section_to_card_id[indexPath.section]!] {
                        (cell as! FeedCellImages).setMapImage(map_img, withDelay: false)
                    }
                    else {
                        startLoadingMapSnapshotForCardId(feed_section_to_card_id[indexPath.section]!, withStyle: "feed", withAssigning: true)
                    }
                }
            }
            else {
                (cell as! FeedCellPlain).setContent(current_feed_cells_data[feed_section_to_card_id[indexPath.section]!]!)
                if current_feed_cells_data[feed_section_to_card_id[indexPath.section]!]!["map_present"] as! Bool {
                    if let map_img = card_id_to_map_snapshot_image[feed_section_to_card_id[indexPath.section]!] {
                        (cell as! FeedCellPlain).setMapImage(map_img, withDelay: false)
                        
                    }
                    else {
                        startLoadingMapSnapshotForCardId(feed_section_to_card_id[indexPath.section]!, withStyle: "feed", withAssigning: true)
                    }
                }

            }
            let cons = CACurrentMediaTime() - will_start
            print("will display took \(cons)")
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == filter_table_view {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            var indices_to_insert:[NSIndexPath] = []
            var indices_to_delete:[NSIndexPath] = []
            if indexPath.row == 0 {
                if current_filter_heads_info[indexPath.section]["isExpandable"] as! Bool {
                    if current_filter_heads_info[indexPath.section]["isExpanded"] as! Bool {
                        current_filter_heads_info[indexPath.section]["isExpanded"] = false
                        switch indexPath.section {
                        case 0:
                            let areas_count = (current_filter_data["shown_areas"] as! [NSDictionary]).count
                            for i in 1...areas_count {
                                indices_to_delete.append(NSIndexPath(forRow: i, inSection: 0))
                            }
                        case 1:
                            indices_to_delete.append(NSIndexPath(forRow: 1, inSection: 1))
                        case 2:
                            let addon = (NSUserDefaults().boolForKey("pro_version") ? 0 : 1)
                            if addon == 1 {
                                indices_to_delete.append(NSIndexPath(forRow: 1, inSection: 2))
                            }
                            indices_to_delete.append(NSIndexPath(forRow: 1 + addon, inSection: 2))
                            indices_to_delete.append(NSIndexPath(forRow: 2 + addon, inSection: 2))
                            if current_filter_heads_info[indexPath.section]["nowDateEditing"] as! Bool {
                                indices_to_delete.append(NSIndexPath(forRow: 3 + addon, inSection: 2))
                                current_filter_heads_info[indexPath.section]["nowDateEditing"] = false
                            }
                        default:
                            break
                        }
                    }
                    else {
                        current_filter_heads_info[indexPath.section]["isExpanded"] = true
                        switch indexPath.section {
                        case 0:
                            let areas_count = (current_filter_data["shown_areas"] as! [NSDictionary]).count
                            for i in 1...areas_count {
                                indices_to_insert.append(NSIndexPath(forRow: i, inSection: 0))
                            }
                        case 1:
                            indices_to_insert.append(NSIndexPath(forRow: 1, inSection: 1))
                        case 2:
                            indices_to_insert.append(NSIndexPath(forRow: 1, inSection: 2))
                            indices_to_insert.append(NSIndexPath(forRow: 2, inSection: 2))
                            if !NSUserDefaults().boolForKey("pro_version") {
                                indices_to_insert.append(NSIndexPath(forRow: 3, inSection: 2))
                            }
                        default:
                            break
                        }
                    }
                    var rot_amount:CGFloat = -3.14
                    if current_filter_heads_info[indexPath.section]["isExpanded"] as! Bool {
                        rot_amount = 3.14
                    }
                    let cell_to_animate_opt = tableView.cellForRowAtIndexPath(indexPath) as? FilterCellHead
                    if let cell_to_animate = cell_to_animate_opt {
                        if current_filter_heads_info[indexPath.section]["isExpanded"] as! Bool {
                            cell_to_animate.backgroundColor = FILTER_EXPANDED_CELL_BG
                        }
                        else {
                            cell_to_animate.backgroundColor = UIColor.whiteColor()
                        }
                        UIView.animateWithDuration(FILTER_ARROW_ANIMATION_DURATION, animations: {
                            cell_to_animate.arrow_image.transform = CGAffineTransformMakeRotation(rot_amount)
                            }, completion: {
                                (fin:Bool) in
                                cell_to_animate.arrow_image.transform = CGAffineTransformIdentity
                                cell_to_animate.arrow_image.image = UIImage(named: rot_amount > 1.0 ? "arrow_up_icon" : "arrow_down_icon")!
                        })
                    }
                }
                else if current_filter_heads_info[indexPath.section]["checkbox_available"] as! Bool {
                    var filter_data_key = "include_nearby"
                    if indexPath.section == 4 {
                        filter_data_key = "include_transport"
                    }
                    else {
                        if (current_filter_data["nearby_areas"] as! [String]).count == 0 {
                            return
                        }
                    }
                    if current_filter_data[filter_data_key] as! Bool {
                        current_filter_data[filter_data_key] = false
                        if indexPath.section == 3 {
                            indices_to_delete.append(NSIndexPath(forRow: 1, inSection: 3))
                        }
                    }
                    else {
                        current_filter_data[filter_data_key] = true
                        if indexPath.section == 3 {
                            indices_to_insert.append(NSIndexPath(forRow: 1, inSection: 3))
                        }
                    }
                    updateHeadInfoInSection(indexPath.section, withReloading: false)
                    let cell_to_animate_opt = tableView.cellForRowAtIndexPath(indexPath) as? FilterCellHead
                    if let cell_to_animate = cell_to_animate_opt {
                        UIView.transitionWithView(cell_to_animate.checkbox_image, duration: FILTER_CHECKBOX_ANIMATION_DURATION, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                            cell_to_animate.checkbox_image.image = self.current_filter_heads_info[indexPath.section]["checkbox_on"] as! Bool ? UIImage(named: "checkbox_icon_on")! : UIImage(named: "checkbox_icon_off")!
                            }, completion: nil)
                    }
                }
            }
            else {
                //dealing not with head cells
                switch indexPath.section {
                case 0:
                    print("now selected")
                    let area_id = indexPath.row - 1
                    //let area_key = areas_keys_to_indices[area_id]!
                    var switched_on = false
                    let new_areas_mutable = NSMutableArray(array: current_filter_data["shown_areas"] as! [NSDictionary])
                    if new_areas_mutable[area_id]["checked"] as! Bool {
                        var new_detailed_area_data = NSMutableDictionary(dictionary: new_areas_mutable[area_id] as! NSDictionary)
                        new_detailed_area_data["checked"] = false
                        new_areas_mutable[area_id] = new_detailed_area_data
                    }
                    else {
                        var new_detailed_area_data = NSMutableDictionary(dictionary: new_areas_mutable[area_id] as! NSDictionary)
                        new_detailed_area_data["checked"] = true
                        new_areas_mutable[area_id] = new_detailed_area_data
                        switched_on = true
                    }
                    current_filter_data["shown_areas"] = new_areas_mutable
                    let cell_area = tableView.cellForRowAtIndexPath(indexPath) as? FilterCellArea
                    if let cell_area_animate = cell_area {
                        UIView.transitionWithView(cell_area_animate.checkbox_image, duration: FILTER_CHECKBOX_ANIMATION_DURATION, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                            cell_area_animate.checkbox_image.image = UIImage(named: switched_on ? "checkbox_icon_on" : "checkbox_icon_off")!
                            }, completion: nil)
                    }
                    updateHeadInfoInSection(0,withReloading: true)
                    let head_cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? FilterCellHead
                    if let head_cell_change = head_cell {
                        head_cell_change.descriptionLabel.text = current_filter_heads_info[0]["text_right"] as? String
                    }
                case 2:
                    let addon = (NSUserDefaults().boolForKey("pro_version") ? 0 : 1)
                    let row_use = indexPath.row - addon
                    if addon == 1 && indexPath.row == 1 {
                        break
                    }
                    if current_filter_heads_info[2]["nowDateEditing"] as! Bool {
                        if row_use - 1 == current_filter_heads_info[2]["editingDateId"] as! Int {
                            current_filter_heads_info[2]["nowDateEditing"] = false
                            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 3 + addon, inSection: 2)], withRowAnimation: .Fade)
                        }
                        else {
                            current_filter_heads_info[2]["editingDateId"] = row_use - 1
                            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 3 + addon, inSection: 2)], withRowAnimation: .Fade)
                        }
                    }
                    else {
                        current_filter_heads_info[2]["nowDateEditing"] = true
                        current_filter_heads_info[2]["editingDateId"] = row_use - 1
                        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 3 + addon, inSection: 2)], withRowAnimation: .Fade)
                    }
                    tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1 + addon, inSection: 2),NSIndexPath(forRow: 2 + addon, inSection: 2)], withRowAnimation: .None)
                default:
                    break
                }
            }
            if indices_to_insert.count != 0 {
                tableView.insertRowsAtIndexPaths(indices_to_insert, withRowAnimation: .Fade)
            }
            if indices_to_delete.count != 0 {
                tableView.deleteRowsAtIndexPaths(indices_to_delete, withRowAnimation: .Fade)
            }
        }
        else if tableView == feed_table_view {
            let cardId = feed_section_to_card_id[indexPath.section]!
            openOnePostWithCardId(cardId,pressedIn: "main_feed")
        }
    }
    
    func openOnePostWithCardId(cardId:Int,pressedIn:String) {
        one_post_vc.setCardIdWithId(cardId)
        one_post_vc.pressed_in = pressedIn
        if pressedIn == "main_feed" {
            if current_feed_cells_data[cardId]!["images_present"] as! Bool {
                startLoadingImagesForCardId(cardId, withAssigningType: "one")
            }
            one_post_vc.setContent(current_feed_cells_data[cardId]!)
            if current_feed_cells_data[cardId]!["map_present"] as! Bool {
                startLoadingMapSnapshotForCardId(cardId, withStyle: "full", withAssigning: true)
            }
        }
        else {
            if posts_vc.current_posts_data[cardId]!["images_present"] as! Bool {
                startLoadingImagesForCardId(cardId, withAssigningType: "one_sep")
            }
            one_post_vc.setContent(posts_vc.current_posts_data[cardId]!)
            if posts_vc.current_posts_data[cardId]!["map_present"] as! Bool {
                startLoadingMapSnapshotForCardId(cardId, withStyle: "full", withAssigning: true)
            }
        }
        self.navigationController!.pushViewController(one_post_vc, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let filter_compare = filter_table_view {
            if tableView == filter_compare {
                return FILTER_HEADS_AMOUNT
            }
        }
        if let feed_compare = feed_table_view {
            if tableView == feed_compare {
                return (feed_section_to_card_id as! NSDictionary).allKeys.count
            }
        }
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let addon = (NSUserDefaults().boolForKey("pro_version") ? 0 : 1)
        if tableView == filter_table_view {
            if indexPath.section == 2 && indexPath.row == 3 + addon {
                return ROW_HEIGHT_TIMEFRAME_PICKER
            }
            else if indexPath.row == 0 {
                return ROW_HEIGHT_HEAD
            }
            else if indexPath.section == 1 && indexPath.row == 1 {
                return ROW_HEIGHT_GENDER
            }
            else if indexPath.section == 3 && indexPath.row == 1 {
                return (constructNearbyAreasText() as! NSString).sizeWithAttributes([NSFontAttributeName:UIFont(name: "SFUIText-Regular", size: NEARBY_AREAS_DESCRIPTION_TEXT_SIZE)!]).height * 2.4
            }
            else {
                return ROW_HEIGHT_REGULAR
            }
        }
        else if tableView == feed_table_view {
            return feed_cells_heights[feed_section_to_card_id[indexPath.section]!]!
        }
        else {
            return 20
        }
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == filter_table_view {
            var ans = 1
            switch section {
            case 0:
                if current_filter_heads_info[0]["isExpanded"] as! Bool {
                    ans += (current_filter_data["shown_areas"] as! [NSDictionary]).count
                }
            case 1:
                if current_filter_heads_info[1]["isExpanded"] as! Bool {
                    ans += 1
                }
            case 2:
                if current_filter_heads_info[2]["isExpanded"] as! Bool {
                    ans += 2
                    if current_filter_heads_info[2]["nowDateEditing"] as! Bool {
                        ans++
                    }
                    if !NSUserDefaults().boolForKey("pro_version") {
                        ans++
                    }
                }
            case 3:
                if current_filter_heads_info[3]["checkbox_on"] as! Bool {
                    ans += 1
                }
            default:
                break
            }
            return ans
        }
        else if tableView == feed_table_view {
            return 1
        }
        else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == feed_table_view {
            if section == (feed_section_to_card_id as! NSDictionary).allKeys.count - 1 {
                return 0
            }
            return FEED_TABLE_CELLS_SPACING
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == feed_table_view {
            if section == (feed_section_to_card_id as! NSDictionary).allKeys.count - 1 {
                return nil
            }
            let footer_view = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: FEED_TABLE_CELLS_SPACING))
            footer_view.backgroundColor = UIColor.clearColor()
            return footer_view
        }
        else {
            return nil
        }
    }
    
    func collapseFilterTable() {
        for section_dict in current_filter_heads_info {
            if section_dict["isExpandable"] as! Bool && section_dict["isExpanded"] as! Bool {
                section_dict["isExpanded"] = false
            }
            if let now_editing = section_dict["nowDateEditing"] as? Bool {
                section_dict["nowDateEditing"] = false
            }
        }
        filter_table_view.reloadData()
    }
    
    
    func adjustUI(sender:NSTimer) {
        sender.invalidate()
        tab_left_label.center.y += 1
        tab_right_label.center.y += 1
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tabPressedRight(sender:UIButton) {
        if now_tab_transition {
            return
        }
        if now_left_tab {
            //need produce some animation
            settings_tab_holder_view.alpha = 0.0
            settings_tab_holder_view.hidden = false
            now_tab_transition = true
            UIView.animateWithDuration(TABS_ANIMATION_TRANSITION_DURATION, animations: {
                self.people_tab_holder_view.alpha = 0.0
                self.people_tab_holder_view.center.x -= self.view.bounds.width
                self.settings_tab_holder_view.alpha = 1.0
                self.settings_tab_holder_view.center.x -= self.view.bounds.width
                }, completion: {
                    (fin:Bool) in
                    self.people_tab_holder_view.hidden = true
                    self.now_tab_transition = false
                    self.navigationItem.title = "Settings"
                    self.navigationItem.rightBarButtonItem = nil
                    self.navigationItem.leftBarButtonItem = nil
            })
        }
        now_left_tab = false
        sender.backgroundColor = TAB_SELECTED_BG
        tab_button_left.backgroundColor = UIColor.whiteColor()
        tab_right_icon.image = UIImage(named: "tab_right_icon_selected")!
        tab_left_icon.image = UIImage(named: "tab_left_icon_unselected")!
        tab_right_label.textColor = TAB_LABEL_SELECTED_COLOR
        tab_left_label.textColor = TAB_LABEL_UNSELECTED_COLOR
    }
    
    @IBAction func tabPressedLeft(sender:UIButton) {
        if now_tab_transition {
            return
        }
        if !now_left_tab {
            people_tab_holder_view.alpha = 0.0
            people_tab_holder_view.hidden = false
            now_tab_transition = true
            UIView.animateWithDuration(TABS_ANIMATION_TRANSITION_DURATION, animations: {
                self.people_tab_holder_view.alpha = 1.0
                self.people_tab_holder_view.center.x += self.view.bounds.width
                self.settings_tab_holder_view.alpha = 0.0
                self.settings_tab_holder_view.center.x += self.view.bounds.width
                }, completion: {
                    (fin:Bool) in
                    self.settings_tab_holder_view.hidden = true
                    self.now_tab_transition = false
                    self.navigationItem.title = self.current_place_name
                    self.setBasicNavigationItemIcons()
            })
        }
        now_left_tab = true
        sender.backgroundColor = TAB_SELECTED_BG
        tab_button_right.backgroundColor = UIColor.whiteColor()
        tab_right_icon.image = UIImage(named: "tab_right_icon_unselected")!
        tab_left_icon.image = UIImage(named: "tab_left_icon_selected")!
        tab_right_label.textColor = TAB_LABEL_UNSELECTED_COLOR
        tab_left_label.textColor = TAB_LABEL_SELECTED_COLOR
    }
    
    func tapCloseFilterDialog(sender:UITapGestureRecognizer) {
        cancelFilterPressed(navigationItem.leftBarButtonItem!)
    }
    
    func resetFiltersButtonPressed(sender:UIButton) {
        sender.alpha = 1.0
        current_filter_data = NSMutableDictionary(dictionary: default_filter_data)
        for i in 0...4 {
            updateHeadInfoInSection(i, withReloading: false)
        }
        collapseFilterTable()
    }
    
    func resetFiltersButtonTouched(sender:UIButton) {
        sender.alpha = 0.6
    }
    
    func resetFiltersButtonReleased(sender:UIButton) {
        sender.alpha = 1.0
    }
    
    func hideFilterDialog() {
        if now_filter_shown {
            now_filter_shown = false
            now_filter_transition = true
            let hidden_scroll_view_center = self.navigationController!.navigationBar.frame.minY + self.navigationController!.navigationBar.frame.height - filter_view.bounds.height * 0.5
            UIView.animateWithDuration(FILTER_SHOW_DURATION, animations: {
                self.filter_overlay_view.alpha = 0.0
                self.filter_view.center.y = hidden_scroll_view_center
                }, completion: {
                    (fin:Bool) in
                    self.now_filter_transition = false
                    self.filter_view.hidden = true
                    self.filter_overlay_view.hidden = true
                    self.collapseFilterTable()
                    self.postFilterCheck()
                    self.setFiltersLabelsShowing(self.map_filter_present, rightOn: self.data_filter_present)
            })
            
        }
    }
    
    func postFilterCheck() {
        //here we're going to check whether smth changed comparing with prev filters and whether there are some differences comparing to default filter
        var changed = false
        if !current_filter_data.isEqualToDictionary(prev_filter_data as [NSObject : AnyObject]) {
            changed = true
        }
        prev_filter_data = NSMutableDictionary(dictionary: current_filter_data)
        var filter_image_title = "filter_icon_off"
        if !current_filter_data.isEqualToDictionary(default_filter_data as [NSObject : AnyObject]) {
            filter_image_title = "filter_icon_on"
            data_filter_present = true
        }
        else {
            data_filter_present = false
        }
        if changed {
            let feed_table_changes = setupCurrentSectionMappingByAppendingCards(nil,withUpdatingTable: true)
            checkFeedScrollingUpdating()
            //updateFeedFooter()
        }
        setBasicNavigationItemIcons()
    }
    
    func showFilterDialog() {
        for i in 0...4 {
            print("updating \(i)")
            updateHeadInfoInSection(i, withReloading: true)
        }
        now_filter_shown = true
        now_filter_transition = true
        filter_overlay_view.hidden = false
        filter_view.hidden = false
        let scroll_view_center = self.navigationController!.navigationBar.frame.minY + self.navigationController!.navigationBar.frame.height + filter_view.bounds.height * 0.5
        var scroll_view_translation_left:CGFloat = scroll_view_center - filter_view.center.y
        UIView.animateWithDuration(FILTER_SHOW_DURATION, animations: {
            self.filter_overlay_view.alpha = self.FILTER_OVERLAY_OPACITY
            }, completion: nil)
        UIView.animateKeyframesWithDuration(FILTER_SHOW_DURATION, delay: 0, options: .CalculationModeCubic, animations: {
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.35, animations: {
                self.filter_view.center.y += (0.35 * scroll_view_translation_left)
                scroll_view_translation_left -= 0.35 * scroll_view_translation_left
            })
            UIView.addKeyframeWithRelativeStartTime(0.35, relativeDuration: 0.65, animations: {
                self.filter_view.center.y += scroll_view_translation_left
                scroll_view_translation_left = 0
            })
            }, completion: {
                (fin:Bool) in
                self.now_filter_transition = false
        })
        let _ = NSTimer.scheduledTimerWithTimeInterval(DELAY_CHANGE_FILTER_ICONS, target: self, selector: "changeFilterIcons:", userInfo: nil, repeats: false)
    }
    
    func changeFilterIcons(sender:NSTimer) {
        sender.invalidate()
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(image: UIImage(named: "cancel_icon")!, style: .Done, target: self, action: "cancelFilterPressed:"), animated: true)
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(image: UIImage(named: "ok_icon")!, style: .Plain, target: self, action: "okFilterPressed:"), animated: true)
    }
    
    func cancelFilterPressed(sender:UIBarButtonItem) {
        if !now_filter_shown || now_filter_transition {
            return
        }
        let now_nearby = current_filter_data["include_nearby"] as! Bool
        let prev_nearby = prev_filter_data["include_nearby"] as! Bool
        if now_nearby != prev_nearby {
            current_filter_heads_info[3]["checkbox_on"] = !now_nearby
            if now_nearby {
                filter_table_view.deleteRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 3)], withRowAnimation: .None)
            }
            else {
                filter_table_view.insertRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 3)], withRowAnimation: .None)
            }
        }
        current_filter_data = NSMutableDictionary(dictionary: prev_filter_data)
        hideFilterDialog()
    }
    
    func okFilterPressed(sender:UIBarButtonItem) {
        if !now_filter_shown || now_filter_transition {
            return
        }
        if current_areas_error {
            current_filter_data["shown_areas"] = prev_filter_data["shown_areas"]
            current_areas_error = false
        }
        if current_gender_error {
            current_gender_error = false
            current_filter_data["gender"] = prev_filter_data["gender"]
        }
        var new_start_date = current_filter_data["timeframe"]!["start_date"] as! NSDate
        var new_end_date = current_filter_data["timeframe"]!["end_date"] as! NSDate
        if new_end_date.compare(new_start_date) != NSComparisonResult.OrderedDescending {
            var mutable_dates = NSMutableDictionary(dictionary: current_filter_data["timeframe"] as! NSDictionary)
            mutable_dates["end_date"] = new_start_date
            current_filter_data["timeframe"] = mutable_dates
        }
        hideFilterDialog()
    }
    
    func setFiltersLabelsShowing(leftOn:Bool, rightOn:Bool) {
        var should_animate_left = false
        var should_animate_right = false
        var should_change_filters = false
        if leftOn != filter_on_left {
            should_animate_left = true
            filter_on_left = leftOn
        }
        if rightOn != filter_on_right {
            should_animate_right = true
            filter_on_right = rightOn
        }
        if (filter_on_right || filter_on_left) && !filters_on_labels_present {
            should_change_filters = true
            filters_on_labels_present = true
        }
        if !filter_on_left && !filter_on_right && filters_on_labels_present {
            should_change_filters = true
            filters_on_labels_present = false
        }
        var labels_text_delay:CFTimeInterval = 0
        var label_position_delay:CFTimeInterval = ANIMATION_FILTER_ON_LABEL_COLOR_CHANGE_DURATION + ANIMATION_FILTERS_ON_LABELS_DELAY
        if should_change_filters && filters_on_labels_present {
            label_position_delay = 0
            labels_text_delay = ANIMATION_FILTERS_ON_LABELS_DELAY + ANIMATION_FILTERS_ON_LABELS_DURATION
        }
        if should_animate_left || should_animate_right {
            var usr:[String:Bool] = [String:Bool]()
            if should_animate_right {
                usr["rightOn"] = filter_on_right
            }
            if should_animate_left {
                usr["leftOn"] = filter_on_left
            }
            let _ = NSTimer.scheduledTimerWithTimeInterval(labels_text_delay, target: self, selector: "switchFiltersLabels:", userInfo: usr, repeats: false)
        }
        if should_change_filters {
            var new_feed_frame = CGRectZero
            if filters_on_labels_present {
                filter_on_right_label.hidden = false
                filter_on_left_label.hidden = false
                new_feed_frame = CGRect(x: 0, y: feed_table_view.frame.minY + filters_on_labels_total_height, width: feed_table_view.bounds.width, height: feed_table_view.bounds.height - filters_on_labels_total_height)
            }
            else {
                new_feed_frame = CGRect(x: 0, y: FEED_TABLE_MARGIN_TOP, width: feed_table_view.bounds.width, height: feed_table_view.bounds.height + filters_on_labels_total_height)
            }
            let filters_all_shift = filters_on_labels_present ? filters_on_labels_total_height : -filters_on_labels_total_height
            UIView.animateWithDuration(ANIMATION_FILTERS_ON_LABELS_DURATION, delay: label_position_delay, options: .CurveLinear, animations: {
                self.feed_table_view.frame = new_feed_frame
                self.filter_on_left_label.center.y += filters_all_shift
                self.filter_on_right_label.center.y += filters_all_shift
                }, completion: {
                    (fin:Bool) in
                    if !self.filters_on_labels_present {
                        self.filter_on_left_label.hidden = true
                        self.filter_on_right_label.hidden = true
                    }
            })
        }
    }
    
    func switchFiltersLabels(sender:NSTimer) {
        if let leftOn = sender.userInfo!["leftOn"] as? Bool {
            UIView.transitionWithView(filter_on_left_label, duration: ANIMATION_FILTER_ON_LABEL_COLOR_CHANGE_DURATION, options: .TransitionCrossDissolve, animations: {
                self.filter_on_left_label.textColor = leftOn ? self.FILTERS_LABELS_COLOR_ON : self.FILTERS_LABELS_COLOR_OFF
                }, completion: nil)
        }
        if let rightOn = sender.userInfo!["rightOn"] as? Bool {
            UIView.transitionWithView(filter_on_right_label, duration: ANIMATION_FILTER_ON_LABEL_COLOR_CHANGE_DURATION, options: .TransitionCrossDissolve, animations: {
                self.filter_on_right_label.textColor = rightOn ? self.FILTERS_LABELS_COLOR_ON : self.FILTERS_LABELS_COLOR_OFF
                }, completion: nil)
        }
        sender.invalidate()
    }
    
    func placesButtonPressed(sender:UIBarButtonItem) {
        if !map_view_is_on_screen {
            places_vc.prev_selected_area_id = selected_area_id
            map_vc.removeMap()
            self.navigationController!.presentViewController(places_nc, animated: true, completion: nil)
        }
    }
    
    func filterButtonPressed(sender:UIBarButtonItem) {
        if !now_filter_shown && !now_filter_transition && !map_view_is_on_screen {
            showFilterDialog()
        }
    }
    
    func addPostScreenOverlayPressed(sender:UITapGestureRecognizer) {
        plusButtonPressed(plus_button)
    }
    
    func setAddPostScreen() {
        add_post_vc.view.endEditing(true)
        if !add_post_screen_shown {
            add_post_vc.view.hidden = false
            add_post_overlay.hidden = false
            self.navigationItem.setLeftBarButtonItem(nil, animated: true)
            self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Clear", style: .Plain, target: add_post_vc, action: "clearButtonPressed:"), animated: true)
            add_post_vc.current_area_title = navigationItem.title!
            add_post_vc.meeting_place_transport_text_posting_zone.text = "You are going to post to \(add_post_vc.current_area_title) zone"
            add_post_vc.loc_pin_vc.selected_area_id = selected_area_id
        }
        else {
            if now_left_tab {
                setBasicNavigationItemIcons()
            }
            else {
                navigationItem.setRightBarButtonItem(nil, animated: true)
            }
        }
        add_post_screen_animating = true
        UIView.animateWithDuration(ANIMATION_ADD_POST_SCALING_DURATION, animations: {
            self.add_post_vc.view.transform = self.add_post_screen_shown ? CGAffineTransformMakeScale(self.ADD_POST_SCALE_INITIAL, self.ADD_POST_SCALE_INITIAL) : CGAffineTransformIdentity
            self.add_post_vc.view.alpha = self.add_post_screen_shown ? 0.0 : 1.0
            self.add_post_overlay.alpha = self.add_post_screen_shown ? 0.0 : self.ADD_POST_OVERLAY_OPACITY
            }, completion: {
                (fin:Bool) in
                if self.add_post_screen_shown {
                    self.add_post_vc.view.hidden = true
                    self.add_post_overlay.hidden = true
                    self.add_post_vc.scroll_view.contentOffset = CGPointMake(0, 0)
                }
                self.add_post_screen_animating = false
                self.add_post_screen_shown = !self.add_post_screen_shown
        })
        UIView.transitionWithView(plus_button, duration: ANIMATION_ADD_POST_SCALING_DURATION, options: .TransitionCrossDissolve, animations: {
            self.plus_button.setBackgroundImage(UIImage(named: self.add_post_screen_shown ? "plus_icon" : "plus_close_icon")!, forState: .Normal)
            }, completion: nil)
    }
    
    @IBAction func plusButtonPressed(sender:UIButton) {
        if add_post_screen_animating {
            return
        }
        setAddPostScreen()
    }
    
    func reportButtonPressedOnePost(sender:NSNotification) {
        reportIssuePressedWithCardId(sender.userInfo!["cardId"] as! Int)
    }
    
    func saveButtonPressedOnePost(sender:NSNotification) {
        savePressedWithCardId(sender.userInfo!["cardId"] as! Int, pressedIn: sender.userInfo!["pressedIn"] as! String)
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        if viewController == self && feed_table_view.indexPathForSelectedRow != nil {
            feed_table_view.deselectRowAtIndexPath(feed_table_view.indexPathForSelectedRow!, animated: true)
        }
        if one_post_vc.large_image_presented {
            one_post_vc.animateLargeImageShouldFinish(true)
        }
        if General.map.isDescendantOfView(one_post_vc.view) {
            one_post_vc.removeMap()
            map_vc.connectMap()
        }
    }
    
    func placesScreenClosedWithLocationId(id:Int) {
        if id != -1 {
            feed_state = "ok"
            print("We re having new location selection!")
            //means we should update filters data and feed
            selected_area_id = id
            prepareDefaultFilterData()
            if data_filter_present {
                data_filter_present = false
                navigationItem.setRightBarButtonItem(UIBarButtonItem(image: UIImage(named: "filter_icon_off")!, style: .Plain, target: self, action: "filterButtonPressed:"), animated: true)
                    
            }
            if map_filter_present {
                map_filter_present = false
                map_vc.removeDrawing()
            }
            setFiltersLabelsShowing(map_filter_present, rightOn: data_filter_present)
            resetFiltersButtonPressed(reset_filters_button)
            prev_filter_data = NSMutableDictionary(dictionary: current_filter_data)
            prepareNewAreaId(id)
            add_post_vc.clearForm()
        }
        map_vc.connectMap()
        map_vc.connectPinsData(current_pins_data, withSelectedAreaId: selected_area_id)
    }
    
    func panDidMove(sender:UIPanGestureRecognizer) {
        switch sender.state {
        case UIGestureRecognizerState.Ended:
            var final_center_x:CGFloat = 0.5 * self.view.bounds.width
            var final_people_holder_center_x:CGFloat = 1.5 * view.bounds.width
            if sender.translationInView(self.view).x < PAN_MAP_GESTURE_MIN_TRANSLATE_RELATIVE * self.view.bounds.width {
                final_center_x = map_view_hidden_center_x
                final_people_holder_center_x = 0.5 * view.bounds.width
                map_view_is_on_screen = false
            }
            else {
                map_vc.view.userInteractionEnabled = true
                map_view_is_on_screen = true
            }
            UIView.animateWithDuration(PAN_MAP_FINISH_ANIMATION_DURATION, animations: {
                self.map_vc.view.center.x = final_center_x
                self.people_tab_holder_view.center.x = final_people_holder_center_x
                self.bg_view.center.x = final_people_holder_center_x
                self.white_bg_view.center.x = final_people_holder_center_x
                self.plus_button.center.x = final_people_holder_center_x
                self.tab_bar_bg.center.x = final_people_holder_center_x
                }, completion: {
                    (fin:Bool) in
                    if self.map_view_is_on_screen {
                        if !self.map_filter_present {
                            self.map_vc.showActionButtonsAnimated(true)
                        }
                        //self.map_vc.startLoadingMapWithNavBarHeight(self.navBar.frame.maxY)
                    }
            })
            map_view_is_dragging = false
        case UIGestureRecognizerState.Changed:
            let panned_full_appearance_relative = sender.translationInView(self.view).x / self.view.bounds.width / PAN_MAP_GESTURE_TRANSLATE_FULL_APPEARANCE_RELATIVE
            var final_map_center_x = panned_full_appearance_relative * self.view.bounds.width * (1.0 - PAN_MAP_GESTURE_INITIAL_POSITION_RELATIVE) + map_view_hidden_center_x
            var final_people_holder_center_x = panned_full_appearance_relative * view.bounds.width + 0.5 * view.bounds.width
            if final_people_holder_center_x < 0.5 * view.bounds.width {
                final_people_holder_center_x = 0.5 * view.bounds.width
                final_map_center_x = map_view_hidden_center_x
            }
            map_vc.view.center.x = final_map_center_x
            people_tab_holder_view.center.x = final_people_holder_center_x
            bg_view.center.x = final_people_holder_center_x
            white_bg_view.center.x = final_people_holder_center_x
            plus_button.center.x = final_people_holder_center_x
            tab_bar_bg.center.x = final_people_holder_center_x
        case UIGestureRecognizerState.Began:
            map_vc.view.hidden = false
            map_view_is_dragging = true
            //map_vc.startLoadingMapWithNavBarHeight(navBar.frame.maxY)
        default:
            break
        }
    }
    
    func hideMapViewWithScrollingToCardId(cardId:Int?) {
        let people_tab_initial_center_x = 0.5 * view.bounds.width
        if map_filter_present {
            let present_cards_ids = (current_feed_cells_data as! NSDictionary).allKeys as! [Int]
            //now we neeed to load cards if we do not have enough
        }
        UIView.animateWithDuration(MAP_SHOW_HIDE_ANIMATION_DURATION, animations: {
            self.map_vc.view.center.x = self.map_view_hidden_center_x
            self.people_tab_holder_view.center.x = people_tab_initial_center_x
            self.bg_view.center.x = people_tab_initial_center_x
            self.white_bg_view.center.x = people_tab_initial_center_x
            self.plus_button.center.x = people_tab_initial_center_x
            self.tab_bar_bg.center.x = people_tab_initial_center_x
            }, completion: {
                (fin:Bool) in
                self.map_view_is_on_screen = false
                self.map_vc.view.userInteractionEnabled = false
                self.map_vc.view.hidden = true
                //self.map_vc.removeMap()
                if !self.map_filter_present {
                    self.map_vc.hideActionButtonsAnimated(false)
                }
                if let card_id_scroll = cardId {
                    self.mapCalloutTappedWithCardId(card_id_scroll)
                }
                self.setFiltersLabelsShowing(self.map_filter_present, rightOn: self.data_filter_present)
                self.setupCurrentSectionMappingByAppendingCards(nil, withUpdatingTable: true)
                //self.updateFeedFooter()
        })
    }
    
    //devised for demonstrational purposes
    func showMapBouncing() {
        let static_max_change_delta = view.bounds.width
        let map_max_change_delta = (1.0 - PAN_MAP_GESTURE_INITIAL_POSITION_RELATIVE) * view.bounds.width
        let people_tab_initial_center_x = 0.5 * view.bounds.width
        UIView.animateKeyframesWithDuration(MAP_BOUNCE_ANIMATION_DURATION, delay: 0, options: .CalculationModeCubicPaced, animations: {
            var current_start_time_rel:Double = 0.0
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: Double(self.MAP_BOUNCE_SHOW_ANIMATION_DURATION / self.MAP_BOUNCE_ANIMATION_DURATION), animations: {
                self.map_vc.view.center.x = self.map_view_hidden_center_x + self.MAP_BOUNCE_1 * map_max_change_delta
                self.people_tab_holder_view.center.x = people_tab_initial_center_x + static_max_change_delta * self.MAP_BOUNCE_1
                self.bg_view.center.x = people_tab_initial_center_x + static_max_change_delta * self.MAP_BOUNCE_1
                self.white_bg_view.center.x = people_tab_initial_center_x + static_max_change_delta * self.MAP_BOUNCE_1
                self.plus_button.center.x = people_tab_initial_center_x + static_max_change_delta * self.MAP_BOUNCE_1
                self.tab_bar_bg.center.x = people_tab_initial_center_x + static_max_change_delta * self.MAP_BOUNCE_1
            })
            current_start_time_rel = Double((self.MAP_BOUNCE_ANIMATION_DURATION + self.MAP_BOUNCE_SLEEP_ANIMATION_DURATION) / self.MAP_BOUNCE_ANIMATION_DURATION)
            let action_time_duration = 1.0 - current_start_time_rel
            let total_transition = self.MAP_BOUNCE_1 + self.MAP_BOUNCE_2 + self.MAP_BOUNCE_3
            UIView.addKeyframeWithRelativeStartTime(current_start_time_rel, relativeDuration: Double(self.MAP_BOUNCE_1 / total_transition) * action_time_duration, animations: {
                self.map_vc.view.center.x = self.map_view_hidden_center_x
                self.people_tab_holder_view.center.x = people_tab_initial_center_x
                self.bg_view.center.x = people_tab_initial_center_x
                self.white_bg_view.center.x = people_tab_initial_center_x
                self.plus_button.center.x = people_tab_initial_center_x
                self.tab_bar_bg.center.x = people_tab_initial_center_x
            })
            current_start_time_rel += Double(self.MAP_BOUNCE_1 / total_transition) * action_time_duration
            UIView.addKeyframeWithRelativeStartTime(current_start_time_rel, relativeDuration: Double(self.MAP_BOUNCE_2 / total_transition) * action_time_duration, animations: {
                self.map_vc.view.center.x = self.map_view_hidden_center_x + self.MAP_BOUNCE_2 * map_max_change_delta
                self.people_tab_holder_view.center.x = people_tab_initial_center_x + self.MAP_BOUNCE_2 * static_max_change_delta
                self.bg_view.center.x = people_tab_initial_center_x + self.MAP_BOUNCE_2 * static_max_change_delta

                self.white_bg_view.center.x = people_tab_initial_center_x + self.MAP_BOUNCE_2 * static_max_change_delta

                self.plus_button.center.x = people_tab_initial_center_x + self.MAP_BOUNCE_2 * static_max_change_delta

                self.tab_bar_bg.center.x = people_tab_initial_center_x + self.MAP_BOUNCE_2 * static_max_change_delta
            })
            current_start_time_rel += Double(self.MAP_BOUNCE_2 / total_transition) * action_time_duration
            UIView.addKeyframeWithRelativeStartTime(current_start_time_rel, relativeDuration: Double(self.MAP_BOUNCE_2 / total_transition) * action_time_duration, animations: {
                self.map_vc.view.center.x = self.map_view_hidden_center_x
                self.people_tab_holder_view.center.x = people_tab_initial_center_x
                self.bg_view.center.x = people_tab_initial_center_x
                self.white_bg_view.center.x = people_tab_initial_center_x
                self.plus_button.center.x = people_tab_initial_center_x
                self.tab_bar_bg.center.x = people_tab_initial_center_x
            })
            current_start_time_rel += Double(self.MAP_BOUNCE_2 / total_transition) * action_time_duration
            UIView.addKeyframeWithRelativeStartTime(current_start_time_rel, relativeDuration: Double(self.MAP_BOUNCE_3 / total_transition) * action_time_duration, animations: {
                self.map_vc.view.center.x = self.map_view_hidden_center_x + self.MAP_BOUNCE_3 * map_max_change_delta
                self.people_tab_holder_view.center.x = people_tab_initial_center_x + self.MAP_BOUNCE_3 * static_max_change_delta
                self.bg_view.center.x = people_tab_initial_center_x + self.MAP_BOUNCE_3 * static_max_change_delta
                self.white_bg_view.center.x = people_tab_initial_center_x + self.MAP_BOUNCE_3 * static_max_change_delta
                self.plus_button.center.x = people_tab_initial_center_x + self.MAP_BOUNCE_3 * static_max_change_delta
                self.tab_bar_bg.center.x = people_tab_initial_center_x + self.MAP_BOUNCE_3 * static_max_change_delta
            })
            current_start_time_rel += Double(self.MAP_BOUNCE_3 / total_transition) * action_time_duration
            UIView.addKeyframeWithRelativeStartTime(current_start_time_rel, relativeDuration: Double(self.MAP_BOUNCE_3 / total_transition) * action_time_duration, animations: {
                self.map_vc.view.center.x = self.map_view_hidden_center_x
                self.people_tab_holder_view.center.x = people_tab_initial_center_x
                self.bg_view.center.x = people_tab_initial_center_x
                self.white_bg_view.center.x = people_tab_initial_center_x
                self.plus_button.center.x = people_tab_initial_center_x
                self.tab_bar_bg.center.x = people_tab_initial_center_x
            })
            }, completion: nil)
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == pan_map_gesture_recognizer {
            if gestureRecognizer.locationInView(self.view).x > self.view.bounds.width * PAN_MAP_GESTURE_BEGIN_ZONE_END_RELATIVE {
                return false
            }
            else if map_view_is_on_screen || map_view_is_dragging {
                return false
            }
            else {
                return true
            }
        }
        else {
            return true
        }
    }
    
    func mapCalloutTappedWithCardId(cardId:Int) {
        let section_id = feedSectionForCardId(cardId)
        if section_id != -1 {
            scrollFeedToSection(section_id,animated: true)
        }
        else {
            if let cell_data_present = current_feed_cells_data[cardId] {
                openOnePostWithCardId(cardId, pressedIn: "main_feed")
            }
            else {
                while true {
                    let all_cards_ids = (current_feed_cells_data as! NSDictionary).allKeys as! [Int]
                    if all_cards_ids.contains(cardId) {
                        break
                    }
                    startLoadingNewCardsWithName("add_data\(selected_area_id)")
                    var all_sections = ((feed_section_to_card_id as! NSDictionary).allKeys as! [Int]).sort()
                    let last_section = all_sections[all_sections.count - 1]
                    scrollFeedToSection(last_section, animated: false)
                }
                let final_section = feedSectionForCardId(cardId)
                if final_section != -1 {
                    scrollFeedToSection(final_section, animated: true)
                }
            }
            //should start loading notes until required appears
        }
    }
    
    func scrollFeedToSection(sectionId:Int,animated:Bool) {
        feed_table_view.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: sectionId), atScrollPosition: .Middle, animated: animated)
        if animated {
            let _ = NSTimer.scheduledTimerWithTimeInterval(TABLE_SCROLLING_DURATION, target: self, selector: "blinkTableRow:", userInfo: sectionId, repeats: false)
        }
    }
    
    func blinkTableRow(sender:NSTimer) {
        let row = NSIndexPath(forRow: 0, inSection: sender.userInfo as! Int)
        if let cell_blink = feed_table_view.cellForRowAtIndexPath(row) {
            UIView.animateWithDuration(ANIMATION_CELL_BLINK_DURATION, animations: {
                cell_blink.backgroundColor = self.CELL_COLOR_BLINK
                }, completion: {
                    (fin:Bool) in
                    UIView.animateWithDuration(self.ANIMATION_CELL_BLINK_DURATION, delay: self.ANIMATION_CELL_BLINK_ON_DELAY, options: .CurveEaseInOut, animations: {
                        cell_blink.backgroundColor = UIColor.whiteColor()
                        }, completion: nil)
            })
        }
    }
    
    //such as places icon and filter icon
    func setBasicNavigationItemIcons() {
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(image: UIImage(named: "places_icon")!, style: .Plain, target: self, action: "placesButtonPressed:"), animated: true)
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(image: UIImage(named: data_filter_present ? "filter_icon_on" : "filter_icon_off")!, style: .Plain, target: self, action: "filterButtonPressed:"), animated: true)
    }
    
    func proVersionSwitchChanged(sender:UISwitch) {
        //should present some alert with pro announcement
        print("presenting PRO offer...")
        sender.setOn(true, animated: true)
    }
    
    func updateSettingsTableNumbers() {
        //updating only first 3 menu items
        for (var i = 0;i < 3;i++) {
            let row = NSIndexPath(forRow: i, inSection: 0)
            if let cell = settings_table_view.cellForRowAtIndexPath(row) as? SettingsCellBig {
                var title_description = ""
                var red_description_text = false
                switch i {
                case 0:
                    let total_chats = NSUserDefaults().integerForKey("chats_total")
                    let unread_chats = NSUserDefaults().integerForKey("unread_chats_total")
                    if unread_chats > 0 {
                        title_description = "\(unread_chats) unread"
                        red_description_text = true
                    }
                    else {
                        title_description = "\(total_chats) total"
                    }
                case 1:
                    let total_saved = (NSUserDefaults().arrayForKey("cards_bookmarks") as! [Int]).count
                    title_description = "\(total_saved) saved"
                case 2:
                    let total_my = (NSUserDefaults().arrayForKey("my_posts_cards_ids") as! [Int]).count
                    title_description = "\(total_my) total"
                default:
                    break
                }
                cell.title_description.text = title_description
                cell.title_description.textColor = red_description_text ? UIColor.redColor() : SETTINGS_TABLE_TEXT_COLOR
            }
        }
    }
    
    func deleteOwnPostWithCardId(cardId:Int) {
        print("dedleting post card id = \(cardId)")
    }
}

