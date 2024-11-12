import SwiftUI

struct FinishView: View {
    var onAdvance: () -> Void
    var onBack: () -> Void // New back action

    var body: some View {
        VStack {
            Spacer()
            
            Text("¡Ahora puedes filtrar agua!")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
                .padding(.bottom, 8)
            
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

                Button("Volver al menú") {
                    onAdvance()
                }
                .bold()
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(12)
    }
}
