import SwiftUI

struct DeveloperPassView: View {
    var onAdvance: () -> Void
    var onBack: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Text("Developer Mode, have fun debbuging")
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            HStack {
                Button("Regresar") {
                    onBack()
                }
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .clipShape(Capsule())

                Button("Avanzar") {
                    onAdvance()
                }
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
