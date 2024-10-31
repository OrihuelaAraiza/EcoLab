import SwiftUI

struct CameraDetectionView: View {
    var onAdvance: () -> Void
    var onBack: () -> Void
    var classificationResult: String

    var body: some View {
        ZStack {
            CameraView(cameraViewController: CameraViewController(), onClassificationResult: { result in
                if result.contains("La botella está en buenas condiciones") {
                    onAdvance()
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
                        onBack()
                    }
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .clipShape(Capsule())

                    Spacer()

                    Button("Avanzar") {
                        if classificationResult.contains("La botella está en buenas condiciones") {
                            onAdvance()
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .cornerRadius(12)
            .padding()
        }
    }
}
