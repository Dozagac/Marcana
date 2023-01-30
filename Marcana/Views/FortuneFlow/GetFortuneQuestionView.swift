//
//  GetFortuneQuestionView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI


struct GetFortuneQuestionView: View {
    @State private var question: String = ""
    @FocusState private var focusTextField
    @Environment(\.presentationMode) var presentationMode

    private var canContinue: Bool {
        question.isNotEmpty
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Background
                //            VideoBackgroundView(videoFileName: "candleVideo", playRate: 0.8)
                BackgroundView()

                VStack {
                    //MARK: Content
                    VStack {
                        Spacer()
                            .frame(height: 100)

                        VStack {
                            QuestionText(text: "Ask your question to fate")
                                .padding(.bottom, 24)
                            TextField("Ask a question",
                                      text: $question,
                                      prompt: Text("Will I get a surprise this month?"))
                                .font(.title3)
                                .minimumScaleFactor(0.5)
                                .textFieldStyle(.plain)
                                .multilineTextAlignment(.center)
                                .focused($focusTextField)
                                .padding(.horizontal, 24)
                        }
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.text)
                            .padding(24)
                            .background(.ultraThinMaterial)
                            .cornerRadius(48)

                        Spacer()
                        Spacer()
                    }

                    //MARK: Continue Button
                    VStack {
                        Spacer()
                        NavigationLink(destination: SelectThreeCardsView(fortuneQuestion: question)) {
                            Text("Continue")
                                .modifier(OnboardingContinueButtonModifier(canContinue: canContinue))
                        }
                            .disabled(question.isEmpty)
                    }
                }
                    .padding(.horizontal, 16)
            }
                .onAppear {
                // this is necessary to make focus work
                DispatchQueue.main.async { focusTextField = true }
            }
                .modifier(customNavBackModifier())
        }
    }
}

struct GetFortuneQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GetFortuneQuestionView()
                .preferredColorScheme(.dark)
        }
    }
}
