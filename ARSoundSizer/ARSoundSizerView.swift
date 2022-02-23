import SwiftUI
import RealityKit
import Combine

struct ARSoundSizerView : View {
    @StateObject var synth = Synth()
    @StateObject var viewModel = SoundSizerViewModel()
    var body: some View {
        ZStack {
            ARViewContainer(viewModel: viewModel)
            VStack() {
                Spacer()
                HStack {
                    Text(synth.isPlaying ? "\(synth.frequency)" : "")
                    Spacer()
                    Text(synth.isPlaying ? "\(343.0/synth.frequency) meters" : "")
                }.foregroundColor(.white).font(.system(size: 20))
                
                ScrollView(.horizontal, showsIndicators: true) {
                    LazyHStack {
                        ForEach(0..<8, id: \.self) { index in
                            OctaveView(octave: index)
                        }
                    }
                }
                .frame(height: 300)
                .background(.ultraThinMaterial)
            }.onAppear {
                viewModel.loadScene()
                
            }.onChange(of: synth.isPlaying) { newValue in
                viewModel.setObjectSize(size: Float(343.0)/synth.frequency)
                print("setting size")
            }
        }
        .environmentObject(synth)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    let viewModel: SoundSizerViewModel
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        viewModel.arView = arView
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
