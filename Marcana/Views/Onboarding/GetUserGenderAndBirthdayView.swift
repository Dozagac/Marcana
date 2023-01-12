//
//  TestingView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI

struct GetUserGenderAndBirthdayView: View {
    @EnvironmentObject var newUser: UserOO
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
    }


    enum Gender: String, CaseIterable {
        case female = "Female"
        case male = "Male"
        case other = "Other"

        var icon: String {
            switch self {
            case .male:
                return "GenderMale"
            case .female:
                return "GenderFemale"
            case .other:
                return "GenderOther"
            }
        }
    }

    var body: some View {
        ZStack {
            OnboardingBackgroundView()
            VStack(spacing: 0) {

                Spacer()

                //MARK: Birthday Selection
                VStack(spacing: 0) {
                    QuestionText(text: "What is your birthday ?")
                    DatePicker("Enter your birthday", selection: $birthday, displayedComponents: .date)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                        .colorScheme(.dark)
                }

                Spacer()

                //MARK: Gender Selection
                VStack(spacing: 24) {
                    //MARK: Question Title
                    QuestionText(text: "What is your gender?")

                    //MARK: Gender Selection
                    HStack(spacing: 24) {
                        //MARK: Gender Buttons
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
                                            .tint(.red)
                                        Text(gender.rawValue)
                                            .font(.title2)
                                    }
                                        .foregroundColor(self.selectedGender == gender ? Color.black : .text))
                            }
                        }
                    }
                }
                Spacer()
                Spacer()
            }

            //MARK: Continue Button
            VStack {
                Spacer()
                NavigationLink(destination: GetUserOccupationView()) {
                    Text("Continue")
                        .modifier(ContinueNavLinkModifier(canContinue: canContinue))
                }
                    .disabled(!canContinue)
                    .simultaneousGesture(TapGesture().onEnded {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    newUser.gender = selectedGender?.rawValue ?? Gender.other.rawValue
                    newUser.birthday = birthday
                })
            }
        }
            .modifier(OnboardingCustomNavBack())
    }
}


struct GetUserGenderAndBirthdayView_Previews: PreviewProvider {
    static var previews: some View {
        GetUserGenderAndBirthdayView()
            .environmentObject(MockUserOO())
    }
}
