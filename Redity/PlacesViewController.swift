//
//  PlacesViewController.swift
//  Redity
//
//  Created by Admin on 10.07.16.
//  Copyright © 2016 Vanoproduction. All rights reserved.
//

import UIKit
import CoreLocation

class PlacesViewController:UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let SELECT_BUTTON_HEIGHT_RELATIVE:CGFloat = 0.074
    let NAVIGATION_BAR_COLOR:UIColor = UIColor(red: 57/255, green: 24/255, blue: 152/255, alpha: 1.0)
    let NAVIGATION_BAR_TINT_COLOR:UIColor = UIColor(red: 216/255, green: 213/255, blue: 242/255, alpha: 1.0)
    let NAVIGATION_BAR_TITLE_TEXT_SIZE:CGFloat = 17
    let BUTTON_BG_COLOR_NORMAL:UIColor = UIColor(red: 96/255, green: 90/255, blue: 210/255, alpha: 1.0)
    let BUTTON_BG_COLOR_HIGHLIGHTED:UIColor = UIColor(red: 51/255, green: 48/255, blue: 112/255, alpha: 1.0)
    let BG_OPACITY:CGFloat = 0.35
    let BUTTONS_MARGIN_SIDES:CGFloat = 8
    let BUTTONS_MARGIN_TOP:CGFloat = 6
    let BUTTONS_SPACING:CGFloat = 11
    let BUTTONS_TEXT_COLOR_NORMAL:UIColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1.0)
    let BUTTONS_TEXT_COLOR_HIGHLIGHTED:UIColor = UIColor(red: 216/255, green: 213/255, blue: 242/255, alpha: 1.0)
    let BUTTONS_ASPECT:CGFloat = 0.3
    let BUTTONS_TEXT_MAX_SIZE:CGFloat = 18
    let BUTTON_NEAR_IMAGE_END_RELATIVE:CGFloat = 0.2711 //to button's width
    let BUTTON_PIN_IMAGE_END_RELATIVE:CGFloat = 0.224
    let BUTTONS_TEXT_MARGIN_LEFT:CGFloat = 5
    let BUTTONS_TEXT_MARGIN_RIGHT:CGFloat = 4
    let HEADER_MARGIN_TOP:CGFloat = 9
    let HEADER_MARGIN_LEFT:CGFloat = 32
    let HEADER_MARGIN_RIGHT:CGFloat = 15
    let HEADER_TEXT_COLOR:UIColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1.0)
    let HEADER_TEXT_SIZE:CGFloat = 15
    let LOCATION_CELL_HEIGHT:CGFloat = 45
    let LOCATION_CELL_MARGIN_TOP:CGFloat = 10 //from my location header label
    let LOCATION_CELL_MARGIN_SIDES:CGFloat = 9
    let LOCATION_BUTTON_MARGIN_LEFT:CGFloat = 11 //from the left side of location cell
    let LOCATION_BUTTON_HEIGHT_RELATIVE:CGFloat = 0.77
    let LOCATION_TITLE_MARGIN_LEFT:CGFloat = 13 // from location button inside location cell
    let LOCATION_TITLE_MARGIN_RIGHT:CGFloat = 8 //from radio button
    let RADIO_BUTTON_REGION_WIDTH:CGFloat = 65 //this area can be pressed
    let RADIO_BUTTON_IMAGE_MARGIN_RIGHT:CGFloat = 17
    let RADIO_BUTTON_HEIGHT_RELATIVE:CGFloat = 0.48
    let LOCATION_TEXT_SIZE_NORMAL:CGFloat = 16
    let LOCATION_TEXT_SIZE_ERROR:CGFloat = 14
    let CELL_TEXT_DETERMINING_OPACITY:CGFloat = 0.6
    let CELL_TEXT_COLOR_NORMAL:UIColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1.0)
    let CELL_TEXT_COLOR_ERROR:UIColor = UIColor(red: 152/255, green: 14/255, blue: 7/255, alpha: 1.0)
    let CELL_TEXT_COLOR_UNKNOWN:UIColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
    let AREAS_TABLE_MARGIN_SIDES:CGFloat = 9
    let AREAS_TABLE_MARGIN_TOP:CGFloat = 10 //from areas header label
    let AREAS_TABLE_CELL_HEIGHT:CGFloat = 40
    let ANIMATION_EXPANSION_DURATION:CFTimeInterval = 0.3
    let ANIMATION_RADIO_BUTTON_DURATION:CFTimeInterval = 0.35
    let TABLE_RELOAD_ANIMATION_DURATION:CFTimeInterval = 0.4
    let CELL_COLOR_BLINK:UIColor = UIColor.yellowColor()
    let ANIMATION_CELL_BLINK_DURATION:CFTimeInterval = 0.4
    let ANIMATION_CELL_BLINK_ON_DELAY:CFTimeInterval = 0.2
    let ANIMATION_SEARCHBAR_APPEARS_DURATION:CFTimeInterval = 0.35
    let ANIMATION_SEARCH_EMPTY_APPEARS_DURATION:CFTimeInterval = 0.3
    let ANIMATION_MINOR_UPDATES_DURATION:CFTimeInterval = 0.3
    let ANIMATION_HIDE_ERROR_DELAY:CFTimeInterval = 1.5
    let ANIMATION_BLINKING_DURATION:CFTimeInterval = 0.4
    let SEARCHBAR_WIDTH_RELATIVE:CGFloat = 0.87
    let SEARCHBAR_HEIGHT_RELATIVE:CGFloat = 0.82 // ... to title view frame in navigation bar
    let SEARCH_OVERLAY_OPACITY:CGFloat = 0.28
    let SEARCH_OVERLAY_GRADIENT_COLOR_1:UIColor = UIColor(red: 57/255, green: 24/255, blue: 152/255, alpha: 1.0)
    let SEARCH_OVERLAY_GRADIENT_COLOR_2:UIColor = UIColor(red: 109/255, green: 108/255, blue: 152/255, alpha: 1.0)
    let SEARCH_OVERLAY_TABLE_OPACITY:Float = 0.95
    let SEARCH_RESULT_TEXT_COLOR:UIColor = UIColor(red: 216/255, green: 213/255, blue: 242/255, alpha: 1.0)
    let SEARCH_RESULT_TEXT_SIZE_ORIGIN:CGFloat = 16
    let SEARCH_RESULT_TEXT_SIZE_PARENT:CGFloat = 14
    let SEARCH_EMPTY_ICON_WIDTH_RELATIVE:CGFloat = 0.331
    let SEARCH_EMPTY_ICON_ICON_ASPECT:CGFloat = 1.004
    let SEARCH_EMPTY_ICON_MARGIN_TOP_RELATIVE:CGFloat = 0.247
    let SEARCH_EMPTY_LABEL_MARGIN_TOP:CGFloat = 50 //from empty search icon
    let SEARCH_EMPTY_ICON_SHIFT_RIGHT_RELATIVE:CGFloat = 0.018
    let SEARCH_EMPTY_LABEL_TEXT_SIZE:CGFloat = 19
    let BUTTON_ENABLED_COLOR:UIColor = UIColor(red: 96/255, green: 90/255, blue: 210/255, alpha: 1.0)
    let BUTTON_DISABLED_COLOR:UIColor = UIColor(red: 159/255, green: 156/255, blue: 209/255, alpha: 1.0)
    
    @IBOutlet var select_button:UIButton!
    @IBOutlet var bg_view:UIView!
    
    var should_update_areas_table = false
    var pin_map_nc:UINavigationController!
    var pin_map_vc:PinMapViewController!
    var title_label:UILabel!
    var searchbar_view:UIView!
    var searchbar:UISearchBar!
    var search_overlay_base:UIView!
    var search_empty_image:UIImageView!
    var search_empty_label:UILabel!
    var search_overlay_table_layer:CAGradientLayer!
    var search_table_view:UITableView!
    var areas_table_view:UITableView!
    var location_cell_view:UIView!
    var location_button:UIButton!
    var location_label:UILabel!
    var location_radio_button:UIButton!
    var location_header_label:UILabel!
    var area_header_label:UILabel!
    var areas_label:UILabel!
    var button_near:UIButton!
    var button_pin:UIButton!
    var navBar:UINavigationBar!
    var searchResultsTableViewController:UITableViewController!
    var vcClosedWithLocationId:((id:Int)->Void)!
    var startUpdatingLocation:(()->Void)!
    var nudged = false
    var searchbar_shown = false
    var now_transition_searchbar = false
    var deepest_map_area_id:Int = -1
    var prev_selected_area_id = -1
    var selected_area_id = 1
    var location_area_id = -1
    var location_button_blinking_shown = true
    var should_blink_location_icon = false
    var should_react_location_cell_press = false
    var areas_pin = false
    var areas_near = false
    var prev_table_type = "basic" //basic, near, pin
    var current_table_type = "basic"
    var prev_pin_coords:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: CLLocationDegrees(5.0), longitude: CLLocationDegrees(7.0))
    var pin_coords:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: CLLocationDegrees(4.0), longitude: CLLocationDegrees(3.0))
    var my_coords:CLLocationCoordinate2D!
    var areas_data:[NSDictionary] = GeneralData.AREAS_DATA
    var select_button_enabled = true
    
    var areas_cells_data:[NSMutableDictionary] = []
    var all_areas_cells_data:[NSMutableDictionary] = []
    var filtered_areas_cells_data:[NSMutableDictionary] = []
    var search_areas_data:[NSDictionary] = []
    var search_table_results_data:[NSAttributedString] = []
    var search_rows_to_areas_id:[Int:Int] = [Int:Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selected_area_id = NSUserDefaults().integerForKey("selected_area_id")
        navBar = self.navigationController!.navigationBar
        navBar.barTintColor = NAVIGATION_BAR_COLOR
        navBar.tintColor = NAVIGATION_BAR_TINT_COLOR
        navBar.barStyle = UIBarStyle.Black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: "closeButtonPressed:")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search_bar_icon")!, style: .Plain, target: self, action: "searchButtonPressed:")
        populateCurrentDataWithAllowedLocations(nil)
        all_areas_cells_data = []
        for entry in areas_cells_data {
            all_areas_cells_data.append(entry)
        }
        createSearchableAreasDictionary()
        constructView()
        constructNavBar()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationUpdated:", name: "location_update_notification", object: nil)
        pin_map_nc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("pin_map_nc") as! UINavigationController
        pin_map_vc = pin_map_nc.childViewControllers[0] as! PinMapViewController
    }
    
    func constructNavBar() {
        //first we need to know the future size of search bar. we do that by adding pseudo title view
        let helper_view = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: navBar.bounds.height))
        self.navigationItem.titleView = helper_view
        helper_view.sizeToFit()
        navBar.layoutIfNeeded()
        let title_view_frame = helper_view.frame
        navigationItem.titleView = nil
        title_label = UILabel(frame: CGRect(x: 0, y: 0, width: title_view_frame.width, height: navBar.bounds.height))
        title_label.text = "Areas"
        title_label.textAlignment = .Center
        title_label.font = UIFont(name: "SFUIText-Bold", size: NAVIGATION_BAR_TITLE_TEXT_SIZE)!
        title_label.textColor = NAVIGATION_BAR_TINT_COLOR
        let real_title_label_size = title_label.textRectForBounds(title_label.bounds, limitedToNumberOfLines: 1)
        title_label.frame = CGRect(x: 0.5 * view.bounds.width - 0.5 * real_title_label_size.width, y: 0.5 * navBar.bounds.height - 0.5 * real_title_label_size.height, width: real_title_label_size.width, height: real_title_label_size.height)
        navBar.addSubview(title_label)
        searchbar_view = UIView(frame: title_view_frame)
        searchbar_view.alpha = 0.0
        searchbar_view.hidden = true
        searchbar = UISearchBar()
        searchbar.delegate = self
        searchbar.searchBarStyle = .Minimal
        searchbar.showsCancelButton = false
        (searchbar.valueForKey("searchField") as! UITextField).textColor = NAVIGATION_BAR_TINT_COLOR
        let searchbar_width = searchbar_view.bounds.width * SEARCHBAR_WIDTH_RELATIVE
        let searchbar_height = searchbar_view.bounds.height * SEARCHBAR_HEIGHT_RELATIVE
        searchbar.frame = CGRect(x: searchbar_view.bounds.width * 0.5 - 0.5 * searchbar_width, y: searchbar_view.bounds.height * 0.5 - 0.5 * searchbar_height, width: searchbar_width, height: searchbar_height)
        searchbar_view.addSubview(searchbar)
        navBar.addSubview(searchbar_view)
        searchbar_view.center.y += navBar.bounds.height
    }
    
    override func viewWillAppear(animated: Bool) {
        if !nudged {
            nudged = true
            let n_y = navBar.frame.minY
            button_near.center.y += n_y
            button_pin.center.y += n_y
            location_header_label.center.y += n_y
            location_cell_view.center.y += n_y
            area_header_label.center.y += n_y
            areas_table_view.frame = CGRect(x: areas_table_view.frame.minX, y: areas_table_view.frame.minY + n_y, width: areas_table_view.frame.width, height: areas_table_view.bounds.height - n_y)
            search_overlay_base.frame = CGRect(x: 0, y: navBar.frame.maxY, width: view.bounds.width, height: view.bounds.height - navBar.frame.maxY)
            search_overlay_table_layer.frame = search_overlay_base.frame
            search_table_view.frame = CGRect(x: 0, y: navBar.frame.maxY, width: view.bounds.width, height: view.bounds.height - navBar.frame.maxY)
        }
        prev_table_type = current_table_type
        if pin_map_vc.pin_set {
            areas_near = false
            button_near.selected = false
            prev_pin_coords = pin_coords
            pin_coords = pin_map_vc.pin_coords
            let populated = populateFilteredAreasCellsDataWithType("pin")
            if populated {
                areas_pin = true
                current_table_type = "pin"
                button_pin.selected = true
            }
            else {
                areas_pin = false
                current_table_type = "basic"
                button_pin.selected = false
                pin_map_vc.clearButtonPressed(pin_map_vc.button_clear)
            }
        }
        else {
            button_pin.selected = false
            areas_pin = false
            if areas_near {
                current_table_type = "near"
            }
            else {
                current_table_type = "basic"
            }
        }
        if current_table_type != prev_table_type || pin_coords.latitude != prev_pin_coords.latitude || pin_coords.longitude != prev_pin_coords.longitude {
            should_update_areas_table = true
        }
        else {
            should_update_areas_table = false
        }
        updateAreasTableWithReloading(false)
        updateLocationCell()
        if !should_update_areas_table {
            let indexScroll = cellDataIndexForAreaId(selected_area_id)
            scrollToCellWithIndex(cellDataIndexForAreaId(selected_area_id), animated: false)
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appDidBecomeActive:", name: "app_did_become_active_notification", object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "app_did_become_active_notification", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        if should_update_areas_table {
            should_update_areas_table = false
            areas_table_view.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
            var areaIdScroll = selected_area_id
            var animate = false
            if current_table_type == "pin" && deepest_map_area_id >= 0 {
                areaIdScroll = deepest_map_area_id
                animate = true
            }
            scrollToCellWithIndex(cellDataIndexForAreaId(areaIdScroll), animated: animate)
        }
    }
    
    //type can be near / pin
    //returns whether looking for nearby areas was succefull
    func populateFilteredAreasCellsDataWithType(type:String) -> Bool {
        let locations_ids_show = General.getNearbyAreasForCoords(type == "near" ? my_coords : pin_coords)
        deepest_map_area_id = General.getDeepestAreaIdAmongAreas(locations_ids_show)
        var prev_current_areas_data:[NSMutableDictionary] = []
        for entry in areas_cells_data {
            prev_current_areas_data.append(entry)
        }
        areas_cells_data = []
        populateCurrentDataWithAllowedLocations(locations_ids_show)
        filtered_areas_cells_data = []
        for entry in areas_cells_data {
            filtered_areas_cells_data.append(entry)
        }
        areas_cells_data = []
        for entry in prev_current_areas_data {
            areas_cells_data.append(entry)
        }
        if locations_ids_show.count == 0 {
            let empty_nearby_alert = UIAlertController(title: "Areas error", message: "No nearby areas were found", preferredStyle: .Alert)
            empty_nearby_alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                (act:UIAlertAction) in
                empty_nearby_alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            presentViewController(empty_nearby_alert, animated: true, completion: nil)
        }
        return locations_ids_show.count != 0
    }
    
    func titleForAreaId(areaId:Int) -> String {
        var title_area = "World"
        if areaId != -69 {
            for area_data in all_areas_cells_data {
                if area_data["areaId"] as! Int == areaId {
                    title_area = area_data["title"] as! String
                }
            }
        }
        return title_area
    }
    
    func updateAreasTableWithReloading(reloading:Bool) {
        if should_update_areas_table {
            var areas_label_text = "Areas"
            if current_table_type == "near" {
                areas_label_text += " near me"
            }
            if current_table_type == "pin" {
                areas_label_text += " near pin"
            }
            UIView.transitionWithView(area_header_label, duration: ANIMATION_MINOR_UPDATES_DURATION, options: .TransitionCrossDissolve, animations: {
                self.area_header_label.text = areas_label_text
                }, completion: nil)
            if current_table_type == "near" || current_table_type == "pin" {
                //maybe collapse currently expanded cells?
                areas_cells_data = []
                for entry in filtered_areas_cells_data {
                    areas_cells_data.append(entry)
                }
            }
            else {
                areas_cells_data = []
                for entry in all_areas_cells_data {
                    areas_cells_data.append(entry)
                }
            }
            tableUpdateSelectedAreas()
            createSearchableAreasDictionary()
            let selIndex = cellDataIndexForAreaId(selected_area_id)
            if selIndex == -1 && selected_area_id != location_area_id {
                select_button.backgroundColor = BUTTON_DISABLED_COLOR
                select_button_enabled = false
            }
            else {
                select_button.backgroundColor = BUTTON_ENABLED_COLOR
                select_button_enabled = true
            }
            if reloading {
                areas_table_view.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
                scrollToCellWithIndex(selIndex, animated: false)
            }
        }
    }
    
    func updateLocationCell() {
        if General.location_status == "OK" {
            location_area_id = General.location_area_id
            my_coords = General.location_coords
        }
        let prev_location_area_id = NSUserDefaults().integerForKey("prev_location_area_id")
        let auth_status = CLLocationManager.authorizationStatus()
        location_button_blinking_shown = true
        if prev_location_area_id != -1 && location_area_id == -1 {
            location_area_id = prev_location_area_id
            let coord_array = NSUserDefaults().objectForKey("prev_location_coords") as! [Double]
            my_coords = CLLocationCoordinate2D(latitude: CLLocationDegrees(coord_array[0]), longitude: CLLocationDegrees(coord_array[1]))
        }
        var should_show_radiobutton = false, should_hide_error_message = false
        should_blink_location_icon = false
        var new_label_font:UIFont!
        var new_label_color:UIColor!
        var new_label_text:String!
        var new_radiobutton_image = "radiobutton_icon_off"
        var new_location_button_image = "location_button_bg_on"
        if auth_status == .Denied || auth_status == .Restricted || !CLLocationManager.locationServicesEnabled() {
            new_label_font = UIFont(name: "SFUIText-Medium", size: LOCATION_TEXT_SIZE_ERROR)!
            new_label_color = CELL_TEXT_COLOR_ERROR
            if !CLLocationManager.locationServicesEnabled() {
                new_label_text = "Location services are disabled!"
            }
            else {
                new_label_text = "Location services are disallowed for this application!"
            }
            if location_area_id == -1 {
                should_show_radiobutton = false
            }
            else {
                should_show_radiobutton = true
                should_hide_error_message = true
            }
            new_location_button_image = "retry_icon"
        }
        else if auth_status == CLAuthorizationStatus.AuthorizedWhenInUse {
            if General.location_status == "DETERMINING" {
                //print("now determiing")
                if location_area_id != -1 {
                    new_label_font = UIFont(name: "SFUIText-Medium", size: LOCATION_TEXT_SIZE_NORMAL)!
                    new_label_color = CELL_TEXT_COLOR_NORMAL
                    new_label_text = titleForAreaId(location_area_id)
                    should_show_radiobutton = true
                }
                else {
                    should_show_radiobutton = false
                    new_label_font = UIFont(name: "SFUIText-Medium", size: LOCATION_TEXT_SIZE_ERROR)!
                    new_label_color = CELL_TEXT_COLOR_UNKNOWN
                    new_label_text = "Determining current location..."
                }
                should_blink_location_icon = true
                new_location_button_image = "location_button_bg_on"
            }
            else if General.location_status == "OK" {
                new_label_font = UIFont(name: "SFUIText-Medium", size: LOCATION_TEXT_SIZE_NORMAL)!
                new_label_color = CELL_TEXT_COLOR_NORMAL
                new_label_text = titleForAreaId(location_area_id)
                new_location_button_image = "location_button_bg_on"
                should_show_radiobutton = true
            }
            else if General.location_status == "ERROR" {
                new_label_font = UIFont(name: "SFUIText-Medium", size: LOCATION_TEXT_SIZE_ERROR)!
                new_label_color = CELL_TEXT_COLOR_ERROR
                new_label_text = "Error while determining location!"
                new_location_button_image = "retry_icon"
                if location_area_id != -1 {
                    should_show_radiobutton = true
                    should_hide_error_message = true
                }
                else {
                    should_show_radiobutton = false
                }
                General.location_status = "IDLE"
            }
            else if General.location_status == "IDLE" {
                if location_area_id == -1 {
                    new_label_color = CELL_TEXT_COLOR_ERROR
                    new_label_text = "Press Retry to update location"
                    new_label_font = UIFont(name: "SFUIText-Medium", size: LOCATION_TEXT_SIZE_ERROR)!
                    should_show_radiobutton = false
                    new_location_button_image = "retry_icon"
                }
                else {
                    new_label_color = CELL_TEXT_COLOR_NORMAL
                    new_label_text = titleForAreaId(location_area_id)
                    new_label_font = UIFont(name: "SFUIText-Medium", size: LOCATION_TEXT_SIZE_NORMAL)!
                    should_show_radiobutton = true
                    new_location_button_image = "location_button_bg_on"
                }
            }
        }
        if location_area_id == selected_area_id {
            new_radiobutton_image = "radiobutton_icon_on"
        }
        else {
            new_radiobutton_image = "radiobutton_icon_off"
        }
        UIView.transitionWithView(location_label, duration: ANIMATION_MINOR_UPDATES_DURATION, options: .TransitionCrossDissolve, animations: {
            self.location_label.font = new_label_font
            self.location_label.textColor = new_label_color
            self.location_label.text = new_label_text
            }, completion: nil)
        if should_show_radiobutton {
            location_radio_button.hidden = false
            location_radio_button.setImage(UIImage(named: new_radiobutton_image)!, forState: .Normal)
            should_react_location_cell_press = true
        }
        else {
            should_react_location_cell_press = false
            location_radio_button.hidden = true
        }
        UIView.transitionWithView(location_button, duration: ANIMATION_MINOR_UPDATES_DURATION, options: .TransitionCrossDissolve, animations: {
            self.location_button.setImage(UIImage(named: new_location_button_image)!, forState: .Normal)
            }, completion: {
                (fin:Bool) in
                if should_hide_error_message {
                    let _ = NSTimer.scheduledTimerWithTimeInterval(self.ANIMATION_HIDE_ERROR_DELAY, target: self, selector: "hideErrorMessage:", userInfo: nil, repeats: false)
                }
                if self.should_blink_location_icon {
                    self.blinkLocationButton()
                }
        })
    }
    
    func hideErrorMessage(sender:NSTimer) {
        UIView.transitionWithView(location_label, duration: ANIMATION_MINOR_UPDATES_DURATION, options: .TransitionCrossDissolve, animations: {
            self.location_label.text = self.titleForAreaId(self.location_area_id)
            self.location_label.font = UIFont(name: "SFUIText-Medium", size: self.LOCATION_TEXT_SIZE_NORMAL)!
            self.location_label.textColor = self.CELL_TEXT_COLOR_NORMAL
            }, completion: nil)
    }
    
    //assumed it blinks button with location icon not retry icon
    func blinkLocationButton() {
        let location_img_name = location_button_blinking_shown ? "location_button_bg_off" : "location_button_bg_on"
        if location_button_blinking_shown {
            location_button_blinking_shown = false
        }
        else {
            location_button_blinking_shown = true
        }
        UIView.transitionWithView(location_button, duration: ANIMATION_BLINKING_DURATION, options: .TransitionCrossDissolve, animations: {
            self.location_button.setImage(UIImage(named: location_img_name)!, forState: .Normal)
            }, completion: {
                (fin:Bool) in
                if self.should_blink_location_icon {
                    self.blinkLocationButton()
                }
        })
    }
    
    func tableUpdateSelectedAreas() {
        for (var i = 0; i < areas_cells_data.count;i++) {
            areas_cells_data[i]["selected"] = false
            if let semi_sel = areas_cells_data[i]["semiSelected"] as? Bool {
                if semi_sel {
                    areas_cells_data[i]["semiSelected"] = false
                }
            }
        }
        let indexSel = cellDataIndexForAreaId(selected_area_id)
        if indexSel != -1 {
            areas_cells_data[indexSel]["selected"] = true
            propagateParentSemiselectedWithId(indexSel)
        }
    }
    
    //pass approved locations to filter them - suitable for creating filtered lists after pin map or near me button
    func populateCurrentDataWithAllowedLocations(locationsShow:[Int]?) {
        //populateCellsDataWithDataArray(areas_data, indentLevel: 0, parentIndex: -1, locationsShow: locationsShow)
        populateCurrentCellsWithAllInfo(General.all_areas_info, locationsShow: locationsShow)
        for (var i = 0;i < areas_cells_data.count;i++) {
            if areas_cells_data[i]["selected"] as! Bool && areas_cells_data[i]["isChildOf"] as! Int != -1 {
                propagateParentSemiselectedWithId(i)
            }
        }
    }
    
    func populateCurrentCellsWithAllInfo(data:[Int:NSMutableDictionary], locationsShow: [Int]?) {
        var all_areas_ids = (data as! NSDictionary).allKeys as! [Int]
        all_areas_ids.sortInPlace()
        for (var i = 0; i < all_areas_ids.count;i++) {
            let origin_area_id = all_areas_ids[i]
            if let locations_to_show = locationsShow {
                var present = false
                for location_id in locations_to_show {
                    if location_id == origin_area_id {
                        present = true
                    }
                }
                if !present {
                    continue
                }
            }
            let areaInfo = data[all_areas_ids[i]] as! NSDictionary
            let cells_data_dict = NSMutableDictionary()
            cells_data_dict["title"] = areaInfo["title"] as! String
            cells_data_dict["expansion_available"] = (areaInfo["childrenAreasIds"] as! [Int]).count != 0 ? true : false
            cells_data_dict["areaId"] = origin_area_id
            cells_data_dict["expanded"] = false
            cells_data_dict["childOfAreaId"] = areaInfo["childOfAreaId"] as! Int
            cells_data_dict["indentLevel"] = areaInfo["indentLevel"] as! Int
            cells_data_dict["shown"] = areaInfo["indentLevel"] as! Int == 0
            cells_data_dict["selected"] = origin_area_id == selected_area_id
            areas_cells_data.append(cells_data_dict)
        }
        for cellData in areas_cells_data {
            let parentAreaId = cellData["childOfAreaId"] as! Int
            cellData["isChildOf"] = -1
            if parentAreaId != -1 {
                for (var i = 0; i < areas_cells_data.count;i++) {
                    if areas_cells_data[i]["areaId"] as! Int == parentAreaId {
                        cellData["isChildOf"] = i
                        break
                    }
                }
            }
        }
        //now,when cells are filtered, we should make sure some regions which were expandable earlier are still expandable
        if locationsShow != nil {
            for cellData in areas_cells_data {
                if cellData["expansion_available"] as! Bool {
                    var hasChildren = false
                    for cellDataCheck in areas_cells_data {
                        if cellDataCheck["childOfAreaId"] as! Int == cellData["areaId"] as! Int {
                            hasChildren = true
                            break
                        }
                    }
                    if !hasChildren {
                        cellData["expansion_available"] = false
                        cellData["expanded"] = false
                    }
                }
            }
        }
        //now sorting so that to make regions appear in a correct order
        //we can perform sorting either by sorting areasIds(considering them correctly arranged in the very first geo_json file) or by moving rows deciding the final position based on childofarea
    }
    
    func createSearchableAreasDictionary() {
        search_areas_data = []
        for (var i = 0; i < areas_cells_data.count;i++) {
            let search_area = NSMutableDictionary()
            search_area["title"] = areas_cells_data[i]["title"] as! NSString
            search_area["superParentTitle"] = getSuperParentTitleForDataIndex(i)
            search_area["areaId"] = areas_cells_data[i]["areaId"] as! Int
            search_areas_data.append(search_area)
        }
    }
    
    func clearSelectedStatus() {
        for(var i = 0; i < areas_cells_data.count;i++) {
            if areas_cells_data[i]["selected"] as! Bool {
                areas_cells_data[i]["selected"] = false
            }
            if let semi_avail = areas_cells_data[i]["semiSelected"] as? Bool {
                if semi_avail {
                    areas_cells_data[i]["semiSelected"] = false
                }
            }
        }
    }
    
    func getSuperParentTitleForDataIndex(index:Int) -> NSString {
        let parentIndex = areas_cells_data[index]["isChildOf"] as! Int
        return parentIndex == -1 ? areas_cells_data[index]["title"] as! NSString : getSuperParentTitleForDataIndex(parentIndex)
    }
    
    func propagateParentSemiselectedWithId(id:Int) {
        let parentId = areas_cells_data[id]["isChildOf"] as! Int
        if parentId != -1 {
            areas_cells_data[parentId]["semiSelected"] = true
            propagateParentSemiselectedWithId(parentId)
        }
    }
    
    func populateCellsDataWithDataArray(dataArray:[NSDictionary], indentLevel:Int, parentIndex:Int, locationsShow:[Int]?) {
        for (var i = 0; i < dataArray.count;i++) {
            let origin_area_id = dataArray[i]["areaId"] as! Int
            if let locations_to_show = locationsShow {
                var present = false
                for location_id in locations_to_show {
                    if location_id == origin_area_id {
                        present = true
                    }
                }
                if !present {
                    continue
                }
            }
            let current_title = dataArray[i]["title"] as! String
            let cells_data_dict = NSMutableDictionary()
            cells_data_dict["title"] = current_title
            cells_data_dict["expansion_available"] = (dataArray[i]["children"] as! [NSDictionary]).count == 0 ? false : true
            cells_data_dict["areaId"] = origin_area_id
            cells_data_dict["expanded"] = false
            cells_data_dict["indentLevel"] = indentLevel
            cells_data_dict["isChildOf"] = parentIndex
            cells_data_dict["shown"] = cells_data_dict["expansion_available"] as! Bool && parentIndex == -1
            cells_data_dict["selected"] = dataArray[i]["areaId"] as! Int == selected_area_id
            areas_cells_data.append(cells_data_dict)
            if (dataArray[i]["children"] as! [NSDictionary]).count != 0 {
                populateCellsDataWithDataArray((dataArray[i]["children"] as! [NSDictionary]), indentLevel:indentLevel + 1, parentIndex: areas_cells_data.count - 1, locationsShow: locationsShow)
            }
        }
    }
    
    func locationUpdated(sender:NSNotification) {
        /*
        let info = sender.userInfo!
        if info["type"] as! String == "ok" {
            location_area_id = info["locationAreaId"] as! Int
        }
*/
        updateLocationCell()
    }
    
    func constructView() {
        bg_view.backgroundColor = UIColor(patternImage: UIImage(named: "bg_pattern")!)
        bg_view.alpha = BG_OPACITY
        button_near = UIButton(type: .Custom)
        button_near.setBackgroundImage(UIImage(named: "near_me_button_bg_unselected")!, forState: .Normal)
        button_near.setBackgroundImage(UIImage(named: "near_me_button_bg_selected")!, forState: .Highlighted)
        button_near.setBackgroundImage(UIImage(named: "near_me_button_bg_selected")!, forState: .Selected)
        button_near.setTitle("Near me", forState: .Normal)
        button_near.setTitle("Near me", forState: .Highlighted)
        button_near.setTitle("Near me", forState: .Selected)
        button_near.setTitleColor(BUTTONS_TEXT_COLOR_NORMAL, forState: .Normal)
        button_near.setTitleColor(BUTTONS_TEXT_COLOR_HIGHLIGHTED, forState: .Highlighted)
        button_near.setTitleColor(BUTTONS_TEXT_COLOR_HIGHLIGHTED, forState: .Selected)
        button_near.titleLabel!.font = UIFont(name: "SFUIText-Medium", size: BUTTONS_TEXT_MAX_SIZE)
        let button_upper_width = (view.bounds.width - BUTTONS_MARGIN_SIDES * 2.0 - BUTTONS_SPACING) * 0.5
        button_near.frame = CGRect(x: BUTTONS_MARGIN_SIDES, y: navBar.frame.maxY + BUTTONS_MARGIN_TOP, width: button_upper_width, height: button_upper_width * BUTTONS_ASPECT)
        view.addSubview(button_near)
        button_pin = UIButton(type: .Custom)
        button_pin.setBackgroundImage(UIImage(named: "pin_map_button_bg_unselected")!, forState: .Normal)
        button_pin.setBackgroundImage(UIImage(named: "pin_map_button_bg_selected")!, forState: .Highlighted)
        button_pin.setBackgroundImage(UIImage(named: "pin_map_button_bg_selected")!, forState: .Selected)
        button_pin.setTitle("Pin map", forState: .Normal)
        button_pin.setTitle("Pin map", forState: .Highlighted)
        button_pin.setTitle("Pin map", forState: .Selected)
        button_pin.setTitleColor(BUTTONS_TEXT_COLOR_NORMAL, forState: .Normal)
        button_pin.setTitleColor(BUTTONS_TEXT_COLOR_HIGHLIGHTED, forState: .Highlighted)
        button_pin.setTitleColor(BUTTONS_TEXT_COLOR_HIGHLIGHTED, forState: .Selected)
        button_pin.titleLabel!.font = UIFont(name: "SFUIText-Medium", size: BUTTONS_TEXT_MAX_SIZE)
        button_pin.frame = CGRect(x: button_near.frame.maxX + BUTTONS_SPACING, y: button_near.frame.minY, width: button_upper_width, height: button_upper_width * BUTTONS_ASPECT)
        view.addSubview(button_pin)
        let near_text_width_max = button_upper_width * (1.0 - BUTTON_NEAR_IMAGE_END_RELATIVE) - BUTTONS_TEXT_MARGIN_LEFT - BUTTONS_TEXT_MARGIN_RIGHT
        let pin_text_width_max = button_upper_width * (1.0 - BUTTON_PIN_IMAGE_END_RELATIVE) - BUTTONS_TEXT_MARGIN_LEFT - BUTTONS_TEXT_MARGIN_RIGHT
        var real_near_text_width = (button_near.titleForState(.Normal) as! NSString).sizeWithAttributes([NSFontAttributeName:button_near.titleLabel!.font]).width
        var real_pin_text_width = (button_pin.titleForState(.Normal) as! NSString).sizeWithAttributes([NSFontAttributeName:button_pin.titleLabel!.font]).width
        if real_near_text_width > near_text_width_max {
            real_near_text_width = near_text_width_max
            button_near.titleLabel!.font = UIFont(name: "SFUIText-Medium", size: General.getFontSizeToFitWidth(real_near_text_width, forString: button_near.titleForState(.Normal)!, withFontName: "SFUIText-Medium"))!
        }
        if real_pin_text_width > pin_text_width_max {
            real_pin_text_width = pin_text_width_max
            button_pin.titleLabel!.font = UIFont(name: "SFUIText-Medium", size: General.getFontSizeToFitWidth(real_pin_text_width, forString: button_pin.titleForState(.Normal)!, withFontName: "SFUIText-Medium"))!
        }
        let near_title_shift = ((1.0 - BUTTON_NEAR_IMAGE_END_RELATIVE) * button_upper_width - BUTTONS_TEXT_MARGIN_LEFT - BUTTONS_TEXT_MARGIN_RIGHT - real_near_text_width) * 0.5 + BUTTONS_TEXT_MARGIN_LEFT + button_upper_width * BUTTON_NEAR_IMAGE_END_RELATIVE - (0.5 * button_upper_width - 0.5 * real_near_text_width)
        let pin_title_shift = ((1.0 - BUTTON_PIN_IMAGE_END_RELATIVE) * button_upper_width - BUTTONS_TEXT_MARGIN_LEFT - BUTTONS_TEXT_MARGIN_RIGHT - real_pin_text_width) * 0.5 + BUTTONS_TEXT_MARGIN_LEFT + button_upper_width * BUTTON_PIN_IMAGE_END_RELATIVE - (0.5 * button_upper_width - 0.5 * real_pin_text_width)
        button_near.titleEdgeInsets = UIEdgeInsetsMake(0, near_title_shift, 0, 0)
        button_pin.titleEdgeInsets = UIEdgeInsetsMake(0, pin_title_shift, 0, 0)
        button_near.addTarget(self, action: "nearButtonPressed:", forControlEvents: .TouchUpInside)
        button_pin.addTarget(self, action: "pinButtonPressed:", forControlEvents: .TouchUpInside)
        location_header_label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        location_header_label.text = "My location"
        location_header_label.font = UIFont(name: "SFUIText-Bold", size: HEADER_TEXT_SIZE)!
        location_header_label.textColor = HEADER_TEXT_COLOR
        location_header_label.textAlignment = .Left
        let real_location_size = location_header_label.textRectForBounds(location_header_label.bounds, limitedToNumberOfLines: 1)
        location_header_label.frame = CGRect(x: HEADER_MARGIN_LEFT, y: button_near.frame.maxY + HEADER_MARGIN_TOP, width: real_location_size.width, height: real_location_size.height)
        view.addSubview(location_header_label)
        location_cell_view = UIView(frame: CGRect(x: LOCATION_CELL_MARGIN_SIDES, y: location_header_label.frame.maxY + LOCATION_CELL_MARGIN_TOP, width: view.bounds.width - LOCATION_CELL_MARGIN_SIDES * 2.0, height: LOCATION_CELL_HEIGHT))
        location_cell_view.backgroundColor = UIColor.whiteColor()
        location_cell_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "locationCellPressed:"))
        location_button = UIButton(type: .Custom)
        location_button.setBackgroundImage(UIImage(named: "location_button_bg_on")!, forState: .Normal)
        let location_button_height = location_cell_view.bounds.height * LOCATION_BUTTON_HEIGHT_RELATIVE
        location_button.frame = CGRect(x: LOCATION_BUTTON_MARGIN_LEFT, y: (location_cell_view.bounds.height - location_button_height) * 0.5, width: location_button_height, height: location_button_height)
        location_button.addTarget(self, action: "locationButtonPressed:", forControlEvents: .TouchUpInside)
        location_radio_button = UIButton(type: .Custom)
        location_radio_button.addTarget(self, action: "locationRadioButtonPressed:", forControlEvents: .TouchUpInside)
        let location_radio_height = location_cell_view.bounds.height * RADIO_BUTTON_HEIGHT_RELATIVE
        location_radio_button.frame = CGRect(x: location_cell_view.bounds.width - RADIO_BUTTON_REGION_WIDTH, y: 0, width: RADIO_BUTTON_REGION_WIDTH, height: location_cell_view.bounds.height)
        let top_edge_img = (location_cell_view.bounds.height - location_radio_height) * 0.5
        location_radio_button.imageEdgeInsets = UIEdgeInsetsMake(top_edge_img, RADIO_BUTTON_REGION_WIDTH - location_radio_height - RADIO_BUTTON_IMAGE_MARGIN_RIGHT, top_edge_img, RADIO_BUTTON_IMAGE_MARGIN_RIGHT)
        let location_label_max_width = location_cell_view.bounds.width - LOCATION_TITLE_MARGIN_LEFT - location_button.frame.maxX - RADIO_BUTTON_IMAGE_MARGIN_RIGHT - location_radio_height - LOCATION_TITLE_MARGIN_RIGHT
        location_label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        if location_area_id != -1 {
            location_label.text = areas_cells_data[cellDataIndexForAreaId(location_area_id)]["title"] as! String
        }
        location_label.text = "some test text"
        location_label.font = UIFont(name: "SFUIText-Medium", size: LOCATION_TEXT_SIZE_NORMAL)!
        location_label.textColor = CELL_TEXT_COLOR_NORMAL
        location_label.textAlignment = .Left
        let real_label_size = location_label.textRectForBounds(location_label.bounds, limitedToNumberOfLines: 1)
        location_label.frame = CGRect(x: LOCATION_TITLE_MARGIN_LEFT + location_button.frame.maxX, y: (location_cell_view.bounds.height - real_label_size.height) * 0.5, width: location_label_max_width, height: real_label_size.height)
        location_cell_view.addSubview(location_label)
        location_cell_view.addSubview(location_radio_button)
        location_cell_view.addSubview(location_button)
        view.addSubview(location_cell_view)
        area_header_label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        area_header_label.text = "Areas"
        area_header_label.textColor = HEADER_TEXT_COLOR
        area_header_label.font = UIFont(name: "SFUIText-Bold", size: HEADER_TEXT_SIZE)!
        area_header_label.textAlignment = .Left
        let real_areas_header_size = area_header_label.textRectForBounds(area_header_label.bounds, limitedToNumberOfLines: 1)
        area_header_label.frame = CGRect(x: HEADER_MARGIN_LEFT, y: HEADER_MARGIN_TOP + location_cell_view.frame.maxY, width: view.bounds.width - HEADER_MARGIN_LEFT - HEADER_MARGIN_RIGHT, height: real_areas_header_size.height)
        view.addSubview(area_header_label)
        areas_table_view = UITableView(frame: CGRect(x: AREAS_TABLE_MARGIN_SIDES,y: area_header_label.frame.maxY + AREAS_TABLE_MARGIN_TOP, width: view.bounds.width - AREAS_TABLE_MARGIN_SIDES * 2.0, height: (1.0 - SELECT_BUTTON_HEIGHT_RELATIVE) * view.bounds.height - AREAS_TABLE_MARGIN_TOP - area_header_label.frame.maxY), style: UITableViewStyle.Plain)
        areas_table_view.registerClass(AreaCell.self, forCellReuseIdentifier: "area_cell")
        areas_table_view.delegate = self
        areas_table_view.dataSource = self
        view.addSubview(areas_table_view)
        search_overlay_base = UIView()
        search_overlay_base.backgroundColor = NAVIGATION_BAR_COLOR
        search_overlay_base.alpha = 0.0
        search_overlay_base.hidden = true
        search_overlay_base.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "searchOverlayPressed:"))
        view.addSubview(search_overlay_base)
        search_overlay_table_layer = CAGradientLayer()
        search_overlay_table_layer.colors = [SEARCH_OVERLAY_GRADIENT_COLOR_1.CGColor,SEARCH_OVERLAY_GRADIENT_COLOR_2.CGColor]
        search_overlay_table_layer.startPoint = CGPointMake(0.5, 0)
        search_overlay_table_layer.endPoint = CGPointMake(0.5, 1.0)
        search_overlay_table_layer.opacity = 0.0
        search_overlay_table_layer.hidden = true
        view.layer.addSublayer(search_overlay_table_layer)
        search_table_view = UITableView(frame: CGRectZero, style: .Plain)
        search_table_view.backgroundColor = nil
        search_table_view.delegate = self
        search_table_view.dataSource = self
        search_table_view.alpha = 0.0
        search_table_view.hidden = true
        search_table_view.tableFooterView = UIView()
        view.addSubview(search_table_view)
        search_empty_image = UIImageView(image: UIImage(named: "search_empty_icon")!)
        search_empty_image.contentMode = .ScaleAspectFit
        let search_image_empty_width = view.bounds.width * SEARCH_EMPTY_ICON_WIDTH_RELATIVE
        search_empty_image.frame = CGRect(x: 0.5 * view.bounds.width - 0.5 * search_image_empty_width + view.bounds.width * SEARCH_EMPTY_ICON_SHIFT_RIGHT_RELATIVE, y: SEARCH_EMPTY_ICON_MARGIN_TOP_RELATIVE * view.bounds.height, width: search_image_empty_width, height: search_image_empty_width * SEARCH_EMPTY_ICON_ICON_ASPECT)
        search_empty_image.alpha = 0.0
        search_empty_image.hidden = true
        view.addSubview(search_empty_image)
        search_empty_label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        search_empty_label.text = "Nothing found"
        search_empty_label.textColor = NAVIGATION_BAR_TINT_COLOR
        search_empty_label.font = UIFont(name: "GothamPro-Medium", size: SEARCH_EMPTY_LABEL_TEXT_SIZE)!
        let real_empty_label_size = search_empty_label.textRectForBounds(search_empty_label.bounds, limitedToNumberOfLines: 1)
        search_empty_label.frame = CGRect(x: 0.5 * view.bounds.width - 0.5 * real_empty_label_size.width, y: search_empty_image.frame.maxY + SEARCH_EMPTY_LABEL_MARGIN_TOP, width: real_empty_label_size.width, height: real_empty_label_size.height)
        search_empty_label.hidden = true
        search_empty_label.alpha = 0.0
        view.addSubview(search_empty_label)
    }
    
    func areaCellIndexForTableRow(row:Int) -> Int {
        var found_no = 0
        var index = -1
        for (var i = 0; i < areas_cells_data.count;i++) {
            if areas_cells_data[i]["shown"] as! Bool {
                found_no++
            }
            if found_no == (row + 1) {
                index = i
                break
            }
        }
        if index == -1 {
            print("FATAL ERROR: Unable to find corresponding areacelldata for table row!")
            return -1
        }
        else {
            return index
        }
    }
    
    func tableRowForDataIndex(index:Int) -> Int {
        var result_row = -1
        for (var i = 0;i < areas_cells_data.count;i++) {
            if areas_cells_data[i]["shown"] as! Bool {
                result_row++
            }
            if i == index {
                break
            }
        }
        if result_row == -1 {
            print("FATAL ERROR: Could not find table row for index")
        }
        return result_row
    }
    
    func isCellIndex(cellIndex:Int,successorOf:Int) -> Bool {
        let parentId = areas_cells_data[cellIndex]["isChildOf"] as! Int
        if  parentId == successorOf {
            return true
        }
        else if parentId == -1 {
            return false
        }
        else {
            return isCellIndex(parentId, successorOf: successorOf)
        }
    }
    
    func cellDataIndexForAreaId(areaId:Int) -> Int {
        var ind = -1
        for (var i = 0; i < areas_cells_data.count;i++) {
            if areas_cells_data[i]["areaId"] as! Int == areaId {
                ind = i
                break
            }
        }
        if ind == -1 {
            print("FATAL ERROR: Could not find cell data index for area id")
        }
        return ind
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == areas_table_view {
            let cell = tableView.dequeueReusableCellWithIdentifier("area_cell") as! AreaCell
            cell.setContentWithData(areas_cells_data[areaCellIndexForTableRow(indexPath.row)], cellSize: CGSizeMake(areas_table_view.bounds.width, AREAS_TABLE_CELL_HEIGHT))
            cell.setAreaCellIndexWithIndex(areaCellIndexForTableRow(indexPath.row))
            cell.setRadioHandlerWithHandler(cellRadioButtonPressedWithIndex)
            return cell
        }
        else {
            var cell = tableView.dequeueReusableCellWithIdentifier("search_cell")
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: "search_cell")
            }
            cell!.accessoryType = .DisclosureIndicator
            cell!.textLabel!.attributedText = search_table_results_data[indexPath.row]
            return cell!
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == search_table_view {
            cell.backgroundColor = UIColor.clearColor()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView == areas_table_view {
            let data_index = areaCellIndexForTableRow(indexPath.row)
            if areas_cells_data[data_index]["expansion_available"] as! Bool {
                var insertCells:[NSIndexPath] = []
                var deleteCells:[NSIndexPath] = []
                var rotation_degree:CGFloat = 1.57
                var new_image_name = "expand_icon_on"
                if areas_cells_data[data_index]["expanded"] as! Bool {
                    areas_cells_data[data_index]["expanded"] = false
                    rotation_degree *= -1.0
                    new_image_name = "expand_icon_off"
                    var indicesToDelete:[Int] = []
                    for (var i = 0;i < areas_cells_data.count;i++) {
                        let should_be_deleted = isCellIndex(i, successorOf: data_index)
                        if should_be_deleted {
                            indicesToDelete.append(i)
                        }
                    }
                    for index in indicesToDelete {
                        deleteCells.append(NSIndexPath(forRow: tableRowForDataIndex(index), inSection: 0))
                    }
                    for index in indicesToDelete {
                        areas_cells_data[index]["shown"] = false
                        areas_cells_data[index]["expanded"] = false
                    }
                }
                else {
                    areas_cells_data[data_index]["expanded"] = true
                    for (var i = 0;i < areas_cells_data.count;i++) {
                        if areas_cells_data[i]["isChildOf"] as! Int == data_index {
                            areas_cells_data[i]["shown"] = true
                            insertCells.append(NSIndexPath(forRow: tableRowForDataIndex(i), inSection: 0))
                        }
                    }
                }
                if insertCells.count != 0 {
                    tableView.insertRowsAtIndexPaths(insertCells, withRowAnimation: .Fade)
                }
                if deleteCells.count != 0 {
                    tableView.deleteRowsAtIndexPaths(deleteCells, withRowAnimation: .Fade)
                }
                if let cell_animate = tableView.cellForRowAtIndexPath(indexPath) as? AreaCell {
                    UIView.animateWithDuration(ANIMATION_EXPANSION_DURATION, animations: {
                        if CGAffineTransformIsIdentity(cell_animate.expand_icon.transform) {
                            cell_animate.expand_icon.transform = CGAffineTransformMakeRotation(rotation_degree)
                        }
                        else {
                            cell_animate.expand_icon.transform = CGAffineTransformMakeRotation(0)
                        }
                        }, completion: nil)
                }
            }
        }
        else {
            searchCancelButtonPressed(navigationItem.rightBarButtonItem!)
            scrollToCellWithIndex(cellDataIndexForAreaId(search_rows_to_areas_id[indexPath.row]!), animated: true)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == areas_table_view {
            var shown = 0
            for area_cell_data in areas_cells_data {
                if area_cell_data["shown"] as! Bool {
                    shown++
                }
            }
            return shown
        }
        else {
            return search_table_results_data.count
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func setHandlersWith(closedHandler:((id:Int)->Void),locationUpdateHandler:(()->Void)) {
        vcClosedWithLocationId = closedHandler
        startUpdatingLocation = locationUpdateHandler
    }
    
    func scrollToCellWithIndex(index:Int, animated:Bool) {
        if index == -1 {
            return
        }
        if !(areas_cells_data[index]["shown"] as! Bool) {
            areas_cells_data[index]["shown"] = true
            let parentIndex = areas_cells_data[index]["isChildOf"] as! Int
            if parentIndex != -1 {
                for (var i = 0;i < areas_cells_data.count;i++) {
                    if areas_cells_data[i]["isChildOf"] as! Int == parentIndex {
                        areas_cells_data[i]["shown"] = true
                    }
                }
                propagateParentExpandingWithIndex(parentIndex)
            }
            let row_anim = animated ? UITableViewRowAnimation.Fade : UITableViewRowAnimation.None
            areas_table_view.reloadSections(NSIndexSet(index: 0), withRowAnimation: row_anim)
        }
        areas_table_view.scrollToRowAtIndexPath(NSIndexPath(forRow: tableRowForDataIndex(index), inSection: 0), atScrollPosition: .Middle, animated: true)
        if animated {
            let _ = NSTimer.scheduledTimerWithTimeInterval(TABLE_RELOAD_ANIMATION_DURATION, target: self, selector: "blinkTableRow:", userInfo: index, repeats: false)
        }
    }
    
    func blinkTableRow(sender:NSTimer) {
        let row = NSIndexPath(forRow: tableRowForDataIndex(sender.userInfo as! Int), inSection: 0)
        if let cell_blink = areas_table_view.cellForRowAtIndexPath(row) as? AreaCell {
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
    
    func propagateParentExpandingWithIndex(index:Int) {
        let parentIndex = areas_cells_data[index]["isChildOf"] as! Int
        areas_cells_data[index]["shown"] = true
        areas_cells_data[index]["expanded"] = true
        if parentIndex != -1 {
            for (var i = 0;i < areas_cells_data.count;i++) {
                if areas_cells_data[i]["isChildOf"] as! Int == parentIndex {
                    areas_cells_data[i]["shown"] = true
                }
            }
            propagateParentExpandingWithIndex(parentIndex)
        }
    }
    
    func cellRadioButtonPressedWithIndex(index:Int) {
        if !select_button_enabled {
            select_button_enabled = true
            select_button.backgroundColor = BUTTON_ENABLED_COLOR
        }
        let indexOnBefore = cellDataIndexForAreaId(selected_area_id)
        if index != indexOnBefore {
            let selected_area_id_before = selected_area_id
            animateRadioButtonsWithIndexOn(index)
            updateSelectedStatesForAllTables()
            let areaIdOn = areas_cells_data[index]["areaId"] as! Int
            if areaIdOn == location_area_id || selected_area_id_before == location_area_id {
                var img_name = "radiobutton_icon_off"
                if areaIdOn == location_area_id {
                    img_name = "radiobutton_icon_on"
                }
                UIView.transitionWithView(location_radio_button, duration: ANIMATION_RADIO_BUTTON_DURATION, options: .TransitionCrossDissolve, animations: {
                    self.location_radio_button.setImage(UIImage(named: img_name)!, forState: .Normal)
                    }, completion: nil)
            }
        }
    }
    
    func nearButtonPressed(sender:UIButton) {
        if areas_near {
            button_near.selected = false
            areas_near = false
            prev_table_type = current_table_type
            current_table_type = "basic"
            if current_table_type != prev_table_type {
                should_update_areas_table = true
            }
            else {
                should_update_areas_table = false
            }
            updateAreasTableWithReloading(true)
        }
        else {
            if location_area_id == -1 || location_area_id == -69{
                let loc_alert = UIAlertController(title: "Location error", message: (location_area_id == -1 ? "Location is unknown" : "Location is not detailed enough"), preferredStyle: .Alert)
                loc_alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                    (act:UIAlertAction) in
                    loc_alert.dismissViewControllerAnimated(true, completion: {
                        self.updateLocationCell()
                    })
                }))
                self.presentViewController(loc_alert, animated: true, completion: nil)
            }
            else {
                prev_table_type = current_table_type
                if areas_pin {
                    areas_pin = false
                    button_pin.selected = false
                    pin_map_vc.clearButtonPressed(pin_map_vc.button_clear)
                }
                let populated = populateFilteredAreasCellsDataWithType("near")
                if populated {
                    areas_near = true
                    current_table_type = "near"
                    button_near.selected = true
                }
                else {
                    current_table_type = "basic"
                }
                if current_table_type != prev_table_type {
                    should_update_areas_table = true
                }
                else {
                    should_update_areas_table = false
                }
                updateAreasTableWithReloading(true)
            }
        }
    }
    
    func pinButtonPressed(sender:UIButton) {
        pin_map_vc.selected_area_id = selected_area_id
        self.navigationController!.presentViewController(pin_map_nc, animated: true, completion: nil)
    }
    
    func locationButtonPressed(sender:UIButton) {
        let auth_status = CLLocationManager.authorizationStatus()
        if auth_status == .Denied || auth_status == .Restricted || !CLLocationManager.locationServicesEnabled() {
            let msg = !CLLocationManager.locationServicesEnabled() ? "Location services are switched off!" : "Location services are disallowed for this application! \n Go to settings -> Redity and enable them!"
            let alert = UIAlertController(title: "Location error", message: msg, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
                (act:UIAlertAction) in
                alert.dismissViewControllerAnimated(true, completion: {
                    self.updateLocationCell()
                })
            }))
            presentViewController(alert, animated: true, completion: nil)
        }
        else {
            if General.location_status != "DETERMINING" {
                startUpdatingLocation()
                self.updateLocationCell()
                if General.location_status != "DETERMINING" {
                    location_label.layer.removeAllAnimations()
                }
                UIView.transitionWithView(location_button, duration: ANIMATION_MINOR_UPDATES_DURATION, options: .TransitionCrossDissolve, animations: {
                    self.location_button.setImage(UIImage(named: "location_button_bg_on")!, forState: .Normal)
                    }, completion: nil)
            }
        }
    }
    
    func animateRadioButtonsWithIndexOn(indexOn:Int) {
        let indexOff = cellDataIndexForAreaId(selected_area_id)
        if indexOff != -1 {
            areas_cells_data[indexOff]["selected"] = false
        }
        if indexOn != -1 {
            areas_cells_data[indexOn]["selected"] = true
        }
        var indicesAnimate:[Int] = []
        var indicesSemiOff:[Int] = []
        var indicesSemiOn:[Int] = []
        for (var i = 0; i < areas_cells_data.count;i++) {
            if let semi_available = areas_cells_data[i]["semiSelected"] as? Bool {
                if semi_available {
                    areas_cells_data[i]["semiSelected"] = false
                    indicesSemiOff.append(i)
                }
            }
        }
        if indexOn != -1 {
            propagateParentSemiselectedWithId(indexOn)
            for (var i = 0;i < areas_cells_data.count;i++) {
                if let semi_available = areas_cells_data[i]["semiSelected"] as? Bool {
                    if semi_available {
                        indicesSemiOn.append(i)
                    }
                }
            }
        }
        indicesAnimate.appendContentsOf(indicesSemiOn)
        indicesAnimate.appendContentsOf(indicesSemiOff)
        if indexOff != -1 {
            indicesAnimate.append(indexOff)
        }
        if indexOn != -1 {
            indicesAnimate.append(indexOn)
        }
        if indicesAnimate.count != 0 {
            for indexAnimate in indicesAnimate {
                var img_name = "radiobutton_icon_off"
                if indexAnimate == indexOn {
                    img_name = "radiobutton_icon_on"
                    print("having index on \(indexOn)")
                }
                for indexSemiOn in indicesSemiOn {
                    if indexSemiOn == indexAnimate {
                        img_name = "radiobutton_icon_semi"
                    }
                }
                if areas_cells_data[indexAnimate]["shown"] as! Bool {
                    if let cell_animate_semi = areas_table_view.cellForRowAtIndexPath(NSIndexPath(forRow: tableRowForDataIndex(indexAnimate), inSection: 0)) as? AreaCell {
                        UIView.transitionWithView(cell_animate_semi, duration: ANIMATION_RADIO_BUTTON_DURATION, options: .TransitionCrossDissolve, animations: {
                            cell_animate_semi.radio_button.setImage(UIImage(named: img_name)!, forState: .Normal)
                            }, completion: nil)
                    }
                }
            }
        }
        if indexOn != -1 {
            selected_area_id = areas_cells_data[indexOn]["areaId"] as! Int
        }
        else {
            selected_area_id = location_area_id
        }
    }
    
    func updateSelectedStatesForAllTables() {
        var prev_current_areas:[NSMutableDictionary] = []
        for entry in areas_cells_data {
            prev_current_areas.append(entry)
        }
        areas_cells_data = []
        for entry in all_areas_cells_data {
            areas_cells_data.append(entry)
        }
        tableUpdateSelectedAreas()
        all_areas_cells_data = []
        for entry in areas_cells_data {
            all_areas_cells_data.append(entry)
        }
        areas_cells_data = []
        for entry in filtered_areas_cells_data {
            areas_cells_data.append(entry)
        }
        if areas_cells_data.count > 0 {
            tableUpdateSelectedAreas()
            filtered_areas_cells_data = []
            for entry in areas_cells_data {
                filtered_areas_cells_data.append(entry)
            }
        }
        areas_cells_data = []
        for entry in prev_current_areas {
            areas_cells_data.append(entry)
        }
    }
    
    func collapseAreasTable() {
        for (var i = 0; i < areas_cells_data.count;i++) {
            if areas_cells_data[i]["isChildOf"] as! Int != -1 {
                areas_cells_data[i]["shown"] = false
            }
            areas_cells_data[i]["expanded"] = false
        }
        areas_table_view.reloadData()
    }
    
    func locationCellPressed(sender:UITapGestureRecognizer) {
        if should_react_location_cell_press {
            locationRadioButtonPressed(location_radio_button)
        }
    }
    
    func locationRadioButtonPressed(sender:UIButton) {
        if location_area_id == -69 {
            return
        }
        if !select_button_enabled {
            select_button_enabled = true
            select_button.backgroundColor = BUTTON_ENABLED_COLOR
        }
        if location_area_id != selected_area_id {
            location_radio_button.setImage(UIImage(named: "radiobutton_icon_on")!, forState: .Normal)
            animateRadioButtonsWithIndexOn(cellDataIndexForAreaId(location_area_id))
            scrollToCellWithIndex(cellDataIndexForAreaId(location_area_id),animated: true)
            updateSelectedStatesForAllTables()
        }
    }
    
    @IBAction func selectButtonPressed(sender:UIButton) {
        if select_button_enabled {
            NSUserDefaults().setInteger(selected_area_id, forKey: "selected_area_id")
            var code_pass = selected_area_id
            if selected_area_id == prev_selected_area_id {
                code_pass = -1
            }
            sender.backgroundColor = BUTTON_BG_COLOR_NORMAL
            dismissViewControllerAnimated(true, completion: {
                self.vcClosedWithLocationId(id:code_pass)
                self.collapseAreasTable()
            })
        }
    }
    
    @IBAction func selectButtonHighlighted(sender:UIButton) {
        if select_button_enabled {
            sender.backgroundColor = BUTTON_BG_COLOR_HIGHLIGHTED
        }
    }
    
    @IBAction func selectButtonReleased(sender:UIButton) {
        if select_button_enabled {
            sender.backgroundColor = BUTTON_BG_COLOR_NORMAL
        }
    }
    
    //id -1 means vc was closed not selected
    func closeButtonPressed(sender:UIBarButtonItem) {
        selected_area_id = prev_selected_area_id
        print("now selected area id \(selected_area_id)")
        dismissViewControllerAnimated(true, completion: {
            self.vcClosedWithLocationId(id:-1)
            self.tableUpdateSelectedAreas()
            self.collapseAreasTable()
            if self.searchbar_shown {
                self.searchCancelButtonPressed(self.navigationItem.rightBarButtonItem!)
            }
            let selIndex = self.cellDataIndexForAreaId(self.selected_area_id)
            if selIndex == -1 && self.selected_area_id != self.location_area_id {
                self.select_button_enabled = true
                self.select_button.backgroundColor = self.BUTTON_ENABLED_COLOR
                if self.areas_near {
                    self.areas_near = false
                    self.button_near.selected = false
                }
                if self.areas_pin {
                    self.areas_pin = false
                    self.button_pin.selected = false
                    self.pin_map_vc.clearButtonPressed(self.pin_map_vc.button_clear)
                }
                self.prev_table_type = self.current_table_type
                self.current_table_type = "basic"
                if self.current_table_type != self.prev_table_type {
                    self.should_update_areas_table = true
                }
                else {
                    self.should_update_areas_table = false
                }
                self.updateAreasTableWithReloading(true)
            }
        })
    }
    
    func updateSearchTableWithText(text:NSString) {
        search_table_results_data = []
        search_rows_to_areas_id = [Int:Int]()
        for (var i = 0; i < search_areas_data.count;i++) {
            let title_origin = search_areas_data[i]["title"] as! NSString
            if text.length > title_origin.length {
                continue
            }
            var title_origin_words = title_origin.componentsSeparatedByString(" ")
            title_origin_words.append(title_origin as String)
            for title_origin_word in title_origin_words {
                let comp_res = (title_origin_word as! NSString).compare(text as! String, options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, min(text.length,title_origin_word.characters.count)))
                if comp_res == NSComparisonResult.OrderedSame {
                    search_rows_to_areas_id[search_table_results_data.count] = search_areas_data[i]["areaId"] as! Int
                    var parent_append_string = search_areas_data[i]["superParentTitle"] as! NSString
                    if parent_append_string == title_origin {
                        parent_append_string = ""
                    }
                    if parent_append_string != "" {
                        parent_append_string = ", \(parent_append_string)"
                    }
                    let result_string = "\(title_origin)\(parent_append_string)"
                    let attr_string = NSMutableAttributedString(string: result_string)
                    let title_len = title_origin.length
                    let parent_len = parent_append_string.length
                    attr_string.addAttributes([NSFontAttributeName:UIFont(name: "SFUIText-Semibold", size: SEARCH_RESULT_TEXT_SIZE_ORIGIN)!,NSForegroundColorAttributeName:SEARCH_RESULT_TEXT_COLOR], range: NSMakeRange(0, title_len))
                    if parent_len != 0 {
                        attr_string.addAttributes([NSFontAttributeName:UIFont(name: "SFUIText-Medium", size: SEARCH_RESULT_TEXT_SIZE_PARENT)!,NSForegroundColorAttributeName:SEARCH_RESULT_TEXT_COLOR], range: NSMakeRange(title_len, parent_len))
                    }
                    search_table_results_data.append(attr_string)
                    break
                }
            }
        }
        var should_show_empty = false
        var should_show_table = false
        if search_table_results_data.count == 0 && search_empty_label.hidden {
            should_show_empty = true
        }
        if search_table_results_data.count != 0 && !search_empty_label.hidden {
            should_show_table = true
        }
        if should_show_table || should_show_empty {
            if should_show_empty {
                search_empty_image.hidden = false
                search_empty_label.hidden = false
            }
            else {
                search_table_view.hidden = false
            }
            UIView.animateWithDuration(ANIMATION_SEARCH_EMPTY_APPEARS_DURATION, animations: {
                self.search_empty_label.alpha = should_show_empty ? 1.0 : 0.0
                self.search_empty_image.alpha = should_show_empty ? 1.0 : 0.0
                self.search_table_view.alpha = should_show_empty ? 0.0 : 1.0
                }, completion: {
                    (fin:Bool) in
                    if should_show_empty {
                        self.search_table_view.hidden = true
                    }
                    else {
                        self.search_empty_label.hidden = true
                        self.search_empty_image.hidden = true
                    }
            })
        }
        search_table_view.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
    }
    
    func searchButtonPressed(sender:UIBarButtonItem) {
        if searchbar_shown || now_transition_searchbar {
            return
        }
        searchbar_view.hidden = false
        search_overlay_base.hidden = false
        now_transition_searchbar = true
        let shift = navBar.bounds.height
        UIView.animateWithDuration(ANIMATION_SEARCHBAR_APPEARS_DURATION, animations: {
            self.title_label.center.y -= shift
            self.searchbar_view.center.y -= shift
            self.title_label.alpha = 0.0
            self.searchbar_view.alpha = 1.0
            self.search_overlay_base.alpha = self.SEARCH_OVERLAY_OPACITY
            }, completion: {
                (fin:Bool) in
                self.title_label.hidden = true
                self.now_transition_searchbar = false
                self.searchbar_shown = true
                self.navigationItem.setRightBarButtonItem(UIBarButtonItem(image: UIImage(named: "cancel_icon")!, style: .Plain, target: self, action: "searchCancelButtonPressed:"), animated: true)
        })
    }
    
    func searchCancelButtonPressed(sender:UIBarButtonItem) {
        if !searchbar_shown || now_transition_searchbar {
            return
        }
        title_label.hidden = false
        now_transition_searchbar = true
        if !search_overlay_table_layer.hidden {
            let grad_anim = CABasicAnimation(keyPath: "opacity")
            grad_anim.fromValue = SEARCH_OVERLAY_TABLE_OPACITY
            grad_anim.toValue = 0.0
            grad_anim.fillMode = kCAFillModeForwards
            grad_anim.removedOnCompletion = false
            grad_anim.duration = ANIMATION_SEARCHBAR_APPEARS_DURATION
            search_overlay_table_layer.addAnimation(grad_anim, forKey: "grad_anim")
        }
        let shift = navBar.bounds.height
        UIView.animateWithDuration(ANIMATION_SEARCHBAR_APPEARS_DURATION, animations: {
            self.title_label.center.y += shift
            self.searchbar_view.center.y += shift
            self.title_label.alpha = 1.0
            self.searchbar_view.alpha = 0.0
            self.search_overlay_base.alpha = 0.0
            if !self.search_table_view.hidden {
                self.search_table_view.alpha = 0.0
            }
            if !self.search_empty_image.hidden {
                self.search_empty_image.alpha = 0.0
                self.search_empty_label.alpha = 0.0
            }
            }, completion: {
                (fin:Bool) in
                self.searchbar.text = nil
                self.searchbar.endEditing(true)
                self.searchbar_view.hidden = true
                self.now_transition_searchbar = false
                self.searchbar_shown = false
                self.search_overlay_table_layer.hidden = true
                self.search_overlay_base.hidden = true
                self.search_empty_label.hidden = true
                self.search_empty_image.hidden = true
                self.search_table_view.hidden = true
                self.navigationItem.setRightBarButtonItem(UIBarButtonItem(image: UIImage(named: "search_bar_icon")!, style: .Plain, target: self, action: "searchButtonPressed:"), animated: true)
        })
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText as! NSString
        let origin_chars = searchText.characters
        var result_text = NSString(string: text)
        var first_letter = -1
        var last_letter = -1
        for (var i = 0;i < text.length;i++) {
            let char_string = text.substringWithRange(NSMakeRange(i, 1))
            if char_string != " " {
                first_letter = i
                break
            }
        }
        for (var i = text.length - 1;i >= 0;i--) {
            let char_string = text.substringWithRange(NSMakeRange(i, 1))
            if char_string != " " {
                last_letter = i
                break
            }
        }
        if first_letter == -1 || last_letter == -1 {
            result_text = NSString(string: "")
        }
        else {
            if last_letter != text.length - 1 || first_letter != 0 {
                result_text = text.substringWithRange(NSMakeRange(first_letter, (text.length - first_letter - (text.length - 1 - last_letter))))
            }
        }
        var should_hide_table = false
        var should_show_table = false
        if result_text.length < 2 {
            if !search_overlay_table_layer.hidden {
                should_hide_table = true //and show base overlay
                search_table_results_data = []
                search_rows_to_areas_id = [Int:Int]()
                search_table_view.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
            }
        }
        else {
            if search_overlay_table_layer.hidden {
                should_show_table = true //and hide base overlay
            }
            updateSearchTableWithText(result_text)
        }
        if should_hide_table || should_show_table {
            let table_bg_anim = CABasicAnimation(keyPath: "opacity")
            if should_hide_table {
                search_overlay_base.hidden = false
            }
            else {
                search_overlay_table_layer.hidden = false
                search_table_view.hidden = false
            }
            table_bg_anim.fromValue = should_hide_table ? SEARCH_OVERLAY_TABLE_OPACITY : 0.0
            table_bg_anim.toValue = should_hide_table ? 0.0 : SEARCH_OVERLAY_TABLE_OPACITY
            table_bg_anim.duration = ANIMATION_SEARCHBAR_APPEARS_DURATION
            table_bg_anim.fillMode = kCAFillModeForwards
            table_bg_anim.removedOnCompletion = false
            search_overlay_table_layer.addAnimation(table_bg_anim, forKey: "opacity_anim")
            UIView.animateWithDuration(ANIMATION_SEARCHBAR_APPEARS_DURATION, animations: {
                self.search_overlay_base.alpha = should_hide_table ? self.SEARCH_OVERLAY_OPACITY : 0.0
                self.search_table_view.alpha = should_hide_table ? 0.0 : 1.0
                if should_hide_table {
                    self.search_empty_image.alpha = 0.0
                    self.search_empty_label.alpha = 0.0
                }
                }, completion: {
                    (fin:Bool) in
                    if should_hide_table {
                        self.search_overlay_table_layer.hidden = true
                        self.search_overlay_table_layer.removeAllAnimations()
                        self.search_overlay_table_layer.opacity = 0.0
                        self.search_table_view.hidden = true
                        self.search_empty_label.hidden = true
                        self.search_empty_image.hidden = true
                    }
                    else {
                        self.search_overlay_base.hidden = true
                    }
            })
        }
    }
    
    func searchOverlayPressed(sender:UITapGestureRecognizer) {
        searchCancelButtonPressed(navigationItem.rightBarButtonItem!)
    }
    
    func appDidBecomeActive(sender:NSNotification) {
        updateLocationCell()
    }
    
}
