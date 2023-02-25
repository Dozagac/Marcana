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

    @State var showRecommendations = false

    private var canContinue: Bool {
        question.isNotEmpty
    }

    let notificationManager = NotificationManager.shared

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ImageBackgroundView(imageName: "questionMarks")
                    .saturation(0.3)

                VStack {
                    //MARK: Content
                    VStack {
                        VStack(spacing: 16) {
                            QuestionText(text: "Ask your question to fate")

                            VStack(spacing: 4) {
                                Text("Yes, you can ask anything")
                                Text("There are no wrong questions")
                            }
                                .frame(maxHeight: .infinity)
                                .fixedSize(horizontal: false, vertical: true)
                                .font(.customFontFootnote)
                                .multilineTextAlignment(.center)

                            Divider()
                                .frame(height: 2)

                            TextField("", text: $question, axis: .vertical)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(1...4)
                                .font(.customFontBody)
                                .multilineTextAlignment(.center)
                                .focused($focusTextField)
                                .accentColor(.white) // changes cursor color

                            Divider()
                                .frame(height: 2)

                            // MARK: - Suggest question button
                            Button {
                                showRecommendations = true
                            } label: {
                                Text("Need ideas?")
                                    .font(.customFontSubheadline)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color.text)
                                    .foregroundColor(.black)
                                    .cornerRadius(100)
                                    .shadow(radius: 8)
                                    .disabled(question.isNotEmpty)
                            }
                                .sheet(isPresented: $showRecommendations) {
                                // The picker view
                                    QuestionListView(fortuneType:fortuneType, question: $question)

                            }

                        }
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.text)
                            .padding(24)
                            .background(.ultraThinMaterial)
                            .cornerRadius(48)
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
    let fortuneType : FortuneType
    @Binding var question: String
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack(alignment: .top) {
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
                ForEach(fortuneType.questionSuggestionCategories, id: \.self) { category in
                    Section {
                        ForEach(category.questions, id: \.self) { category in
                            Button {
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
                .padding(.top, 32)
        }
            .background(BackgroundBlurView())
    }
}


enum QuestionSuggestion: String {
    case daily = "Daily"
    case love = "Love"
    case career = "Career"
    case personal = "Personal"
    case health = "health"

    var questions: [String] {
        switch self {
        case .daily:
            return [
                "What should I focus on today?",
                "What challenges may I face today?",
                "What opportunities should I look out for today?"
            ]
        case .love:
            return [
                "What do I need to know about my current romantic relationship?",
                "What is blocking me from finding true love?",
                "What can I do to improve my relationship with my partner?"
            ]
        case .career:
            return [
                "What do I need to focus on to advance my career?",
                "What is holding me back from achieving my professional goals?",
                "What steps can I take to improve my work-life balance?"
            ]
        case .personal:
            return [
                "What do I need to focus on to improve myself?",
                "What is blocking me from achieving my personal goals?",
                "How can I best develop my spiritual and emotional self?"
            ]
        case .health:
            return [
                "What can I do to improve my physical health?",
                "What is the root cause of my current health issue?",
                "How can I best take care of my mental health and well-being?"
            ]
        }
    }

    var iconName: String {
        switch self {
        case .daily:
            return "sun.and.horizon.fill"
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

struct GetFortuneQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GetFortuneQuestionView(fortuneType: FortuneType.with1card,
                                   showingFortuneSheet: .constant(true))
                .preferredColorScheme(.dark)
        }
    }
}
