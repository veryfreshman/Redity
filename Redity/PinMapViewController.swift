//
//  PinMapViewController.swift
//  Redity
//
//  Created by Vano on 16.07.16.
//  Copyright © 2016 Vanoproduction. All rights reserved.
//

import UIKit
import MapKit

class PinMapViewController: UIViewController, MKMapViewDelegate {
    
    let NAVIGATION_BAR_COLOR:UIColor = UIColor(red: 57/255, green: 24/255, blue: 152/255, alpha: 1.0)
    let NAVIGATION_BAR_TINT_COLOR:UIColor = UIColor(red: 216/255, green: 213/255, blue: 242/255, alpha: 1.0)
    let BUTTON_ENABLED_COLOR:UIColor = UIColor(red: 96/255, green: 90/255, blue: 210/255, alpha: 1.0)
    let BUTTON_DISABLED_COLOR:UIColor = UIColor(red: 159/255, green: 156/255, blue: 209/255, alpha: 1.0)
    let GUIDE_LINES_COLOR:UIColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
    let GUIDE_LINES_OPACITY:Float = 0.22
    let GUIDE_LINES_WIDTH:CGFloat = 2
    let MAP_POINT_UNSET_OPACITY:CGFloat = 0.7
    let MAP_POINT_WIDTH_RELATIVE:CGFloat = 0.082
    let MAP_POINT_PADDING:CGFloat = 29 // lines stop at that distance before hitting map pin at the center of the screen
    let MAP_POINT_ASPECT:CGFloat = 1.333
    let ANIMATION_MINOR_UPDATES_DURATION:CFTimeInterval = 0.35
    let MAP_REGION_BOUNDING_FACTOR:CGFloat = 1.24
    let MAP_CUSTOM_LOCATION_WIDTH_METERS:Double = 3600.0
    let WARN_FONT_SIZE:CGFloat = 14
    let WARN_BG_COLOR:UIColor = UIColor(red: 4/255, green: 11/255, blue: 34/255, alpha: 1.0)
    let WARN_TEXT_COLOR:UIColor = UIColor(red: 235/255, green: 235/255, blue: 244/255, alpha: 1.0)
    let WARN_LABEL_WIDTH_RELATIVE:CGFloat = 0.8 // to bounding bg rect
    let WARN_LABEL_HEIGHT_RELATIVE:CGFloat = 0.54
    let WARN_LABEL_MARGIN_TOP:CGFloat = 8
    let WARN_BOX_ALPHA:CGFloat = 0.57
    
    @IBOutlet var map_point_unset:UIImageView!
    @IBOutlet var button_clear:UIButton!
    @IBOutlet var button_set:UIButton!
    
    var nudged = false
    var point_outside = false
    var line_up:CAShapeLayer!, line_bottom:CAShapeLayer!, line_right:CAShapeLayer!, line_left:CAShapeLayer!
    var point_out_warn_bg:UIView!
    var point_out_warn_label:UILabel!
    var button_clear_enabled = false
    var button_set_enabled = true
    var navBar:UINavigationBar!
    var pin_set = false
    var pin_coords:CLLocationCoordinate2D!
    var prev_selected_area_id:Int = -1
    var selected_area_id = -1
    var send_result_back = false
    var prev_coords:CLLocationCoordinate2D? = nil
    var parentAddController:AddPostViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navBar = self.navigationController!.navigationBar
        navBar.barTintColor = NAVIGATION_BAR_COLOR
        navBar.tintColor = NAVIGATION_BAR_TINT_COLOR
        navBar.barStyle = UIBarStyle.Black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ok_icon")!, style: .Plain, target: self, action: "closePinMapPressed:")
        point_out_warn_label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))
        point_out_warn_label.font = UIFont(name: "SFUIText-Regular", size: WARN_FONT_SIZE)!
        point_out_warn_label.text = "This point is outside the area zone"
        point_out_warn_label.textColor = WARN_TEXT_COLOR
        point_out_warn_label.textAlignment = .Center
        let real_warn_size = point_out_warn_label.textRectForBounds(point_out_warn_label.bounds, limitedToNumberOfLines: 1)
        let box_size = CGSizeMake(real_warn_size.width / WARN_LABEL_WIDTH_RELATIVE, real_warn_size.height / WARN_LABEL_HEIGHT_RELATIVE)
        point_out_warn_label.frame = CGRect(x: 0, y: (1.0 - WARN_LABEL_HEIGHT_RELATIVE) * 0.5 * box_size.height + WARN_LABEL_MARGIN_TOP, width: view.bounds.width, height: real_warn_size.height)
        point_out_warn_bg = UIView(frame: CGRect(x: 0.5 * view.bounds.width - 0.5 * box_size.width, y: WARN_LABEL_MARGIN_TOP, width: box_size.width, height: box_size.height))
        point_out_warn_bg.backgroundColor = WARN_BG_COLOR
        point_out_warn_bg.alpha = 0.0
        point_out_warn_label.alpha = 0.0
        point_out_warn_bg.layer.cornerRadius = 10
        point_out_warn_bg.layer.zPosition = 9
        point_out_warn_label.layer.zPosition = 10
        view.addSubview(point_out_warn_bg)
        view.addSubview(point_out_warn_label)
        //now adding lines
        let line_left_fin = CGPointMake(view.center.x - 0.5 * MAP_POINT_WIDTH_RELATIVE * view.bounds.width - MAP_POINT_PADDING, view.center.y)
        let line_right_fin = CGPointMake(view.center.x + 0.5 * MAP_POINT_WIDTH_RELATIVE * view.bounds.width + MAP_POINT_PADDING, view.center.y)
        let line_up_fin = CGPointMake(view.center.x, view.center.y - 0.5 * MAP_POINT_WIDTH_RELATIVE * view.bounds.width * MAP_POINT_ASPECT - MAP_POINT_PADDING)
        let line_bottom_fin = CGPointMake(view.center.x, view.center.y + 0.5 * MAP_POINT_WIDTH_RELATIVE * view.bounds.width * MAP_POINT_ASPECT + MAP_POINT_PADDING)
        let line_left_path = UIBezierPath()
        line_left_path.moveToPoint(CGPoint(x: 0, y: view.center.y))
        line_left_path.addLineToPoint(line_left_fin)
        let line_right_path = UIBezierPath()
        line_right_path.moveToPoint(CGPoint(x: view.bounds.width, y: view.center.y))
        line_right_path.addLineToPoint(line_right_fin)
        let line_up_path = UIBezierPath()
        line_up_path.moveToPoint(CGPoint(x: view.center.x, y: 0))
        line_up_path.addLineToPoint(line_up_fin)
        let line_bottom_path = UIBezierPath()
        line_bottom_path.moveToPoint(CGPoint(x: view.center.x, y: view.bounds.height))
        line_bottom_path.addLineToPoint(line_bottom_fin)
        line_left = CAShapeLayer()
        line_left.path = line_left_path.CGPath
        line_left.strokeColor = GUIDE_LINES_COLOR.CGColor
        line_left.lineWidth = GUIDE_LINES_WIDTH
        line_left.opacity = GUIDE_LINES_OPACITY
        line_left.frame = view.bounds
        line_right = CAShapeLayer()
        line_right.path = line_right_path.CGPath
        line_right.strokeColor = GUIDE_LINES_COLOR.CGColor
        line_right.lineWidth = GUIDE_LINES_WIDTH
        line_right.opacity = GUIDE_LINES_OPACITY
        line_right.frame = view.bounds
        line_up = CAShapeLayer()
        line_up.path = line_up_path.CGPath
        line_up.strokeColor = GUIDE_LINES_COLOR.CGColor
        line_up.lineWidth = GUIDE_LINES_WIDTH
        line_up.opacity = GUIDE_LINES_OPACITY
        line_up.frame = view.bounds
        line_bottom = CAShapeLayer()
        line_bottom.path = line_bottom_path.CGPath
        line_bottom.strokeColor = GUIDE_LINES_COLOR.CGColor
        line_bottom.lineWidth = GUIDE_LINES_WIDTH
        line_bottom.opacity = GUIDE_LINES_OPACITY
        line_bottom.frame = view.bounds
        view.layer.addSublayer(line_up)
        view.layer.addSublayer(line_bottom)
        view.layer.addSublayer(line_right)
        view.layer.addSublayer(line_left)
        line_up.zPosition = 5
        line_right.zPosition = 6
        line_bottom.zPosition = 7
        line_left.zPosition = 8
        if General.map == nil {
            General.map = MKMapView()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        General.map.layer.zPosition = -6
        view.addSubview(General.map)
        General.map.frame = CGRect(x: 0, y: navBar.frame.maxY, width: view.bounds.width, height: view.bounds.height - navBar.frame.maxY)
        if !nudged {
            point_out_warn_label.center.y += navBar.frame.maxY
            point_out_warn_bg.center.y += navBar.frame.maxY
            nudged = true
        }
        button_set.layer.zPosition = 12
        button_clear.layer.zPosition = 11
        map_point_unset.layer.zPosition = 10
        view.bringSubviewToFront(button_clear)
        view.bringSubviewToFront(button_set)
        view.bringSubviewToFront(point_out_warn_label)
        view.bringSubviewToFront(point_out_warn_bg)
        General.map.delegate = self
        if pin_set {
            let annot = MKPointAnnotation()
            annot.coordinate = pin_coords
            General.map.addAnnotation(annot)
        }
        General.map.alpha = 1.0
        General.map.hidden = false
        General.map.userInteractionEnabled = true
        if selected_area_id != prev_selected_area_id || send_result_back{
            General.map.visibleMapRect = General.getUnionBoundingMapRectForAreaId(selected_area_id, withBoundingFactor: MAP_REGION_BOUNDING_FACTOR)
        }
        else {
            General.map.region = General.map_pin_span
        }
        point_out_warn_label.alpha = 0.0
        point_out_warn_bg.alpha = 0
        point_outside = false
        prev_selected_area_id = selected_area_id
    }
    
    override func viewDidDisappear(animated: Bool) {
        General.map_pin_span = General.map.regionThatFits(General.map.region)
        General.map.removeAnnotations(General.map.annotations)
        General.map.removeFromSuperview()
        General.map.delegate = nil
    }
    
    @IBAction func clearButtonPressed(sender:UIButton) {
        if button_clear_enabled {
            button_clear_enabled = false
            sender.backgroundColor = BUTTON_DISABLED_COLOR
            button_set_enabled = true
            button_set.backgroundColor = BUTTON_ENABLED_COLOR
            pin_set = false
            General.map.removeAnnotations(General.map.annotations)
            map_point_unset.hidden = false
            line_up.hidden = false
            line_bottom.hidden = false
            line_left.hidden = false
            line_right.hidden = false
            UIView.animateWithDuration(ANIMATION_MINOR_UPDATES_DURATION, animations: {
                self.map_point_unset.alpha = self.MAP_POINT_UNSET_OPACITY
                }, completion: {
                    (fin:Bool) in
                    self.line_up.opacity = self.GUIDE_LINES_OPACITY
                    self.line_right.opacity = self.GUIDE_LINES_OPACITY
                    self.line_left.opacity = self.GUIDE_LINES_OPACITY
                    self.line_bottom.opacity = self.GUIDE_LINES_OPACITY
                    self.line_bottom.removeAllAnimations()
                    self.line_left.removeAllAnimations()
                    self.line_right.removeAllAnimations()
                    self.line_up.removeAllAnimations()
                    
            })
            let lines_anim = CABasicAnimation(keyPath: "opacity")
            lines_anim.fromValue = 0.0
            lines_anim.toValue = GUIDE_LINES_OPACITY
            lines_anim.fillMode = kCAFillModeForwards
            lines_anim.removedOnCompletion = false
            line_up.addAnimation(lines_anim, forKey: "op")
            line_bottom.addAnimation(lines_anim, forKey: "op")
            line_left.addAnimation(lines_anim, forKey: "op")
            line_right.addAnimation(lines_anim, forKey: "op")
        }
    }
    
    @IBAction func setButtonPressed(sender:UIButton) {
        if button_set_enabled {
            button_set_enabled = false
            sender.backgroundColor = BUTTON_DISABLED_COLOR
            button_clear_enabled = true
            button_clear.backgroundColor = BUTTON_ENABLED_COLOR
            pin_set = true
            let annotation = MKPointAnnotation()
            pin_coords = General.map.convertPoint(CGPointMake(map_point_unset.center.x, map_point_unset.frame.maxY), toCoordinateFromView: view)
            annotation.coordinate = pin_coords
            General.map.addAnnotation(annotation)
            UIView.animateWithDuration(ANIMATION_MINOR_UPDATES_DURATION, animations: {
                self.map_point_unset.alpha = 0.0
                }, completion: {
                    (fin:Bool) in
                    self.map_point_unset.hidden = true
                    self.line_up.opacity = 0.0
                    self.line_up.hidden = true
                    self.line_right.opacity = 0.0
                    self.line_right.hidden = true
                    self.line_left.opacity = 0.0
                    self.line_left.hidden = true
                    self.line_bottom.hidden = true
                    self.line_bottom.opacity = 0.0
                    self.line_bottom.removeAllAnimations()
                    self.line_left.removeAllAnimations()
                    self.line_right.removeAllAnimations()
                    self.line_up.removeAllAnimations()
                
            })
            let lines_anim = CABasicAnimation(keyPath: "opacity")
            lines_anim.fromValue = GUIDE_LINES_OPACITY
            lines_anim.toValue = 0.0
            lines_anim.fillMode = kCAFillModeForwards
            lines_anim.removedOnCompletion = false
            line_up.addAnimation(lines_anim, forKey: "op")
            line_bottom.addAnimation(lines_anim, forKey: "op")
            line_left.addAnimation(lines_anim, forKey: "op")
            line_right.addAnimation(lines_anim, forKey: "op")
        }
    }
    
    func closePinMapPressed(sender:UIBarButtonItem) {
        var changes = false
        if let prev_pin_coords = prev_coords {
            if !pin_set {
                changes = true
            }
            else {
                if prev_pin_coords.latitude != pin_coords.latitude || prev_pin_coords.longitude != pin_coords.longitude {
                    changes = true
                }
            }
        }
        else {
            if pin_set {
                changes = true
            }
        }
        if pin_set {
            prev_coords = CLLocationCoordinate2D(latitude: pin_coords.latitude, longitude: pin_coords.longitude)
            if changes && send_result_back {
                parentAddController.startLoadingLocationMapSnapshot()
            }
        }
        dismissViewControllerAnimated(true, completion: {
            if self.send_result_back {
                self.parentAddController.locationPinningFinishedWithChanges(changes)
            }
        })
    }
    
    func setCustomPinLocationWithCoords(coords:CLLocationCoordinate2D) {
        clearButtonPressed(button_clear)
        let mapPointCenter = MKMapPointForCoordinate(coords)
        let map_rect_width = MKMapPointsPerMeterAtLatitude(coords.latitude) * MAP_CUSTOM_LOCATION_WIDTH_METERS
        let map_rect_height = map_rect_width * Double(General.map.bounds.height / General.map.bounds.width)
        let map_rect = MKMapRectMake(mapPointCenter.x - 0.5 * map_rect_width, mapPointCenter.y - 0.5 * map_rect_height, map_rect_width, map_rect_height)
        General.map.visibleMapRect = map_rect
        setButtonPressed(button_set)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        print("now here getting view")
        var annotation_view = mapView.dequeueReusableAnnotationViewWithIdentifier("map_point_view_pin") as? MapPinView
        if annotation_view == nil {
            annotation_view = MapPinView(annotation: annotation, reuseIdentifier: "map_point_view_pin")
            let map_point_width = view.bounds.width * MAP_POINT_WIDTH_RELATIVE
            annotation_view!.setFrameWith(CGRect(x: 0, y: 0, width: map_point_width, height: map_point_width * MAP_POINT_ASPECT))
            annotation_view!.centerOffset = CGPoint(x: 0, y: -0.5 * annotation_view!.frame.height)
        }
        return annotation_view
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if !pin_set && send_result_back {
            var show_box = false
            let now_coords = General.map.convertPoint(CGPointMake(map_point_unset.center.x, map_point_unset.frame.maxY), toCoordinateFromView: view)
            if !General.areaId(selected_area_id, containsCoords: now_coords) {
                show_box = true
                point_outside = true
            }
            else {
                point_outside = false
            }
            UIView.animateWithDuration(ANIMATION_MINOR_UPDATES_DURATION, animations: {
                self.point_out_warn_bg.alpha = show_box ? self.WARN_BOX_ALPHA : 0.0
                self.point_out_warn_label.alpha = show_box ? 1.0 : 0.0
            })
        }
        
    }
    
}
