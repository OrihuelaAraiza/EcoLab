import SwiftUI
import CoreML
import Vision
import AVFoundation

struct ContentView: View {
    @State private var classificationResult: String = "Clasifica una imagen"
    @State private var isCameraRunning: Bool = false
    private let cameraViewController = CameraViewController()

    var body: some View {
        ZStack {
            CameraView(cameraViewController: cameraViewController)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text(classificationResult)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()

                Spacer()

                Button(action: toggleCamera) {
                    Text(isCameraRunning ? "Detener Clasificación" : "Iniciar Clasificación en Tiempo Real")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            cameraViewController.onClassificationResult = { result in
                classificationResult = result
            }
        }
    }

    func toggleCamera() {
        if isCameraRunning {
            cameraViewController.stopCamera()
        } else {
            cameraViewController.startCamera()
        }
        isCameraRunning.toggle()
    }
}


#Preview {
    ContentView()
}
