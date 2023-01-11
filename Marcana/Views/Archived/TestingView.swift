//
//  TestingView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 10/01/2023.
//

import SwiftUI

struct TestingView: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.foreground)
                .frame(width: 190, height: 190)
                .foregroundColor(Color.text)
                .overlay(RoundedRectangle(cornerRadius: 20)
                .stroke(Color.text, lineWidth: 1).background(.clear))
                .overlay(
                    VStack {
                        Image("GenderMaleWhite")
                        Text("Male")
                            .font(.title2)
                    })
            
            VStack {
                Image("GenderMaleWhite")
                Text("Male")
                    .font(.title2)
            }
                .frame(width: 190, height: 190)
                .background(Color.foreground)
                .foregroundColor(Color.text)
                .overlay(RoundedRectangle(cornerRadius: 20)
                .stroke(Color.text, lineWidth: 1).background(.clear))
        }
    }
}


struct TestingView_Previews: PreviewProvider {
    static var previews: some View {
        TestingView()
            .preferredColorScheme(.dark)
    }
}
