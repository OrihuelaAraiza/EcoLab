import SwiftUI

struct ContentView: View {
    @State private var showProyectsMenu = false
    private let cameraViewController = CameraViewController() // Instancia compartida

    var body: some View {
        ZStack {
            // Cámara en el fondo, siempre activa
            CameraView(cameraViewController: cameraViewController, onClassificationResult: { detectionPhase in
                // Manejo de resultados de clasificación si es necesario
            })
            .blur(radius: 5)
            .ignoresSafeArea()

            // Superposición translúcida
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            if showProyectsMenu {
                // Mostrar ProyectsMenuView
                ProyectsMenuView(showProyectsMenu: $showProyectsMenu)
            } else {
                // Mostrar el menú principal
                MainMenuView(showProyectsMenu: $showProyectsMenu)
            }
        }
    }
}
