import SwiftUI

struct KeyboardView: View {
    @StateObject var synth = Synth()
    var body: some View {
        VStack {
            Text(synth.isPlaying ? "\(343.0/synth.frequency) meters" : "").frame(height: 30).padding()
            ScrollView(.horizontal, showsIndicators: true) {
                LazyHStack {
                    ForEach(0..<8, id: \.self) { index in
                        OctaveView(octave: index)
                    }
                }
            }
            .background(Color.orange)
            .environmentObject(synth)
        }
    }
}

struct KeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardView()
    }
}
