import SwiftUI

struct IntroView: View {
    var onAdvance: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Filtro de agua")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.bottom, 8)
            
            Text("Hecho en casa")
                .font(.title2)
                .foregroundColor(.white)
            
            Spacer()
            
            Spacer()
            
            Button("Avanzar") {
                onAdvance()
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .clipShape(Capsule())
            
            Spacer()

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(12)
    }
    
}
