//
//  TestingView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 26/02/2023.
//

import SwiftUI
import StoreKit

struct TestingView: View {

    // MARK: - PROPERTIES

    @State private var showDiscloureGroup = false
    @State private var showDetails = false

    // MARK: - BODY

    var body: some View {
        VStack {
            DisclosureGroup(isExpanded: $showDiscloureGroup, content: {
                VStack {
                    Text("revelaled")
                        .frame(width: 300)
                        .buttonStyle(PlainButtonStyle()).accentColor(.black)
                }
            }, label:  {
                Toggle("Show Disclosure Group", isOn: $showDiscloureGroup)
                    .foregroundColor(.white)
            })
        }
        .background(.green.opacity(0.5))
            .padding()
    }
}


struct TestingView_Previews: PreviewProvider {
    static var previews: some View {
        TestingView()
    }
}
