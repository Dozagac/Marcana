//
//  Cards.swift
//  Marcana
//
//  Created by Deniz Ozagac on 26/11/2022.
//

import Foundation

struct Card: Decodable {
    let name: String
    let suite: String
    let image: String
    let description: String
    let interpretation: String
}


//    "The Magician",
//    "The High Priestess",
//    "The Empress",
//    "The Emperor",
//    "The Hierophant",
//    "The Lovers",
//    "The Chariot",
//    "Strength,
//    "The Hermit",
//    "Wheel of Fortune,
//    "Justice,
//    "The Hanged Man,
//    "Death,
//    "Temperance",
//    "The Devil",
//    "The Tower",
//    "The Star",
//    "The Moon",
//    "The Sun",
//    "Judgement,
//    "The World",
//    "The Fool",

