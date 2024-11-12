import SwiftUI
import SceneKit

struct IntroView: View {
    @State var bottle: SCNScene? = .init(named: "PlasticBottle.scn")
    @State var bucket: SCNScene? = .init(named: "Bucket.scn")
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
            
            HStack {
                Model3DView(scene: $bottle)
                    .frame(height: 150)
                Model3DView(scene: $bucket)
                    .frame(height: 150)
            }
            
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

