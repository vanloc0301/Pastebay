import SwiftUI

struct TestView: View {
    @State var sel1 = 1
    @State var sel2 = 2
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Picker("", selection: $sel1) { Text("Telex").tag(1) }
                .labelsHidden()
                .controlSize(.small)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(width: 148)
                .frame(width: 168, alignment: .trailing)
                .border(Color.red)
                
            Picker("", selection: $sel2) { Text("Unicode").tag(2) }
                .labelsHidden()
                .controlSize(.small)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(width: 148)
                .frame(width: 168, alignment: .trailing)
                .border(Color.blue)
        }
        .padding()
    }
}
