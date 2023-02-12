//
//  NotificationManager.swift
//  Marcana
//
//  Created by Deniz Ozagac on 12/02/2023.
//

import Foundation
import UserNotifications

class NotificationManager {
    let notificationCenter = UNUserNotificationCenter.current()
    
    func scheduleFortuneReminder(at date: Date, message: String) {
        let content = UNMutableNotificationContent()
        content.title = "Daily Fortune Reading Reminder"
        content.body = message
        content.sound = UNNotificationSound.default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: date), repeats: true)
        
        let request = UNNotificationRequest(identifier: "FortuneReminder", content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error adding notification: \(error)")
            } else {
                print("Notification added successfully!")
            }
        }
    }
    
    func requestPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if let error = error {
                print("Error requesting permission: \(error)")
            } else {
                if granted {
                    print("Notification permission granted!")
                } else {
                    print("Notification permission denied.")
                }
            }
        }
    }
}
