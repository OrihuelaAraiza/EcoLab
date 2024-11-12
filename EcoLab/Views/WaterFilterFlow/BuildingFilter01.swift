import SwiftUI
import RealityKit
import ARKit

struct BuildingFilter01View: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Configure AR session
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        arView.session.run(configuration)
        
        // Add coaching overlay to guide users to move their device
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.session = arView.session
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.activatesAutomatically = true
        arView.addSubview(coachingOverlay)
        
        // Tap gesture to place the bucket
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        context.coordinator.arView = arView
        
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    class Coordinator: NSObject {
        weak var arView: ARView?
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let arView = arView else { return }
            
            let location = gesture.location(in: arView)
            let results = arView.hitTest(location, types: .existingPlaneUsingExtent)
            
            if let result = results.first {
                placeBucket(at: result.worldTransform, in: arView)
            }
        }
        
        private func placeBucket(at transform: simd_float4x4, in arView: ARView) {
            // Load the bucket model
            guard let bucketEntity = try? ModelEntity.load(named: "bucket") else {
                print("Failed to load bucket model")
                return
            }
            
            bucketEntity.scale = SIMD3<Float>(0.5, 0.5, 0.5) // Scale the bucket
            
            // Create an anchor and place the model
            let anchor = AnchorEntity(world: transform)
            anchor.addChild(bucketEntity)
            arView.scene.addAnchor(anchor)
        }
    }
}

// SwiftUI wrapper to display the AR view and overlay text
struct BuildingFilter01: View {
    var onAdvance: () -> Void
    var onBack: () -> Void
    
    var body: some View {
        ZStack {
            BuildingFilter01View()
                .edgesIgnoringSafeArea(.all)

            VStack {                
                Spacer()

                Text("Coloca tu cubeta para captar el agua, en el lugar que desees")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.bottom, 50)

                // Buttons at the bottom
                HStack {
                    Button(action: onBack) {
                        Text("Regresar")
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                    
                    Spacer().frame(width: 20)
                    
                    Button(action: onAdvance) {
                        Text("Avanzar")
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
