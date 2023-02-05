//
//  GetUserOccupationView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI

struct GetUserOccupationView: View {
    @Binding var doUserInfoFlow: Int
    @AppStorage("userOccupation") var userOccupation = ""
    @FocusState private var focusTextField

    private var canContinue: Bool {
        userOccupation.isNotEmpty
    }

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 50)
                VStack(spacing: 12) {
                    Image(systemName: "briefcase.fill")
                        .font(.largeTitle)
                    QuestionText(text: "What is your job/occupation?")
                    Text("Your occupation can provide insight into your life path and give us a better understanding of your current life situation.")
                        .multilineTextAlignment(.center)
                        .font(.customFontCallout)
                        
                    TextField("Enter your occupation", text: $userOccupation, prompt: Text("Job"))
                        .padding(.top, 12)
                        .font(.customFontTitle3)
                        .foregroundColor(.text)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.plain)
                        .focused($focusTextField)
                        .onSubmit {
                        if userOccupation.isNotEmpty {
                            doUserInfoFlow += 1
                            focusTextField = false
                        }
                    }
                }
                    .padding(24)
                    .background(.ultraThinMaterial)
                    .cornerRadius(48)
                
                Spacer()
            }

            //MARK: Continue Button
            VStack {
                Spacer()
                GetUserInfoContinueButton(doUserInfoFlow: $doUserInfoFlow, canContinue: canContinue)
                    .simultaneousGesture(TapGesture().onEnded {
                    focusTextField = false
                })
            }
        }
            .onAppear {
            // this is necessary to make focus work
            DispatchQueue.main.async { focusTextField = true }
        }
    }
}


struct GetUserOccupationView_Previews: PreviewProvider {
    @State static var doUserInfoFlow = 3
    static var previews: some View {
        GetUserOccupationView(doUserInfoFlow: $doUserInfoFlow)
            .environmentObject(MockUserOO())
            .preferredColorScheme(.dark)
    }
}
