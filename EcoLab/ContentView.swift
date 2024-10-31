import SwiftUI
import CoreML
import Vision
import AVFoundation

struct ContentView: View {
    @State private var showIntro = true
    @State private var showMaterialInfo = false
    @State private var showChecklist = false
    @State private var showBottleCheck = false
    @State private var showCamera = false
    @State private var showAR = false
    @State private var classificationResult: String = ""

    // Camera view controller que mantiene la sesión activa
    private let cameraViewController = CameraViewController()

    var body: some View {
        ZStack {
            // Cámara en el fondo, siempre encendida
            CameraView(cameraViewController: cameraViewController, onClassificationResult: { result in
                classificationResult = result
            })
            .blur(radius: 5)
            .ignoresSafeArea()

            // Vistas de contenido superpuestas
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
                        classificationResult: classificationResult
                    )
                    .transition(.opacity)
                } else if showAR {
                    ARViewContainer()
                        .ignoresSafeArea()
                }
            }
        }
        .onAppear {
            // Iniciar la cámara al iniciar la app
            cameraViewController.startCamera()
        }
        .onDisappear {
            // Detener la cámara solo cuando la app sale por completo
            cameraViewController.stopCamera()
        }
    }
}
