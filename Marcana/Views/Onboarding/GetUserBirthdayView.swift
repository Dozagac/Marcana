//
//  GetUserBirthdayView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 29/01/2023.
//

import SwiftUI

struct GetUserBirthdayView: View {
    @Binding var onboardingStage: Int

    // Condition for the continue button, turns true if datepicker is interacted (via didset)
    @State var canContinue = false

    @AppStorage("userBirthday") var birthdayTimeInterval: Double = defaultDate.timeIntervalSince1970
    
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
                    .frame(height: 100)

                VStack(spacing: 16) {
                    //MARK: - Birthday Selection
                    VStack(spacing: 8) {
                        Image(systemName: "birthday.cake.fill")
                            .font(.largeTitle)
                        QuestionText(text: "When is your birthday?")
                        
                        Text("Knowing your gender helps us tailor the reading to your specific needs and gives us a better understanding of your life experiences.")
                            .multilineTextAlignment(.center)
                            .font(.customFontCallout)
                        
                        DatePicker("Enter your birthday", selection: birthday, in: ...Date(), displayedComponents: .date)
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                            .colorScheme(.dark)
                    }
                }
                .padding(.vertical, 24)
                    .background(.ultraThinMaterial)
                    .cornerRadius(48)

            }

            //MARK: Continue Button
            VStack {
                Spacer()
                OnboardingContinueButton(onboardingStage: $onboardingStage, canContinue: canContinue)
                    .simultaneousGesture(TapGesture().onEnded {
                })
            }
        }
    }
}


struct GetUserBirthdayView_Previews: PreviewProvider {
    @State static var onboardingStage = 2
    static var previews: some View {
        GetUserBirthdayView(onboardingStage: $onboardingStage)
            .environmentObject(MockUserOO())
            .preferredColorScheme(.dark)
    }
}
