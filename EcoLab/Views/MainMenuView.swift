import SwiftUI

struct MainMenuView: View {
    @Binding var showProyectsMenu: Bool
    @EnvironmentObject var appSettings: AppSettings
    var cornerRadius: CGFloat = 20

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
                            ButtonContent(imageName: "ProjectsIcon", title: "Proyectos", subtitle: "Convierte materiales en ideas increíbles")
                        }
                        .frame(width: 140, height: 120)
                        .background(Color.white)
                        .cornerRadius(cornerRadius)

                        Button(action: {
                            // Acción para el botón "Aprende"
                        }) {
                            ButtonContent(imageName: "LearningIcon", title: "Aprende", subtitle: "Para cuidar a tu comunidad y al planeta")
                        }
                        .frame(width: 140, height: 120)
                        .background(Color.white)
                        .cornerRadius(cornerRadius)
                    }

                    HStack(spacing: 20) {
                        Button(action: {
                            // Acción para el botón "Próximamente"
                        }) {
                            ButtonContent(imageName: "SoonIcon", title: "Próximamente", subtitle: "Proximamente")
                        }
                        .frame(width: 140, height: 120)
                        .background(Color.white)
                        .cornerRadius(cornerRadius)

                        Button(action: {
                            // Acción para el botón "Info"
                        }) {
                            ButtonContent(imageName: "InfoIcon", title: "Info", subtitle: "Acerca de EcoLab")
                        }
                        .frame(width: 140, height: 120)
                        .background(Color.white)
                        .cornerRadius(cornerRadius)
                    }
                }
                .padding()
            }
            .padding()
        }
    }
}
