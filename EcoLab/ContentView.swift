import SwiftUI

struct ContentView: View {
    @State private var showWaterFilter = false
    private let cameraViewController = CameraViewController()

    var body: some View {
        ZStack {
            // Cámara en el fondo
            CameraView(cameraViewController: cameraViewController, onClassificationResult: { detectionPhase in
                // Manejo de resultados de clasificación si es necesario
            })
            .blur(radius: 5)
            .ignoresSafeArea()
            
            // Superposición translúcida para atenuar la vista de la cámara
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            // Menú centrado
            ZStack {
                // Fondo del menú
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.4))
                    .frame(width: 600, height: 350) // Ajusta el tamaño según tus necesidades
                
                HStack {
                    // Logo o icono en el lado izquierdo
                    Image("EcoLabIcon")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .padding()
                    
                    // Botones en el lado derecho
                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            // Botón "Projects"
                            Button(action: {
                                showWaterFilter = true
                            }) {
                                ButtonContent(imageName: "LearningIcon", title: "Water Project")
                            }
                            .frame(width: 120, height: 120)
                            .background(Color.white)
                            .cornerRadius(10)
                            
                            // Botón "Learning"
                            Button(action: {
                                // Acción para el botón "Learning"
                            }) {
                                ButtonContent(imageName: "LearningIcon", title: "Learning")
                            }
                            .frame(width: 120, height: 120)
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                        
                        HStack(spacing: 20) {
                            // Botón "Coming Soon"
                            Button(action: {
                                // Acción para el botón "Coming Soon"
                            }) {
                                ButtonContent(imageName: "InfoIcon", title: "Coming Soon")
                            }
                            .frame(width: 120, height: 120)
                            .background(Color.white)
                            .cornerRadius(10)
                            
                            // Botón "Info"
                            Button(action: {
                                // Acción para el botón "Info"
                            }) {
                                ButtonContent(imageName: "InfoIcon", title: "Info")
                            }
                            .frame(width: 120, height: 120)
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }
                .padding()
            }
        }
        .fullScreenCover(isPresented: $showWaterFilter) {
            WaterFilter()
        }
    }
}

// Vista personalizada para el contenido del botón
struct ButtonContent: View {
    let imageName: String
    let title: String

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) { // Establecer alineación a .leading
                HStack(spacing: 0) {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width / 4, height: geometry.size.height / 4)
                        .padding(.leading, 10)
                    Spacer()
                }
                .frame(height: geometry.size.height / 2)

                Text(title)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading) // Alinear texto a la izquierda
                    .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 2, alignment: .leading)
                    .padding(.top, 10)
                    .padding(.leading, 10) // Agregar padding a la izquierda
            }
        }
    }
}
