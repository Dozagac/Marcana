//
//  ProgressStepperView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 01/02/2023.
//

import SwiftUI

struct ProgressStepperView: View {
    var stepperColor: Color
    var progressStep: Int
    var numberOfSteps: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<numberOfSteps) { index in
                Rectangle()
                    .frame(width: 50, height: progressStep >= index + 1 ? 6 : 1.5)
                    .foregroundColor(stepperColor)
                    .cornerRadius(8)
                    .tag(index)
            }
        }
    }
}

struct ProgressStepperViewView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressStepperView(stepperColor: Color.white, progressStep: 2, numberOfSteps: 4)
    }
}
