import CoreML
import Vision
import SwiftUI

class ObjectsFuncionalityClassifier {
    static let shared = ObjectsFuncionalityClassifier()
    
    private init() {}
    
    func classifyBottleImage(image: CIImage, completion: @escaping (String) -> Void) {
        guard let model = try? VNCoreMLModel(for: PlasticBottleClasifModel().model) else {
            print("No se pudo cargar el modelo")
            completion("No se pudo cargar el modelo")
            return
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            if let results = request.results as? [VNClassificationObservation], let topResult = results.first {
                if topResult.confidence > 0.95 {
                    let classificationResult = "Resultado: \(topResult.identifier) (\(Int(topResult.confidence * 100))%)"
                    DispatchQueue.main.async {
                        completion(classificationResult)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion("No se detectó ningún objeto con suficiente confianza.")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion("No se pudo clasificar la imagen.")
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print("Error al realizar la clasificación: \(error)")
                DispatchQueue.main.async {
                    completion("Error al realizar la clasificación: \(error.localizedDescription)")
                }
            }
        }
    }
}
