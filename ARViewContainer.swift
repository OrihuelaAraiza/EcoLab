import ARKit
import SwiftUI
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Configuración básica de AR
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration)
        
        // Agregar modelos 3D o pasos
        addBottleModel(to: arView)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    private func addBottleModel(to arView: ARView) {
        let bottleAnchor = try! Entity.load(named: "BottleModel") // Nombre del modelo 3D de la botella
        bottleAnchor.position = SIMD3(x: 0, y: 0, z: -0.5) // Posiciona el modelo 3D
        
        arView.scene.anchors.append(bottleAnchor as! HasAnchoring)
    }
}
