import SwiftUI
import RealityKit
import ARKit

struct BuildingFilter01View: UIViewRepresentable {

    @Binding var coachingCompleted: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(coachingCompleted: $coachingCompleted)
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        arView.session.run(configuration)

        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.session = arView.session
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.delegate = context.coordinator  // Set the delegate
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        arView.addSubview(coachingOverlay)

        NSLayoutConstraint.activate([
            coachingOverlay.topAnchor.constraint(equalTo: arView.topAnchor),
            coachingOverlay.leadingAnchor.constraint(equalTo: arView.leadingAnchor),
            coachingOverlay.trailingAnchor.constraint(equalTo: arView.trailingAnchor),
            coachingOverlay.bottomAnchor.constraint(equalTo: arView.bottomAnchor)
        ])

        // Tap gesture to handle the sequence of steps
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        context.coordinator.arView = arView

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    class Coordinator: NSObject, ARCoachingOverlayViewDelegate {
        weak var arView: ARView?
        @Binding var coachingCompleted: Bool

        var currentStep = 0
        var bucketAnchor: AnchorEntity?

        init(coachingCompleted: Binding<Bool>) {
            self._coachingCompleted = coachingCompleted
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            // Only handle taps after coaching is completed
            guard coachingCompleted, let arView = arView else { return }

            switch currentStep {
            case 0:
                // First tap: Place the bucket in front of the camera
                placeBucket(in: arView)
                currentStep += 1
            case 1:
                // Second tap: Place the cloth above the bucket
                if let bucketAnchor = bucketAnchor {
                    placeCloth(above: bucketAnchor)
                    currentStep += 1
                }
            case 2:
                // Third tap: Place the bottle pointing to the bucket
                if let bucketAnchor = bucketAnchor {
                    placeBottle(towards: bucketAnchor)
                    currentStep += 1
                }
            default:
                // Do nothing or reset steps if needed
                break
            }
        }

        private func placeBucket(in arView: ARView) {
            // Get the camera transform
            let cameraTransform = arView.cameraTransform

            // Create a position 0.5 meters in front of the camera
            let distanceInFront: Float = -0.5 // Negative Z is in front of the camera
            let forwardVector = cameraTransform.matrix.columns.2
            let translationVector = SIMD3<Float>(forwardVector.x, forwardVector.y, forwardVector.z) * distanceInFront
            let bucketPosition = cameraTransform.translation + translationVector

            // Create a transform for the bucket
            var bucketTransform = matrix_identity_float4x4
            bucketTransform.columns.3 = SIMD4<Float>(bucketPosition.x, bucketPosition.y, bucketPosition.z, 1)

            // Load the bucket model
            guard let bucketEntity = try? ModelEntity.load(named: "bucket") else {
                print("Failed to load bucket model")
                return
            }

            bucketEntity.scale = SIMD3<Float>(0.1, 0.1, 0.1) // Adjusted scale to make it smaller

            // Create an anchor and place the model
            let anchor = AnchorEntity(world: bucketTransform)
            anchor.addChild(bucketEntity)
            arView.scene.addAnchor(anchor)

            // Store the bucket's anchor for future reference
            bucketAnchor = anchor
        }

        private func placeCloth(above bucketAnchor: AnchorEntity) {
            // Load the cloth model
            guard let clothEntity = try? ModelEntity.load(named: "cloth") else {
                print("Failed to load cloth model")
                return
            }

            // Adjust the scale of the cloth
            clothEntity.scale = SIMD3<Float>(0.002, 0.002, 0.002) // Adjusted scale to match the bucket's size

            // Position the cloth above the bucket
            let startPosition = SIMD3<Float>(0, 0.5, 0) // Start 0.5 meters above the bucket
            clothEntity.position = startPosition

            // Add the cloth to the bucket's anchor
            bucketAnchor.addChild(clothEntity)

            // Animate the cloth moving down to just above the bucket
            let endPosition = SIMD3<Float>(0, 0.1, 0) // 0.1 meters above the bucket
            let animationDuration: TimeInterval = 1.0

            clothEntity.move(
                to: Transform(
                    scale: clothEntity.scale,
                    rotation: clothEntity.orientation,
                    translation: endPosition
                ),
                relativeTo: bucketAnchor,
                duration: animationDuration,
                timingFunction: .easeInOut
            )
        }

        private func placeBottle(towards bucketAnchor: AnchorEntity) {
            // Load the bottle model
            guard let bottleEntity = try? ModelEntity.load(named: "bottle") else {
                print("Failed to load bottle model")
                return
            }

            // Adjust the scale of the bottle
            bottleEntity.scale = SIMD3<Float>(0.005, 0.005, 0.005) // Adjusted scale to match the other models

            // Position the bottle some distance away from the bucket
            let startPosition = SIMD3<Float>(0, 0.2, -0.5) // Start 0.5 meters in front of the bucket
            bottleEntity.position = startPosition

            // Rotate the bottle to face the bucket
            let direction = normalize(SIMD3<Float>(0, 0, 0) - startPosition)
            let bottleOrientation = simd_quatf(from: [0, 0, -1], to: direction)
            bottleEntity.orientation = bottleOrientation

            // Add the bottle to the bucket's anchor
            bucketAnchor.addChild(bottleEntity)

            // Animate the bottle moving towards the bucket
            let endPosition = SIMD3<Float>(0, 0.2, -0.1) // Move closer to the bucket
            let animationDuration: TimeInterval = 1.0

            bottleEntity.move(
                to: Transform(
                    scale: bottleEntity.scale,
                    rotation: bottleOrientation,
                    translation: endPosition
                ),
                relativeTo: bucketAnchor,
                duration: animationDuration,
                timingFunction: .easeInOut
            )
        }

        // MARK: - ARCoachingOverlayViewDelegate Methods

        func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
            // Plane detection is completed
            coachingCompleted = true
        }

        func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
            // Plane detection is starting
            coachingCompleted = false
        }

        func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {}
    }
}

struct BuildingFilter01: View {
    var onAdvance: () -> Void
    var onBack: () -> Void

    @State private var coachingCompleted = false  // State variable to track coaching completion

    var body: some View {
        ZStack {
            BuildingFilter01View(coachingCompleted: $coachingCompleted)
                .edgesIgnoringSafeArea(.all)
        }
        .background(Color.black.opacity(0.5))
    }
}
