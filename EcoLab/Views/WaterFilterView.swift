import SwiftUI
import CoreML
import Vision
import AVFoundation

struct WaterFilter: View {
    @State private var showIntro = true
    @State private var showMaterialInfo = false
    @State private var showChecklist = false
    @State private var showBottleCheck = false
    @State private var showCamera = false
    @State private var showAR = false

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
                        showCamera = true
                    }
                    .transition(.opacity)
                } else if showCamera {
                    CameraDetectionView(
                        onAdvance: {
                            showCamera = false
                            showAR = true
                        },
                        onBack: {
                            showCamera = false
                            showBottleCheck = true
                        },
                        cameraViewController: cameraViewController
                    )
                    .transition(.opacity)
                } else if showAR {
                    ARViewContainer()
                        .ignoresSafeArea()
                }
            }
        }
    }
}
