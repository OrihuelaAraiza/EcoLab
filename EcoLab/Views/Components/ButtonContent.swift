import SwiftUI
struct ButtonContent: View {
    let imageName: String
    let title: String
    let subtitle: String

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) { // Establecer alineación a .leading
                HStack(spacing: 0) {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width / 4, height: geometry.size.height / 4)
                        .padding(.leading, 10)
                    Spacer()
                }
                .frame(height: geometry.size.height / 2)

                Text(title)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 2, alignment: .leading)
                    .padding(.top, 10)
                    .padding(.leading, 10)
                
                Text(subtitle)
                    .font(.system(size: 8))
                    .foregroundColor(.gray)
                    .fontWeight(.light)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 2, alignment: .leading)
                    .padding(.leading, 10)
            }
            .padding(.bottom, 10)
        }
    }
}
