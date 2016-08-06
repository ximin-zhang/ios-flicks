//
//  AppDelegate.swift
//  Flicks
//
//  Created by ximin_zhang on 8/1/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//        iconImageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "IconList")
        iconImageView.image = image


        
        // Set up the first View Controller
        let topRatedNaviController = storyboard.instantiateViewControllerWithIdentifier("MoviesNaviController") as! UINavigationController
        let topRatedViewController = topRatedNaviController.topViewController as! MoviesViewController
        topRatedViewController.endpoint = "top_rated"
        topRatedNaviController.tabBarItem.title = "Top Rated"
        topRatedNaviController.tabBarItem.image = UIImage(named: "IconTopRated.png")
        topRatedNaviController.navigationBar.setBackgroundImage(UIImage(named: "AppBkg"), forBarMetrics: .Default)
        topRatedNaviController.navigationItem.titleView = iconImageView
        topRatedNaviController.navigationItem.title = "NOOK"

        // Set up the second View Controller
        let nowPlayingNaviController = storyboard.instantiateViewControllerWithIdentifier("MoviesNaviController") as! UINavigationController
        let nowPlayingViewController = nowPlayingNaviController.topViewController as! MoviesViewController
        nowPlayingViewController.endpoint = "now_playing"
        nowPlayingNaviController.tabBarItem.title = "Now Playing"
        nowPlayingNaviController.tabBarItem.image = UIImage(named: "IconNow.png")
//         nowPlayingNaviController.navigationBar.barTintColor = UIColor(hue: 0.8861, saturation: 0.01, brightness: 0.91, alpha: 0.3)
        nowPlayingNaviController.navigationBar.setBackgroundImage(UIImage(named: "AppBkg"), forBarMetrics: .Default)
        nowPlayingNaviController.navigationItem.titleView = iconImageView
        nowPlayingNaviController.navigationItem.title = "NOOK"

        // Tab background color
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        UITabBar.appearance().barTintColor = UIColor.blackColor()
        UITabBar.appearance().translucent = true
//        UITabBar.appearance().alpha = 0.9



        // Set up the Tab Bar Controller to have two tabs
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [topRatedNaviController, nowPlayingNaviController]

        
        
        // Make the Tab Bar Controller the root view controller
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        var categoryError :NSError?
        var success: Bool
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            success = true
        } catch let error as NSError {
            categoryError = error
            success = false
        }
        
        if !success {
            print("AppDelegate Debug - Error setting AVAudioSession category.  Because of this, there may be no sound. \(categoryError!)")
        }

        
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

