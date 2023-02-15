//
//  GetUserInfoFlowView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 12/01/2023.
//
//

import SwiftUI

struct GetUserInfoFlowView: View {
    //Transitions
    let transition: AnyTransition = .push(from: .trailing)
    
    @State var getUserInfoStep: Int = 0

    var body: some View {

        ZStack(alignment: .top) {
            ImageBackgroundView(imageName: "fieldWalk")
                .saturation(0.5)

            ChevronBackButton(getUserInfoStep: $getUserInfoStep)
            
            ProgressStepperView(stepperColor: Color.white,
                                progressStep: $getUserInfoStep)
                .zIndex(2)
                .padding(.top)

            //MARK: GetUserInfoFlowView Views
            Group {
                switch getUserInfoStep {
                case 0:
                    GetUserNameView(getUserInfoStep: $getUserInfoStep).transition(transition)
                case 1:
                    GetUserGenderView(getUserInfoStep: $getUserInfoStep).transition(transition)
                case 2:
                    GetUserBirthdayView(getUserInfoStep: $getUserInfoStep).transition(transition)
                case 3:
                    GetUserOccupationView(getUserInfoStep: $getUserInfoStep).transition(transition)
                case 4:
                    GetUserRelationshipView(getUserInfoStep: $getUserInfoStep).transition(transition)
                default:
                    VStack {
                        Text("This should not appear")
                        Button("Reset") {
                            getUserInfoStep = 0
                        }
                    }
                }
            }
            .padding(.horizontal, 16) // Equal lateral spacing is given to all views here.
                .zIndex(1) // This is needed to enable transition out animations. It's a bug: https://sarunw.com/posts/how-to-fix-zstack-transition-animation-in-swiftui/
                .accentColor(.text)
                .preferredColorScheme(.dark)
        }
    }
}


struct QuestionText: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.customFontTitle3.bold())
            .foregroundColor(.text)
            .frame(maxWidth: .infinity)
            .minimumScaleFactor(0.5)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
    }
}


struct GetUserInfoContinueButton: View {
    @Environment(\.dismiss) var dismiss
    @Binding var getUserInfoStep: Int
    let finalStep = 4
    var canContinue: Bool
    var body: some View {
        Button {
            if getUserInfoStep == finalStep {
                // nothing here, the last step is without this button since it is multiple choice
            } else if getUserInfoStep == 99 {
                // this means it got called from the profile page
                dismiss()
            }
            else {
                withAnimation(.spring()) {
                    getUserInfoStep += 1
                }
            }
        } label: {
            Text(getUserInfoStep == 99 ? "Save" : getUserInfoStep == finalStep ?  "Finish" : "Continue")
                .modifier(GetUserInfoContinueButtonModifier(canContinue: canContinue))
            
        }
            .disabled(!canContinue)

    }
}


//MARK: Custom modifier for the continue navigation button
struct GetUserInfoContinueButtonModifier: ViewModifier {
    var canContinue: Bool
    func body(content: Content) -> some View {
        content
            .font(.customFontTitle3)
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(canContinue ? Color.marcanaBlue : .gray)
            .foregroundColor(canContinue ? .white : .text)
            .cornerRadius(50)
            .saturation(canContinue ? 1 : 0)
            .padding(.bottom, 24)
            .animation(.easeIn(duration: 0.3), value: canContinue)
            .padding(.horizontal, 24)
            .shadow(radius: 8)
    }
}


struct ChevronBackButton: View {
    @Binding var getUserInfoStep: Int
    var body: some View {
        HStack {
            VStack {
                Button {
                    if getUserInfoStep > 0 {
                        getUserInfoStep -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: 40, height: 40)
                        .tint(Color.text)
                }
                Spacer()
            }
                .opacity(getUserInfoStep == 0 ? 0 : 1)
            Spacer()
        }
            .padding()
    }
}


struct GetUserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        GetUserInfoFlowView()
            .preferredColorScheme(.dark)
    }
}
