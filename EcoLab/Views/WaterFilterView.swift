import SwiftUI
import CoreML
import Vision
import AVFoundation

struct WaterFilterView: View {
    @State private var showIntro = true
    @State private var showMaterialInfo = false
    @State private var showChecklist = false
    @State private var showBottleCheck = false
    @State private var showBottleDetection = false
    @State private var showBucketCheck = false

    private let cameraViewController = CameraViewController()

    var body: some View {
        ZStack {
            CameraView(cameraViewController: cameraViewController, onClassificationResult: { detectionPhase in
                // Puedes manejar el resultado de la clasificación aquí si es necesario
            })
            .blur(radius: 5)
            .ignoresSafeArea()

            VStack {
                if showIntro {
                    IntroView {
                        showIntro = false
                        showMaterialInfo = true
                    }
                    .transition(.opacity)
                } else if showMaterialInfo {
                    MaterialInfoView {
                        showMaterialInfo = false
                        showChecklist = true
                    }
                    .transition(.opacity)
                } else if showChecklist {
                    ChecklistViewWrapper {
                        showChecklist = false
                        showBottleCheck = true
                    }
                    .transition(.opacity)
                } else if showBottleCheck {
                    BottleCheckView {
                        showBottleCheck = false
                        showBottleDetection = true
                    }
                    .transition(.opacity)
                } else if showBottleDetection {
                    BottleDetectionView(
                        onAdvance: {
                            showBottleDetection = false
                            showBucketCheck = true
                        },
                        onBack: {
                            showBottleDetection = false
                            showBottleCheck = true
                        },
                        cameraViewController: cameraViewController
                    )
                    .transition(.opacity)
                } else if showBucketCheck {
                    BucketCheckView {
                        showBottleDetection = false
                    }
                    .transition(.opacity)
                }
            }
        }
    }
}
