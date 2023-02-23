//
//  OnboardingView5.swift
//  Marcana
//
//  Created by Deniz Ozagac on 21/02/2023.
//

import SwiftUI

struct OnboardingView5: View {
    @State private var date = Calendar.current.date(bySettingHour: 10, minute: 30, second: 0, of: Date()) ?? Date()
    @State private var message = "Don't forget to check your daily tarot reading! 🤍"
//    @State private var notificationPermissionStatus: UNAuthorizationStatus?
    @State private var notificationAllowed = false

    let notificationManager = NotificationManager()

    var body: some View {
        ZStack(alignment: .top) {
            BackgroundView()

            OnboardingCustomBackButton()
                .padding(.leading)

            ProgressStepperView(stepperColor: Color.white,
                                progressStep: 5)
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
                DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())

                Spacer()

                // MARK: - ASK NOTIFICATION PERMISSION
                Button {
//                    notificationManager.requestPermission()
                    notificationManager.requestNotificationPermission { granted in
                        DispatchQueue.main.async {
                            notificationAllowed = granted
                        }
                    }
                    
                    notificationManager.scheduleFortuneReminder(at: self.date, message: self.message)
                } label: {
                    Text("Turn On Notifications")
                        .font(.customFontTitle3)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(.marcanaBackground)
                        .cornerRadius(50)
//                        .padding(.horizontal, 24)
                    .shadow(radius: 8)
                }
                    .navigationDestination(isPresented: $notificationAllowed, destination: {
                    OnboardingEndTransitionView()
                })
                    .padding(.bottom, 35)

            }
                .padding(.horizontal, UIValues.bigButtonHPadding)
        }
            .navigationBarBackButtonHidden(true)
    }
}

struct NotificationPreviewView: View {
    var body: some View {
        ZStack {

            HStack(spacing: 12) {
                Image("AIFortuneTeller")
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
        OnboardingView5()
    }
}
