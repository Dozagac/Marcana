//
//  GetUserBirthdateView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI

struct GetUserBirthdateView: View {
    @State private var birthday: Date = Date()
    private var defaultDate = Date()

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

            if birthday != defaultDate {
                VStack {
                    Spacer()
                    Button(action: {
                        // Navigate to the next page
                    }) {
                        Text("Continue")
                            .font(.title3)
                            .padding(.horizontal, 10)
                            .frame(width: 280, height: 30)
                    }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.automatic)
                        .controlSize(.large)
                        .tint(.foreground)
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
