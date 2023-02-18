//
//  CardBackSelectionView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 18/02/2023.
//

import SwiftUI

enum CardBacks: Int, CaseIterable {
    case facedownCard1 = 1
    case facedownCard2
    case facedownCard3
    case facedownCard4
    case facedownCard5
    
    var displayName: String {
        switch self {
        case .facedownCard1:
            return "Card Back 1"
        case .facedownCard2:
            return "Card Back 2"
        case .facedownCard3:
            return "Card Back 3"
        case .facedownCard4:
            return "Card Back 4"
        case .facedownCard5:
            return "Card Back 5"
        }
    }
}

struct CardBackSelectionView: View {
    @AppStorage("selectedCardBack") var selectedCardBack: Int = CardBacks.facedownCard1.rawValue
    
    var body: some View {
        TabView {
            ForEach(CardBacks.allCases, id: \.self) { cardBack in
                VStack{
                    Image(cardBack.rawValue == 1 ? "facedownCard1" : "facedownCard\(cardBack.rawValue)")
                        .resizable()
                        .frame(width: 300, height: 450)
                        .aspectRatio(contentMode: .fit)
                    
                    Text(cardBack.displayName)
                           .font(.customFontTitle2)
                           .fontWeight(.thin)
                           .foregroundColor(.text)
                }
                
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .onChange(of: selectedCardBack) { newValue in
            // Save selected card back to AppStorage
            selectedCardBack = newValue
        }
    }
}

struct CardBackSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CardBackSelectionView()
    }
}
