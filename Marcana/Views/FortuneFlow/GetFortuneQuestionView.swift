//
//  GetFortuneQuestionView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import Foundation
import SwiftUI

enum questionSuggestion: String {
    case love = "Love"
    case career = "Career"
    case personal = "Personal"
    case health = "health"

    var questions: [String] {
        switch self {
            case .love:
                return ["Will my relationship/marriage improve?",
                        "Will I find love in the near future?",
                        "What do I need to know about a specific person in my life?"]
            case .career:
                return ["What does the future hold for my career?",
                        "What can I do to advance in my career?",
                        "What can I do to improve my financial situation?"]
            case .personal:
                return ["What can I do to bring more happiness into my life?",
                        "What is the best path for my spiritual journey?",
                        "What should I focus on to bring balance to my life?"]
            case .health:
                return ["What do I need to know about my health?",
                        "Will I have any health concerns in the near future?",
                        "How can I improve my overall well-being?"]
        }
    }

    var iconName: String {
        switch self {
            case .love:
                return "heart.circle"
            case .career:
                return "briefcase"
            case .personal:
                return "brain"
            case .health:
                return "plus.circle"
        }
    }
}

struct GetFortuneQuestionView: View {
    var fortuneType: FortuneType
    @Binding var showingFortuneSheet: Bool
//    @State private var question: String = "What part of me needs more acceptance and love?"
    @State private var question: String = ""
    @FocusState private var focusTextField // = true

    @State private var animateViews = false

    @State var showRecommendations = false
    
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
        NavigationStack {
            ZStack(alignment: .top) {
                BackgroundView()

                VStack {
                    //MARK: Content
                    VStack {
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
                                .frame(height: 2)

                            ZStack{
                                BackgroundView()
                                // Interacting with this breaks the live preview for some reason...
                                //MARK: - Text Editor for Question
                                    // https://www.hackingwithswift.com/quick-start/swiftui/how-to-change-the-background-color-of-list-texteditor-and-more
                                    TextEditor(text: $question)
                                        .scrollContentBackground(.hidden) // iOS 16
                                        .background(.ultraThinMaterial)
                                        .font(.customFontBody)
                                        .multilineTextAlignment(.center)
                                        .textFieldStyle(.plain)
                                        .focused($focusTextField)
                                        .frame(minHeight: 35, maxHeight: 70)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .accentColor(.white)
                            }

                            Divider()
                                .frame(height: 2)

                            // MARK: - Suggest question button
                            Button {
                                showRecommendations = true
                            } label: {
                                Text("Need ideas ?")
                                    .font(.customFontSubheadline)
                                    .padding()
                                    .background(.white)
                                    .foregroundColor(.black)
                                    .cornerRadius(100)
                                    .shadow(radius: 8)
                                    .disabled(question.isNotEmpty)
                            }
                            .sheet(isPresented: $showRecommendations) {
                                // The picker view
                                QuestionListView(question: $question)
                                    
                            }

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
}


struct QuestionListView: View {
    @Binding var question: String
    let suggestionCategory: [questionSuggestion] = [.love, .career, .personal, .health]
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack(alignment: .top){
            // MARK: - X button
            HStack() {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title3.bold())
                        .foregroundColor(.text)
                        
                }
                Spacer()
            }
            .padding([.leading, .top], 20)
            .zIndex(2)
            
            List {
                ForEach(suggestionCategory, id: \.self) { category in
                    Section{
                        ForEach(category.questions, id: \.self) { category in
                            Button{
                                question = category
                                dismiss()
                            } label: {
                                Text(category)
                            }
                        }
                    } header: {
                        Label(category.rawValue, systemImage: category.iconName)
                            .font(.customFontCallout.bold())
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .padding(.top, 24)
        }
        .background(BackgroundBlurView())
    }
}

struct GetFortuneQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GetFortuneQuestionView(fortuneType: FortuneType.with1card,
                                   showingFortuneSheet: .constant(true))
                .preferredColorScheme(.dark)
        }
    }
}
