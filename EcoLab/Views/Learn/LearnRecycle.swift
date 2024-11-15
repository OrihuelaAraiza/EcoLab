import SwiftUI

struct LearnRecycle: View {
    var onBack: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ZStack {
                    Image("recycleBG")
                        .resizable()
                        .frame(width: .infinity, height: 410)
                        .opacity(0.5)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("¿Sabes cómo reciclar?")
                            .bold()
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        
                        Text("Te damos unos tips para reciclar mejor")
                            .bold()
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        Text("Desliza para conocer más")
                            .bold()
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.horizontal, 70)
                    .padding(.top, 80)
                }
                .background(Color.black)
                .shadow(radius: 20)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("""
                    Reciclar permite crear un objeto a partir de otro ya usado, contribuyendo a la disminución de desechos. Sin duda, es uno de los objetivos globales para frenar la contaminación y el cambio climático, dos problemas que afectan de sobremanera al planeta. Por eso, es fundamental que esta acción la fomentemos en el hogar. A continuación te compartimos algunas sugerencias: 
                    """)
                    .font(.body)
                    .foregroundColor(.black) // Cambié a negro aquí
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .top) {
                            Text("1.")
                                .font(.body)
                                .bold()
                            Text("Compra de manera consciente. Haz un lista de lo que realmente necesitas, de esta manera evitarás comprar cosas innecesarias y ahorras dinero.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                        
                        HStack(alignment: .top) {
                            Text("2.")
                                .font(.body)
                                .bold()
                            Text("Instala recipientes específicos donde puedas dividir la basura: orgánica, vidrio, cartón, plásticos y residuos tóxicos.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                        
                        HStack(alignment: .top) {
                            Text("3.")
                                .font(.body)
                                .bold()
                            Text("Separa correctamente los residuos e indica al recolector de basura como están clasificados.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                        
                        HStack(alignment: .top) {
                            Text("4.")
                                .font(.body)
                                .bold()
                            Text("Lava los envases y las latas antes de tirarlas para evitar vertidos tóxicos en el agua.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                        
                        HStack(alignment: .top) {
                            Text("5.")
                                .font(.body)
                                .bold()
                            Text("Utiliza las botellas de vidrio para guardar semillas, cereales, leguminosas o granos. También como floreros o jarras para agua.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                        
                        HStack(alignment: .top) {
                            Text("6.")
                                .font(.body)
                                .bold()
                            Text("La ropa que ya no usas la podrías ocupar para hacer una cobija, una cama o un juguete para tu mascota. Los pantalones de mezclilla transfórmalos en increíbles bolsas.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                        
                        HStack(alignment: .top) {
                            Text("7.")
                                .font(.body)
                                .bold()
                            Text("Las latas de aluminio las puedes convertir en macetas, en porta lápices o para colocar cubiertos. ¡Píntalas y hecha a volar tu imaginación!")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                        
                        HStack(alignment: .top) {
                            Text("8.")
                                .font(.body)
                                .bold()
                            Text("Las hojas que sobran de los cuadernos, únelas y forma uno nuevo.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                    }
                    
                    Text("""
                    Es fundamental concienciar sobre la importancia de reciclar y reutilizar, al hacerlo los beneficios serian infinitos tanto para el planeta como para la especie humana.
                    """)
                    .font(.body)
                    .foregroundColor(.black) // Cambié a negro aquí
                }
                .padding(.horizontal, 120)
                .padding(.bottom, 20)
            }
            .background(Color.white)
            .overlay(
                Button(action: onBack) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                        .padding()
                }
                    .padding(.trailing, 40),
                alignment: .topTrailing
            )
        }
        .ignoresSafeArea()
    }
}

#Preview{
    LearnRecycle(onBack: {})
}

