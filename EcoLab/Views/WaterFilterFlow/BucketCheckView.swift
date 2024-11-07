import SwiftUI

struct BucketCheckView: View {
    var onAdvance: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Text("Verifiquemos el estado de tu cubeta")
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
