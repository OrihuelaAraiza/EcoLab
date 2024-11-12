import SwiftUI
import SceneKit

struct Model3DView: UIViewRepresentable {
    
    @Binding var scene: SCNScene?

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
            // Invalidate any existing timer before starting a new one
            rotationTimer?.invalidate()
            
            // Set up a timer to rotate the model continuously
            rotationTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] _ in
                self?.rotationIdle()
            }
        }
        
        private func rotationIdle() {
            // Increment the rotation on the Y-axis
            scene?.rootNode.eulerAngles.y += 0.01
        }
        
        deinit {
            // Clean up the timer if the Coordinator is deinitialized
            rotationTimer?.invalidate()
        }
    }
}
