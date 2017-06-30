//
//  AppDelegate.swift
//  TouchIdDemo
//
//  Created by Stephen Wong on 6/28/17.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  struct Constants {
    static let jsBundleRoot = "index.ios"
    static let moduleName = "TouchIdDemo"
  }
  
  var window: UIWindow?
  var bridge: RCTBridge!
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    let jsCodeLocation = RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: Constants.jsBundleRoot, fallbackResource: nil)
    var rootView = RCTRootView(bundleURL: jsCodeLocation, moduleName: Constants.moduleName, initialProperties: nil, launchOptions: launchOptions)
    rootView?.backgroundColor = .white
    bridge = rootView?.bridge
    
    window = UIWindow(frame: UIScreen.main.bounds)
    
    let rootViewController = UIViewController()
    rootViewController.view = rootView
    
    window?.rootViewController = rootViewController
    window?.makeKeyAndVisible()
    
    return true
  }
}
