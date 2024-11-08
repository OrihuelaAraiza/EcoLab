import SwiftUI

struct ProgressBar: View {
    let currentStep: Int
    let totalSteps: Int = 3

    var body: some View {
        HStack(spacing: 20) {
            ForEach(0..<totalSteps) { index in
                HStack(spacing: 0) {
                    Circle()
                        .fill(index < currentStep ? Color.green : Color.black)
                        .frame(width: 40, height: 40)
                        .overlay(Text("\(index + 1)").foregroundColor(.white).font(.headline))
                    if index < totalSteps - 1 {
                        Rectangle()
                            .fill(index < currentStep ? Color.green : Color.black)
                            .frame(width: 50, height: 6)
                    }
                }
            }
        }
    }
}
