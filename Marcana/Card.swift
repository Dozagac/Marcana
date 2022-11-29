//
//  Cards.swift
//  Marcana
//
//  Created by Deniz Ozagac on 26/11/2022.
//

import Foundation

struct Card: Decodable, Identifiable {
    let id: Int
    let name: String
    let suite: Suite
    let image: String
    let description: String
    let interpretation: String
    
    enum Suite: String, Decodable {
        case major
        case wands
        case pentacles
        case swords
        case cups
        
        var name: String {
            return rawValue
        }
    }
}



