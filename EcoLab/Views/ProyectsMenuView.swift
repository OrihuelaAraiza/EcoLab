import SwiftUI

struct ProyectsMenuView: View {
    let onBack: () -> Void
    @State private var showWaterFilter = false
    var cornerRadius: CGFloat = 20

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
                            ButtonContent(imageName: "WaterIcon", title: "Filtro de agua", subtitle: "Un filtro de agua para el uso diario", titleColor: .black, subtitleColor: .gray)
                        }
                        .frame(width: 240, height: 120)
                        .background(Color.white)
                        .cornerRadius(cornerRadius)

                        Button(action: {
                            // Acción para "Coming Soon"
                        }) {
                            ButtonContent(imageName: "SoonIcon", title: "Coming Soon", subtitle: "Comming soon", titleColor: .black, subtitleColor: .gray)
                        }
                        .frame(width: 240, height: 120)
                        .background(Color.white)
                        .cornerRadius(cornerRadius)
                    }
                    HStack(spacing: 20) {
                        Button(action: {

                        }) {
                            ButtonContent(imageName: "SoonIcon", title: "Coming Soon", subtitle: "Comming soon", titleColor: .black, subtitleColor: .gray)
                        }
                        .frame(width: 240, height: 120)
                        .background(Color.white)
                        .cornerRadius(cornerRadius)

                        Button(action: {

                        }) {
                            ButtonContent(imageName: "SoonIcon", title: "Coming Soon", subtitle: "Comming soon", titleColor: .black, subtitleColor: .gray)
                        }
                        .frame(width: 240, height: 120)
                        .background(Color.white)
                        .cornerRadius(cornerRadius)
                    }

                    Button(action: {
                        withAnimation {
                            onBack()
                        }
                    }) {
                        Text("Regresar")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(cornerRadius)
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
