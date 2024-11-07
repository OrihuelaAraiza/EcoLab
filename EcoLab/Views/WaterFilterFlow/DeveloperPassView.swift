import SwiftUI

struct DeveloperPassView: View {
    var onAdvance: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Text("Developer Mode, have fun debbuging")
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            Button("Avanzar") {
                onAdvance()
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(12)
        .padding()
    
    }
}
