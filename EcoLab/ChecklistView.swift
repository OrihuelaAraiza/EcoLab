import SwiftUI

struct ChecklistView: View {
    @State private var items: [ChecklistItem] = [
        ChecklistItem(name: "Botella", isChecked: false),
        ChecklistItem(name: "Agua", isChecked: false),
        ChecklistItem(name: "Paño", isChecked: false),
        ChecklistItem(name: "Recipiente", isChecked: false)
    ]
    var onAllItemsChecked: (() -> Void)?

    var body: some View {
        VStack {
            Text("Asegúrate de tener los materiales")
                .font(.headline)
                .foregroundColor(.white)
                .padding()

            List {
                ForEach($items) { $item in
                    HStack {
                        Text(item.name)
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.white)
                            .onTapGesture {
                                item.isChecked.toggle()
                                checkIfAllItemsChecked()
                            }
                    }
                }
                .listRowBackground(Color.black.opacity(0.4)) // Fondo oscuro en cada fila para mejorar visibilidad
            }
            .background(Color.clear) // Fondo transparente para la lista

            Button(action: {
                onAllItemsChecked?()
            }) {
                Text("Continuar")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!items.allSatisfy { $0.isChecked })
            .padding()
        }
    }
    
    private func checkIfAllItemsChecked() {
        if items.allSatisfy({ $0.isChecked }) {
            onAllItemsChecked?()
        }
    }
}

struct ChecklistItem: Identifiable {
    let id = UUID()
    let name: String
    var isChecked: Bool
}
