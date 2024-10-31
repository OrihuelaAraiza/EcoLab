import SwiftUI
import CoreML
import Vision
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    let cameraViewController: CameraViewController
    let onClassificationResult: (String) -> Void

    func makeUIViewController(context: Context) -> CameraViewController {
        cameraViewController.onClassificationResult = onClassificationResult
        return cameraViewController
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let captureSession = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    var onClassificationResult: ((String) -> Void)?
    private var recentResults: [String] = []
    private let maxResultsCount = 10
    private var frameProcessingSemaphore = DispatchSemaphore(value: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startCamera()
    }

    func setupCamera() {
        guard let device = AVCaptureDevice.default(for: .video) else {
            onClassificationResult?("No se pudo detectar la cámara.")
            return
        }
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: device)
            if captureSession.canAddInput(cameraInput) {
                captureSession.addInput(cameraInput)
            } else {
                onClassificationResult?("No se pudo agregar la entrada de la cámara.")
                return
            }
        } catch {
            onClassificationResult?("Error al configurar la cámara: \(error.localizedDescription)")
            return
        }
        
        videoDataOutput.videoSettings = [
            (kCVPixelBufferPixelFormatTypeKey as String): NSNumber(value: kCVPixelFormatType_32BGRA)
        ]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
        } else {
            onClassificationResult?("No se pudo agregar la salida de video.")
            return
        }
        
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
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }

    func stopCamera() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if frameProcessingSemaphore.wait(timeout: .now()) == .success {
            defer { frameProcessingSemaphore.signal() }

            guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                debugPrint("No se pudo obtener la imagen del buffer de muestra")
                return
            }
            let ciImage = CIImage(cvPixelBuffer: frame)

            ObjectsFunctionalityClassifier.shared.detectAndClassifyBottleImage(image: ciImage) { results in
                DispatchQueue.main.async {
                    self.updateRecentResults(with: results)
                }
            }
        }
    }

    private func updateRecentResults(with results: [String]) {
        let combinedResult = results.joined(separator: "\n")
        
        if recentResults.count >= maxResultsCount {
            recentResults.removeFirst()
        }
        recentResults.append(combinedResult)
        
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
