//
//  GetUserBirthdateView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI

struct GetUserBirthdateView: View {
    @State private var birthday: Date = defaultDate

    static var defaultDate: Date {
        let currentDate = Date()
        let calendar = Calendar.current
        var components = calendar.dateComponents([.month, .day], from: currentDate)
        components.year = 2000
        
        return Calendar.current.date(from: components) ?? Date.now
    }

    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Text("What is your birthday?")
                    .font(.title)
                    .foregroundColor(.text)
                DatePicker("Enter your birthday", selection: $birthday, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                    .colorScheme(.dark)

            }

            if birthday != GetUserBirthdateView.defaultDate {
                VStack {
                    Spacer()
                    Button(action: {
                        // Navigate to the next page
                    }) {
                        Text("Continue")
                            .font(.title3)
                            .padding(.horizontal, 12)
                            .frame(width: 280, height: 30)
                    }
                        .modifier(ContinueNavLinkModifier())
                }
            }
        }
    }
}

struct GetUserBirthdateView_Previews: PreviewProvider {
    static var previews: some View {
        GetUserBirthdateView()
    }
}
