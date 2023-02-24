//
//  test2view.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/02/2023.
//

import SwiftUI

struct test2view: View {
        @AppStorage(DefaultKeys.dailyReminderNotificationHour) var reminderHour: Int = 10
        @AppStorage(DefaultKeys.dailyReminderNotificationMinute) var reminderMinute: Int = 30

    var selectedDate: Binding<Date> {
        Binding(get: {
            var components = DateComponents()
            components.hour = reminderHour
            components.minute = reminderMinute
            return Calendar.current.date(from: components)!
        }, set: {
            let components = Calendar.current.dateComponents([.hour, .minute], from: $0)
            reminderHour = components.hour!
            reminderMinute = components.minute!
        })
    }
    
        var body: some View {
            VStack {
                Text("Reminder time: \(reminderHour):\(reminderMinute)")
                DatePicker("Select Time", selection: selectedDate, displayedComponents: [.hourAndMinute])
            }
        }


    }


struct test2view_Previews: PreviewProvider {
    static var previews: some View {
        test2view()
    }
}
