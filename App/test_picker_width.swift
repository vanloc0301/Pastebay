import SwiftUI

struct TestView: View {
    @State var sel1 = 1
    var body: some View {
        VStack {
            Picker("", selection: $sel1) {
                Text("Short")
                    .frame(width: 120, alignment: .leading)
                    .tag(1)
            }
            .labelsHidden()
            .controlSize(.small)
        }
    }
}
