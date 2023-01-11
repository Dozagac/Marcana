//
//  CollectUserInfoView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI


struct GetUserNameView: View {
    @EnvironmentObject var newUser: User
    @State private var name: String = ""
    @FocusState private var focusTextField
    private var canContinue: Bool {
        name.isNotEmpty
    }
    var body: some View {
        ZStack {
            OnboardingBackgroundView()

            //MARK: Get User Name
            VStack(spacing: 24) {
                Spacer()
                QuestionText(text: "What is your name?")
                VStack {
                    TextField("Enter your name", text: $name, prompt: Text(""))
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.plain)
                        .focused($focusTextField)
                    Rectangle()
                        .frame(height: 2)
                }
                    .frame(width: 200)
                    .foregroundColor(.white.opacity(0.8))
                Spacer()
            }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)

            //MARK: Continue Button
            VStack {
                Spacer()
                NavigationLink(destination: GetUserGenderAndBirthdayView()) {
                    Text("Continue")
                        .modifier(ContinueNavLinkModifier(canContinue: canContinue))
                }
                    .disabled(!canContinue)
                    .simultaneousGesture(TapGesture().onEnded {
                    newUser.name = name
                    print("yoyoyoyo")
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                })
            }
        }
            .onAppear {
            // this is necessary to make focus work
            DispatchQueue.main.async { focusTextField = true }
        }
    }
}


struct QuestionText: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.title)
            .foregroundColor(.text)
            .frame(maxWidth: .infinity)
            .minimumScaleFactor(0.8)
    }
}


//MARK: Custom modifier for the back button in onboarding
struct OnboardingCustomNavBack: ViewModifier {
    @Environment(\.presentationMode) var presentationMode
    func body(content: Content) -> some View {
        content
        // Hide the system back button
        .navigationBarBackButtonHidden(true)
        // Add your custom back button here
        .navigationBarItems(leading:
            Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrowshape.backward")
                .frame(width: 24, height: 24)
        })
    }
}


//MARK: Custom modifier for the continue navigation button
struct ContinueNavLinkModifier: ViewModifier {
    var canContinue: Bool
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .frame(width: 280, height: 50)
            .background(Color.red.opacity(0.7))
            .foregroundColor(Color.text)
            .cornerRadius(12)
            .saturation(canContinue ? 1 : 0)
            .padding(.bottom, 24)
//            .opacity(filled ? 1 : 0.2)
        .animation(.easeIn(duration: 0.3), value: canContinue)
    }
}


struct CollectUserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        GetUserNameView()
            .environmentObject(MockUser())
    }
}


