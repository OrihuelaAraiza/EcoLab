import SwiftUI

struct BucketCheckView: View {
    var onAdvance: () -> Void
    var onBack: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Text("Verifiquemos el estado de tu cubeta")
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            HStack {
                Button("Regresar") {
                    onBack()
                }
                .bold()
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .clipShape(Capsule())

                Button("Avanzar") {
                    onAdvance()
                }
                .bold()
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(12)
        .padding()
    
    }
}
