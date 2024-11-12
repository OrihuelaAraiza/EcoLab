import SwiftUI

struct IntroView: View {
    var onAdvance: () -> Void
    var onBack: () -> Void // New back action

    var body: some View {
        VStack {
            Spacer()
            
            Text("Filtro de agua")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
                .padding(.bottom, 8)
            
            Text("Hecho en casa")
                .font(.title2)
                .foregroundColor(.white)
            
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
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(12)
    }
}
