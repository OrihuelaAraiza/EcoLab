import SwiftUI

struct AboutView: View {
    var onBack: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ZStack {
                    Image("aboutBG")
                        .resizable()
                        .frame(width: .infinity, height: 400)
                        .opacity(0.5)
                    
                    VStack(alignment: .center, spacing: 10) {
                        Text("Acerca de EcoLab")
                            .bold()
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        
                        Text("¿Te animas a fabricar tus propias soluciones?")
                            .bold()
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        Text("Convierte materiales comunes en ideas extraordinarias.")
                            .bold()
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 60)
                }
                .background(Color.black)
                .cornerRadius(15)
                .shadow(radius: 10)
                .padding(.horizontal, 10)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("""
                    **EcoLab** es una iniciativa dedicada a promover la sostenibilidad y el cuidado del medio ambiente a través de proyectos educativos y comunitarios. Nuestro objetivo es empoderar a las comunidades con las herramientas y conocimientos necesarios para crear un impacto positivo en nuestro entorno.
                    """)
                        .font(.body)
                        .padding(.horizontal, 20)
                    
                    Text("**Desarrollado por**")
                        .bold()
                        .font(.title2)
                        .padding(.horizontal, 20)
                    
                    // Lista de desarrolladores
                    VStack(alignment: .leading, spacing: 10) {
                        Text("• **Emiliano Montes Gómez**")
                            .font(.body)
                        
                        Text("• **Lizbeth Rocio Trujillo Salgado**")
                            .font(.body)
                        
                        Text("• **Diego Vitela**")
                            .font(.body)
                        
                        Text("• **Juan Pablo Orihuela**")
                            .font(.body)
                    }
                    .padding(.horizontal, 20)
                    .foregroundColor(.black)
                    
                    // Información Adicional (Opcional)
                    Text("""
                    **Nuestra Misión:** Fomentar prácticas sostenibles y educar a las comunidades sobre la importancia de preservar los recursos naturales para las futuras generaciones.
                    
                    **Nuestra Visión:** Ser una referencia en iniciativas ambientales que inspiren cambios positivos a nivel local y global.
                    """)
                        .font(.body)
                        .padding(.horizontal, 20)
                }
                .padding(.horizontal, 120)
                .padding(.bottom, 20)
                .foregroundColor(.black)
            }
            .background(Color.white) // Fondo blanco para el contenido
            .overlay(
                // Botón de cerrar en la esquina superior derecha
                Button(action: onBack) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.7))
                        .clipShape(Circle())
                        .padding()
                }
                .padding(.trailing, 20),
                alignment: .topTrailing
            )
        }
        .background(Color.white) // Fondo blanco para toda la vista
        .ignoresSafeArea()
    }
    
    struct AboutView_Previews: PreviewProvider {
        static var previews: some View {
            AboutView(onBack: {})
        }
    }
}
