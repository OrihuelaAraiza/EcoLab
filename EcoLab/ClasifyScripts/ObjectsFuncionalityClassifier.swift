import CoreML
import Vision
import SwiftUI

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
    
    func detectAndClassifyBottleImage(image: CIImage, completion: @escaping ([String]) -> Void) {
        guard let detectionModel = detectionModel else {
            completion(["No se pudo cargar el modelo de detección"])
            return
        }
        
        // Solicitud de detección de objetos
        let detectionRequest = VNCoreMLRequest(model: detectionModel) { (request, error) in
            if let error = error {
                print("Error en la detección: \(error)")
                completion(["Error en la detección: \(error.localizedDescription)"])
                return
            }
            
            guard let results = request.results as? [VNRecognizedObjectObservation], !results.isEmpty else {
                completion(["No se detectaron botellas en la imagen."])
                return
            }
            
            var classifications: [String] = []
            let dispatchGroup = DispatchGroup()
            
            for observation in results {
                dispatchGroup.enter()
                
                // Obtener el bounding box y recortar la imagen
                let boundingBox = observation.boundingBox
                let croppedImage = self.cropImage(image: image, boundingBox: boundingBox)
                
                // Clasificar la imagen recortada
                self.classifyCroppedImage(image: croppedImage) { classificationResult in
                    classifications.append(classificationResult)
                    dispatchGroup.leave()
                }
            }
            
            // Esperar a que todas las clasificaciones terminen
            dispatchGroup.notify(queue: .main) {
                completion(classifications)
            }
        }
        
        // Ejecutar la solicitud de detección
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([detectionRequest])
            } catch {
                print("Error al realizar la detección: \(error)")
                DispatchQueue.main.async {
                    completion(["Error al realizar la detección: \(error.localizedDescription)"])
                }
            }
        }
    }
    
    // Función para clasificar una imagen recortada
    private func classifyCroppedImage(image: CIImage, completion: @escaping (String) -> Void) {
        guard let classificationModel = classificationModel else {
            completion("No se pudo cargar el modelo de clasificación")
            return
        }
        
        let classificationRequest = VNCoreMLRequest(model: classificationModel) { (request, error) in
            if let error = error {
                print("Error en la clasificación: \(error)")
                completion("Error en la clasificación: \(error.localizedDescription)")
                return
            }
            
            if let results = request.results as? [VNClassificationObservation] {
                // Obtener las dos mejores clasificaciones
                let topResults = results.prefix(2)
                if let bestResult = topResults.first, bestResult.confidence > 0.8 {
                    completion("Resultado: \(bestResult.identifier) (\(Int(bestResult.confidence * 100))%)")
                } else if let secondBestResult = topResults.last, abs(bestResult.confidence - secondBestResult.confidence) < 0.1 {
                    completion("Clasificación indeterminada entre \(bestResult.identifier) y \(secondBestResult.identifier).")
                } else {
                    completion("Clasificación con baja confianza.")
                }
            } else {
                completion("No se pudo clasificar la botella.")
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        do {
            try handler.perform([classificationRequest])
        } catch {
            print("Error al realizar la clasificación: \(error)")
            completion("Error al realizar la clasificación: \(error.localizedDescription)")
        }
    }
    
    // Función para recortar la imagen usando el bounding box
    private func cropImage(image: CIImage, boundingBox: CGRect) -> CIImage {
        let imageSize = image.extent.size
        let x = boundingBox.origin.x * imageSize.width
        let y = (1.0 - boundingBox.origin.y - boundingBox.size.height) * imageSize.height
        let width = boundingBox.size.width * imageSize.width
        let height = boundingBox.size.height * imageSize.height
        let rect = CGRect(x: x, y: y, width: width, height: height)
        
        let croppedImage = image.cropped(to: rect)
        return croppedImage
    }
}
