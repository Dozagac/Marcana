//
//  Deck.swift
//  Marcana
//
//  Created by Deniz Ozagac on 26/11/2022.
//

import Foundation

class Deck: ObservableObject {
    let allCards: [Card]
    
    init(){
        let url = Bundle.main.url(forResource: "tarot", withExtension: ".json")!
        let data = try! Data(contentsOf: url)
        allCards = try! JSONDecoder().decode([Card].self, from: data)
    }
}

