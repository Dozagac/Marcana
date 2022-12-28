//
//  GetUserQuestionView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI



struct GetUserQuestionView: View {
    @State private var question: String = ""
    private var defaultQuestions = [
        "When will I find a job?",
        "When will I find a lover?",
        "When will I get married?",
        "When will I have a child?",
        "Will my relationship last?",
        "Will I get the promotion at work?",
        "Will my ex come back into my life?",

    ]

    private var filled: Bool {
        question.isNotEmpty
    }

    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Spacer()
                QuestionText(text: "What is the one question")
                QuestionText(text: "that you seek the answer for?")
                    .padding(.bottom, 24)
                TextField("Enter your occupation",
                          text: $question,
                          prompt: Text("How can I attract love into my life?"))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 24)

                Text("You can ask your own personal question to Aurelion, or choose one below:")
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .foregroundColor(.text)

                VStack(alignment: .leading, spacing: 12) {
                    //MARK: Gender Buttons
                    ForEach(defaultQuestions, id: \.self) { question in
                        Button(action: {
                            self.question = question }
                        ) {
                            HStack {
                                Text(question)
                                    .font(.subheadline)
                                    .padding(.leading, 8)
                                    .padding(4)
                                Spacer()
                            }
                        }
                            .frame(maxWidth: .infinity)
                            .background(Color.clear)
                            .foregroundColor(Color.text)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10
                        ).stroke(Color.text, lineWidth: 0.3).background(.clear))
                            .padding(.horizontal, 24)
                    }
                }

                Spacer()
            }

            //MARK: Continue Button
            VStack {
                Spacer()
                NavigationLink(destination: ThreeCardSelectionView()) {
                    Text("Continue")
                        .modifier(ContinueNavLinkModifier(filled: filled))
                }
            }
        }
    }
}

struct GetUserQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        GetUserQuestionView()
    }
}
