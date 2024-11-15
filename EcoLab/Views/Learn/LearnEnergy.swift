import SwiftUI

struct LearnEnergy: View {
    var onBack: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ZStack {
                    Image("luzBG")
                        .resizable()
                        .frame(width: .infinity, height: 410)
                        .opacity(0.5)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Es muy sencillo cuidar de la luz")
                            .bold()
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        
                        Text("Ahorra unos pesitos en tu recibo de luz")
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
                    Es posible que todos y cada uno de nosotros adoptemos medidas sencillas para cuidar nuestro planeta mediante un uso responsable y eficiente de la energía. El folleto “Para cuidar el medio ambiente, tu salud y tus bolsillos unos consejillos”, del Centro de Educación y Capacitación para el Desarrollo Sustentable, recomienda:
                    """)
                    .font(.body)
                    .foregroundColor(.black) // Cambié a negro aquí
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .top) {
                            Text("1.")
                                .font(.body)
                                .bold()
                            Text("Revisa que la instalación eléctrica no tenga “fugas”. Apaga todas las luces que no necesites; desconecta los aparatos eléctricos que no utilices y verifica que el disco del medidor no gire; si tu medidor es digital, checa que no avance la numeración.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                        
                        HStack(alignment: .top) {
                            Text("2.")
                                .font(.body)
                                .bold()
                            Text("No conectes varios aparatos a un solo contacto; produce sobrecarga en la instalación, sobrecalentamiento, operación deficiente, interrupciones, cortocircuitos y daños.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                        
                        HStack(alignment: .top) {
                            Text("3.")
                                .font(.body)
                                .bold()
                            Text("Identifica aparatos que al conectarlos producen chispas o calientan el cable. No los uses sin haber resuelto el problema.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                        
                        HStack(alignment: .top) {
                            Text("4.")
                                .font(.body)
                                .bold()
                            Text("Aprovecha al máximo la luz natural; utiliza la energía eléctrica sólo si la necesitas. Pinta techos y paredes de tonos claros; usa lámparas ahorradoras y límpialas periódicamente.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                        
                        HStack(alignment: .top) {
                            Text("5.")
                                .font(.body)
                                .bold()
                            Text("Apaga y desconecta aparatos que no se están usando: televisor, radio, computadora, tostador, horno de microondas, DVD. Si suspendes el uso de la computadora, apaga por lo menos el monitor.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                        
                        HStack(alignment: .top) {
                            Text("6.")
                                .font(.body)
                                .bold()
                            Text("Cierra herméticamente la puerta del refrigerador. No dejes abierta la puerta más tiempo del necesario. Nunca introduzcas alimentos calientes. Ajusta el termostato al mínimo requerido.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                        
                        HStack(alignment: .top) {
                            Text("7.")
                                .font(.body)
                                .bold()
                            Text("Coloca el refrigerador en un lugar fresco y ventilado, lejos de la estufa, el calentador o de una ventana donde el sol dé directamente. Descongélalo y límpialo con frecuencia.")
                                .font(.body)
                                .foregroundColor(.black) // Cambié a negro aquí
                        }
                        
                        HStack(alignment: .top) {
                            Text("8.")
                                .font(.body)
                                .bold()
                            Text("Plancha durante el día para aprovechar la luz natural. Inicia con la ropa que requiera menos calor y plancha la mayor cantidad en cada sesión. Apágala antes de terminar toda la tanda de ropa para aprovechar el calor acumulado.")
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
    LearnEnergy(onBack: {})
}

