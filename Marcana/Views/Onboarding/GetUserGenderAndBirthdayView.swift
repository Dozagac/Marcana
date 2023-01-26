//
//  TestingView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI

struct GetUserGenderAndBirthdayView: View {
    @Binding var onboardingStage: Int
    // Gender
    @State private var selectedGender: Gender? = nil

    // Birthday
    @State private var birthday: Date = defaultDate

    // Condition for the continue button
    private var canContinue: Bool {
//        birthday != GetUserGenderAndBirthdayView.defaultDate && selectedGender != nil
        selectedGender != nil
    }

    static var defaultDate: Date {
        let currentDate = Date()
        let calendar = Calendar.current
        var components = calendar.dateComponents([.month, .day], from: currentDate)
        components.year = 2000
        return Calendar.current.date(from: components) ?? Date.now
//        Date()
    }


    enum Gender: String, CaseIterable {
        case female = "Her"
        case male = "Him"
        case other = "They"

        var icon: String {
            switch self {
            case .male:
                return "GenderMale"
            case .female:
                return "GenderFemale"
            case .other:
                return "GenderIntersex"
            }
        }
    }

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: 100)

                VStack(spacing: 0) {
                    //MARK: - Birthday Selection
                    VStack(spacing: 8) {
                        Image(systemName: "birthday.cake.fill")
                            .font(.largeTitle)
                        QuestionText(text: "What is your birthday ?")
                        DatePicker("Enter your birthday", selection: $birthday, in: ...Date(), displayedComponents: .date)
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                            .colorScheme(.dark)
                    }
                    .padding(.bottom, 24)

                    //MARK: - Gender Selection
                    VStack(spacing: 8) {
                        Image(systemName: "person.fill")
                            .font(.largeTitle)

                        QuestionText(text: "How should we call you?")
                            .padding(.bottom)

                        //MARK: Gender Buttons
                        HStack(spacing: 16) {
                            ForEach(Gender.allCases, id: \.self) { gender in
                                Button(action: {
                                    self.selectedGender = gender }
                                ) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(self.selectedGender == gender ? Color.text : .clear)
                                        .frame(width: 95, height: 95)
                                        .overlay(RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.text, lineWidth: 1).background(.clear))
                                        .overlay(
                                        VStack {
                                            Image(gender.icon)
                                                .renderingMode(.template)
                                            Text(gender.rawValue)
                                                .font(.title2)
                                        }
                                            .foregroundColor(self.selectedGender == gender ? Color.black : .text))
                                }
                            }
                        }
                    }
                }
                    .padding(24)
                    .background(.ultraThinMaterial)
                    .cornerRadius(48)

                Spacer()
            }

            //MARK: Continue Button
            VStack {
                Spacer()
                OnboardingContinueButton(onboardingStage: $onboardingStage, canContinue: canContinue)
                    .simultaneousGesture(TapGesture().onEnded {
                    if selectedGender != nil {
                        PersistentDataManager.shared.user.gender = selectedGender!.rawValue
                        PersistentDataManager.shared.user.birthday = birthday
                    }
                })
            }
        }
            .padding(.horizontal, 16)

    }
}


struct GetUserGenderAndBirthdayView_Previews: PreviewProvider {
    @State static var onboardingStage = 2
    static var previews: some View {
        GetUserGenderAndBirthdayView(onboardingStage: $onboardingStage)
            .environmentObject(MockUserOO())
            .preferredColorScheme(.dark)
    }
}
