import SwiftUI

struct IntroView: View {
    var onAdvance: () -> Void
    
    var body: some View {
        VStack {
            Text("Filtro de agua")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.bottom, 8)
            
            Text("Hecho en casa")
                .font(.title2)
                .foregroundColor(.white)
            
            Button("Avanzar") {
                onAdvance()
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Asegura el centrado total
        .cornerRadius(12)
    }
}
