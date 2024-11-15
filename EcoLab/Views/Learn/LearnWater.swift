import SwiftUI
import Lottie

struct LearnWater: View {
    var onBack: () -> Void // Cierre para dismiss
    
    func rgbColor(red: Double, green: Double, blue: Double) -> Color {
        return Color(red: red / 255.0, green: green / 255.0, blue: blue / 255.0)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Sección de encabezado con imagen de fondo
                ZStack {
                    Image("waterBG")
                        .resizable()
                        .frame(height: 410) // Ajusta la altura
                        .opacity(0.5)
                    
                    VStack(alignment: .leading, spacing: 10) { // Cambiado a .leading
                        // Logo con animación Lottie
                        LottieView(animationName: "WaterBubble", loopMode: .loop)
                                        .frame(width: 80, height: 80) // Tamaño del logo animado
                                        .padding(.bottom, 10)
                        
                        Text("¿Cómo podemos cuidar el agua?")
                            .bold()
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        
                        Text("Te contamos un poco en este artículo")
                            .bold()
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        Text("Desliza para conocer más")
                            .bold()
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 80)
                }
                .background(.black)
                .shadow(radius: 20)

                // Contenido del artículo
                VStack(alignment: .leading, spacing: 15) {
                    Text("""
                    El agua es un recurso fundamental para la salud del ser humano y del planeta. El cambio climático y el consumo excesivo de este recurso están afectando tanto a la cantidad como a la calidad de agua en la Tierra. Ahorrar agua supone una forma de evitar su desperdicio y proteger así el medio ambiente.
                    
                    El agua es un recurso fundamental para la vida y cubre cerca del 80% de la superficie del planeta. Sin embargo, es limitado y cada vez son más los problemas en diferentes partes del mundo derivados de la escasez del agua. Cerrar el grifo cuando no se use o asegurarse de que los grifos cierran bien y no hay fugas, son algunas de las recomendaciones sobre cómo ahorrar agua en casa.
                    """)
                    .font(.body)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading) // Alineación .leading
                    
                    Text("""
                    El ser humano necesita del agua para vivir, pero también para llevar a cabo una serie de actividades como bañarse, limpiar, cocinar…etc. En ocasiones, en algunas de estas rutinas que practicamos día a día, nos olvidamos de la importancia de ahorrar agua para evitar así un malgasto de un recurso tan valioso cuyo despilfarro puede suponer un problema ambiental mayor.
                    
                    Ahorrar agua supone evitar un consumo excesivo de ésta con el fin de proteger el medio ambiente y mitigar los efectos del cambio climático en el planeta. Un consumo sostenible del agua es una responsabilidad de todos y, a través de pequeños gestos, podemos colaborar a reducir su despilfarro.
                    """)
                    .font(.body)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading) // Alineación .leading
                    
                    Text("¿Cómo ahorrar agua en casa?: 10 ‘tips’ básicos")
                        .bold()
                        .font(.title2)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading) // Alineación .leading
                    
                    VStack(alignment: .leading, spacing: 10) { // Tips alineados a la izquierda
                        HStack(alignment: .top) {
                            Text("1.")
                                .font(.body)
                                .bold()
                            Text("Cierra los grifos siempre que no los uses, aunque te parezca poco tiempo: mientras te enjabonas el pelo, te cepillas los dientes, fregar utensilios de cocina, mientras te afeitas.")
                                .font(.body)
                                .foregroundColor(.black)
                        }
                        // Más tips...
                    }
                    
                    Text("""
                    El uso global del agua se ha multiplicado por seis en los últimos 100 años y continúa creciendo de manera constante a una tasa aproximada del 1% anual. El aumento de la población, el desarrollo económico y los patrones de consumo siguen aumentando el uso de este recurso hídrico tan valioso. Esto llevará al empeoramiento de la calidad de vida de aquellos lugares donde el acceso al agua ya es un problema y comenzará a serlo en algunas regiones donde todavía no lo es.
                    
                    Otra forma de poner nuestro granito de arena para construir un mundo más sostenible es ahorrando energía. Por ello, compartimos una serie de recomendaciones para ahorrar energía eléctrica.
                    """)
                    .font(.body)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading) // Alineación .leading
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
                .padding(.trailing, 20),
                alignment: .topTrailing
            )
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LearnWater(onBack: {})
}
