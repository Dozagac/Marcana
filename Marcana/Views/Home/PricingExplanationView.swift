//
//  PricingExplanationView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 27/02/2023.
//

import SwiftUI

struct PricingExplanationView: View {
    let pricingExplanationText = """
Good question!

Our app provides personalized tarot readings that require effort and resources to create.

As a result, we cannot offer it for free. 😔

To make the app accessible to everyone, we offer a range of pricing options, including an affordable weekly option.
    
Thank you for your support!

Best regards,
Marcana Team
"""
    
    var body: some View {
//        ZStack{
//
            ScrollView(showsIndicators: true){
                ZStack(alignment: .bottomTrailing){
        //            BackgroundView()
                    
                    Image("ConfusedOwl2")
                        .resizable()
                        .scaledToFit()
                        .frame(height: UIScreen.main.bounds.height * 0.18)
                        .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
                    
                    Text(pricingExplanationText)
                        .font(.customFontHeadline)
                        .multilineTextAlignment(.leading)
                        .padding()
                }
                .padding(.top)
            }
//        }
//        .edgesIgnoringSafeArea(.bottom)
    }
}

struct PricingExplanationView_Previews: PreviewProvider {
    static var previews: some View {
        PricingExplanationView()
    }
}
