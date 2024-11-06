import SwiftUI

struct MaterialInfoView: View {
    var onAdvance: () -> Void

    var body: some View {
        VStack {
            Text("Antes de comenzar asegúrate de tener los materiales necesarios para hacer tu filtro")
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()

            HStack(spacing: 20) {
                Image(systemName: "square.fill")
                Image(systemName: "square.fill")
                Image(systemName: "square.fill")
            }
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
