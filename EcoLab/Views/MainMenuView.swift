import SwiftUI

struct MainMenuView: View {
    @Binding var showProyectsMenu: Bool
    @EnvironmentObject var appSettings: AppSettings

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.4))
                .frame(width: 600, height: 350)

            HStack {

                Image("EcoLabIcon")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding()
                    .gesture(
                        TapGesture(count: 3).onEnded{
                            appSettings.isDeveloperMode.toggle()
                            print("Modo Desarrollador: \(appSettings.isDeveloperMode ? "Activado" : "Desactivado")")
                        }
                    )

                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        Button(action: {
                            withAnimation{
                                showProyectsMenu = true
                            }
                        }) {
                            ButtonContent(imageName: "LearningIcon", title: "Proyectos")
                        }
                        .frame(width: 120, height: 120)
                        .background(Color.white)
                        .cornerRadius(10)

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
                        Button(action: {
                            // Acción para el botón "Próximamente"
                        }) {
                            ButtonContent(imageName: "InfoIcon", title: "Próximamente")
                        }
                        .frame(width: 120, height: 120)
                        .background(Color.white)
                        .cornerRadius(10)

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
