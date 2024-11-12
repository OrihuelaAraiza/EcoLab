import SwiftUI
import SceneKit

struct MaterialInfoView: View {
    @State private var bottle: SCNScene? = nil
    @State private var bucket: SCNScene? = nil
    @State private var cloth: SCNScene? = nil
    @State private var isLoaded = false
    var onAdvance: () -> Void
    var onBack: () -> Void

    var body: some View {
        VStack {
            Spacer()
            
            if isLoaded {
                Text("Antes de comenzar asegúrate de tener los materiales necesarios para hacer tu filtro")
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()

                HStack(spacing: -15){
                    Model3DView(scene: $bottle, scaleFactor: 1)
                        .frame(height: 120)
                    Model3DView(scene: $bucket, scaleFactor: 1)
                        .frame(height: 120)
                    Model3DView(scene: $cloth, scaleFactor: 0.6)
                        .frame(height: 120)
                }
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
                
                Spacer()
            } else {
                ProgressView("Cargando...")
                    .foregroundColor(.white)
                    .font(.title)
            }
            

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(12)
        .padding()
        .onAppear {
            loadModels()
        }
        
    }
    
    private func loadModels() {
        DispatchQueue.global(qos: .userInitiated).async {
            let loadedBottle = SCNScene(named: "PlasticBottle.scn")
            let loadedBucket = SCNScene(named: "Bucket.scn")
            let loadedCloth = SCNScene(named: "Cloth.scn")
            
            DispatchQueue.main.async {
                self.bottle = loadedBottle
                self.bucket = loadedBucket
                self.cloth = loadedCloth
                self.isLoaded = true
            }
        }
    }
}
