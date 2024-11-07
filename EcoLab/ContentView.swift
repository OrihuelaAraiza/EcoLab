import SwiftUI

struct ContentView: View {
    @State private var showProyectsMenu = false
    private let cameraViewController = CameraViewController() // Instancia compartida

    var body: some View {
        ZStack {
            CameraView(cameraViewController: cameraViewController, onBottleClassificationResult: { detectionPhase in
                // Manejo de resultados de clasificación si es necesario
            }, onBucketClassificationResult: nil)
            .blur(radius: 5)
            .ignoresSafeArea()

            Color.black.opacity(0.7)
                .ignoresSafeArea()

            if showProyectsMenu {
                ProyectsMenuView(showProyectsMenu: $showProyectsMenu)
                    .transition(.opacity)
            } else {
                MainMenuView(showProyectsMenu: $showProyectsMenu)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.7), value: showProyectsMenu)
    }
}
