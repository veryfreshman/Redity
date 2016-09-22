//
//  AppDelegate.swift
//  Redity
//
//  Created by Admin on 13.06.16.
//  Copyright © 2016 Vanoproduction. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let CHAT_AVATAR_BG_SAT:CGFloat = 0.06
    let CHAT_AVATAR_BG_BR:CGFloat = 0.94
    let CACHE_IMAGES_MAX_SIZE:UInt64 = 50 * 1024 * 1024

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //should create imgs and map folders in cache if they are not present
        let file_manager = NSFileManager.defaultManager()
        let cache_dir = try? file_manager.URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let documents_dir = try? file_manager.URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false)
        if let dir = cache_dir {
            let imgs_dir = dir.URLByAppendingPathComponent("imgs")
            let maps_dir = dir.URLByAppendingPathComponent("maps")
            if !file_manager.fileExistsAtPath(imgs_dir.absoluteString) {
                try? file_manager.createDirectoryAtURL(imgs_dir, withIntermediateDirectories: true, attributes: nil)
            }
            try? file_manager.createDirectoryAtURL(maps_dir, withIntermediateDirectories: true, attributes: nil)
        }
        if let doc_dir = documents_dir {
            let saved_url = doc_dir.URLByAppendingPathComponent("saved_posts.plist")
            let saved_archive_url = doc_dir.URLByAppendingPathComponent("saved_posts_archive.arch")
            let saved_path = saved_url.path!
            let chats_path = doc_dir.URLByAppendingPathComponent("chats.arch").path!
            let saved_dict = NSMutableDictionary()
            if !file_manager.fileExistsAtPath(saved_path) {
                let ok = saved_dict.writeToFile(saved_url.path!, atomically: true)
                print("saved \(ok)")
                
            }
            if !file_manager.fileExistsAtPath(saved_archive_url.path!) {
                let archive = NSKeyedArchiver.archivedDataWithRootObject(saved_dict)
                let ok_arch = archive.writeToFile(saved_archive_url.path!, atomically: false)
                print("saved archive \(ok_arch)")
            }
           // if !file_manager.fileExistsAtPath(chats_path) {
            let chats_archive = NSMutableArray()
            let ch_ex_1 = NSMutableDictionary()
            ch_ex_1["adding_date"] = NSDate(timeInterval: -21000, sinceDate: NSDate()) //only use it when messages are yet to be sent
            ch_ex_1["nick"] = "MK"
            ch_ex_1["cardId"] = 19
            ch_ex_1["cardTitle"] = "Some ex1 text on El CAmino"
            ch_ex_1["unread"] = false
            var messages:[NSDictionary] = []
            messages.append(NSDictionary(dictionary: ["text":"Hello!","nick":"000","date":NSDate(timeInterval: -17000, sinceDate: NSDate())]))
            ch_ex_1["messages"] = messages
            let ch_ex_2 = NSMutableDictionary()
            ch_ex_2["adding_date"] = NSDate(timeInterval: -22000, sinceDate: NSDate())
            ch_ex_2["nick"] = "KK"
            ch_ex_2["cardId"] = 11
            ch_ex_2["cardTitle"] = "Some ex2 text on Another location"
            ch_ex_2["unread"] = true
            var messages_2:[NSDictionary] = []
            messages_2.append(NSDictionary(dictionary: ["text":"Hello! This is ex 2 Vano is writing!!!","nick":"000","date":NSDate(timeInterval: -102000, sinceDate: NSDate())]))
            messages_2.append(NSDictionary(dictionary: ["text":"Hello! This is ex 2 . My name is Kilo kilo!","nick":"KK","date":NSDate(timeInterval: -100000, sinceDate: NSDate())]))
            ch_ex_2["messages"] = messages_2
            chats_archive.addObject(ch_ex_2)
            chats_archive.addObject(ch_ex_1)
            NSKeyedArchiver.archivedDataWithRootObject(chats_archive).writeToFile(chats_path, atomically: false)
            var unread_chats_count = 0
            for chatData in chats_archive {
                if chatData["unread"] as! Bool {
                    unread_chats_count++
                }
            }
            NSUserDefaults().setInteger(unread_chats_count, forKey: "unread_chats_total")
            NSUserDefaults().setInteger(chats_archive.count, forKey: "chats_total")
          //  }
        }
        var cards_bookmarks:[Int] = []
        NSUserDefaults().registerDefaults(["prev_location_area_id":-1,"prev_location_coords":[0.0,0.0],"selected_area_id":1,"cards_bookmarks":cards_bookmarks,"my_posts_cards_ids":cards_bookmarks,"saved_total":2,"chats_total":0,"settings_notifications":false,"my_nick":"IK","unread_chats_total":0,"pro_version":false]) // no prev location is available
        //now we should preload some general info - such as all_areas_cell_data
        //var my:[Int] = []
        //NSUserDefaults().setObject(my, forKey: "my_posts_cards_ids")
        NSUserDefaults().setBool(false, forKey: "pro_version")
        General.populateAllAreasInfo()
        General.populateGeoInfo()
        General.my_avatar_bg_color = UIColor(hue: CGFloat(arc4random()) / CGFloat(UINT32_MAX), saturation: CHAT_AVATAR_BG_SAT, brightness: CHAT_AVATAR_BG_BR, alpha: 1.0)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        NSNotificationCenter.defaultCenter().postNotificationName("app_did_become_active_notification", object: nil, userInfo: nil)
    }

    func applicationWillTerminate(application: UIApplication) {
        let file_manager = NSFileManager.defaultManager()
        let cache_dir = try? file_manager.URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        if let dir = cache_dir {
            let images_cache_dir = dir.URLByAppendingPathComponent("imgs")
            let map_cache_dir = dir.URLByAppendingPathComponent("maps")
            var total_size:UInt64 = 0
            let files_array:[NSURL]? = (try? file_manager.contentsOfDirectoryAtURL(images_cache_dir, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions()))
            if let files = files_array {
                for file_un in files {
                        let attrib:NSDictionary? = try? file_manager.attributesOfItemAtPath(file_un.path!)
                        if let _attrib = attrib {
                            total_size += _attrib.fileSize()
                        }
                }
                print("cache size is \(total_size)")
                if total_size > CACHE_IMAGES_MAX_SIZE {
                    for file_un in files {
                            try? file_manager.removeItemAtURL(file_un)
                        }
                    print("\(total_size) bytes of image cache data!")
                }
            }
            try? file_manager.removeItemAtURL(map_cache_dir)
        }
    }


}

