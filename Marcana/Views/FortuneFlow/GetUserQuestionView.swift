//
//  GetUserQuestionView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI



struct GetUserQuestionView: View {
    @State private var question: String = ""
    @FocusState private var focusTextField
    @Environment(\.presentationMode) var presentationMode

    private var canContinue: Bool {
        question.isNotEmpty
    }

    var body: some View {
        ZStack {
            // Background
            VideoBackgroundView(videoFileName: "candleVideo", playRate: 0.8)

            //MARK: Content
            VStack{
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
                NavigationLink(destination: ThreeCardSelectionView(chosenQuestion: question)) {
                    Text("Continue")
                        .modifier(OnboardingContinueButtonModifier(canContinue: canContinue))
                }
                .disabled(question.isEmpty)
            }
        }
        .padding(.horizontal, 16)
            .onAppear {
            // this is necessary to make focus work
            DispatchQueue.main.async { focusTextField = true }
        }
            .modifier(customNavBackModifier())
    }
}

struct GetUserQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        GetUserQuestionView()
            .preferredColorScheme(.dark)
    }
}
