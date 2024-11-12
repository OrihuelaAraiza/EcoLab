import SwiftUI
import RealityKit
import ARKit

struct BuildingFilterView: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Configuración de AR
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        arView.session.run(configuration)
        
        // Cargar el modelo y establecer la animación
        context.coordinator.loadModel(arView: arView)
        
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    class Coordinator: NSObject {
        var bucketEntity: Entity?
        
        func loadModel(arView: ARView) {
            // Cargar el archivo usdz con la animación
            if let bucketEntity = try? Entity.load(named: "BuildingScene") { // Cambia "BuildingScene" al nombre exacto de tu archivo
                self.bucketEntity = bucketEntity
                bucketEntity.scale = SIMD3<Float>(0.1, 0.1, 0.1) // Reducir la escala del modelo

                // Crear un ancla y agregar la entidad al ARView
                let anchorEntity = AnchorEntity(plane: .horizontal)
                anchorEntity.addChild(bucketEntity)
                arView.scene.addAnchor(anchorEntity)
            } else {
                print("Error al cargar el modelo.")
            }
        }
        
    }
}

struct BuildingFilter: View {
    var onBack: () -> Void
    var onAdvance: () -> Void
    
    var body: some View {
        ZStack {
            BuildingFilterView()
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Button(action: onBack) {
                        Text("Regresar")
                            .bold()
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                    
                    Button(action: onAdvance) {
                        Text("Avanzar")
                            .bold()
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.trailing, 20)
                }
                .padding(.top, 20)
                
                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black.opacity(0.6))
                        .frame(width: 400, height: 120)
                        .shadow(radius: 10)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("1. Toca la flecha verde para empezar")
                        Text("2. Coloca la cubeta en algún lugar plano")
                        Text("3. Coloca el trapo encima de la cubeta")
                        Text("4. Utiliza la botella o botellas para guiar el agua a la cubeta")
                        Text("5. ¡Listo!")
                    }
                    .padding()
                    .foregroundColor(.white)
                    .font(.system(size: 8))
                    .bold()
                    .multilineTextAlignment(.leading)
                    .frame(width: 400, height: 120)
                }
                .padding(.bottom, 30)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
