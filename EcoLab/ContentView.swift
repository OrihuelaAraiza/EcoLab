import SwiftUI
import CoreML
import Vision
import AVFoundation

struct ContentView: View {
    @State private var showChecklist = true
    @State private var showCamera = false
    @State private var showAR = false
    @State private var classificationResult: String = ""

    var body: some View {
        VStack {
            if showChecklist {
                ZStack {
                    CameraView(cameraViewController: CameraViewController(), onClassificationResult: { _ in })
                        .blur(radius: 5)
                        .overlay(Color.black.opacity(0.4)) // Superposición para oscurecer un poco el fondo

                    ChecklistView(onAllItemsChecked: {
                        showChecklist = false
                        showCamera = true
                    })
                }
            } else if showCamera {
                ZStack {
                    CameraView(cameraViewController: CameraViewController(), onClassificationResult: { result in
                        classificationResult = result
                        if result.contains("La botella está en buenas condiciones") {
                            showCamera = false
                            showAR = true
                        } else {
                            print("Botella en mal estado")
                        }
                    })
                    .blur(radius: 5)
                    .overlay(Color.black.opacity(0.5))

                    VStack {
                        Text("Filtro de agua")
                            .font(.title)
                            .foregroundColor(.white)
                        Text("Hecho en casa")
                            .font(.subheadline)
                            .foregroundColor(.white)

                        Spacer()

                        HStack {
                            Button("Retroceder") {
                                showCamera = false
                                showChecklist = true
                            }
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .clipShape(Capsule())

                            Spacer()

                            Button("Avanzar") {
                                if classificationResult.contains("La botella está en buenas condiciones") {
                                    showCamera = false
                                    showAR = true
                                } else {
                                    print("Botella en mal estado")
                                }
                            }
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                        }
                        .padding(.horizontal, 40)
                    }
                    .padding()
                }
            } else if showAR {
                ARViewContainer()
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
