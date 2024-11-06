import SwiftUI
import CoreML
import Vision
import AVFoundation

// MARK: - CameraView

struct CameraView: UIViewControllerRepresentable {
    let cameraViewController: CameraViewController
    let onClassificationResult: (DetectionPhase) -> Void

    func makeUIViewController(context: Context) -> CameraViewController {
        cameraViewController.onClassificationResult = onClassificationResult
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
    var onClassificationResult: ((DetectionPhase) -> Void)?

    // Semáforo para controlar el procesamiento de frames
    private var frameProcessingSemaphore = DispatchSemaphore(value: 1)

    // Variables para estabilizar la clasificación
    private var currentCondition: BottleCondition = .unknown
    private var conditionStreak: Int = 0
    private let requiredStreak: Int = 5 // Número de frames consecutivos para cambiar de estado

    // Variable para controlar si se deben procesar frames
    private var shouldProcessFrames = true

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
            onClassificationResult?(.error("No se pudo detectar la cámara."))
            return
        }

        do {
            let cameraInput = try AVCaptureDeviceInput(device: device)
            if captureSession.canAddInput(cameraInput) {
                captureSession.addInput(cameraInput)
            } else {
                onClassificationResult?(.error("No se pudo agregar la entrada de la cámara."))
                return
            }
        } catch {
            onClassificationResult?(.error("Error al configurar la cámara: \(error.localizedDescription)"))
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
            onClassificationResult?(.error("No se pudo agregar la salida de video."))
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

    // Detener la cámara
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

            // Llamar al clasificador para detectar y clasificar la botella
            ObjectsFunctionalityClassifier.shared.detectAndClassifyBottleImage(image: ciImage) { detectionPhase in
                DispatchQueue.main.async {
                    self.updateClassificationResult(with: detectionPhase)
                }
            }
        }
    }

    // Actualizar el resultado de la clasificación con lógica de histéresis
    private func updateClassificationResult(with detectionPhase: DetectionPhase) {
        if case .conditionChecked(let condition) = detectionPhase {
            if condition == currentCondition {
                conditionStreak += 1
            } else {
                currentCondition = condition
                conditionStreak = 1
            }

            if conditionStreak >= requiredStreak {
                onClassificationResult?(.conditionChecked(currentCondition))
            }
        } else {
            // Si el estado es diferente a una condición de botella, reiniciar el contador
            conditionStreak = 0
            currentCondition = .unknown
            onClassificationResult?(detectionPhase)
        }
    }

    // Método para detener el procesamiento de frames
    func stopProcessingFrames() {
        shouldProcessFrames = false
    }

    // Método para reanudar el procesamiento de frames (si es necesario)
    func startProcessingFrames() {
        shouldProcessFrames = true
    }
}
