import SwiftUI

struct LearnView: View {
    let onBack: () -> Void
    var cornerRadius: CGFloat = 20
    @Environment(\.presentationMode) var presentationMode
    @State private var showingLearnWater = false // Variable de estado para presentar LearnWater
    @State private var showingLearnEnergy = false // Variable de estado para presentar LearnEnergy
    @State private var showingLearnRecycle = false // Variable de estado para presentar LearnRecycle
    
    var body: some View {
        VStack {
            // Encabezado
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
            
            // Botones de Aprendizaje
            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    // Botón para LearnWater
                    Button(action: {
                        showingLearnWater = true // Activar la presentación de la hoja
                    }) {
                        ButtonContent(
                            imageName: "careWaterIcon",
                            title: "Cuidado de agua",
                            subtitle: "Conoce diferentes formas de cuidar el agua",
                            titleColor: .white,
                            subtitleColor: .white.opacity(0.7)
                        )
                    }
                    .frame(width: 200, height: 100)
                    .background(Color("LearnCard"))
                    .cornerRadius(12)
                    .sheet(isPresented: $showingLearnWater) { // Presentar LearnWater como una hoja
                        LearnWater(onBack: {
                            showingLearnWater = false // Cerrar la hoja
                        })
                    }
                    
                    // Botón para LearnEnergy
                    Button(action: {
                        showingLearnEnergy = true // Activar la presentación de la hoja
                    }) {
                        ButtonContent(
                            imageName: "careEnergyIcon", // Asegúrate de tener una imagen llamada "energyIcon" en tus assets
                            title: "Cuidado de energía",
                            subtitle: "Aprende cómo ahorrar energía en casa",
                            titleColor: .white,
                            subtitleColor: .white.opacity(0.7)
                        )
                    }
                    .frame(width: 200, height: 100)
                    .background(Color("LearnCard"))
                    .cornerRadius(12)
                    .sheet(isPresented: $showingLearnEnergy) { // Presentar LearnEnergy como una hoja
                        LearnEnergy(onBack: {
                            showingLearnEnergy = false // Cerrar la hoja
                        })
                    }
                }
                HStack(spacing: 20) {
                    Button(action: {
                        showingLearnRecycle = true // Activar la presentación de la hoja
                    }) {
                        ButtonContent(
                            imageName: "recycleIcon", // Asegúrate de tener una imagen llamada "recycleIcon" en tus assets
                            title: "Reciclaje",
                            subtitle: "Descubre cómo reciclar eficientemente",
                            titleColor: .white,
                            subtitleColor: .white.opacity(0.7)
                        )
                    }
                    .frame(width: 200, height: 100)
                    .background(Color("LearnCard"))
                    .cornerRadius(12)
                    .sheet(isPresented: $showingLearnRecycle) { // Presentar LearnRecycle como una hoja
                        LearnRecycle(onBack: {
                            showingLearnRecycle = false // Cerrar la hoja
                        })
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()

            Button(action: {
                withAnimation {
                    onBack()
                }
            }) {
                Text("Regresar")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(cornerRadius)
            }
            .padding(.top, 2)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white.edgesIgnoringSafeArea(.all)) // Fondo blanco para la vista
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        LearnView(onBack: {})
    }
}
