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
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.6))
                .frame(width: 300, height: 400)
                .overlay(
                    VStack {
                        Text("Asegúrate de tener los materiales")
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.top, 20)

                        Spacer()

                        ForEach($items) { $item in
                            HStack {
                                Text(item.name)
                                    .foregroundColor(.white)
                                    .padding(.leading)
                                Spacer()
                                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        item.isChecked.toggle()
                                        checkIfAllItemsChecked()
                                    }
                                    .padding(.trailing)
                            }
                            .padding(.vertical, 8)
                        }

                        Spacer()

                        Button(action: {
                            onAllItemsChecked?()
                        }) {
                            Text("Continuar")
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        .disabled(!items.allSatisfy { $0.isChecked })
                    }
                    .padding()
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
