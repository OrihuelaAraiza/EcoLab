import SwiftUI

struct LearnWater: View {
    var onBack: () -> Void // Cierre para dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ZStack {
                    Image("waterBG")
                        .resizable()
                        .frame(width: .infinity, height: 410)
                        .opacity(0.5)
                    
                    VStack(alignment: .leading, spacing: 10) {
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
                .background(Color.black)
                .shadow(radius: 20)

                VStack(alignment: .leading, spacing: 15) {
                    Text("""
                    El agua es un recurso fundamental para la salud del ser humano y del planeta. El cambio climático y el consumo excesivo de este recurso están afectando tanto a la cantidad como a la calidad de agua en la Tierra. Ahorrar agua supone una forma de evitar su desperdicio y proteger así el medio ambiente.
                    
                    El agua es un recurso fundamental para la vida y cubre cerca del 80% de la superficie del planeta. Sin embargo, es limitado y cada vez son más los problemas en diferentes partes del mundo derivados de la escasez del agua. Cerrar el grifo cuando no se use o asegurarse de que los grifos cierran bien y no hay fugas, son algunas de las recomendaciones sobre cómo ahorrar agua en casa.
                    """)
                    .font(.body)
                    .foregroundColor(.black) // Cambié a negro aquí
                    
                    Text("""
                    El ser humano necesita del agua para vivir, pero también para llevar a cabo una serie de actividades como bañarse, limpiar, cocinar…etc. En ocasiones, en algunas de estas rutinas que practicamos día a día, nos olvidamos de la importancia de ahorrar agua para evitar así un malgasto de un recurso tan valioso cuyo despilfarro puede suponer un problema ambiental mayor.
                    
                    Ahorrar agua supone evitar un consumo excesivo de ésta con el fin de proteger el medio ambiente y mitigar los efectos del cambio climático en el planeta. Un consumo sostenible del agua es una responsabilidad de todos y, a través de pequeños gestos, podemos colaborar a reducir su despilfarro.
                    """)
                    .font(.body)
                    .foregroundColor(.black) // Cambié a negro aquí
                    
                    Text("¿Cómo ahorrar agua en casa?: 10 ‘tips’ básicos")
                        .bold()
                        .font(.title2)
                        .foregroundColor(.white) // Cambié a blanco aquí
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .top) {
                            Text("1.")
                                .font(.body)
                                .bold()
                            Text("Cierra los grifos siempre que no los uses, aunque te parezca poco tiempo: mientras te enjabonas el pelo, te cepillas los dientes, fregar utensilios de cocina, mientras te afeitas.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                        
                        HStack(alignment: .top) {
                            Text("2.")
                                .font(.body)
                                .bold()
                            Text("Dúchate en lugar de bañarte, una ducha gasta un 50% menos de agua. Una ducha de 5 min, ahorra unos 3.500 litros al mes.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                        
                        HStack(alignment: .top) {
                            Text("3.")
                                .font(.body)
                                .bold()
                            Text("Recoge el agua que sale del grifo mientras esperas a que se caliente, y reutilízala para regar, fregar el suelo, lavar ropa a mano, etc.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                        
                        HStack(alignment: .top) {
                            Text("4.")
                                .font(.body)
                                .bold()
                            Text("Utiliza reductores de presión para la ducha con el objetivo de ahorrar agua.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                        
                        HStack(alignment: .top) {
                            Text("5.")
                                .font(.body)
                                .bold()
                            Text("Coloca 2 botellas llenas dentro de la cisterna y ahorrarás de 2 a 4 litros cada vez que la uses y no emplees el inodoro como papelera.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                        
                        HStack(alignment: .top) {
                            Text("6.")
                                .font(.body)
                                .bold()
                            Text("Utiliza de forma eficiente los electrodomésticos: pon la lavadora, el lavavajillas y similares cuando estén totalmente llenos. Poner la lavadora cuando esté llena te puede hacer ahorrar de 2.500 a 2.800 litros cada mes.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                        
                        HStack(alignment: .top) {
                            Text("7.")
                                .font(.body)
                                .bold()
                            Text("Descongela los alimentos en la nevera o a temperatura ambiente, pero no bajo el chorro del grifo.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                        
                        HStack(alignment: .top) {
                            Text("8.")
                                .font(.body)
                                .bold()
                            Text("Agua fría en la nevera. Si dejas siempre una jarra de agua fría en la nevera no tendrás que esperar cuando abras el grifo a que salga fresca, ahorrando una importante cantidad.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                        
                        HStack(alignment: .top) {
                            Text("9.")
                                .font(.body)
                                .bold()
                            Text("Si tienes jardín, mejor utiliza plantas autóctonas, así no te excederás en el uso de agua para regar. Aprovecha también a recoger el agua de lluvia. Riega tus plantas al amanecer o al anochecer porque así evitarás que el agua se evapore antes de ser absorbida. No limpies el suelo con manguera, usa una escoba.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                        
                        HStack(alignment: .top) {
                            Text("10.")
                                .font(.body)
                                .bold()
                            Text("Arregla enseguida cualquier fuga de agua: un grifo goteando puede suponer hasta 40 litros de agua al día.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                    }
                    
                    Text("""
                    El uso global del agua se ha multiplicado por seis en los últimos 100 años y continúa creciendo de manera constante a una tasa aproximada del 1% anual. El aumento de la población, el desarrollo económico y los patrones de consumo siguen aumentando el uso de este recurso hídrico tan valioso. Esto llevará al empeoramiento de la calidad de vida de aquellos lugares donde el acceso al agua ya es un problema y comenzará a serlo en algunas regiones donde todavía no lo es.
                    
                    Otra forma de poner nuestro granito de arena para construir un mundo más sostenible es ahorrando energía. Por ello, compartimos una serie de recomendaciones para ahorrar energía eléctrica.
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
    LearnWater(onBack: {})
}

