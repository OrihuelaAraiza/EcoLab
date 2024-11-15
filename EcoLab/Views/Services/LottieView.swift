import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var animationName: String
    var loopMode: LottieLoopMode = .loop

    func makeUIView(context: Context) -> UIView {
        // Contenedor principal
        let containerView = UIView()

        // Configurar la vista de animación Lottie
        let animationView = LottieAnimationView(name: animationName)
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleAspectFit // Asegura que la animación se ajuste correctamente
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.play() // Iniciar la animación

        // Añadir la animación al contenedor
        containerView.addSubview(animationView)

        // Establecer restricciones para que la animación llene el contenedor
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            animationView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Aquí puedes actualizar la vista si es necesario
    }
}
