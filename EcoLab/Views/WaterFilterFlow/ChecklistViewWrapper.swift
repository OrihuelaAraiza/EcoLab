import SwiftUI

struct ChecklistViewWrapper: View {
    var onAllItemsChecked: () -> Void

    var body: some View {
        ZStack {
            ChecklistView(onAllItemsChecked: {
                onAllItemsChecked()
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .cornerRadius(12)
            .padding()
        }
    }
}
