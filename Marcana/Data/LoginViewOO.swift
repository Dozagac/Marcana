//
//  LoginViewModel.swift
//  Marcana
//
//  Created by Deniz Ozagac on 20/01/2023.
//

import AuthenticationServices
import CryptoKit
import Firebase
import Foundation
import SwiftUI

class LoginViewOO: ObservableObject {
    @Published var nonce = ""
    @AppStorage(wrappedValue: false, "log_status") var log_Status
    
    func authenticate(credendial: ASAuthorizationAppleIDCredential){
        // Getting token
        guard let token = credendial.identityToken else {
            print("error with firebase - token")
            return
        }
        
        // Token String
        guard let tokenString = String(data: token, encoding: .utf8) else{
            print("error with Token")
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
        
        Auth.auth().signIn(with: firebaseCredential) { result, err in
            if let error = err{
                print(error.localizedDescription)
                return
            }
            
            // User Successfully Logged into Firebase...
            print("Apple login successfull")
            
            //Directing User to the Home Page
            withAnimation(.easeOut){
                self.log_Status = true
            }
        }
    }
    
    func anonymousSignIn(){
        Auth.auth().signInAnonymously { result, err in
            if let error = err{
                print(error.localizedDescription)
                return
            }
            
            // User Successfully Logged into Firebase...
            print("Anonymous login successfull")
            
            guard let user = result?.user else { return }
//            let isAnonymous = user.isAnonymous  // true
//            let uid = user.uid
            
            //Directing User to the Home Page
            withAnimation(.easeOut){
                self.log_Status = true
            }
        }
    }
}

// Helpers for apple login with FireBase

// Hashing function for the nonce
func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()

    return hashString
}


func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length

    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError(
                    "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                )
            }
            return random
        }

        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }

            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }

    return result
}
