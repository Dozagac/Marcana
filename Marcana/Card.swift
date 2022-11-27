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

