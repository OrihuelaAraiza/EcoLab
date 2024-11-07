import SwiftUI

struct ProyectsMenuView: View {
    @Binding var showProyectsMenu: Bool
    @State private var showWaterFilter = false // Nueva variable de estado

    var body: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.4))
                    .frame(width: 600, height: 350)

                VStack(spacing: 20) {

                    HStack(spacing: 20) {
                        Button(action: {
                            // Acción para "Filtro de agua"
                            showWaterFilter = true
                        }) {
                            ButtonContent(imageName: "WaterIcon", title: "Filtro de agua")
                        }
                        .frame(width: 240, height: 120)
                        .background(Color.white)
                        .cornerRadius(10)

                        Button(action: {
                            // Acción para "Coming Soon"
                        }) {
                            ButtonContent(imageName: "WaterIcon", title: "Coming Soon")
                        }
                        .frame(width: 240, height: 120)
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                    HStack(spacing: 20) {
                        Button(action: {

                        }) {
                            ButtonContent(imageName: "SunIcon", title: "Coming Soon")
                        }
                        .frame(width: 240, height: 120)
                        .background(Color.white)
                        .cornerRadius(10)

                        Button(action: {

                        }) {
                            ButtonContent(imageName: "SunIcon", title: "Coming Soon")
                        }
                        .frame(width: 240, height: 120)
                        .background(Color.white)
                        .cornerRadius(10)
                    }

                    Button(action: {
                        withAnimation {
                            showProyectsMenu = false
                        }
                    }) {
                        Text("Regresar")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 2)
                }
                .padding()
            }
        }
        // Presentar WaterFilterView cuando showWaterFilter es true
        .fullScreenCover(isPresented: $showWaterFilter) {
            WaterFilterView()
        }
    }
}
