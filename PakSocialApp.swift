//
//  TinderGroupsApp.swift
//  Pak Social App
//
//  Created by Dean Spann on 25/10/21.
//

import SwiftUI
import Firebase
import FacebookLogin
import FirebaseMessaging
@main
struct PakSocialApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}

// MARK: Setting Up Firebase
import Firebase
import SwiftUI
class AppDelegate: NSObject,UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate{
    @AppStorage("fcm") var fcm: String = ""
    @AppStorage("ViewSelection") var ViewSelection = ""
    @AppStorage("eventID") var eventid = ""
    @AppStorage("dealID") var dealID = ""
    @AppStorage("notificationType") var notificationType = ""
    @AppStorage("notificationAuthor") var author = ""
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        
        
        
        
        
        
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
//        self.ViewSelection = ""
//        self.eventid = ""
//        self.dealID = ""
//        self.notificationType = ""
//        self.author = ""
        return true
    }
    

    
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("Firebase registration token: \(String(describing: fcmToken))")
        self.fcm = fcmToken ?? ""
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
          name: Notification.Name("FCMToken"),
          object: nil,
          userInfo: dataDict
        )
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        print("################# IN Background ##################")
       
       eventid =  userInfo["event"] as? String ?? ""
       dealID = userInfo["dealid"] as? String ?? ""
       notificationType = userInfo["type"] as? String ?? ""
        author = userInfo["authorId"] as? String ?? ""
        if notificationType == "events"{
            ViewSelection = "EventView"
        }
        else{
            ViewSelection = "DealView"
        }
        
//        here in foreground click
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                  -> Void) {
      let userInfo = notification.request.content.userInfo
      print(userInfo)
       print("################# IN Foreground ##################")
      // Change this to your preferred presentation option
      //completionHandler([[.alert, .sound]])
        //ViewSelection = "EventView"
      eventid =  userInfo["event"] as? String ?? ""
        dealID = userInfo["dealid"] as? String ?? ""
        notificationType = userInfo["type"] as? String ?? ""
        author = userInfo["authorId"] as? String ?? ""
        completionHandler([.banner, .badge, .sound])
        
    }
    //Since OTP Requires Remote Notification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        print(userInfo)
        return .noData
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.ViewSelection = ""
        self.eventid = ""
        self.dealID = ""
        self.notificationType = ""
        self.author = ""
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for notifications: \(error.localizedDescription)")
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    
    

    

    

}

//class NotificationCenter: NSObject, ObservableObject {
//    @Published var dumbData: UNNotificationResponse?
//
//    override init() {
//        super.init()
//        UNUserNotificationCenter.current().delegate = self
//    }
//}

//extension NotificationCenter: UNUserNotificationCenterDelegate  {
//    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.list, .badge, .sound])
//
////        or
//        //completionHandler([.banner, .badge, .sound])
//    }
//
//    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        //dumbData = response
//        completionHandler()
//    }
//
//    public func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) { }
//}




