//
//  MapViewController.swift
//  Redity
//
//  Created by Admin on 03.07.16.
//  Copyright © 2016 Vanoproduction. All rights reserved.
//

import UIKit
import MapKit

class MapViewController:UIViewController, MKMapViewDelegate {
    
    let BACK_BUTTON_HEIGHT_RELATIVE:CGFloat = 0.072
    let SELECTION_BUTTON_WIDTH_RELATIVE:CGFloat = 0.147
    let SELECTION_BUTTON_MARGIN_RIGHT:CGFloat = 5
    let SELECTION_BUTTON_MARGIN_BOTTOM_CLOSED:CGFloat = 30
    let BUTTONS_VERTICAL_SPACING:CGFloat = 30
    let BUTTONS_APPEARANCE_ANIMATION_DURATION:CFTimeInterval = 0.3
    let BUTTON_BG_COLOR_NORMAL:UIColor = UIColor(red: 96/255, green: 90/255, blue: 210/255, alpha: 1.0)
    let BUTTON_BG_COLOR_HIGHLIGHTED:UIColor = UIColor(red: 51/255, green: 48/255, blue: 112/255, alpha: 1.0)
    let OVERLAY_COLOR:UIColor = UIColor(red: 57/255, green: 24/255, blue: 152/255, alpha: 1.0)
    let OVERLAY_OPACITY:CGFloat = 0.58
    let OVERLAY_STROKE_COLOR:UIColor = UIColor(red: 210/255, green: 206/255, blue: 238/255, alpha: 1.0)
    let OVERLAY_STROKE_WIDTH:CGFloat = 4
    let OVERLAY_FILL_COLOR:UIColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
    let ANIMATION_DRAWING_PREPARATION_DURATION:CFTimeInterval = 0.4
    let ANIMATION_SELECTION_DISAPPEARING_DURATION:CFTimeInterval = 0.25
    let ANIMATION_SELECTION_DISAPPEARING_DELAY:CFTimeInterval = 0.35
    
    var MAP_PIN_MARGIN_SIDES:CGFloat = 0
    let CALLOUT_TITLE_TEXT_SIZE:CGFloat = 15
    let CALLOUT_TITLE_TEXT_COLOR:UIColor = UIColor(red: 57/255, green: 24/255, blue: 152/255, alpha: 1.0)
    let CALLOUT_TITLE_MARGIN_SIDES:CGFloat = 5 // from left and right
    let CALLOUT_TIME_TEXT_SIZE:CGFloat = 9
    let CALLOUT_TIME_TEXT_COLOR:UIColor = UIColor(red: 216/255, green: 213/255, blue: 242/255, alpha: 1.0)
    let CALLOUT_TIME_BG_COLOR:UIColor = UIColor(red: 96/255, green: 90/255, blue: 210/255, alpha: 1.0)
    let CALLOUT_MAX_WIDTH_RELATIVE:CGFloat = 0.65 // to screen width
    let CALLOUT_MIN_WIDTH_RELATIVE:CGFloat = 0.4 // same applies here
    let CALLOUT_TIME_WIDTH:CGFloat = 80 //absolute value
    let CALLOUT_HEIGHT_BUBBLE:CGFloat = 38 //abs
    let CALLOUT_TAIL_HEIGHT:CGFloat = 18
    let CALLOUT_TAIL_ASPECT:CGFloat = 0.455
    let CALLOUT_MARGIN_TOP:CGFloat = 5
    let CALLOUT_MARGIN_BOTTOM:CGFloat = 5
    let CALLOUT_MARGIN_SIDES:CGFloat = 6
    
    let CLUSTERS_CELLS_PER_WIDTH:Int = 8
    let MAP_PIN_POINT_WIDTH_RELATIVE:CGFloat = 0.08 //of screen's width
    let MAP_PIN_POINT_ASPECT:CGFloat = 1.333
    let MAP_CLUSTER_MAX_WIDTH_RELATIVE:CGFloat = 0.101
    let MAP_CLUSTER_MIN_WIDTH_RELATIVE:CGFloat = 0.088
    let MAP_CLUSTER_PRESSED_SCALE_FACTOR:Double = 3.0
    let MAP_REGION_BOUNDING_FACTOR:CGFloat = 1.24
    
    let HINT_MARGIN_LEFT:CGFloat = 25
    let HINT_MARGIN_RIGHT:CGFloat = 20
    let HINT_LABEL_WIDTH_RELATIVE:CGFloat = 0.8
    let HINT_LABEL_HEIGHT_RELATIVE:CGFloat = 0.65
    let HINT_LABEL_TEXT_SIZE:CGFloat = 15
    let HINT_OPACITY:CGFloat = 0.65
    let HINT_DISAPPEARS_DELAY:CFTimeInterval = 0.75
    let ANIMATION_HINT_DISAPPEARING_DURATION:CFTimeInterval = 0.3
    
    @IBOutlet var button_back:UIButton!
    @IBOutlet var back_button_bottom_cons:NSLayoutConstraint!
    @IBOutlet var selection_button:UIButton!
    @IBOutlet var overlay_view:OverlayView! // is also used as a drawing surface
    var hint_bg_view:UIView!
    var hint_label:UILabel!
    var selection_layer:CAShapeLayer!
    var navBarHeight:CGFloat = 0
    var firstShown = false
    var prev_scale:Int = -1
    var prev_selected_area_id:Int = -1
    
    var hint_in_transition = false
    var selection_is_editing = false
    var selection_is_established = false
    var should_intercept_touches = false
    var prev_point:CGPoint = CGPointZero
    var drawing_points:[CGPoint] = []
    var current_pins_data:[Int:NSDictionary] = [Int:NSDictionary]()
    var pins_annotations:[Int:MapPinAnnotation] = [Int:MapPinAnnotation]()
    var clusters_annotations:[(pinsIds:[Int],annotation:MapClusterAnnotation)] = []
    var pins_shown_ids:[Int] = []
    var filtered_cards_ids:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let actions_arr:[String:CAAction] = ["hidden":NSNull(),"opacity":NSNull()]
        overlay_view.alpha = 0
        overlay_view.hidden = true
        navBarHeight = (parentViewController as! MainViewController).navBar.frame.maxY
        overlay_view.frame = CGRect(x: 0, y: navBarHeight, width: view.bounds.width, height: (view.bounds.height - navBarHeight))
        overlay_view.layer.zPosition = -4
        selection_layer = CAShapeLayer()
        selection_layer.frame = overlay_view.frame
        selection_layer.hidden = true
        selection_layer.opacity = Float(OVERLAY_OPACITY)
        selection_layer.zPosition = -3
        selection_layer.fillColor = OVERLAY_COLOR.CGColor
        selection_layer.actions = actions_arr
        let hint_bg_width = view.bounds.width - SELECTION_BUTTON_MARGIN_RIGHT - SELECTION_BUTTON_WIDTH_RELATIVE * view.bounds.width - HINT_MARGIN_RIGHT - HINT_MARGIN_LEFT
        hint_label = UILabel(frame: CGRect(x: 0, y: 0, width: hint_bg_width * HINT_LABEL_WIDTH_RELATIVE, height: 200))
        hint_label.text = "Use your finger to draw some region on the screen"
        hint_label.numberOfLines = 0
        hint_label.textColor = OVERLAY_STROKE_COLOR
        hint_label.font = UIFont(name: "SFUIText-Medium", size: HINT_LABEL_TEXT_SIZE)
        let real_hint_label_size = hint_label.textRectForBounds(hint_label.bounds, limitedToNumberOfLines: 0)
        hint_bg_view = UIView(frame: CGRect(x: HINT_MARGIN_LEFT, y: view.bounds.height - SELECTION_BUTTON_MARGIN_BOTTOM_CLOSED - real_hint_label_size.height / HINT_LABEL_HEIGHT_RELATIVE, width: hint_bg_width, height: real_hint_label_size.height / HINT_LABEL_HEIGHT_RELATIVE))
        hint_label.frame = CGRect(x: HINT_MARGIN_LEFT + 0.5 * (1.0 - HINT_LABEL_WIDTH_RELATIVE) * hint_bg_width, y: hint_bg_view.frame.minY + (1.0 - HINT_LABEL_HEIGHT_RELATIVE) * hint_bg_view.bounds.height * 0.5, width: hint_bg_width * HINT_LABEL_WIDTH_RELATIVE, height: real_hint_label_size.height)
        hint_bg_view.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
        hint_bg_view.alpha = 0.0
        hint_label.alpha = 0.0
        hint_bg_view.hidden = true
        hint_label.hidden = true
        hint_bg_view.layer.zPosition = -2
        hint_label.layer.zPosition = -1
        view.addSubview(hint_bg_view)
        view.addSubview(hint_label)
        view.layer.addSublayer(selection_layer)
        if General.map == nil {
            General.map = MKMapView()
        }
        General.map.frame = CGRect(x: 0, y: navBarHeight, width: view.bounds.width, height: view.bounds.height - navBarHeight)
        view.addSubview(General.map)
        General.map.layer.zPosition = -6
        view.bringSubviewToFront(button_back)
        view.bringSubviewToFront(selection_button)
        General.map_main_span = General.map.regionThatFits(General.map.region)
        General.map_pin_span = General.map_main_span
        General.map.delegate = self
        General.map.alpha = 1.0
        General.map.hidden = false
    }
    
    func connectMap() {
        if General.map.superview == nil {
            General.map.frame = CGRect(x: 0, y: navBarHeight, width: view.bounds.width, height: view.bounds.height - navBarHeight)
            view.addSubview(General.map)
            General.map.layer.zPosition = -6
        }
        General.map.layer.zPosition = -6
        General.map.alpha = 1.0
        General.map.hidden = false
        view.bringSubviewToFront(button_back)
        view.bringSubviewToFront(selection_button)
        General.map.delegate = self
        General.map.userInteractionEnabled = selection_is_established ? false : true
        General.map.region = General.map_main_span
    }
    
    func connectPinsData(pinsData:[Int:NSDictionary], withSelectedAreaId:Int) {
        if withSelectedAreaId != prev_selected_area_id {
            General.map.setVisibleMapRect(General.getUnionBoundingMapRectForAreaId(withSelectedAreaId, withBoundingFactor: MAP_REGION_BOUNDING_FACTOR), animated: true)
        }
        prev_selected_area_id = withSelectedAreaId
        current_pins_data = [Int:NSDictionary]()
        pins_annotations = [Int:MapPinAnnotation]()
        pins_shown_ids = []
        for pin in pinsData {
            let current_pin = NSMutableDictionary(dictionary: pin.1)
            let coords = (pin.1["coords"] as! NSValue).MKCoordinateValue
            let point_coords = MKMapPointForCoordinate(coords)
            let point = CGPoint(x: point_coords.x, y: point_coords.y)
            current_pin["point_coords"] = NSValue(CGPoint: point)
            current_pins_data[pin.0] = current_pin
            let pin_annotation = MapPinAnnotation(coords:coords,cardId:pin.0)
            pins_annotations[pin.0] = pin_annotation
        }
        updatePointsClustering()
    }
    
    func updatePointsClustering() {
        var clusters_show:[(volume:Int,location:CLLocationCoordinate2D,pinsIds:[Int])] = []
        var pins_show_ids:[Int] = []
        let whole_map_rect = General.map.visibleMapRect
        var should_redraw_clusters = false
        let scale:Int = Int(floor(whole_map_rect.size.width / MKMapSizeWorld.width * 10000.0))
        if scale != prev_scale {
            should_redraw_clusters = true
        }
        prev_scale = scale
        let cell_width_map = whole_map_rect.size.width / Double(CLUSTERS_CELLS_PER_WIDTH)
        for (var nowX = whole_map_rect.origin.x; nowX < whole_map_rect.origin.x + whole_map_rect.size.width; nowX += cell_width_map) {
            for (var nowY = whole_map_rect.origin.y; nowY < whole_map_rect.origin.y + whole_map_rect.size.height; nowY += cell_width_map) {
                let map_rect_check = MKMapRectMake(nowX, nowY, cell_width_map, cell_width_map)
                let pins_present_ids = getPointsIdsWithMapRect(map_rect_check)
                /*
                let pins_inside = General.map.annotationsInMapRect(map_rect_check)
                var pins_present:[MKPointAnnotation] = []
                for pinInside in pins_inside {
                    if !pinInside.isKindOfClass(MapClusterAnnotation) {
                        if let pin_annot = pinInside as? MKPointAnnotation {
                            pins_present.append(pin_annot)
                        }
                    }
                }
*/
                if pins_present_ids.count == 1 {
                    pins_show_ids.append(pins_present_ids[0])
                }
                else if pins_present_ids.count > 1 {
                    var total_x:Double = 0, total_y:Double = 0
                    var pins_ids:[Int] = []
                    for pin in pins_present_ids {
                        pins_ids.append(pin)
                        let p = (current_pins_data[pin]!["point_coords"] as! NSValue).CGPointValue()
                        total_x += Double(p.x)
                        total_y += Double(p.y)
                    }
                    let cluster_location = MKCoordinateForMapPoint(MKMapPoint(x: total_x / Double(pins_present_ids.count), y: total_y / Double(pins_present_ids.count)))
                    let cluster = (volume: pins_present_ids.count, location:cluster_location,pinsIds:pins_ids)
                    clusters_show.append(cluster)
                }
            }
        }
        var max_cluster_volume:Int = 0
        var min_cluster_volume:Int = 999
        for clusterShow in clusters_show {
            if clusterShow.volume > max_cluster_volume {
                max_cluster_volume = clusterShow.volume
            }
            if clusterShow.volume < min_cluster_volume {
                min_cluster_volume = clusterShow.volume
            }
        }
        var pins_delete:[MKAnnotation] = []
        var pins_insert:[MKAnnotation] = []
        for pinToShow in pins_show_ids {
            if !pins_shown_ids.contains(pinToShow) {
                pins_insert.append(pins_annotations[pinToShow]!)
            }
        }
        for pinPreviousShown in pins_shown_ids {
            if !pins_show_ids.contains(pinPreviousShown) {
                pins_delete.append(pins_annotations[pinPreviousShown]!)
            }
        }
        var clusters_indices_remove_now:[Int] = []
        var clusters_indices_remove_shown:[Int] = []
        outer: for (var i = 0; i < clusters_annotations.count;i++) {
            for (var b = 0;b < clusters_show.count;b++) {
                if clusters_annotations[i].pinsIds == clusters_show[b].pinsIds {
                    clusters_indices_remove_now.append(b)
                    continue outer
                }
            }
            clusters_indices_remove_shown.append(i)
            pins_delete.append(clusters_annotations[i].annotation)
        }
        /*
        clusters_annotations = []
        for cluster in clusters_show {
            var fraction:CGFloat = 1.0
            if max_cluster_volume - min_cluster_volume != 0 {
                fraction = CGFloat(cluster.volume) / CGFloat(max_cluster_volume - min_cluster_volume)
            }
            let cluster_annotation = MapClusterAnnotation(coords: cluster.location,fraction: fraction, count: cluster.volume)
            clusters_annotations.append(cluster_annotation)
        }
        for clusterInsert in clusters_annotations {
            pins_insert.append(clusterInsert)
        }
*/
        var clusters_annotations_copy:[(pinsIds:[Int],annotation:MapClusterAnnotation)] = []
        clusters_annotations_copy.appendContentsOf(clusters_annotations)
        clusters_annotations = []
        for (var i = 0; i < clusters_annotations_copy.count;i++) {
            if clusters_indices_remove_shown.contains(i) {
                continue
            }
            clusters_annotations.append(clusters_annotations_copy[i])
        }
        for (var i = 0; i < clusters_show.count;i++) {
            if clusters_indices_remove_now.contains(i) {
                continue
            }
            var fraction:CGFloat = 1.0
            if max_cluster_volume - min_cluster_volume != 0 {
                fraction = CGFloat(clusters_show[i].volume) / CGFloat(max_cluster_volume - min_cluster_volume)
            }
            let cluster_annotation = MapClusterAnnotation(coords: clusters_show[i].location,fraction: fraction, count: clusters_show[i].volume)
            pins_insert.append(cluster_annotation)
            clusters_annotations.append((pinsIds:clusters_show[i].pinsIds, annotation:cluster_annotation))
        }
        pins_shown_ids = []
        pins_shown_ids.appendContentsOf(pins_show_ids)
        General.map.addAnnotations(pins_insert)
        General.map.removeAnnotations(pins_delete)
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("calling upde clustering from ergion did change")
        updatePointsClustering()
    }
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        for viewAnimate in views {
            let bounce_anim = CAKeyframeAnimation(keyPath: "transform.scale")
            bounce_anim.values = [0.05,1.1,0.9,1.0]
            bounce_anim.duration = 0.6
            var timing_funcs:[CAMediaTimingFunction] = []
            for _ in 1...3 {
                timing_funcs.append(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
            }
            bounce_anim.timingFunctions = timing_funcs
            viewAnimate.layer.addAnimation(bounce_anim, forKey: "bounce")
        }
    }
    
    func getPointsIdsWithMapRect(mapRect:MKMapRect) -> [Int] {
        //simple implementstion - just looking through all the points - gonna substitute it with QuadTree a bit later
        let minX = MKMapRectGetMinX(mapRect)
        let maxX = MKMapRectGetMaxX(mapRect)
        let minY = MKMapRectGetMinY(mapRect)
        let maxY = MKMapRectGetMaxY(mapRect)
        var points_ids:[Int] = []
        for pin in current_pins_data {
            let point = (pin.1["point_coords"] as! NSValue).CGPointValue()
            let map_point = MKMapPointMake(Double(point.x), Double(point.y))
            if MKMapRectContainsPoint(mapRect, map_point) {
                points_ids.append(pin.0)
            }
        }
        return points_ids
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if view.isKindOfClass(MapClusterView) {
            let now_rect = mapView.visibleMapRect
            let new_rect_width = now_rect.size.width / MAP_CLUSTER_PRESSED_SCALE_FACTOR
            let new_rect_height = now_rect.size.height / MAP_CLUSTER_PRESSED_SCALE_FACTOR
            var cluster_coords:CLLocationCoordinate2D!
            for selected in mapView.selectedAnnotations {
                if selected.isKindOfClass(MapClusterAnnotation) {
                    cluster_coords = selected.coordinate
                    mapView.deselectAnnotation(selected, animated: false)
                    break
                }
            }
            let new_rect_center = MKMapPointForCoordinate(cluster_coords)
            let new_map_rect = MKMapRectMake(new_rect_center.x - 0.5 * new_rect_width, new_rect_center.y - new_rect_height * 0.5, new_rect_width, new_rect_height)
            mapView.setVisibleMapRect(new_map_rect, animated: true)
        }
        else {
            if MAP_PIN_MARGIN_SIDES == 0 {
                let tail_width = CALLOUT_TAIL_HEIGHT / CALLOUT_TAIL_ASPECT
                let map_pin_width = MAP_PIN_POINT_WIDTH_RELATIVE * view.bounds.width
                MAP_PIN_MARGIN_SIDES = CALLOUT_MARGIN_SIDES + 0.5 * tail_width - 0.5 * map_pin_width
            }
            var map_pin_screen_point_bottom = mapView.convertCoordinate(view.annotation!.coordinate, toPointToView: self.view)
            var map_pin_view_frame = CGRectMake(map_pin_screen_point_bottom.x - 0.5 * view.frame.width, map_pin_screen_point_bottom.y - view.frame.height, view.frame.width, view.frame.height)
            var mkTranslationX:Double = 0
            var mkTranslationY:Double = 0
            var should_move_map = false
            var new_visible_rect:MKMapRect!
            if map_pin_view_frame.maxX > self.view.bounds.width - MAP_PIN_MARGIN_SIDES {
                let mkPointRightCurrent = MKMapPointForCoordinate(mapView.convertPoint(CGPointMake(map_pin_view_frame.maxX, map_pin_view_frame.maxY), toCoordinateFromView: self.view))
                let mkPointRightRequired = MKMapPointForCoordinate(mapView.convertPoint(CGPointMake(self.view.bounds.width - MAP_PIN_MARGIN_SIDES, map_pin_view_frame.maxY), toCoordinateFromView: self.view))
                mkTranslationX = mkPointRightCurrent.x - mkPointRightRequired.x
                map_pin_screen_point_bottom.x = self.view.bounds.width - MAP_PIN_MARGIN_SIDES - 0.5 * map_pin_view_frame.width
                map_pin_view_frame = CGRectMake(self.view.bounds.width - MAP_PIN_MARGIN_SIDES - map_pin_view_frame.width, map_pin_view_frame.minY, map_pin_view_frame.width, map_pin_view_frame.height)
                should_move_map = true
            }
            else if map_pin_view_frame.minX < MAP_PIN_MARGIN_SIDES {
                let mkPointLeftCurrent = MKMapPointForCoordinate(mapView.convertPoint(CGPointMake(map_pin_view_frame.minX, map_pin_view_frame.maxY), toCoordinateFromView: self.view))
                let mkPointLeftRequired = MKMapPointForCoordinate(mapView.convertPoint(CGPointMake(MAP_PIN_MARGIN_SIDES, map_pin_view_frame.maxY), toCoordinateFromView: self.view))
                mkTranslationX = mkPointLeftCurrent.x - mkPointLeftRequired.x
                map_pin_screen_point_bottom.x = MAP_PIN_MARGIN_SIDES + 0.5 * map_pin_view_frame.width
                map_pin_view_frame = CGRect(x: MAP_PIN_MARGIN_SIDES, y: map_pin_view_frame.minY, width: map_pin_view_frame.width, height: map_pin_view_frame.height)
                should_move_map = true
            }
            let callout_whole_height = (view as! MapPinView).calloutTotalView.bounds.height + CALLOUT_MARGIN_TOP + CALLOUT_MARGIN_BOTTOM
            let callout_whole_width = (view as! MapPinView).calloutTotalView.bounds.width
            if self.view.bounds.height * (1.0 - BACK_BUTTON_HEIGHT_RELATIVE) - map_pin_screen_point_bottom.y < callout_whole_height {
                //need some map movement to the bottom
                let callout_most_bottom_point = CGPointMake(map_pin_screen_point_bottom.x, map_pin_screen_point_bottom.y + callout_whole_height)
                let mk_point_bottom = MKMapPointForCoordinate(mapView.convertPoint(callout_most_bottom_point, toCoordinateFromView: self.view))
                let visible_map_bottom_point = MKMapPointForCoordinate(mapView.convertPoint(CGPointMake(0.5 * view.bounds.width, view.bounds.height * (1.0 - BACK_BUTTON_HEIGHT_RELATIVE)), toCoordinateFromView: self.view))
                mkTranslationY = mk_point_bottom.y - visible_map_bottom_point.y
                should_move_map = true
            }
            if should_move_map {
                let current_visible_rect = mapView.visibleMapRect
                new_visible_rect = MKMapRectMake(MKMapRectGetMinX(current_visible_rect) + mkTranslationX, MKMapRectGetMinY(current_visible_rect) + mkTranslationY, current_visible_rect.size.width, current_visible_rect.size.height)
            }
            var callout_view_x:CGFloat!
            let callout_view_top_y = view.bounds.height + CALLOUT_MARGIN_TOP + CALLOUT_TAIL_HEIGHT
            let callout_possible_left_x = map_pin_screen_point_bottom.x - 0.5 * callout_whole_width
            let callout_possible_right_x = map_pin_screen_point_bottom.x + 0.5 * callout_whole_width
            if callout_possible_left_x < CALLOUT_MARGIN_SIDES {
                callout_view_x = CALLOUT_MARGIN_SIDES
            }
            else if callout_possible_right_x > (self.view.bounds.width - CALLOUT_MARGIN_SIDES) {
                callout_view_x = self.view.bounds.width - CALLOUT_MARGIN_SIDES - callout_whole_width
            }
            else {
                callout_view_x = callout_possible_left_x
            }
            let callout_total_view_center_x = callout_view_x - map_pin_view_frame.minX + callout_whole_width * 0.5
            let tail_x_callout_whole_center = map_pin_screen_point_bottom.x - callout_view_x // relative to callout
            if should_move_map {
                mapView.setVisibleMapRect(new_visible_rect, animated: true)
            }
            (view as! MapPinView).setCalloutPositions((calloutWholeCenterX:callout_total_view_center_x, calloutTailCenterX:tail_x_callout_whole_center))
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKindOfClass(MapPinAnnotation) {
            var pin_view = mapView.dequeueReusableAnnotationViewWithIdentifier("map_point_view") as? MapPinView
            if pin_view == nil {
                pin_view = MapPinView(annotation: annotation, reuseIdentifier: "map_point_view")
            }
            let pin_width = view.bounds.width * MAP_PIN_POINT_WIDTH_RELATIVE
            pin_view!.setFrameWith(CGRect(x: 0, y: 0, width: pin_width, height: pin_width * MAP_PIN_POINT_ASPECT))
            pin_view!.centerOffset = CGPointMake(0,-pin_width * 0.5)
            pin_view!.canShowCallout = false
            let cardId = (annotation as! MapPinAnnotation).cardId
            let time_components = getTimeComponentsForDate(current_pins_data[cardId]!["date"] as! NSDate)
            let title_text = current_pins_data[cardId]!["title"] as! String
            pin_view!.setupCalloutViewWithTimeComponents(time_components, title: title_text, parentViewBounds:self.view.bounds, cardId:cardId)
            pin_view!.setCalloutPressedHandlerWith(mapCalloutPressedWithCardId)
            return pin_view
        }
        else {
            let fraction = (annotation as! MapClusterAnnotation).getFraction()
            let count = (annotation as! MapClusterAnnotation).count
            var cluster_view = mapView.dequeueReusableAnnotationViewWithIdentifier("map_cluster_view") as? MapClusterView
            if cluster_view == nil {
                cluster_view = MapClusterView(annotation: annotation, reuseIdentifier: "map_cluster_view")
            }
            let cluster_width = (fraction * (MAP_CLUSTER_MAX_WIDTH_RELATIVE - MAP_CLUSTER_MIN_WIDTH_RELATIVE) + MAP_CLUSTER_MIN_WIDTH_RELATIVE) * view.bounds.width
            cluster_view!.setFrameWith(CGRect(x: 0, y: 0, width: cluster_width, height: cluster_width))
            cluster_view!.setNeedsDisplay()
            cluster_view!.setCountLabelWithCount(count)
            return cluster_view
        }
    }
    
    func getTimeComponentsForDate(date:NSDate) -> (periodValue:Int,periodName:String) {
        print("calculating passed from date \(date)")
        var passed:Double = Double(NSDate().timeIntervalSinceDate(date))
        var name:String = ""
        if passed < 60.0 {
            name = "sec"
        }
        else {
            passed = round(passed / 60.0)
            if passed < 60.0 {
                name = Int(passed) == 1 ? "min" : "mins"
            }
            else {
                passed = round(passed / 60.0)
                if passed < 24.0 {
                    name = Int(passed) == 1 ? "hour" : "hrs"
                }
                else {
                    passed = round(passed / 24.0)
                    if passed < 30.0 {
                        name = Int(passed) == 1 ? "day" : "days"
                    }
                    else {
                        passed = round(passed / 30.0)
                        if passed < 12.0 {
                            name = Int(passed) == 1 ? "mnth" : "mths"
                        }
                        else {
                            passed = round(passed / 12.0)
                            name = Int(passed) == 1 ? "year" : "yrs"
                        }
                    }
                }
            }
        }
        return (periodValue:Int(passed),periodName:name)
    }
    
    func removeMap() {
        General.map_main_span = General.map.regionThatFits(General.map.region)
        if !firstShown {
            General.map_pin_span = General.map_main_span
            firstShown = true
        }
        General.map.removeAnnotations(General.map.annotations)
        pins_shown_ids = []
        clusters_annotations = []
        //pins_annotations = [Int:MapPinAnnotation]()
        General.map.delegate = nil
        General.map.removeFromSuperview()
    }
    
    func hideActionButtonsAnimated(anim:Bool) {
        let bottom_shift = BACK_BUTTON_HEIGHT_RELATIVE * view.bounds.height + BUTTONS_VERTICAL_SPACING + SELECTION_BUTTON_WIDTH_RELATIVE * view.bounds.width
        back_button_bottom_cons.constant = -bottom_shift
        if anim {
            UIView.animateWithDuration(BUTTONS_APPEARANCE_ANIMATION_DURATION, animations: {
                self.view.layoutIfNeeded()
            })
        }
        else {
            view.layoutIfNeeded()
        }
    }
    
    func showActionButtonsAnimated(anim:Bool) {
        back_button_bottom_cons.constant = 0
        if anim {
            UIView.animateWithDuration(BUTTONS_APPEARANCE_ANIMATION_DURATION, animations: {
                self.view.layoutIfNeeded()
            })
        }
        else {
            view.layoutIfNeeded()
        }
    }
    
    func removeDrawing() {
        back_button_bottom_cons.constant = 0
        UIView.animateWithDuration(ANIMATION_DRAWING_PREPARATION_DURATION, animations: {
            self.view.layoutIfNeeded()
            self.overlay_view.alpha = 0
            self.hint_label.alpha = 0.0
            self.hint_bg_view.alpha = 0.0
            }, completion: {
                (fin:Bool) in
                self.hint_label.hidden = true
                self.hint_bg_view.hidden = true
                self.overlay_view.hidden = true
                self.overlay_view.layer.mask = nil
                self.selection_layer.opacity = 0.0
                self.selection_layer.hidden = true
                self.selection_layer.removeAllAnimations()
                self.selection_is_editing = false
                self.selection_is_established = false
                General.map.userInteractionEnabled = true
        })
        if !selection_layer.hidden {
            let selection_anim = CABasicAnimation(keyPath: "opacity")
            selection_anim.fromValue = Float(OVERLAY_OPACITY)
            selection_anim.toValue = 0.0
            selection_anim.duration = ANIMATION_DRAWING_PREPARATION_DURATION
            selection_anim.fillMode = kCAFillModeForwards
            selection_anim.removedOnCompletion = false
            selection_layer.addAnimation(selection_anim, forKey: "opacity")
        }
    }
    
    func prepareDrawing() {
        print(view.bounds)
        let bottom_shift_back_button = BACK_BUTTON_HEIGHT_RELATIVE * view.bounds.height
        back_button_bottom_cons.constant = -bottom_shift_back_button
        overlay_view.hidden = false
        hint_bg_view.hidden = false
        hint_label.hidden = false
        UIView.animateWithDuration(ANIMATION_DRAWING_PREPARATION_DURATION, animations: {
            self.view.layoutIfNeeded()
            self.overlay_view.alpha = self.OVERLAY_OPACITY
            self.hint_bg_view.alpha = self.HINT_OPACITY
            self.hint_label.alpha = 1.0
            }, completion: {
                (fin:Bool) in
                self.selection_is_editing = true
                General.map.userInteractionEnabled = false
        })
    }
    
    func showSelectionShape() {
        let selection_path_shape = UIBezierPath(rect: overlay_view.bounds)
        let selection_path_points = UIBezierPath()
        selection_path_points.moveToPoint(drawing_points[0])
        for i in 1...drawing_points.count - 1 {
            selection_path_points.addLineToPoint(drawing_points[i])
        }
        selection_path_points.addLineToPoint(drawing_points[0])
        selection_path_points.closePath()
        selection_path_shape.appendPath(selection_path_points)
        selection_path_shape.usesEvenOddFillRule = true
        selection_path_shape.closePath()
        selection_path_shape.closePath()
        selection_layer.path = selection_path_shape.CGPath
        selection_layer.fillRule = kCAFillRuleEvenOdd
        selection_layer.opacity = Float(OVERLAY_OPACITY)
        selection_layer.hidden = false
        let selection_mask = CAShapeLayer()
        selection_mask.frame = overlay_view.bounds
        selection_mask.path = selection_path_points.CGPath
        selection_mask.lineWidth = OVERLAY_STROKE_WIDTH
        overlay_view.layer.mask = selection_mask
        back_button_bottom_cons.constant = 0
        UIView.animateWithDuration(ANIMATION_SELECTION_DISAPPEARING_DURATION, delay: ANIMATION_SELECTION_DISAPPEARING_DELAY, options: .CurveEaseInOut, animations: {
            self.overlay_view.alpha = 0.0
            self.view.layoutIfNeeded()
            }, completion: {
                (fin:Bool) in
                self.overlay_view.hidden = true
                self.overlay_view.drawing_mode = "FLUSH"
                self.overlay_view.setNeedsDisplay()
        })
        //now let's look which geo pins do lie inside our shape
        filtered_cards_ids = []
        //var pins_screen_points:[Int:CGPoint] = [Int:CGPoint]()
        for pinData in current_pins_data {
            let scr_p = General.map.convertCoordinate((pinData.1["coords"] as! NSValue).MKCoordinateValue, toPointToView: self.overlay_view)
            if selection_path_points.containsPoint(scr_p) {
                filtered_cards_ids.append(pinData.0)
            }
        }
        print("filtered ids")
        print(filtered_cards_ids)
    }
    
    func mapCalloutPressedWithCardId(cardId:Int) {
        (parentViewController as! MainViewController).map_filter_present = selection_is_established
        (parentViewController as! MainViewController).hideMapViewWithScrollingToCardId(cardId)
    }
    
    @IBAction func backButtonPressed(sender:UIButton) {
        sender.backgroundColor = BUTTON_BG_COLOR_NORMAL
        (parentViewController as! MainViewController).map_filter_present = selection_is_established
        (parentViewController as! MainViewController).map_filtered_cards_ids = filtered_cards_ids
        (parentViewController as! MainViewController).hideMapViewWithScrollingToCardId(nil)
    }
    
    @IBAction func backButtonHighlighted(sender:UIButton) {
        sender.backgroundColor = BUTTON_BG_COLOR_HIGHLIGHTED
    }
    
    @IBAction func backButtonReleased(sender:UIButton) {
        sender.backgroundColor = BUTTON_BG_COLOR_NORMAL
    }
    
    @IBAction func selectionButtonPressed(sender:UIButton) {
        for selectedAnnotation in General.map.selectedAnnotations {
            General.map.deselectAnnotation(selectedAnnotation, animated: true)
        }
        if selection_is_established || selection_is_editing {
            sender.setBackgroundImage(UIImage(named: "selection_icon")!, forState: .Normal)
            removeDrawing()
        }
        else {
            sender.setBackgroundImage(UIImage(named: "selection_reset_icon")!, forState: .Normal)
            prepareDrawing()
        }
    }
    
    func hintLabelDisappears(sender:NSTimer) {
        hint_in_transition = true
        UIView.animateWithDuration(ANIMATION_HINT_DISAPPEARING_DURATION, animations: {
            self.hint_bg_view.alpha = 0.0
            self.hint_label.alpha = 0.0
            }, completion: {
                (fin:Bool) in
                self.hint_label.hidden = true
                self.hint_bg_view.hidden = true
                self.hint_in_transition = false
        })
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let p = touches.first!.locationInView(overlay_view)
        if selection_is_editing {
            if overlay_view.bounds.contains(p) {
                if !hint_bg_view.hidden && !hint_in_transition {
                    let _ = NSTimer.scheduledTimerWithTimeInterval(HINT_DISAPPEARS_DELAY, target: self, selector: "hintLabelDisappears:", userInfo: nil, repeats: false)
                }
                should_intercept_touches = true
                overlay_view.drawing_mode = "CONSTRUCTING"
                drawing_points = []
                drawing_points.append(p)
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let p = touches.first!.locationInView(overlay_view)
        if should_intercept_touches {
            if overlay_view.bounds.contains(p) {
                
                drawing_points.append(p)
                overlay_view.setPoints(drawing_points)
                overlay_view.setNeedsDisplay()
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let p = touches.first!.locationInView(overlay_view)
        if drawing_points.count > 1 && selection_is_editing {
            selection_is_editing = false
            selection_is_established = true
            should_intercept_touches = false
            overlay_view.drawing_mode = "CLOSING"
            overlay_view.setNeedsDisplay()
            showSelectionShape()
        }
        if drawing_points.count == 1 && selection_is_editing {
            drawing_points = []
        }
    }
    
}

class OverlayView:UIView {
    
    let OVERLAY_DRAWING_COLOR:UIColor = UIColor(red: 210/255, green: 206/255, blue: 238/255, alpha: 1.0)
    let OVERLAY_DRAWING_WIDTH:CGFloat = 4
    
    var points_all:[CGPoint] = []
    var drawing_mode:String = "CONSTRUCTING" // CLOSING, CONSTRUCTING, FLUSH
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        if drawing_mode == "FLUSH" {
            //CGContextClearRect(context, self.bounds)
        }
        else {
            CGContextSetStrokeColorWithColor(context, OVERLAY_DRAWING_COLOR.CGColor)
            CGContextSetLineWidth(context, drawing_mode == "CLOSING" ? OVERLAY_DRAWING_WIDTH * 2.0 : OVERLAY_DRAWING_WIDTH)
            CGContextSetLineJoin(context, CGLineJoin.Round)
            CGContextSetLineCap(context, CGLineCap.Round)
            if points_all.count > 1 {
                CGContextMoveToPoint(context, points_all[0].x, points_all[0].y)
                for(var i = 1;i < points_all.count;i++) {
                    CGContextAddLineToPoint(context, points_all[i].x, points_all[i].y)
                    CGContextMoveToPoint(context, points_all[i].x, points_all[i].y)
                }
            }
            if drawing_mode == "CLOSING" {
                CGContextAddLineToPoint(context, points_all[0].x, points_all[0].y)
            }
            CGContextStrokePath(context)
        }
    }
    
    func setPoints(points:[CGPoint]) {
        points_all = points
    }
    
}
