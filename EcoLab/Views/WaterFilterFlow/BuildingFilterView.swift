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

// SwiftUI wrapper para la vista de AR y controles adicionales
struct BuildingFilter: View {
    var onBack: () -> Void
    @State private var isAnimating = false // Estado para el botón "Ver cómo se hace" / "Detener"
    
    var body: some View {
        ZStack {
            BuildingFilterView()
                .edgesIgnoringSafeArea(.all)

            VStack {
                // Botón de "Regresar" en la esquina superior izquierda
                HStack {
                    Button(action: onBack) {
                        Text("Regresar")
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
                
                Spacer()
                
            }
            .padding()
        }
        .edgesIgnoringSafeArea(.all)
        .background(.clear)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
