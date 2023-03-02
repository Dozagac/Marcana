//
//  OnboardingView5.swift
//  Marcana
//
//  Created by Deniz Ozagac on 21/02/2023.
//

import SwiftUI

struct OnboardingSetRemindersView: View {
    @State private var reminderTime = Calendar.current.date(bySettingHour: 10, minute: 30, second: 0, of: Date()) ?? Date()
    @AppStorage(wrappedValue: 10, DefaultKeys.dailyReminderNotificationHour) var reminderHour
    @AppStorage(wrappedValue: 30, DefaultKeys.dailyReminderNotificationMinute) var reminderMinute

//    @State private var notificationPermissionStatus: UNAuthorizationStatus?
    @State private var notificationPermissionChoiceMade = false

    let notificationManager = NotificationManager.shared

    var body: some View {
        ZStack(alignment: .top) {
            BackgroundView()

            OnboardingCustomBackButton()
                .padding(.leading)

            ProgressStepperView(stepperColor: Color.white,
                                progressStep: 4,
                                numberOfSteps: 4)
                .zIndex(2)
                .padding(.top)

            //MARK: - Placing the continue button at the same spot at all screens
            VStack() {

                VStack(spacing: 24) {

                    Spacer()

                        .frame(height: UIValues.onboardingScreenTopPadding)

                    Text("Set daily Tarot Reading Reminder")
                        .font(.customFontTitle).bold()
                        .multilineTextAlignment(.center)


                    Text("You can easily change this later")
                        .font(.customFontCallout)

                    // notification view
                    NotificationPreviewView()
                }

                Spacer()

//                 MARK: - Notification Time Picker
                DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())

                Spacer()

                // MARK: - ASK NOTIFICATION PERMISSION
                ZStack(alignment: .bottom) {
                    Button {
                        // Its named granted, but it always returns true. I use this to trigger transition to the next view.
                        notificationManager.requestNotificationPermission { granted in
                            DispatchQueue.main.async {
                                notificationPermissionChoiceMade = granted
                            }
                        }

                        // Save the notification hour and minute
                        let calendar = Calendar.current
                        reminderHour = calendar.component(.hour, from: reminderTime)
                        reminderMinute = calendar.component(.minute, from: reminderTime)

                        // Schedule the reminder
                        notificationManager.scheduleDailyReminder(at: self.reminderTime)

                        // Analytics
                        AnalyticsManager.shared.setUserProperties(properties: [
                            AnalyticsAmplitudeUserPropertyKeys.reminderTimeHour: reminderHour,
                            AnalyticsAmplitudeUserPropertyKeys.reminderTimeMinute: reminderMinute
                        ])

                    } label: {
                        Text("Continue")
                            .modifier(OnboardingContinueButtonModifier(canContinue: true))
                    }
                        .navigationDestination(isPresented: $notificationPermissionChoiceMade, destination: {
                        OnboardingEndTransitionView()
                    })
                        .padding(.bottom, UIValues.onboardingContinueButtonBottomPadding)

//                    //MARK: - Skip for now button
//                    NavigationLink {
//                        OnboardingEndTransitionView()
//                    } label: {
//                        Text("Skip for now")
//                            .font(.customFontBody)
//                            .fontWeight(.black)
//                            .foregroundColor(.gray)
//                    }
//                    .padding(.bottom, 4)
                }
            }
                .padding(.horizontal, UIValues.bigButtonHPadding)
        }
            .navigationBarBackButtonHidden(true)
            .onAppear {
            AnalyticsManager.shared.logEvent(eventName: AnalyticsKeys.onboardingRemindersPageview)
        }
    }
}

struct NotificationPreviewView: View {
    var body: some View {
        ZStack {

            HStack(spacing: 12) {
                Image("AppIconInApp")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .scaledToFit()
                    .cornerRadius(10)

                VStack(alignment: .leading, spacing: 4) {
                    Text("MARCANA")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black.opacity(0.5))
                    Text("Time for your daily Tarot Reading 🙏")
                        .font(.body)
                        .foregroundColor(.black)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                }

                Spacer()
            }
                .padding()
                .background(.gray)
                .cornerRadius(16)
                .zIndex(3)


            HStack {
                Text("dummy").opacity(0.01)
                Spacer()
            }
                .padding()
                .background(.gray)
                .brightness(-0.1)
                .cornerRadius(16)
                .offset(y: 24)
                .scaleEffect(0.92)
                .zIndex(2)

            HStack {
                Text("dummy").opacity(0.01)
                Spacer()
            }
                .padding()
                .background(.gray)
                .brightness(-0.2)
                .cornerRadius(16)
                .offset(y: 38)
                .scaleEffect(0.82)
                .zIndex(1)
        }
    }
}

struct OnboardingView5_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingSetRemindersView()
    }
}
