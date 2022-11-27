//
//  Deck.swift
//  Marcana
//
//  Created by Deniz Ozagac on 26/11/2022.
//

import Foundation

class Deck: ObservableObject{
    let allCards: [Card]
    
    init(){
        let url = Bundle.main.url(forResource: "tarot", withExtension: ".json")!
        let data = try! Data(contentsOf: url)
        allCards = try! JSONDecoder().decode([Card].self, from: data)
    }
}



//class Locations: ObservableObject {
//    let places: [Location]
//
//    var primary: Location {
//        places[0]
//    }
//
//    init() {
//        // ! is the rookie way of doing it. "Crash operator" is its name afterall. I'll learn better, safer ways later.
//        // find locations.json
//        let url = Bundle.main.url(forResource: "locations", withExtension: ".json")!
//        // read the data
//        let data = try! Data(contentsOf: url)
//        // place it into a list. .self is required. Means we are referring to an array of locations, generally not a specific one.
//        places = try! JSONDecoder().decode([Location].self, from: data) // the struct it is reading (Location) should inherid "Decodable"
//    }
//}
