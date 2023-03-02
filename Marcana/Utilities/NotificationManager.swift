//
//  NotificationManager.swift
//  Marcana
//
//  Created by Deniz Ozagac on 12/02/2023.
// https://www.youtube.com/watch?v=mG9BVAs8AIo for some help, rest with chatgpt or efe

import Foundation
import UserNotifications
import SwiftUI

// Conforms to these two so it can become assigned as the delegate
class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    override private init(){
        super.init()
        notificationCenter.delegate = self
    }
    
    // Efe helped writing this
    // Adding this made so the banner shows even if the app is open
    // Automatically called because of UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner])
        // if I want the banner comletion to trigger something, is should go here
    }
    
    static let shared = NotificationManager() // Singleton

    let notificationCenter = UNUserNotificationCenter.current()

    func resetNotificationBadges() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    // TESTING ONLY, REMOVE LATER
    func scheduleTESTINGNOTIFICATION(seconds: Double = 3.0) {
        let content = UNMutableNotificationContent()
//        content.title = "Daily Tarot Reading"
        content.body = "Don't forget to check your daily tarot reading! 🤍"
        content.sound = UNNotificationSound.default
        content.badge = 1

        //3 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)

        let request = UNNotificationRequest(identifier: "TESTNOTIFICATION", content: content, trigger: trigger)

        notificationCenter.add(request)
    }


    func scheduleDailyReminder(at date: Date) {
        let content = UNMutableNotificationContent()
//        content.title = "Daily Tarot Reading"
        content.body = "Don't forget to check your daily tarot reading! 🤍"
        content.sound = UNNotificationSound.default
        content.badge = 1

        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: date), repeats: true)

        let request = UNNotificationRequest(identifier: NotificationKeys.dailyReminder, content: content, trigger: trigger)

        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error adding notification: \(error)")
            } else {
                let components = Calendar.current.dateComponents([.hour, .minute], from: date)
                print("NOTIFICATION ADDED SUCCESSFULLY! hour: \(components.hour!) minute: \(components.minute!)")
            }
        }
    }

    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if let error = error {
                print("Error requesting permission: \(error)")
            } else {
                if granted {
                    print("Notification permission granted!")
                    AnalyticsManager.shared.setUserProperties(properties: [AnalyticsAmplitudeUserPropertyKeys.consentedNotifications : true])
                    completion(true) // these are both true because I use these to check if the user interacted with the notification permission alert at all
                } else {
                    print("Notification permission denied.")
                    AnalyticsManager.shared.setUserProperties(properties: [AnalyticsAmplitudeUserPropertyKeys.consentedNotifications : false])
                    completion(true) // these are both true because I use these to check if the user interacted with the notification permission alert at all
                    // even  if they say no, they transition into the next onboarding screen
                }
            }
        }
    }
}
