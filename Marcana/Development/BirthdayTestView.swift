//
//  BirthdayTestView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 29/01/2023.
//

import SwiftUI

import SwiftUI

struct BirthdayTestView: View {
    @AppStorage("birthday") var birthdayTimeInterval: Double = 0

    var body: some View {
        VStack {
            DatePicker(selection: birthday, displayedComponents: .date) {
                Text("Select your birthday")
            }
        }
    }
    var birthday: Binding<Date> {
        Binding<Date>(
            get: {
                return Date(timeIntervalSince1970: self.birthdayTimeInterval)
            },
            set: {
                self.birthdayTimeInterval = $0.timeIntervalSince1970
            }
        )
    }
}

struct BirthdayTestView_Previews: PreviewProvider {
    static var previews: some View {
        BirthdayTestView()
    }
}
