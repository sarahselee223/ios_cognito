//
//  AppDelegate.swift
//  iOS_Cognito
//
//  Created by Sarah Lee on 12/2/19.
//  Copyright © 2019 Sarah Lee. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

let userPoolID = "test_pool"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    class func defaultUserPool() -> AWSCognitoIdentityUserPool {
        return AWSCognitoIdentityUserPool(forKey: userPoolID)
    }
    var window: UIWindow?
    
    var loginViewController: LoginViewController?
    
    var navigationController: UINavigationController?
    
    var cognitoConfig: CognitoConfig?
    
    var storyboard: UIStoryboard? {
        return UIStoryboard(name: "Main", bundle: nil)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // setup logging
        AWSDDLog.sharedInstance.logLevel = .verbose
        AWSDDLog.add(AWSDDTTYLogger.sharedInstance)
        
        // setup cognito config
        self.cognitoConfig = CognitoConfig()
        
        // setup cognito
        setupCognitoUserPool()
        
        //Override point for customization after application launch.
        
        return true
    }

    func setupCognitoUserPool() { 
        let clientId:String = self.cognitoConfig!.getClientId()
        let poolId:String = self.cognitoConfig!.getPoolId()
        let region:AWSRegionType = self.cognitoConfig!.getRegion()
        
        let serviceConfiguration: AWSServiceConfiguration = AWSServiceConfiguration(region: region, credentialsProvider: nil)
        let cognitoConfiguration: AWSCognitoIdentityUserPoolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: clientId, clientSecret: nil , poolId: poolId)
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: cognitoConfiguration, forKey: userPoolID)
        let pool:AWSCognitoIdentityUserPool = AppDelegate.defaultUserPool()
        pool.delegate = self
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension AppDelegate: AWSCognitoIdentityInteractiveAuthenticationDelegate {
    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
        if(self.navigationController == nil) {
            self.navigationController = self.window?.rootViewController as? UINavigationController
        }
        
        if(self.loginViewController == nil) {
            self.loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        }
        
        DispatchQueue.main.async {
            if(self.loginViewController!.isViewLoaded || self.loginViewController!.view.window == nil) {
                self.navigationController?.present(self.loginViewController!, animated: true, completion: nil)
            }
        }
        return self.loginViewController!
    }
}

