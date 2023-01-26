//
//  LoginView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 20/01/2023.
// https://www.youtube.com/watch?v=6bYMc2WUhwk
// https://firebase.google.com/docs/auth/ios/apple

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @StateObject var loginData = LoginViewOO()
    @State private var buttonClicked = false
    
    var body: some View {
        ZStack{
            VideoBackgroundView(videoFileName: "tarotTableVideo", playRate: 0.8)
            
            
            if buttonClicked{
                Rectangle()
                    .frame(width: 60, height: 60)
                    .background(.thinMaterial)
                    .cornerRadius(8)
                    .overlay{
                        ProgressView()
                            .frame(width: 60,height: 60)
                            .tint(.black)
                    }
            }
            
            VStack(alignment: .leading){
                Text("Marcana")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                
                Spacer()

                VStack(alignment: .leading, spacing:25){
                    Text("AI Fortune Teller")
                        .font(.system(size:45))
                        .fontWeight(.heavy)
                    
                    Text("Ask open ended questions, get unique fortunereadings.")
                        .fontWeight(.semibold)
                }
//                .padding(.horizontal, 30)
                Spacer()
                
                //MARK: - Login Buttons
                VStack(spacing:20){
                    SignInWithAppleButton() { (request) in
                        
                        withAnimation{
                            buttonClicked = true
                        }
                        
                        // request parameters from apple login
                        loginData.nonce = randomNonceString()
                        request.requestedScopes = [.email, .fullName]
                        request.nonce = sha256(loginData.nonce)
                    } onCompletion: { (result) in
                        switch result{
                        case .success(let user):
                            print("login success")
                            // Do login with firebase..
                            guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                                print("error with firebase")
                                return
                            }
                            loginData.authenticate(credendial: credential)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    .font(.body)
                    .signInWithAppleButtonStyle(.white)
                    .frame(height: 50)
                    .clipShape(Capsule())
                    .padding(.horizontal, 40)

                    // Anonymous Signin
                    Button{
                        withAnimation{
                            buttonClicked = true
                        }
                        loginData.anonymousSignIn()
                    } label: {
                        Text("Skip for now")
                            .foregroundColor(.white.opacity(0.6))
                            .fontWeight(.semibold)
                    }
                }
                .padding(.bottom, 70)

            }
            .padding()
        }
        .preferredColorScheme(.dark)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.dark)
    }
}
