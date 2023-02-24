//
//  ReminderTimePickerView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 24/02/2023.
//

import SwiftUI

struct ReminderTimePickerView: View {
    let notificationManager = NotificationManager.shared

    @AppStorage(wrappedValue: 10, DefaultKeys.dailyReminderNotificationHour) var reminderHour
    @AppStorage(wrappedValue: 30, DefaultKeys.dailyReminderNotificationMinute) var reminderMinute
    
    private var reminderTime: Binding<Date> {
        Binding(get: {
            var components = DateComponents()
            components.hour = reminderHour
            components.minute = reminderMinute
            return Calendar.current.date(from: components)!
        }, set: {
            let components = Calendar.current.dateComponents([.hour, .minute], from: $0)
            reminderHour = components.hour!
            reminderMinute = components.minute!
            // Convert back to date and set the notification
            notificationManager.scheduleDailyReminder(at: Calendar.current.date(bySettingHour: reminderHour, minute: reminderMinute, second: 0, of: Date())!)
        })
    }
    
    var body: some View {
        //                 MARK: - Notification Time Picker
        DatePicker("", selection: reminderTime, displayedComponents: .hourAndMinute)
            .labelsHidden()
            .tint(.white)
    }
}

struct ReminderTimePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderTimePickerView()
    }
}
