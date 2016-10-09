//
//  General.swift
//  Redity
//
//  Created by Vano on 01.07.16.
//  Copyright © 2016 Vanoproduction. All rights reserved.
//

import UIKit
import CoreGraphics
import CoreLocation
import MapKit

class General {
    
    static let MAP_PLACEHOLDER_BG_COLOR:UIColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
    static let MAP_GRADIENT_OPAQUE_LOCATION:CGFloat = 0.55
    static let MAP_POINT_WIDTH_RELATIVE:CGFloat = 0.22 //to whole map's width
    static let MAP_POINT_WIDTH:CGFloat = 28
    static let MAP_POINT_ASPECT:CGFloat = 1.333
    static var map:MKMapView!
    static var map_main_span:MKCoordinateRegion!
    static var map_pin_span:MKCoordinateRegion!
    
    //some data for location, we want to make it accessible from any part of the app
    static var location_status = "IDLE" //DETERMINING, IDLE, OK, ERROR
    static var location_area_id:Int = -1
    static var location_coords:CLLocationCoordinate2D!
    static var all_areas_info:[Int:NSMutableDictionary] = [Int:NSMutableDictionary]()
    static var areas_geo_info:[NSMutableDictionary] = []
    static var map_placeholder_gradient:UIImage!
    static var my_avatar_bg_color:UIColor!
    
    static var temp_card_no:Int = 14
    static var prev_area:Int = -1
    
    static func generateFeedDataFromJsonData(data:NSDictionary) -> (cells_add: [Int:NSMutableDictionary], error:String) {
        var result_cells_data:[Int: NSMutableDictionary] = [Int:NSMutableDictionary]()
        let cards = data["cards"] as! [NSDictionary]
        var error = ""
        let this_area_id = data["areaId"] as! Int
        if this_area_id != prev_area {
            prev_area = this_area_id
            temp_card_no = this_area_id == 1 ? 24 : 14
        }
        //temp testing methods
        if (temp_card_no <= 1 && this_area_id == 2) || (temp_card_no <= 14 && this_area_id == 1) {
            return (result_cells_data,"end")
        }
        for card in cards {
            let card_dict = NSMutableDictionary()
            //let cardId = card["cardId"] as! Int
            let cardId = temp_card_no--
            card_dict["title_text"] = card["title"] as! String
            let meeting_time_str = card["meeting_time"] as! NSString
            let meeting_time = NSTimeInterval(meeting_time_str.doubleValue)
            let meeting_date = NSDate(timeIntervalSince1970: meeting_time)
            let approx_value = card["meeting_approx"] as! String
            card_dict["date_text"] = General.getMeetingDateTextFromDate(meeting_date, withApproximation: approx_value)
            card_dict["person_1"] = card["person_1"] as! String
            card_dict["person_2"] = card["person_2"] as! String
            card_dict["description_text"] = card["body"] as! String
            let map_present = card["map"] as! Bool
            let transport_present = card["transport"] as! Bool
            card_dict["nick"] = card["nick"] as! String
            card_dict["map_present"] = map_present
            card_dict["transport_icon_present"] = transport_present
            var transport_id = -1
            var map_coords = CLLocationCoordinate2D(latitude: CLLocationDegrees(0), longitude: CLLocationDegrees(0))
            if transport_present {
                transport_id = card["transport_id"] as! Int
            }
            card_dict["transport_icon_type"] = transport_id
            if map_present {
                map_coords = CLLocationCoordinate2DMake(CLLocationDegrees(card["map_lat"] as! Double), CLLocationDegrees(card["map_long"] as! Double))
                card_dict["map_coords"] = NSValue(MKCoordinate: map_coords)
            }
            let images_amount = card["images_amount"] as! Int
            card_dict["images_count"] = images_amount
            card_dict["images_present"] = images_amount > 0
            var images_sizes_values:[NSValue] = []
            if images_amount > 0 {
                let images_sizes = card["images_sizes"] as! [NSDictionary]
                for image_size in images_sizes {
                    let image_size_value = NSValue(CGSize: CGSizeMake(CGFloat(image_size["w"] as! Int), CGFloat(image_size["h"] as! Int)))
                    images_sizes_values.append(image_size_value)
                }
            }
            card_dict["images_sizes"] = images_sizes_values
            card_dict["areaId"] = card["areaId"] as! Int
            let cal = NSCalendar.currentCalendar()
            let posting_time_str = card["posting_time"] as! NSString
            let posting_time_since = NSTimeInterval(posting_time_str.doubleValue)
            let posting_date = cal.startOfDayForDate(NSDate(timeIntervalSince1970: posting_time_since))
            card_dict["posting_date"] = posting_date
            result_cells_data[cardId] = card_dict
        }
        if let error_description = data["error"] as? String {
            error = error_description
        }
        return (result_cells_data,error)
    }
    
    static func generateGeoPinsListForJsonData(data:NSDictionary) -> [Int:NSDictionary] {
        let area_id = data["areaId"] as! Int
        let pins = data["pins"] as! [NSDictionary]
        var result_pins:[Int:NSDictionary] = [Int:NSDictionary]()
        for pin in pins {
            var pin_data = NSMutableDictionary()
            let date_time = (pin["meeting_time"] as! NSString).doubleValue
            pin_data["date"] = NSDate(timeIntervalSince1970: NSTimeInterval(date_time))
            pin_data["title"] = pin["title"] as! String
            let coords = CLLocationCoordinate2D(latitude: CLLocationDegrees(pin["lat"] as! Double), longitude: CLLocationDegrees(pin["long"] as! Double))
            pin_data["coords"] = NSValue(MKCoordinate: coords)
            result_pins[pin["cardId"] as! Int] = pin_data
        }
        return result_pins
    }
    
    static func getFontSizeToFitWidth(width:CGFloat,forString:String,withFontName:String) -> CGFloat{
        var result_font_size:CGFloat = 50
        while (forString as! NSString).sizeWithAttributes([NSFontAttributeName:UIFont(name: withFontName, size: result_font_size)!]).width > width {
            result_font_size -= 1.0
        }
        return result_font_size
    }
    
    static func precalculateMapPlaceholderWithSize(size:CGSize) {
        map_placeholder_gradient = getGradientMapImageForSize(size, originalImage: UIImage(named: "map_placeholder")!, isPlaceholder: true, withStyle: "feed")
    }
    
    static func populateAllAreasInfo() {
        let json_data = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("geo_json", ofType: "json")!)
        let res = (try? NSJSONSerialization.JSONObjectWithData(json_data!, options: [])) as! [NSDictionary]
        all_areas_info = [Int:NSMutableDictionary]()
        General.populateAllAreasInfoWithGeoJsonArray(res)
        let all_areas_ids = (General.all_areas_info as! NSMutableDictionary).allKeys as! [Int]
        for (var i = 0;i < all_areas_ids.count;i++) {
            let allParentAreasIds = getParentsForAreaId(all_areas_ids[i])
            all_areas_info[all_areas_ids[i]]!["parentsAreasIds"] = allParentAreasIds
            var childrenAreas:[Int] = []
            all_areas_info[all_areas_ids[i]]!["childrenAreasIds"] = childrenAreas
        }
        for (var i = 0; i < all_areas_ids.count;i++) {
            let parents = all_areas_info[all_areas_ids[i]]!["parentsAreasIds"] as! [Int]
            var indentLevel = 0
            for (var b = parents.count - 1;b >= 0; b--) {
                all_areas_info[parents[b]]!["indentLevel"] = indentLevel++
            }
            all_areas_info[all_areas_ids[i]]!["indentLevel"] = indentLevel
            for (var b = 0; b < parents.count;b++) {
                var childrenAreas = all_areas_info[parents[b]]!["childrenAreasIds"] as! [Int]
                childrenAreas.append(all_areas_ids[i])
                all_areas_info[parents[b]]!["childrenAreasIds"] = childrenAreas
            }
        }
        //maybe we should sort children areas by indentLevel??
    }
    
    static func populateGeoInfo() {
        let all_areas_ids = (all_areas_info as! NSDictionary).allKeys as! [Int]
        for area_id in all_areas_ids {
            let geo_dict = NSMutableDictionary()
            geo_dict["areaId"] = area_id
            geo_dict["indentLevel"] = all_areas_info[area_id]!["indentLevel"] as! Int
            var vertices:[[NSValue]] = [] // cgpoints
            var boundingRects:[NSValue] = [] //cgrects
            for zone in all_areas_info[area_id]!["coords"] as! [[Double]] {
                var zoneVertices:[NSValue] = []
                for (var i = 0;i < zone.count;i += 2) {
                    let mapPoint = MKMapPointForCoordinate(CLLocationCoordinate2D(latitude: CLLocationDegrees(zone[i + 1]), longitude: CLLocationDegrees(zone[i])))
                    let point_value = NSValue(CGPoint: CGPoint(x: mapPoint.x, y: mapPoint.y))
                    zoneVertices.append(point_value)
                }
                if zoneVertices.count != 0 {
                    var minX = zoneVertices[0].CGPointValue().x, maxX = zoneVertices[0].CGPointValue().x, minY = zoneVertices[0].CGPointValue().y, maxY = zoneVertices[0].CGPointValue().y
                    for vertex in zoneVertices {
                        if vertex.CGPointValue().x < minX {
                            minX = vertex.CGPointValue().x
                        }
                        if vertex.CGPointValue().y < minY {
                            minY = vertex.CGPointValue().y
                        }
                        if vertex.CGPointValue().x > maxX {
                            maxX = vertex.CGPointValue().x
                        }
                        if vertex.CGPointValue().y > maxY {
                            maxY = vertex.CGPointValue().y
                        }
                    }
                    let boundingRect = CGRectMake(minX, minY, maxX - minX, maxY - minY)
                    boundingRects.append(NSValue(CGRect: boundingRect))
                }
                vertices.append(zoneVertices)
            }
            geo_dict["vertices"] = vertices
            geo_dict["boundingRects"] = boundingRects
            areas_geo_info.append(geo_dict)
        }
    }
    
    static func getGeoInfoForAreaId(areaId:Int) -> NSDictionary {
        for geoInfo in areas_geo_info {
            if geoInfo["areaId"] as! Int == areaId {
                return geoInfo
            }
        }
        print("FATAL: area geo info was not found!")
        return all_areas_info
    }
    
    static func getParentsForAreaId(areaId:Int) -> [Int] {
        var parents:[Int] = []
        let parentAreaId = all_areas_info[areaId]!["childOfAreaId"] as! Int
        if parentAreaId != -1 {
            parents.append(parentAreaId)
            parents.appendContentsOf(getParentsForAreaId(parentAreaId))
        }
        return parents
    }
    
    static func areaId(areaId:Int, hasChildAreaId:Int) -> Bool {
        let children = all_areas_info[areaId]!["childrenAreasIds"] as! [Int]
        var found = false
        for child in children {
            if child == hasChildAreaId {
                found = true
                break
            }
        }
        return found
    }
    
    static func areaId(areaId:Int, hasParentAreaId:Int) -> Bool {
        let parents = all_areas_info[areaId]!["parentsAreasIds"] as! [Int]
        return parents.contains(hasParentAreaId)
    }
    
    static func populateAllAreasInfoWithGeoJsonArray(data:[NSDictionary]) {
        for (var i = 0;i < data.count;i++) {
            let areaId = data[i]["areaId"] as! Int
            let dict = NSMutableDictionary()
            dict["title"] = data[i]["title"] as! String
            let parentAreaId = data[i]["childOfAreaId"] as! Int
            dict["childOfAreaId"] = parentAreaId
            dict["type"] = data[i]["type"] as! String
            dict["coords"] = data[i]["coords"] as! [[Double]]
            all_areas_info[areaId] = dict
        }
    }
    
    static func getUnionBoundingMapRectForAreaId(areaId:Int, withBoundingFactor:CGFloat) -> MKMapRect {
        let geoInfo = General.getGeoInfoForAreaId(areaId)
        let boundingRectsValues = geoInfo["boundingRects"] as! [NSValue]
        var bounding_rects:[CGRect] = []
        for boundingValue in boundingRectsValues {
            bounding_rects.append(boundingValue.CGRectValue())
        }
        var minX:CGFloat = bounding_rects[0].minX, maxX:CGFloat = bounding_rects[0].maxX, minY:CGFloat = bounding_rects[0].minY, maxY:CGFloat = bounding_rects[0].maxY
        for boundingRect in bounding_rects {
            if boundingRect.minX < minX {
                minX = boundingRect.minX
            }
            if boundingRect.maxX > maxX {
                maxX = boundingRect.maxX
            }
            if boundingRect.minY < minY {
                minY = boundingRect.minY
            }
            if boundingRect.maxY > maxY {
                maxY = boundingRect.maxY
            }
        }
        let visible_map_rect = General.map.visibleMapRect
        let visible_rect_aspect = visible_map_rect.size.height / visible_map_rect.size.width
        let union_width = maxX - minX
        let union_height = maxY - minY
        let total_width = union_width * withBoundingFactor
        let total_height = max(union_height * withBoundingFactor,CGFloat(visible_rect_aspect) * total_width)
        let new_rect = MKMapRectMake(Double(minX - (total_width - union_width) * 0.5), Double(minY - (total_height - union_height) * 0.5), Double(total_width), Double(total_height))
        return new_rect
    }
    
    //we need working implementation
    static func getAreasIdsForCoords(coords:CLLocationCoordinate2D) -> [Int] {
        //print(areas_geo_info)
        let mapPoint = MKMapPointForCoordinate(coords)
        let point = CGPoint(x: mapPoint.x, y: mapPoint.y)
        var areas:[Int] = []
        for geoInfo in areas_geo_info {
            let area_id = geoInfo["areaId"] as! Int
            /*
            let boundingRectsValues = geoInfo["boundingRects"] as! [NSValue]
            let verticesValues = geoInfo["vertices"] as! [[NSValue]]
            var boundingRects:[CGRect] = []
            var vertices:[[CGPoint]] = []
            for rectValue in boundingRectsValues {
                boundingRects.append(rectValue.CGRectValue())
            }
            for zone in verticesValues {
                var verticesZone:[CGPoint] = []
                for verticeValue in zone {
                    verticesZone.append(verticeValue.CGPointValue())
                }
                vertices.append(verticesZone)
            }
            for (var ir = 0; ir < boundingRects.count;ir++) {
                //print("checking point \(point) in rect \(boundingRects[ir])")
                if CGRectContainsPoint(boundingRects[ir], point) {
                   // print("bouding rect contains")
                    var inside = false
                    for (var i = 0, j = vertices[ir].count - 1; i < vertices[ir].count; j = i++) {
                        let t1 = (vertices[ir][i].y > point.y) != (vertices[ir][j].y > point.y)
                        let comp_r = (vertices[ir][j].x - vertices[ir][i].x) * (point.y - vertices[ir][i].y) / (vertices[ir][j].y - vertices[ir][i].y) + vertices[ir][i].x
                        let t2 = point.x < comp_r
                        if t1 && t2 {
                            inside = !inside
                        }
                    }
                    if inside {
                        areas.append(geoInfo["areaId"] as! Int)
                        break
                    }
                }
            }
*/
            if General.areaId(area_id, containsCoords: coords) {
                areas.append(area_id)
            }
        }
        //print("location areas")
        //print(areas)
        return areas
    }
    
    static func areaId(areaId:Int, containsCoords:CLLocationCoordinate2D) -> Bool {
        let geoInfo = General.getGeoInfoForAreaId(areaId)
        var res = false
        let mapPoint = MKMapPointForCoordinate(containsCoords)
        let point = CGPoint(x: mapPoint.x, y: mapPoint.y)
        let boundingRectsValues = geoInfo["boundingRects"] as! [NSValue]
        let verticesValues = geoInfo["vertices"] as! [[NSValue]]
        var boundingRects:[CGRect] = []
        var vertices:[[CGPoint]] = []
        for rectValue in boundingRectsValues {
            boundingRects.append(rectValue.CGRectValue())
        }
        for zone in verticesValues {
            var verticesZone:[CGPoint] = []
            for verticeValue in zone {
                verticesZone.append(verticeValue.CGPointValue())
            }
            vertices.append(verticesZone)
        }
        for (var ir = 0; ir < boundingRects.count;ir++) {
            //print("checking point \(point) in rect \(boundingRects[ir])")
            if CGRectContainsPoint(boundingRects[ir], point) {
                // print("bouding rect contains")
                var inside = false
                for (var i = 0, j = vertices[ir].count - 1; i < vertices[ir].count; j = i++) {
                    let t1 = (vertices[ir][i].y > point.y) != (vertices[ir][j].y > point.y)
                    let comp_r = (vertices[ir][j].x - vertices[ir][i].x) * (point.y - vertices[ir][i].y) / (vertices[ir][j].y - vertices[ir][i].y) + vertices[ir][i].x
                    let t2 = point.x < comp_r
                    if t1 && t2 {
                        inside = !inside
                    }
                }
                if inside {
                    res = true
                    break
                }
            }
        }
        return res
    }
    
    //this func is used with near pin / near me buttons
    //we just look for deepest area at that location and all locations near it(with the same max possible indentlevel)
    //as a result of having an indentation system in the table, the parent are also included automatically
    static func getNearbyAreasForCoords(coords:CLLocationCoordinate2D) -> [Int] {
        let coords_map_point = MKMapPointForCoordinate(coords)
        let coords_point = CGPoint(x: coords_map_point.x, y: coords_map_point.y)
        var nearby_areas_ids:[Int] = []
        var areas_ids = getAreasIdsForCoords(coords)
        nearby_areas_ids.appendContentsOf(areas_ids)
        let deepest_area_id = getDeepestAreaIdAmongAreas(areas_ids)
        if deepest_area_id >= 0 {
            var currentBounding = CGRectZero
            for geoInfo in areas_geo_info {
                if geoInfo["areaId"] as! Int == deepest_area_id {
                    for rectValue in geoInfo["boundingRects"] as! [NSValue] {
                        let rect = rectValue.CGRectValue()
                        if rect.contains(coords_point) {
                            currentBounding = rect
                            break
                        }
                    }
                    break
                }
            }
            for geoInfo in areas_geo_info {
                let boundingRectsValues = geoInfo["boundingRects"] as! [NSValue]
                for rectValue in boundingRectsValues {
                    let rect = rectValue.CGRectValue()
                    if CGRectIntersectsRect(rect, currentBounding) {
                        nearby_areas_ids.append(geoInfo["areaId"] as! Int)
                        break
                    }
                }
            }
            if areas_ids.count != 0 {
                areas_ids = fillAreasWithParents(areas_ids)
            }
        }
        return areas_ids
    }
    
    //this func is used for finding areas near currently selected area. it 's used in filter
    //we simply look for areas near current area, which have the same indentLevel(maybe also include the parent?)
    static func getNearbyAreasForAreaId(areaId:Int) -> [Int] {
        var nearby_areas_ids:[Int] = []
        var boundingRects:[CGRect] = []
        var thisIndentLevel = -1
        for geoInfo in areas_geo_info {
            if geoInfo["areaId"] as! Int == areaId {
                for rectValue in geoInfo["boundingRects"] as! [NSValue] {
                    boundingRects.append(rectValue.CGRectValue())
                }
                thisIndentLevel = geoInfo["indentLevel"] as! Int
                break
            }
        }
        geoSearch: for geoInfo in areas_geo_info {
            if geoInfo["indentLevel"] as! Int == thisIndentLevel {
                if geoInfo["areaId"] as! Int == areaId {
                    continue
                }
                for checkRectValue in geoInfo["boundingRects"] as! [NSValue] {
                    let checkRect = checkRectValue.CGRectValue()
                    for currentRect in boundingRects {
                        if CGRectIntersectsRect(currentRect, checkRect) {
                            nearby_areas_ids.append(geoInfo["areaId"] as! Int)
                            continue geoSearch
                        }
                    }
                }
            }
        }
        //nearby_areas_ids = fillAreasWithParents(nearby_areas_ids)
        return nearby_areas_ids
    }
    
    static func getDeepestAreaIdAmongAreas(areas:[Int]) -> Int {
        var deepest_area_id = -69, maxIndent = -1
        for area in areas {
            let thisIndent = all_areas_info[area]!["indentLevel"] as! Int
            if thisIndent > maxIndent {
                maxIndent = thisIndent
                deepest_area_id = area
            }
        }
        return deepest_area_id
    }
    
    static func populateCellsDataWithJson() {
        let cells_info_json = NSBundle.mainBundle().pathForResource("cells_json", ofType: "json")!
        let res = (try? NSJSONSerialization.JSONObjectWithData(NSData(contentsOfFile: cells_info_json)!, options: [])) as! NSDictionary
        let cells_data = res["cells_data"] as! [NSDictionary]
        
    }
    
    static func fillAreasWithParents(areasIds:[Int]) -> [Int] {
        var resultAreasIds:[Int] = []
        resultAreasIds.appendContentsOf(areasIds)
        var parentsAppend:[Int] = []
        for areaId in areasIds {
            let parentsIds = all_areas_info[areaId]!["parentsAreasIds"] as! [Int]
            adding: for parentId in parentsIds {
                for checkParent in parentsAppend {
                    if checkParent == parentId {
                        continue adding
                    }
                }
                parentsAppend.append(parentId)
            }
        }
        resultAreasIds.appendContentsOf(parentsAppend)
        return resultAreasIds
    }
    
    static func getMeetingDateTextFromDate(date:NSDate,withApproximation:String) -> String {
        var date_text_str = ""
        let date_formatter = NSDateFormatter()
        date_formatter.dateStyle = .LongStyle
        date_formatter.timeStyle = .NoStyle
        date_formatter.locale = NSLocale(localeIdentifier: "en_US")
        if withApproximation == "none" {
            date_text_str = date_formatter.stringFromDate(date)
        }
        else if withApproximation == "month" {
            let year = NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: date)
            date_text_str = "Year of \(year)" //localization required
        }
        else {
            let month_title = date_formatter.monthSymbols[NSCalendar.currentCalendar().component(NSCalendarUnit.Month, fromDate: date) - 1]
            let year = NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: date)
            date_text_str = "\(month_title), \(year)"
        }
        return date_text_str
    }
    
    static func getGradientMapImageForSize(size:CGSize,originalImage:UIImage,isPlaceholder:Bool, withStyle:String) -> UIImage {
        let originalCGImage = originalImage.CGImage!
        let final_aspect = size.height / size.width
        let origin_aspect = originalImage.size.height / originalImage.size.width
        var final_width = size.width
        var final_height = size.height
        if isPlaceholder {
            if final_aspect < origin_aspect {
                final_width = final_height / origin_aspect
            }
            else {
                final_height = final_width * origin_aspect
            }
        }
        /*
        let gray_cs = CGColorSpaceCreateDeviceGray()
        let mask_context = CGBitmapContextCreate(nil, Int(size.width), Int(size.height), CGImageGetBitsPerComponent(originalCGImage), CGImageGetBytesPerRow(originalCGImage), gray_cs, CGImageAlphaInfo.None.rawValue)
        let grad = CGGradientCreateWithColors(gray_cs, [UIColor(white: 0.0, alpha: 0.0).CGColor,UIColor(white: 0.0, alpha: 1.0).CGColor], [0.0,1.0])
        CGContextDrawLinearGradient(mask_context, grad, CGPointMake(0, 0), CGPointMake(MAP_GRADIENT_OPAQUE_LOCATION * size.width, 0), [])
        let mask_image = CGBitmapContextCreateImage(mask_context)
*/
        let img_context = CGBitmapContextCreate(nil, Int(size.width), Int(size.height), CGImageGetBitsPerComponent(originalCGImage), CGImageGetBytesPerRow(originalCGImage), CGImageGetColorSpace(originalCGImage), CGImageGetBitmapInfo(originalCGImage).rawValue)
        if isPlaceholder {
            CGContextSetFillColorWithColor(img_context, MAP_PLACEHOLDER_BG_COLOR.CGColor)
            CGContextFillRect(img_context, CGRectIntegral(CGRect(x: 0, y: 0, width: size.width, height: size.height)))
        }
        CGContextDrawImage(img_context, CGRectIntegral(CGRect(x: (size.width - final_width) * 0.5, y: (size.height - final_height) * 0.5, width: final_width, height: final_height)), originalCGImage)
        if !isPlaceholder {
            let pin_image = UIImage(named: "map_point_set")!.CGImage!
            //let pin_image_size = CGSizeMake(MAP_POINT_WIDTH_RELATIVE * size.width, MAP_POINT_WIDTH_RELATIVE * size.width * MAP_POINT_ASPECT)
            let pin_image_size = CGSizeMake(MAP_POINT_WIDTH, MAP_POINT_WIDTH * MAP_POINT_ASPECT)
            print(pin_image_size)
            CGContextDrawImage(img_context, CGRectIntegral(CGRect(x: 0.5 * size.width - 0.5 * pin_image_size.width, y: 0.5 * size.height, width: pin_image_size.width, height: pin_image_size.height)), pin_image)
        }
        if withStyle == "feed" || withStyle == "feed_sep" {
            let grad_img = CGGradientCreateWithColors(CGImageGetColorSpace(originalCGImage), [UIColor(white: 1.0, alpha: 1.0).CGColor,UIColor(white: 1.0, alpha: 0.0).CGColor], [0.0,1.0])
            CGContextDrawLinearGradient(img_context, grad_img, CGPointMake(0, 0), CGPointMake(MAP_GRADIENT_OPAQUE_LOCATION * size.width, 0), [])
        }
        //return UIImage(CGImage: CGImageCreateWithMask(CGBitmapContextCreateImage(img_context), mask_image)!)
        return UIImage(CGImage: CGBitmapContextCreateImage(img_context)!)
    }
    
    static func apprFontSize(str:String?, str_attr:NSAttributedString?, fontName:String, ref_value:CGFloat, type:String, attributed:Bool) -> CGFloat {
        var final_size:CGFloat = 0
        for(var s:CGFloat = 50;s>=0;s-=1) {
            let font = UIFont(name: fontName, size: s)!
            var this_size:CGSize = CGSizeMake(0, 0)
            if attributed {
                this_size = str_attr!.size()
            }
            else {
                this_size = str!.sizeWithAttributes([NSFontAttributeName:font])
            }
            if type == "w" {
                if this_size.width <= ref_value {
                    final_size = s
                    break
                }
            }
            else {
                if this_size.height <= ref_value {
                    final_size = s
                    break
                }
            }
        }
        return final_size
    }
    
}

