import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var animationName: String
    var loopMode: LottieLoopMode = .loop // Define si la animación se repite

    func makeUIView(context: Context) -> LottieAnimationView {
        let animationView = LottieAnimationView(name: animationName)
        animationView.loopMode = loopMode
        animationView.play() // Iniciar animación
        return animationView
    }

    func updateUIView(_ uiView: LottieAnimationView, context: Context) {
        // Actualizaciones para el UIView si son necesarias
    }
}
