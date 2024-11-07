import SwiftUI
import CoreML
import Vision
import AVFoundation

// MARK: - CameraView

struct CameraView: UIViewControllerRepresentable {
    let cameraViewController: CameraViewController
    let onBottleClassificationResult: ((BottleDetectionPhase) -> Void)?
    let onBucketClassificationResult: ((BucketDetectionPhase) -> Void)?

    func makeUIViewController(context: Context) -> CameraViewController {
        cameraViewController.onBottleClassificationResult = onBottleClassificationResult
        cameraViewController.onBucketClassificationResult = onBucketClassificationResult
        return cameraViewController
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

// MARK: - CameraViewController

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    // Sesión de captura y salida de video
    private let captureSession = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

    // Closure para pasar el resultado de la clasificación a la vista SwiftUI
    var onBottleClassificationResult: ((BottleDetectionPhase) -> Void)?
    var onBucketClassificationResult: ((BucketDetectionPhase) -> Void)?

    // Semáforo para controlar el procesamiento de frames
    private var frameProcessingSemaphore = DispatchSemaphore(value: 1)

    // Variables para estabilizar la clasificación de botellas
    private var currentCondition: BottleCondition = .unknown
    private var conditionStreak: Int = 0
    private let requiredStreak: Int = 5

    // Variables para estabilizar la clasificación de cubetas
    private var currentBucketCondition: BucketCondition = .unknown
    private var bucketConditionStreak: Int = 0
    private let requiredBucketStreak: Int = 5

    // Variable para controlar si se deben procesar frames
    private var shouldProcessFrames = true

    // Variable para indicar si se está detectando cubetas
    var detectingBucket: Bool = false // Por defecto, detectamos botellas

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startCamera()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopCamera()
    }

    // Configuración de la cámara
    func setupCamera() {
        guard let device = AVCaptureDevice.default(for: .video) else {
            onBottleClassificationResult?(.error("No se pudo detectar la cámara."))
            return
        }

        do {
            let cameraInput = try AVCaptureDeviceInput(device: device)
            if captureSession.canAddInput(cameraInput) {
                captureSession.addInput(cameraInput)
            } else {
                onBottleClassificationResult?(.error("No se pudo agregar la entrada de la cámara."))
                return
            }
        } catch {
            onBottleClassificationResult?(.error("Error al configurar la cámara: \(error.localizedDescription)"))
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
            onBottleClassificationResult?(.error("No se pudo agregar la salida de video."))
            return
        }

        guard let connection = videoDataOutput.connection(with: .video), connection.isVideoOrientationSupported else {
            return
        }

        // Cambiar la orientación a landscape
        connection.videoOrientation = .landscapeRight // o .landscapeLeft
        previewLayer.connection?.videoOrientation = .landscapeRight // o .landscapeLeft

        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }

    // Iniciar la cámara
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

    // Procesamiento de cada frame capturado
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard shouldProcessFrames else { return } // No procesar si está en false

        if frameProcessingSemaphore.wait(timeout: .now()) == .success {
            defer { frameProcessingSemaphore.signal() }

            guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                debugPrint("No se pudo obtener la imagen del buffer de muestra")
                return
            }
            let ciImage = CIImage(cvPixelBuffer: frame)

            if detectingBucket {
                // Llamar al clasificador para detectar y clasificar la cubeta
                ObjectsFunctionalityClassifier.shared.detectAndClassifyBucketImage(image: ciImage) { detectionPhase in
                    DispatchQueue.main.async {
                        self.updateBucketClassificationResult(with: detectionPhase)
                    }
                }
            } else {
                // Llamar al clasificador para detectar y clasificar la botella
                ObjectsFunctionalityClassifier.shared.detectAndClassifyBottleImage(image: ciImage) { detectionPhase in
                    DispatchQueue.main.async {
                        self.updateBottleClassificationResult(with: detectionPhase)
                    }
                }
            }
        }
    }

    private func updateBottleClassificationResult(with detectionPhase: BottleDetectionPhase) {
        if case .conditionChecked(let condition) = detectionPhase {
            if condition == currentCondition {
                conditionStreak += 1
            } else {
                currentCondition = condition
                conditionStreak = 1
            }

            if conditionStreak >= requiredStreak {
                onBottleClassificationResult?(.conditionChecked(currentCondition))
            }
        } else {
            // Si el estado es diferente a una condición de botella, reiniciar el contador
            conditionStreak = 0
            currentCondition = .unknown
            onBottleClassificationResult?(detectionPhase)
        }
    }

    // Actualizar el resultado de la clasificación de cubetas
    private func updateBucketClassificationResult(with detectionPhase: BucketDetectionPhase) {
        if case .conditionChecked(let condition) = detectionPhase {
            if condition == currentBucketCondition {
                bucketConditionStreak += 1
            } else {
                currentBucketCondition = condition
                bucketConditionStreak = 1
            }

            if bucketConditionStreak >= requiredBucketStreak {
                onBucketClassificationResult?(.conditionChecked(currentBucketCondition))
            }
        } else {
            // Si el estado es diferente, reiniciar el contador
            bucketConditionStreak = 0
            currentBucketCondition = .unknown
            onBucketClassificationResult?(detectionPhase)
        }
    }

    // Métodos para controlar el procesamiento de frames
    func stopProcessingFrames() {
        shouldProcessFrames = false
    }

    func startProcessingFrames() {
        shouldProcessFrames = true
    }
}
