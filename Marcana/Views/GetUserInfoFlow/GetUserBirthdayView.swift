//
//  GetUserBirthdayView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 29/01/2023.
//

import SwiftUI

struct GetUserBirthdayView: View {
    @Binding var getUserInfoStep: Int

    // Condition for the continue button, turns true if datepicker is interacted (via didset)
    @State var canContinue = false

    @AppStorage(UserDataManager.UserKeys.userBirthday.rawValue) var birthdayTimeInterval: Double = defaultDate.timeIntervalSince1970
    
    
    var birthday: Binding<Date> {
        Binding<Date>(
            get: {
                return Date(timeIntervalSince1970: self.birthdayTimeInterval)
            },
            set: {
                self.birthdayTimeInterval = $0.timeIntervalSince1970
                canContinue = true
            }
        )
    }
    
    // Today's day and month for for year 2000
    static var defaultDate: Date {
        let currentDate = Date()
        let calendar = Calendar.current
        var components = calendar.dateComponents([.month, .day], from: currentDate)
        components.year = 2000
        return Calendar.current.date(from: components) ?? Date.now
//        Date()
    }


    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Spacer()
                    .frame(height: 50)

                VStack(spacing: 16) {
                    //MARK: - Birthday Selection
                    VStack(spacing: 8) {
                        Image(systemName: "birthday.cake.fill")
                            .font(.largeTitle)
                        QuestionText(text: "When is your birthday?")
                        
                        Text("Your personal information is solely used for generating personalized fortune tellings and will be kept confidential.")
                            .multilineTextAlignment(.center)
                            .font(.customFontFootnote)
                            .padding(.horizontal)
                        
                        DatePicker("Enter your birthday", selection: birthday, in: ...Date(), displayedComponents: .date)
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                            .colorScheme(.dark)
                    }
                }
                .padding(.vertical, 24)
                    .background(.ultraThinMaterial)
                    .cornerRadius(48)

                Spacer()
            }
            .padding(.horizontal, UIValues.bigButtonHPadding)

            //MARK: Continue Button
            VStack {
                Spacer()
                GetUserInfoContinueButton(getUserInfoStep: $getUserInfoStep, canContinue: canContinue)
                    .simultaneousGesture(TapGesture().onEnded {

                        // Analytics for birthday string
                        let formatter = DateFormatter()
                        formatter.dateStyle = .short
                        formatter.timeStyle = .none
                        let dateString = formatter.string(from: birthday.wrappedValue)
                        AnalyticsManager.shared.setUserProperties(
                            properties: [AnalyticsAmplitudeUserPropertyKeys.userBirthday: dateString]
                        )
                        // Analytics for age integer
                        let now = Date()
                        let calendar = Calendar.current
                        let ageComponents = calendar.dateComponents([.year], from: birthday.wrappedValue, to: now)
                        let userAge = ageComponents.year ?? 0
                        AnalyticsManager.shared.setUserProperties(
                            properties: [AnalyticsAmplitudeUserPropertyKeys.userAge: userAge]
                        )
                })
            }
            .padding(.horizontal, UIValues.bigButtonHPadding)
        }
        .onAppear{
            AnalyticsManager.shared.logEvent(
                eventName: AnalyticsKeys.userInfoFlowBirthdayPageview
            )
        }
    }
}


struct GetUserBirthdayView_Previews: PreviewProvider {
    @State static var getUserInfoStep = 2
    static var previews: some View {
        GetUserBirthdayView(getUserInfoStep: $getUserInfoStep)
            .preferredColorScheme(.dark)
    }
}
