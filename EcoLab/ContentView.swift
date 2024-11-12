import SwiftUI

struct ContentView: View {
    private let cameraViewController = CameraViewController() // Instancia compartida
    @State private var currentMenu: Menu = .main // Estado para el menú actual

    enum Menu {
        case main
        case projects
        case learn
    }

    var body: some View {
        ZStack {
            // Mostrar CameraView solo si no estamos en el menú de aprendizaje
            if currentMenu != .learn {
                CameraView(
                    cameraViewController: cameraViewController,
                    onBottleClassificationResult: nil,
                    onBucketClassificationResult: nil
                )
                .blur(radius: 5)
                .ignoresSafeArea()
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
            }
            else{
                Color.white
                    .ignoresSafeArea()
            }

            switch currentMenu {
            case .main:
                MainMenuView(
                    onProjectsTap: { currentMenu = .projects },
                    onLearnTap: { currentMenu = .learn }
                )
                .transition(.opacity)
                
            case .projects:
                ProyectsMenuView(onBack: { currentMenu = .main })
                    .transition(.opacity)
                
            case .learn:
                LearnView(onBack: { currentMenu = .main })
                    .transition(.opacity)
                    .ignoresSafeArea(.all)
            }
        }
        .animation(.easeInOut(duration: 0.7), value: currentMenu)
    }
}
