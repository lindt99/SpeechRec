//
//  AppDelegate.swift
//  SpeechRec
//
//  Created by 本田彩 on 2020/06/04.
//  Copyright © 2020 本田彩. All rights reserved.
//

import UIKit
import CoreData
import Parse


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            // アプリ起動中でもアラートと音で通知
            completionHandler([.alert, .sound])
            
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            completionHandler()
            
        }
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // get authorization for notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]){
                (granted, _) in
                if granted{
                    UNUserNotificationCenter.current().delegate = self
                }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "リマインド";
        content.body = "英語の発音を練習しましょう"
        content.sound = UNNotificationSound.default
        let date = DateComponents(hour:19, minute: 0)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: true)
        let request = UNNotificationRequest.init(identifier: "dailyNotification", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request)
        center.delegate = self
        
        //connect to back4app server
        let configuration = ParseClientConfiguration {
          $0.applicationId = "uljtKAMxZvgsJBHLzQOtfCMujxsfOqQfHPxP1zND"
          $0.clientKey = "3Oc57Re8m2FnrV7TuvYLNBTPTpit0pIKATVufEjx"
          $0.server = "https://parseapi.back4app.com"
        }
        
        Parse.initialize(with: configuration)
        
        saveInstallationObject()
        
        return true
    }
    
        func saveInstallationObject(){
            if let installation = PFInstallation.current(){
                installation.saveInBackground {
                    (success: Bool, error: Error?) in
                    if (success) {
                        print("You have successfully connected your app to Back4App!")
                    } else {
                        if let myError = error{
                            print(myError.localizedDescription)
                        }else{
                            print("Unknown error")
                        }
                    }
                }
            }
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "SpeechRec")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

//extension AppDelegate: UNUserNotificationCenterDelegate{
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        // アプリ起動中でもアラートと音で通知
//        completionHandler([.alert, .sound])
//
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        completionHandler()
//
//    }
//
//
//    func scheduleNotification(notificationType:String){
//        let content = UNMutableNotificationContent()
//        content.title = "英語の発音の練習をしましょう"
//        content.body = ""
//
//        let notificationCenter = UNUserNotificationCenter.current()
//        var dateComponentsDay = DateComponents()
//        dateComponentsDay.hour = 12
//        dateComponentsDay.minute = 10
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponentsDay, repeats: true)
//
//        let request = UNNotificationRequest(identifier: "dailynotification", content: content, trigger: trigger)
//
//        notificationCenter.add(request) {(error) in
//            if error != nil {
//                print(error.debugDescription)
//            }
//        }
//    }
//
//}
