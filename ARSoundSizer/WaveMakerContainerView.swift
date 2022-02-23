import SwiftUI

struct WaveMakerContainerView: View {
    @StateObject var synth = Synth()
    var body: some View {
        VStack {
            Spacer()
            ScrollView(.horizontal, showsIndicators: true) {
                LazyHStack {
                    ForEach(0..<8, id: \.self) { index in
                        OctaveView(octave: index)
                    }
                }
            }
            .frame(height: 300)
            .background(.ultraThinMaterial)
        }
        .environmentObject(synth)
    }
}

struct WaveMakerContainerView_Previews: PreviewProvider {
    static var previews: some View {
        WaveMakerContainerView()
    }
}
