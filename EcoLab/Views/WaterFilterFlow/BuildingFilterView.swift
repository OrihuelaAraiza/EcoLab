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
        
        func playAnimation() {
            // Reproducir la animación desde el inicio
            bucketEntity?.playAnimation(named: "animationName", // Cambia "animationName" al nombre exacto de la animación
                                        transitionDuration: 0.3,
                                        startsPaused: false)
        }
        
        func pauseAnimation() {
            // Pausar la animación
            bucketEntity?.stopAllAnimations()
        }
    }
}

// SwiftUI wrapper para la vista de AR y controles adicionales
struct BuildingFilterTest: View {
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
                
                // Botones de control de animación en el centro
                HStack {
                    Button(action: {
                        if isAnimating {
                            // Detener la animación
                            BuildingFilterView.Coordinator().pauseAnimation()
                        } else {
                            // Iniciar la animación
                            BuildingFilterView.Coordinator().playAnimation()
                        }
                        isAnimating.toggle() // Cambiar el estado
                    }) {
                        Text(isAnimating ? "Detener" : "Ver cómo se hace")
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                }
                .padding(.bottom, 30)
            }
            .padding()
        }
    }
}
