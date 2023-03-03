//
//  ReminderSettingsView.swift
//  Witch
//
//  Created by Deniz Ozagac on 23/02/2023.
//

import SwiftUI

struct ReminderSettingsView: View {
    let notificationManager = NotificationManager.shared
    @State private var reminderTime = Calendar.current.date(bySettingHour: 10, minute: 30, second: 0, of: Date()) ?? Date() // this should come from user settings or smt...

    var body: some View {
        //                 MARK: - Notification Time Picker
        DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
            .labelsHidden()
            .tint(.white)
            .onChange(of: reminderTime) { newReminderTime in
                notificationManager.scheduleDailyReminder(at: newReminderTime)
            }
    }
}

struct ReminderSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderSettingsView()
    }
}
