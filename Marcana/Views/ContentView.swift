//
//  ContentView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 26/11/2022.
//

// http://www.aquatictarot.de/deck/list_major.html
// https://gist.github.com/ajzeigert/32461d73c17cfd8fd475c0049db451f5

import SwiftUI

struct startButton {
    let title: String
    let subtitle: String
    let imageName: String

    static let example = startButton(
        title: "Read 1 card",
        subtitle: "seek answers to a question",
        imageName: "threeReader")
}


struct ContentView: View {
    var body: some View {
        
        
        
            VStack {
                
                NavigationLink(destination: SingleReaderView(), label: {
                    startChoiceCard(buttonInfo: startButton(
                        title: "Read 1 card",
                        subtitle: "Read the vibe of the day",
                        imageName: "threeReader"))
                })

                
                Spacer().frame(height: 24)
                
                
                NavigationLink(destination: ThreeReaderView(), label: {
                    startChoiceCard(buttonInfo: startButton(
                        title: "Read 3 cards",
                        subtitle: "Seek answers to a question",
                        imageName: "singleReader"))
                })
            }
            .navigationBarTitle("Start Screen")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




