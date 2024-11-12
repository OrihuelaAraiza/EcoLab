import SwiftUI

struct BottleDetectionView: View {
    var onAdvance: () -> Void
    var onBack: () -> Void
    @State private var detectionStatus: DetectionStatus = .waitingForBottle
    @State private var hasDetectedGoodCondition = false // Nueva variable
    let cameraViewController: CameraViewController

    enum DetectionStatus: Equatable {
        case waitingForBottle
        case bottleLost
        case bottleDetected
        case conditionChecked(BottleCondition)
        case error(String)
    }

    var body: some View {
        ZStack {
            CameraView(
                cameraViewController: cameraViewController,
                onBottleClassificationResult: { detectionPhase in
                    handleClassificationResult(detectionPhase)
                }, onBucketClassificationResult: nil
            )
            .blur(radius: 5)
            .overlay(Color.black.opacity(0.5))
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                // Mensaje: Revisando si detecto una botella...
                Text("Revisando si detecto una botella...")
                    .font(.title2)
                    .foregroundColor(.white)
                    .opacity(detectionStatus == .waitingForBottle ? 1 : 0)
                    .animation(.easeInOut, value: detectionStatus)

                // Mensaje: No logro detectar ninguna botella
                Text("No logro detectar ninguna botella")
                    .font(.title2)
                    .foregroundColor(.white)
                    .opacity(detectionStatus == .bottleLost ? 1 : 0)
                    .animation(.easeInOut, value: detectionStatus)

                // Mensaje: Botella detectada
                Text("Botella detectada")
                    .font(.title2)
                    .foregroundColor(.white)
                    .opacity(detectionStatus == .bottleDetected ? 1 : 0)
                    .animation(.easeInOut, value: detectionStatus)

                // Mensaje: La botella está en buenas condiciones
                Text("La botella está en buenas condiciones")
                    .font(.title2)
                    .foregroundColor(.green)
                    .opacity(isCondition(.good) || hasDetectedGoodCondition ? 1 : 0)
                    .animation(.easeInOut, value: detectionStatus)

                // Mensaje: La botella está en mal estado
                Text("La botella está en mal estado")
                    .font(.title2)
                    .foregroundColor(.red)
                    .opacity(isCondition(.bad) ? 1 : 0)
                    .animation(.easeInOut, value: detectionStatus)

                // Mensaje: No se pudo determinar el estado de la botella
                Text("No se pudo determinar el estado de la botella")
                    .font(.title2)
                    .foregroundColor(.yellow)
                    .opacity(isCondition(.unknown) ? 1 : 0)
                    .animation(.easeInOut, value: detectionStatus)

                // Mensaje: Error
                if let errorMessage = getErrorMessage() {
                    Text("Error: \(errorMessage)")
                        .font(.title2)
                        .foregroundColor(.red)
                        .animation(.easeInOut, value: detectionStatus)
                }

                Spacer()

                HStack {
                    Button("Regresar") {
                        onBack()
                    }
                    .bold()
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .clipShape(Capsule())

                    Spacer()

                    if isCondition(.good) || hasDetectedGoodCondition {
                        Button("Avanzar") {
                            onAdvance()
                        }
                        .bold()
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
    }

    private func handleClassificationResult(_ detectionPhase: BottleDetectionPhase) {
        // Si ya se detectó que la botella está en buen estado, no actualizar más el estado
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

    private func isCondition(_ condition: BottleCondition) -> Bool {
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

extension BottleDetectionPhase {
    func toDetectionStatus() -> BottleDetectionView.DetectionStatus {
        switch self {
        case .checkingForBottle:
            return .waitingForBottle
        case .noBottleDetected:
            return .bottleLost
        case .bottleDetected:
            return .bottleDetected
        case .conditionChecked(let condition):
            return .conditionChecked(condition)
        case .error(let message):
            return .error(message)
        }
    }
}
