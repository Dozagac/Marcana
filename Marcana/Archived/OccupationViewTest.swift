//
//  GetUserOccupationView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI

struct OccupationViewTest: View {
    @State private var occupation: String = ""
    fileprivate var defaultOccupations = [
        "Working as a ___",
        "Studying ___",
        "Not Working",
        "Looking for a job",
        "Parent",
        "Business Owner",
        "Retired",
    ]

    private var canContinue: Bool {
        occupation.isNotEmpty
    }


    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Spacer()
                Image(systemName: "star.fill")
                    .font(.largeTitle)
                QuestionText(text: "What is your occupation?")
                    .padding(.bottom, 24)
                TextField("Enter your occupation", text: $occupation, prompt: Text("Student, Artist, Lawyer, Engineer ..."))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 24)

                VStack {
                    Text("Enter your occupation")
                }
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .foregroundColor(.text)


                VStack(alignment: .leading, spacing: 12) {
                    //MARK: Gender Buttons
                    ForEach(defaultOccupations, id: \.self) { occupation in
                        Button(action: {
                            self.occupation = occupation }
                        ) {
                            HStack {
                                Text(occupation)
                                    .font(.subheadline)
                                    .padding(.leading, 8)
                                    .padding(4)
                                Spacer()
                            }
                        }
                            .frame(maxWidth: .infinity)
                            .background(Color.clear)
                            .foregroundColor(Color.text)
                            .overlay(RoundedRectangle(cornerRadius: 12
                        ).stroke(Color.text, lineWidth: 0.3).background(.clear))
                            .padding(.horizontal, 24)
                    }
                }

                Spacer()
            }

            //MARK: Continue Button

            VStack {
                Spacer()
                NavigationLink(destination: Text("test")) {
//                    Text("Continue")
//                        .modifier(OnboardingContinueButtonModifier(canContinue: canContinue))
                }
                .simultaneousGesture(TapGesture().onEnded {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    PersistentDataManager.shared.user.occupation = occupation
            })
            }
        }
    }
}

struct OccupationViewTest_Previews: PreviewProvider {
    static var previews: some View {
        OccupationViewTest()
            .preferredColorScheme(.dark)
    }
}
