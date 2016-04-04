//
//  AppDelegate.swift
//  SNS-Realtime
//
//  Created by Icaro Barreira Lavrador on 3/10/15.
//  Copyright © 2015 Icaro Barreira Lavrador. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var firebase = Firebase(url: "https://sns-realtimeapp.firebaseio.com")

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        if let uid = self.firebase.authData?.uid{
            firebase.childByAppendingPath("users").childByAppendingPath(uid).updateChildValues(["isOnline":false])
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        if let uid = self.firebase.authData?.uid{
            firebase.childByAppendingPath("users").childByAppendingPath(uid).updateChildValues(["isOnline":true])
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

