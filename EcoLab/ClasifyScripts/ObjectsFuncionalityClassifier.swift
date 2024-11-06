import CoreML
import Vision
import SwiftUI

enum BottleCondition: Equatable, Hashable {
    case good
    case bad
    case unknown
    case error(String)

    var numericValue: Int {
        switch self {
        case .good:
            return 1
        case .bad:
            return -1
        default:
            return 0
        }
    }
}

enum DetectionPhase: Hashable {
    case checkingForBottle
    case bottleDetected
    case noBottleDetected
    case conditionChecked(BottleCondition)
    case error(String)
}

class ObjectsFunctionalityClassifier {
    static let shared = ObjectsFunctionalityClassifier()
    
    private init() {}
    
    private lazy var detectionModel: VNCoreMLModel? = {
        do {
            let model = try VNCoreMLModel(for: PlasticBottleDetection().model)
            return model
        } catch {
            print("Error al cargar el modelo de detección: \(error)")
            return nil
        }
    }()
    
    private lazy var classificationModel: VNCoreMLModel? = {
        do {
            let model = try VNCoreMLModel(for: PlasticBottleClasifModel().model)
            return model
        } catch {
            print("Error al cargar el modelo de clasificación: \(error)")
            return nil
        }
    }()
    
    func detectAndClassifyBottleImage(image: CIImage, completion: @escaping (DetectionPhase) -> Void) {
        guard let detectionModel = detectionModel else {
            completion(.error("No se pudo cargar el modelo de detección"))
            return
        }
        
        let detectionRequest = VNCoreMLRequest(model: detectionModel) { (request, error) in
            if let error = error {
                print("Error en la detección: \(error)")
                completion(.error("Error en la detección: \(error.localizedDescription)"))
                return
            }
            
            guard let results = request.results as? [VNRecognizedObjectObservation], !results.isEmpty else {
                completion(.noBottleDetected)
                return
            }
            
            // Botella detectada
            var classificationResults: [(BottleCondition, Float)] = []
            let dispatchGroup = DispatchGroup()
            
            for observation in results {
                dispatchGroup.enter()
                
                let boundingBox = observation.boundingBox
                let croppedImage = self.cropImage(image: image, boundingBox: boundingBox)
                
                self.classifyCroppedImage(image: croppedImage) { classificationResult, confidence in
                    classificationResults.append((classificationResult, confidence))
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                let totalConfidence = classificationResults.reduce(0) { $0 + $1.1 * Float($1.0.numericValue) }
                let averageConfidence = totalConfidence / Float(classificationResults.count)
                let finalCondition: BottleCondition = averageConfidence >= 0 ? .good : .bad
                completion(.conditionChecked(finalCondition))
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        do {
            try handler.perform([detectionRequest])
        } catch {
            print("Error al realizar la detección: \(error)")
            completion(.error("Error al realizar la detección: \(error.localizedDescription)"))
        }
    }
    
    private func classifyCroppedImage(image: CIImage, completion: @escaping (BottleCondition, Float) -> Void) {
        guard let classificationModel = classificationModel else {
            completion(.unknown, 0)
            return
        }
        
        let classificationRequest = VNCoreMLRequest(model: classificationModel) { (request, error) in
            if let error = error {
                print("Error en la clasificación: \(error)")
                completion(.unknown, 0)
                return
            }
            
            if let results = request.results as? [VNClassificationObservation], let topResult = results.first {
                if topResult.identifier == "itWorks" {
                    if topResult.confidence > 0.9 {
                        completion(.good, topResult.confidence)
                    } else if topResult.confidence > 0.7 {
                        completion(.unknown, topResult.confidence)
                    } else {
                        completion(.unknown, topResult.confidence)
                    }
                } else if topResult.identifier == "doesntWork" {
                    if topResult.confidence > 0.9 {
                        completion(.bad, topResult.confidence)
                    } else if topResult.confidence > 0.7 {
                        completion(.unknown, topResult.confidence)
                    } else {
                        completion(.unknown, topResult.confidence)
                    }
                } else {
                    completion(.unknown, topResult.confidence)
                }
            } else {
                completion(.unknown, 0)
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        do {
            try handler.perform([classificationRequest])
        } catch {
            print("Error al realizar la clasificación: \(error)")
            completion(.unknown, 0)
        }
    }
    
    private func cropImage(image: CIImage, boundingBox: CGRect) -> CIImage {
        let imageSize = image.extent.size
        let x = boundingBox.origin.x * imageSize.width
        let y = (1.0 - boundingBox.origin.y - boundingBox.size.height) * imageSize.height
        let width = boundingBox.size.width * imageSize.width
        let height = boundingBox.size.height * imageSize.height
        return image.cropped(to: CGRect(x: x, y: y, width: width, height: height))
    }
}
