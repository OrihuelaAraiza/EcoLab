import SwiftUI

struct BucketDetectionView: View {
    var onAdvance: () -> Void
    var onBack: () -> Void
    @State private var detectionStatus: DetectionStatus = .waitingForBucket
    @State private var hasDetectedGoodCondition = false
    let cameraViewController: CameraViewController

    enum DetectionStatus: Equatable {
        case waitingForBucket
        case bucketLost
        case bucketDetected
        case conditionChecked(BucketCondition)
        case error(String)
    }

    var body: some View {
        ZStack {
            CameraView(
                cameraViewController: cameraViewController,
                onBottleClassificationResult: nil,
                onBucketClassificationResult: { detectionPhase in
                    handleClassificationResult(detectionPhase)
                }
            )
            .blur(radius: 5)
            .overlay(Color.black.opacity(0.5))
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                // Mensajes de estado
                Text("Revisando si detecto una cubeta...")
                    .font(.title2)
                    .foregroundColor(.white)
                    .opacity(detectionStatus == .waitingForBucket ? 1 : 0)
                    .animation(.easeInOut, value: detectionStatus)

                Text("No logro detectar ninguna cubeta")
                    .font(.title2)
                    .foregroundColor(.white)
                    .opacity(detectionStatus == .bucketLost ? 1 : 0)
                    .animation(.easeInOut, value: detectionStatus)

                Text("Cubeta detectada")
                    .font(.title2)
                    .foregroundColor(.white)
                    .opacity(detectionStatus == .bucketDetected ? 1 : 0)
                    .animation(.easeInOut, value: detectionStatus)

                // Mensajes de condición
                Text("La cubeta está en buenas condiciones")
                    .font(.title2)
                    .foregroundColor(.green)
                    .opacity(isCondition(.good) || hasDetectedGoodCondition ? 1 : 0)
                    .animation(.easeInOut, value: detectionStatus)

                Text("La cubeta está en mal estado")
                    .font(.title2)
                    .foregroundColor(.red)
                    .opacity(isCondition(.bad) ? 1 : 0)
                    .animation(.easeInOut, value: detectionStatus)

                Text("No se pudo determinar el estado de la cubeta")
                    .font(.title2)
                    .foregroundColor(.yellow)
                    .opacity(isCondition(.unknown) ? 1 : 0)
                    .animation(.easeInOut, value: detectionStatus)

                // Mensaje de error
                if let errorMessage = getErrorMessage() {
                    Text("Error: \(errorMessage)")
                        .font(.title2)
                        .foregroundColor(.red)
                        .animation(.easeInOut, value: detectionStatus)
                }

                Spacer()

                HStack {
                    Button("Retroceder") {
                        onBack()
                    }
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .clipShape(Capsule())

                    Spacer()

                    if isCondition(.good) || hasDetectedGoodCondition {
                        Button("Avanzar") {
                            onAdvance()
                        }
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, 40)
            }
            .padding()
        }
        .onAppear {
            cameraViewController.startProcessingFrames()
        }
        .onDisappear {
            cameraViewController.stopProcessingFrames()
        }
    }

    private func handleClassificationResult(_ detectionPhase: BucketDetectionPhase) {
        // Si ya se detectó que la cubeta está en buen estado, no actualizar más el estado
        if hasDetectedGoodCondition {
            return
        }

        let newStatus = detectionPhase.toDetectionStatus()
        if detectionStatus != newStatus {
            detectionStatus = newStatus

            if detectionStatus == .conditionChecked(.good) {
                hasDetectedGoodCondition = true
                cameraViewController.stopProcessingFrames() // Detener procesamiento
            }
        }
    }

    private func isCondition(_ condition: BucketCondition) -> Bool {
        if case .conditionChecked(let currentCondition) = detectionStatus {
            return currentCondition == condition
        }
        return false
    }

    private func getErrorMessage() -> String? {
        if case .error(let message) = detectionStatus {
            return message
        }
        return nil
    }
}

extension BucketDetectionPhase {
    func toDetectionStatus() -> BucketDetectionView.DetectionStatus {
        switch self {
        case .checkingForBucket:
            return .waitingForBucket
        case .noBucketDetected:
            return .bucketLost
        case .bucketDetected:
            return .bucketDetected
        case .conditionChecked(let condition):
            return .conditionChecked(condition)
        case .error(let message):
            return .error(message)
        }
    }
}
