import SwiftUI

struct LearnView: View {
    let onBack: () -> Void
    var cornerRadius: CGFloat = 20
    var body: some View {
        VStack{
            HStack {
                Image(systemName: "graduationcap.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.green)
                Text("EcoLab Aprende")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            .padding(.bottom, 20)

            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    ButtonContent(
                        imageName: "waterIcon",
                        title: "Cuidado de agua",
                        subtitle: "Conoce diferentes formas de cuidar el agua y reutilizarla",
                        titleColor: .white,
                        subtitleColor: .white.opacity(0.7)
                    )
                    .frame(width: 200, height: 100)
                    .background(Color("LearnCard"))
                    .cornerRadius(12)

                    ButtonContent(
                        imageName: "recycleIcon",
                        title: "Recicla",
                        subtitle: "Sabes como reciclar correctamente. Ven a aprender",
                        titleColor: .white,
                        subtitleColor: .white.opacity(0.7)
                    )
                    .frame(width: 200, height: 100)
                    .background(Color("LearnCard"))
                    .cornerRadius(12)
                }

                HStack(spacing: 20) {
                    ButtonContent(
                        imageName: "energyIcon",
                        title: "Energía",
                        subtitle: "Aprende a ahorrar electricidad para disminuir tu huella de carbono",
                        titleColor: .white,
                        subtitleColor: .white.opacity(0.7)
                    )
                    .frame(width: 200, height: 100)
                    .background(Color("LearnCard"))
                    .cornerRadius(12)

                    ButtonContent(
                        imageName: "reuseWaterIcon",
                        title: "Reutiliza el agua",
                        subtitle: "Conoce diferentes formas de reutilizar el agua",
                        titleColor: .white,
                        subtitleColor: .white.opacity(0.7)
                    )
                    .frame(width: 200, height: 100)
                    .background(Color("LearnCard"))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 20)
            
            Button(action: {
                withAnimation {
                    onBack()
                }
            }) {
                Text("Regresar")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
            }
            .padding(.top, 2)
            .cornerRadius(cornerRadius)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

