import SwiftUI
import CoreML
import Vision
import AVFoundation

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let captureSession = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    var onClassificationResult: ((String) -> Void)?
    private var recentResults: [String] = []
    private let maxResultsCount = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    func setupCamera() {
        guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
            onClassificationResult?("No se pudo detectar la cámara.")
            return
        }
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: device)
            captureSession.addInput(cameraInput)
        } catch {
            onClassificationResult?("Error al configurar la cámara.")
            return
        }
        
        videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString): NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        captureSession.addOutput(videoDataOutput)
        
        guard let connection = videoDataOutput.connection(with: .video), connection.isVideoOrientationSupported else {
            return
        }
        
        connection.videoOrientation = .portrait
        
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }

    func startCamera() {
        captureSession.startRunning()
    }

    func stopCamera() {
        captureSession.stopRunning()
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("Unable to get image from the sample buffer")
            return
        }
        let ciImage = CIImage(cvPixelBuffer: frame)
        ObjectsFuncionalityClassifier.shared.classifyBottleImage(image: ciImage) { result in
            DispatchQueue.main.async {
                self.updateRecentResults(with: result)
            }
        }
    }

    private func updateRecentResults(with result: String) {
        if recentResults.count >= maxResultsCount {
            recentResults.removeFirst()
        }
        recentResults.append(result)
        
        let mostFrequentResult = recentResults.mostFrequent()
        onClassificationResult?(mostFrequentResult ?? "No se pudo clasificar la imagen.")
    }
}

extension Array where Element == String {
    func mostFrequent() -> String? {
        let counts = self.reduce(into: [:]) { counts, word in
            counts[word, default: 0] += 1
        }
        return counts.max { $0.value < $1.value }?.key
    }
}

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

struct CameraView: UIViewControllerRepresentable {
    let cameraViewController: CameraViewController

    func makeUIViewController(context: Context) -> CameraViewController {
        return cameraViewController
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

#Preview {
    ContentView()
}
