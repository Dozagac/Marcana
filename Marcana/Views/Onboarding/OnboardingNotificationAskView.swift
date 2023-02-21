//
//  OnboardingNotificationAskView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 12/02/2023.
//

import SwiftUI

struct OnboardingNotificationAskView: View {
    @State private var date = Calendar.current.date(bySettingHour: 19, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var message = "Don't forget to check your daily tarot reading! 🔮"

    let notificationManager = NotificationManager()

    var body: some View {
        VStack {
            Text("Set your daily Tarot reading reminder")
                .font(.customFontTitle2)
                .multilineTextAlignment(.center)
                .padding()
            
            Text("Don't worry, you can change this later.")
                .font(.customFontCallout)
                .multilineTextAlignment(.center)

//            DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
//                .labelsHidden()
//                .datePickerStyle(WheelDatePickerStyle())
            
            

            Button(action: {
                self.notificationManager.requestPermission()
                self.notificationManager.scheduleFortuneReminder(at: self.date, message: self.message)
            }) {
                Text("Set Reminder Time")
                    .font(.headline)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
            
            Button(action: {
                // next page
            }) {
                Text("Skip for now")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.secondary)
                    .cornerRadius(10)
            }
        }
    }
}

struct OnboardingNotificationAskView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingNotificationAskView()
    }
}
