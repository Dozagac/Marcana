//
//  TestingView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI

struct TestingView: View {
    @State private var name: String = ""
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Spacer()
                QuestionText(text: "Hello, seeker of answers")
                TextField("Enter your name", text: $name, prompt: Text("What is your name?"))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                Spacer()
            }
            .frame(width: .infinity)
            .background(.red)
        .padding(120)
        }
    }
}



struct TestingView_Previews: PreviewProvider {
    static var previews: some View {
        TestingView()
    }
}
