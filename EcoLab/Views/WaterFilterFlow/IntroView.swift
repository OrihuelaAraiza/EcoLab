import SwiftUI
import RealityKit

struct IntroView: View {
    var onAdvance: () -> Void
    
    var body: some View {
        VStack {
            Text("Filtro de agua")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.bottom, 8)
            
            Text("Hecho en casa")
                .font(.title2)
                .foregroundColor(.white)
            
            Spacer()
            
            Model3DView()
                .frame(width: 150, height: 150)
                .padding()
            
            Spacer()
            
            Button("Avanzar") {
                onAdvance()
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(12)
        .padding()
    }
}

struct Model3DView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        let modelEntity = try! ModelEntity.loadModel(named: "bottleWater")
        modelEntity.scale = SIMD3<Float>(0.1, 0.1, 0.1)
        let anchorEntity = AnchorEntity(world: [0, -0.7, 0])
        anchorEntity.addChild(modelEntity)
        
        arView.scene.addAnchor(anchorEntity)
        
        startRotation(entity: modelEntity)
        
        arView.environment.background = .color(.clear)
        
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
    
    private func startRotation(entity: Entity) {
        let rotationDuration: TimeInterval = 5.0
        let rotateTransform = Transform(pitch: 0, yaw: .pi * 2, roll: 0)
        
        entity.move(to: rotateTransform, relativeTo: entity, duration: rotationDuration, timingFunction: .linear)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + rotationDuration) {
            self.startRotation(entity: entity)
        }
    }
}
