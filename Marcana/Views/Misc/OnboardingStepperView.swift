//
//  ProgressStepperView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 01/02/2023.
//

import SwiftUI

struct ProgressStepperView: View {
    var stepperColor : Color
    @Binding var doUserInfoFlow: Int
    
    var body: some View {
        HStack(spacing: 4) {
            
            Rectangle()
                .frame(width: 50, height: doUserInfoFlow >= 0 ? 6 : 1.5)
                .foregroundColor(stepperColor)
                .cornerRadius(8)
                .tag(0)

            Rectangle()
                .frame(width: 50, height: doUserInfoFlow >= 1 ? 6 : 1.5)
                .foregroundColor(stepperColor)
                .cornerRadius(8)
                .tag(1)
            Rectangle()
                .frame(width: 50, height: doUserInfoFlow >= 2 ? 6 : 1.5)
                .foregroundColor(stepperColor)
                .cornerRadius(8)
                .tag(2)
            Rectangle()
                .frame(width: 50, height: doUserInfoFlow >= 3 ? 6 : 1.5)
                .foregroundColor(stepperColor)
                .cornerRadius(8)
                .tag(3)
            Rectangle()
                .frame(width: 50, height: doUserInfoFlow >= 4 ? 6 : 1.5)
                .foregroundColor(stepperColor)
                .cornerRadius(8)
                .tag(4)
        }
    }
}

struct ProgressStepperViewView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressStepperView(stepperColor: Color.red, doUserInfoFlow: .constant(2))
    }
}
