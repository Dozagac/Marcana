//
//  TestingView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 17/02/2023.
//

import SwiftUI


struct PayWallOptionsTestingView: View {
    var selected = true
    var body: some View {
        HStack(spacing: 16) {
            
            // MARK: - 1
            VStack(alignment: .leading, spacing: 0) {
                Text("Annually")
                    .font(.customFontTitle3)
                    .fontWeight(.black)
                VStack(alignment: .leading){
                    Text("$19.99") +
                    Text("/year")
                    Text("cancel anytime")
                }
                .font(.customFontCaption)
            }
            .frame(height: 125)
            .frame(maxWidth: .infinity)
                .cornerRadius(12)
                .foregroundColor(.text)
                .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray, lineWidth: 1)
            )
            
            // MARK: - 2
            VStack(alignment: .leading, spacing: 0) {
                Text("Annually")
                    .font(.customFontTitle3)
                    .fontWeight(.black)
                VStack(alignment: .leading){
                    Text("$19.99") +
                    Text("/year")
                    Text("cancel anytime")
                }
                .font(.customFontCaption)
            }
            .frame(height: 125)
            .frame(maxWidth: .infinity)
                .cornerRadius(12)
                .foregroundColor(.text)
                .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selected ? Color.white : Color.gray, lineWidth: selected ? 2 : 0.3)
                    .overlay(alignment: .top){
                        Text("Most Selected").bold()
                            .font(.caption)
                            .frame(height: 30)
                            .frame(maxWidth: .infinity)
                            .background(Color.marcanaLightGreen)
                            .cornerRadius(12)
                            .offset(y: -10)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .scaleEffect(1.02)
                    }
            )
            
            // MARK: - 3
            VStack(alignment: .leading, spacing: 0) {
                Text("Annually")
                    .font(.customFontTitle3)
                    .fontWeight(.black)
                VStack(alignment: .leading){
                    Text("$19.99") +
                    Text("/year")
                    Text("cancel anytime")
                }
                .font(.customFontCaption)
            }
            .frame(height: 125)
            .frame(maxWidth: .infinity)
                .cornerRadius(12)
                .foregroundColor(.text)
                .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
        .padding(.horizontal, 16)
    }
}



//VStack(alignment: .leading) {
//    Text("Annually")
//        .font(.customFontTitle3)
//        .fontWeight(.black)
//    VStack{
//        Text("$19.99") +
//        Text("year")
//        Text("cancel anytime")
//    }
//    .font(.customFontCaption)
//}
//    .frame(width: 115, height: 125)
//    .cornerRadius(12)
//    .foregroundColor(.text)
//    .background(
//    RoundedRectangle(cornerRadius: 12)
//        .stroke(selected ? Color.green : Color.gray, lineWidth: selected ? 2 : 0.3)
//)
//}

struct PayWallOptionsTestingView_Previews: PreviewProvider {
    static var previews: some View {
        PayWallOptionsTestingView()
            .preferredColorScheme(.dark)
    }
}
