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

    var body: some View {
        GeometryReader { geometry in
            VStack {
                if showIntro {
                    ZStack{
                        CameraView(cameraViewController: CameraViewController(), onClassificationResult: { _ in })
                            .blur(radius: 5)
                            .overlay(Color.black.opacity(0.4))
                            .ignoresSafeArea()
                        
                        VStack {
                            Spacer()
                            Text("Filtro de agua")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding(.bottom, 8)
                            Text("Hecho en casa")
                                .font(.title2)
                                .foregroundColor(.white)

                            Spacer()

                            Button("Avanzar") {
                                showIntro = false
                                showMaterialInfo = true
                            }
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                        }
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5)
                        .cornerRadius(12)
                        .padding()
                    }

                }
                else if showMaterialInfo {
                    ZStack {
                        CameraView(cameraViewController: CameraViewController(), onClassificationResult: { _ in })
                            .blur(radius: 5)
                            .overlay(Color.black.opacity(0.4))
                            .ignoresSafeArea()
                        
                        VStack {
                            Text("Antes de comenzar asegúrate de tener los materiales necesarios para hacer tu filtro")
                                .font(.headline)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()

                            HStack(spacing: 20) {
                                Image(systemName: "square.fill") // Aquí puedes usar tus imágenes de los materiales
                                Image(systemName: "square.fill")
                                Image(systemName: "square.fill")
                            }
                            .padding()

                            Spacer()

                            Button("Avanzar") {
                                showMaterialInfo = false
                                showChecklist = true
                            }
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                        }
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5)
                        .cornerRadius(12)
                        .padding()
                    }
                }
                else if showChecklist {
                    ZStack {
                        CameraView(cameraViewController: CameraViewController(), onClassificationResult: { _ in })
                            .blur(radius: 5)
                            .overlay(Color.black.opacity(0.4))
                            .ignoresSafeArea()
                        
                        ChecklistView(onAllItemsChecked: {
                            showChecklist = false
                            showBottleCheck = true
                        })
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5)
                        .cornerRadius(12)
                        .padding()
                    }
                    
                }
                else if showBottleCheck {
                    ZStack{
                        CameraView(cameraViewController: CameraViewController(), onClassificationResult: { _ in })
                            .blur(radius: 5)
                            .overlay(Color.black.opacity(0.4))
                            .ignoresSafeArea()
                    
                        VStack {
                            Spacer()
                            Text("Verifiquemos el estado de tu botella")
                                .font(.headline)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()

                            Spacer()

                            Button("Avanzar") {
                                showBottleCheck = false
                                showCamera = true
                            }
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                        }
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5)
                        .cornerRadius(12)
                        .padding()
                    }
                }
                else if showCamera {
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
                        .ignoresSafeArea()

                        VStack {
                            Text("Detectando el estado de la botella")
                                .font(.title)
                                .foregroundColor(.white)

                            Spacer()

                            HStack {
                                Button("Retroceder") {
                                    showCamera = false
                                    showBottleCheck = true
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
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5)
                        .cornerRadius(12)
                        .padding()
                    }
                }
                else if showAR {
                    ARViewContainer()
                        .ignoresSafeArea()
                }
            }
            .ignoresSafeArea()
        }
    }
}
