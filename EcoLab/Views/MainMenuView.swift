import SwiftUI

struct MainMenuView: View {
    @Binding var showProyectsMenu: Bool

    var body: some View {
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
                        // Botón "Proyectos"
                        Button(action: {
                            showProyectsMenu = true
                        }) {
                            ButtonContent(imageName: "LearningIcon", title: "Proyectos")
                        }
                        .frame(width: 120, height: 120)
                        .background(Color.white)
                        .cornerRadius(10)

                        // Botón "Aprende"
                        Button(action: {
                            // Acción para el botón "Aprende"
                        }) {
                            ButtonContent(imageName: "LearningIcon", title: "Aprende")
                        }
                        .frame(width: 120, height: 120)
                        .background(Color.white)
                        .cornerRadius(10)
                    }

                    HStack(spacing: 20) {
                        // Botón "Próximamente"
                        Button(action: {
                            // Acción para el botón "Próximamente"
                        }) {
                            ButtonContent(imageName: "InfoIcon", title: "Próximamente")
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
}
