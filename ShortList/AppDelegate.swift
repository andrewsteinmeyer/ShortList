//
//  AppDelegate.swift
//  ShortList
//
//  Created by Andrew Steinmeyer on 12/14/15.
//  Copyright © 2015 Andrew Steinmeyer. All rights reserved.
//

import UIKit
import Meteor
import Contacts
import GoogleMaps


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  // for importing contacts
  var contactStore = CNContactStore()
  
  // location picker
  let googleMapsApiKey = "AIzaSyBk_737O6cJZiVdOlMhlaCWCyETfCcaQxc"
  
  private func createMenuView() {
    // main storyboard
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    // setup slide menu
    let mainViewController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
    let leftViewController = storyboard.instantiateViewControllerWithIdentifier("LeftViewController") as! LeftViewController
    
    let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
    
    leftViewController.homeViewController = nvc
    
    let slideMenuController = SLSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
    slideMenuController.automaticallyAdjustsScrollViewInsets = true
    self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
    self.window?.rootViewController = slideMenuController
    self.window?.makeKeyAndVisible()
  }
  
  private func setAppearance() {
    UINavigationBar.appearance().tintColor = UIColor.textColor()
    UINavigationBar.appearance().backgroundColor = UIColor.primaryColor()
    
  }
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // setup appearance and menu
    self.setAppearance()
    self.createMenuView()
    
    GMSServices.provideAPIKey(googleMapsApiKey)
    
    // set up account manager and establish connection to Meteor
    AccountManager.setUpDefaultAccountManager(AccountManager())
    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "METShouldLogDDPMessages")
    
    if !AccountManager.defaultAccountManager.isUserLoggedIn {
      SignInViewController.presentSignInViewController()
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
  
  // MARK: Class functions
  
  class func getAppDelegate() -> AppDelegate {
    return UIApplication.sharedApplication().delegate as! AppDelegate
  }
  
  class func getRootViewController() -> UIViewController? {
    return getAppDelegate().window?.rootViewController
  }
  
  // MARK: Helpers
  
  func showMessage(message: String) {
    let alertController = UIAlertController(title: "ShortList", message: message, preferredStyle: UIAlertControllerStyle.Alert)
    let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
    }
    
    alertController.addAction(dismissAction)
    
    let pushedViewControllers = (self.window?.rootViewController as! UINavigationController).viewControllers
    let presentedViewController = pushedViewControllers[pushedViewControllers.count - 1]
    
    presentedViewController.presentViewController(alertController, animated: true, completion: nil)
  }
  
  func requestForAccess(completionHandler: (accessGranted: Bool) -> Void) {
    let authorizationStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
    
    switch authorizationStatus {
    case .Authorized:
      completionHandler(accessGranted: true)
      
    case .Denied, .NotDetermined:
      self.contactStore.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { (access, accessError) -> Void in
        if access {
          completionHandler(accessGranted: access)
        }
        else {
          if authorizationStatus == CNAuthorizationStatus.Denied {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
              let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
              self.showMessage(message)
            })
          }
        }
      })
      
    default:
      completionHandler(accessGranted: false)
    }
  }


}

