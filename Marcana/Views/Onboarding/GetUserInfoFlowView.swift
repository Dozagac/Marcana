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
    let transition: AnyTransition = .asymmetric(insertion: .move(edge: .trailing),
                                                removal: .move(edge: .leading))
    @StateObject var user = UserOO()
    @State var getUserInfoStep: Int = 0

    var body: some View {

        ZStack(alignment: .top) {
//            VideoBackgroundView(videoFileName: "tarotTableVideo", playRate: 0.8)
            BackgroundView()

            ChevronBackButton(doUserInfoFlow: $getUserInfoStep)
            
            ProgressStepperView(stepperColor: Color.white,
                                  doUserInfoFlow: $getUserInfoStep)
                .zIndex(2)
//                .padding(.top, 50) // this is half the height of the spacer used in all the views

            //MARK: GetUserInfoFlowView Views
            Group {
                switch getUserInfoStep {
                case 0:
                    GetUserNameView(doUserInfoFlow: $getUserInfoStep).transition(transition)
                case 1:
                    GetUserGenderView(doUserInfoFlow: $getUserInfoStep).transition(transition)
                case 2:
                    GetUserBirthdayView(doUserInfoFlow: $getUserInfoStep).transition(transition)
                case 3:
                    GetUserOccupationView(doUserInfoFlow: $getUserInfoStep).transition(transition)
                case 4:
                    GetUserRelationshipView(doUserInfoFlow: $getUserInfoStep).transition(transition)
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
            .environmentObject(user)
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
    @Binding var doUserInfoFlow: Int
    let finalStep = 4
    var canContinue: Bool
    var body: some View {
        Button {
            if doUserInfoFlow == finalStep {
                // nothing here, the last step is without this button since it is multiple choice
            } else if doUserInfoFlow == 99 {
                // this means it got called from the profile page
                dismiss()
            }
            else {
                withAnimation(.spring()) {
                    doUserInfoFlow += 1
                }
            }
        } label: {
            Text(doUserInfoFlow == 99 ? "Save" : doUserInfoFlow == finalStep ?  "Finish" : "Continue")
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
            .frame(width: 280, height: 50)
            .background(canContinue ? Color.text : .purple)
            .foregroundColor(canContinue ? .black : .text)
            .cornerRadius(12)
            .saturation(canContinue ? 1 : 0)
            .padding(.bottom, 24)
            .animation(.easeIn(duration: 0.3), value: canContinue)
            .shadow(radius: 8)
    }
}


struct ChevronBackButton: View {
    @Binding var doUserInfoFlow: Int
    var body: some View {
        HStack {
            VStack {
                Button {
                    if doUserInfoFlow > 0 {
                        doUserInfoFlow -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: 40, height: 40)
                        .tint(Color.text)
                }
                Spacer()
            }
                .opacity(doUserInfoFlow == 0 ? 0 : 1)
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
