//
//  GetFortuneQuestionView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import Foundation
import SwiftUI


struct GetFortuneQuestionView: View {
    var fortuneType: FortuneType
    @Binding var showingFortuneSheet: Bool
//    @State private var question: String = "What part of me needs more acceptance and love?"
    @State private var question: String = ""
    @FocusState private var focusTextField // = true

    @State private var animateViews = false

    @State var suggestedQuestions = [
        "What does the future hold for my career?",
        "Will my relationship/marriage improve?",
        "What can I do to improve my financial situation?",
        "What do I need to know about my health?",
        "What can I do to bring more happiness into my life?",
        "What is the best path for my spiritual journey?",
        "What should I focus on to bring balance to my life?",
        "What is the best approach for resolving a current conflict?",
        "How can I find clarity and direction in my life?",
        "What do I need to know about a specific person in my life?"
    ]

    private var canContinue: Bool {
        question.isNotEmpty
    }
    

    init(fortuneType: FortuneType, showingFortuneSheet: Binding<Bool>) {
        self.fortuneType = fortuneType
        self._showingFortuneSheet = showingFortuneSheet
        
        // Clear out the background color of the textEditor
        // Only works earlier than iOS 16, after that
        // the modifier ".scrollContentBackground(.hidden)" does the same rick
        UITextView.appearance().backgroundColor = .clear
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                // Background
                //            VideoBackgroundView(videoFileName: "candleVideo", playRate: 0.8)
                BackgroundView()

                VStack {
                    //MARK: Content
                    VStack {
//                        Spacer()
//                            .frame(height: 100)

                        VStack(spacing: 24) {
                            QuestionText(text: "Ask your question to fate")


                            VStack(spacing: 12) {
                                Text("Yes, you can ask anything")
                                Text("There are no wrong questions")
                            }
                                .frame(maxHeight: .infinity)
                                .fixedSize(horizontal: false, vertical: true)
                                .font(.customFontBody)
                                .multilineTextAlignment(.center)

                            Divider()

                            ZStack{
                                BackgroundView()
                                // Interacting with this breaks the live preview for some reason...
                                //MARK: - Text Editor for Question
                                if #available(iOS 16.0, *) {
                                    // https://www.hackingwithswift.com/quick-start/swiftui/how-to-change-the-background-color-of-list-texteditor-and-more
                                    TextEditor(text: $question)
                                        .scrollContentBackground(.hidden)
                                        .background(.ultraThinMaterial)
                                        .font(.customFontBody)
                                        .multilineTextAlignment(.center)
                                        .textFieldStyle(.plain)
                                        .focused($focusTextField)
                                        .frame(minHeight: 35, maxHeight: 70)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .accentColor(.white)
//                                        .cornerRadius(12)
                                } else {
                                    // Fallback on earlier versions
                                    TextEditor(text: $question)
                                        .background(.ultraThinMaterial) // doesn't work
                                        .font(.customFontBody)
                                        .multilineTextAlignment(.center)
                                        .textFieldStyle(.plain)
                                        .focused($focusTextField)
                                        .frame(minHeight: 35, maxHeight: 70)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .cornerRadius(12)
                                        .accentColor(.white)
                                }
                            }


                            Divider()

                            // MARK: - Suggest question button
                            Button {
                                suggestQuestion()
                            } label: {
                                Text("Recommend Question")
                                    .font(.customFontSubheadline)
                                    .padding()
                                    .background(Color.marcanaBlue)
                                    .cornerRadius(100)
                                    .shadow(radius: 8)
                                    .disabled(question.isNotEmpty)
                            }
//                                .opacity(animateViews ? 1 : 0)
//                                .animation(.easeInOut(duration: 1).delay(2), value: animateViews)
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
                        NavigationLink() {
                            switch fortuneType {
                            case .with1card: SelectOneCardView(
                                    showingFortuneSheet: $showingFortuneSheet,
                                    fortuneQuestion: question
                                )
                            case .with3cards: SelectThreeCardsView(
                                    showingFortuneSheet: $showingFortuneSheet,
                                    fortuneQuestion: question
                                )
                                // TODO FOR 5 CARDS
                            case .with5cards: SelectThreeCardsView(
                                    showingFortuneSheet: $showingFortuneSheet,
                                    fortuneQuestion: question
                                )
                            }
                        } label: {
                            Text("Continue")
                                .modifier(GetUserInfoContinueButtonModifier(canContinue: canContinue))
                        }
                            .disabled(question.isEmpty)
                    }
                }
                    .padding(.horizontal, 16)
            }
                .onAppear {
                // this is necessary to make focus work
                DispatchQueue.main.async { focusTextField = true }
                animateViews = true
            }
                .modifier(customNavBackModifier())
        }
    }
    
    func suggestQuestion() {
        suggestedQuestions.shuffle()
        question = suggestedQuestions.popLast() ?? "How can I become more decisive?"
    }
}




struct GetFortuneQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GetFortuneQuestionView(fortuneType: FortuneType.with1card,
                                   showingFortuneSheet: .constant(true))
                .preferredColorScheme(.dark)
        }
    }
}
