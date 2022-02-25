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
                    Text(synth.isPlaying ? "\(String(format: "%.1f", synth.frequency)) hz" : "")
                    Spacer()
                    Text(sizeText)
                }
                .font(.title3.bold())
                .foregroundColor(.white).font(.system(size: 20))
                
                ScrollView(.horizontal, showsIndicators: true) {
                    LazyHStack {
                        ForEach(0..<8, id: \.self) { index in
                            OctaveView(octave: index)
                        }
                    }
                }.background(.ultraThinMaterial)
                .frame(height: 250)
            }
            .onAppear {
                viewModel.loadScene()
                
            }.onChange(of: synth.isPlaying) { newValue in
                viewModel.setObjectSize(size: Float(343.0)/synth.frequency)
                print("setting size")
            }.sheet(isPresented: $viewModel.showingMenu) {
                VStack {
                    Spacer()
                    Toggle("background", isOn: $viewModel.showBackground)
                    Spacer()
                }
            }.environmentObject(viewModel)
        }
        .navigationBarItems(trailing: Toggle("menu", isOn: $viewModel.showingMenu))
        .environmentObject(synth)
        .edgesIgnoringSafeArea(.all)
    }
    
    var sizeText: String {
        guard synth.isPlaying else {
            return ""
        }
        
        let size = 343.0/synth.frequency
        return size > 1 ? "\(String(format: "%.1f", size)) meters" : "\(String(format: "%.2f", size * 100)) cm"
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
