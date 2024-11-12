import SwiftUI
import SceneKit

struct Model3DView: UIViewRepresentable {
    
    @Binding var scene: SCNScene?
    var scaleFactor: Float // Add a scale factor parameter

    func makeCoordinator() -> Coordinator {
        Coordinator(scene: scene)
    }
    
    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        view.allowsCameraControl = false
        view.autoenablesDefaultLighting = true
        view.antialiasingMode = .multisampling2X
        view.scene = scene
        view.backgroundColor = .clear
        
        // Apply the scale factor to the scene's root node
        scene?.rootNode.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        
        // Start the continuous rotation
        context.coordinator.startContinuousRotation()
        
        return view
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {}
    
    class Coordinator {
        var rotationTimer: Timer?
        weak var scene: SCNScene?
        
        init(scene: SCNScene?) {
            self.scene = scene
        }
        
        func startContinuousRotation() {
            rotationTimer?.invalidate()
            
            rotationTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] _ in
                self?.rotationIdle()
            }
        }
        
        private func rotationIdle() {
            scene?.rootNode.childNode(withName: "Root", recursively: true)?.eulerAngles.y += 0.01
        }
        
        deinit {
            rotationTimer?.invalidate()
        }
    }
}
