import SwiftUI
import RealityKit

struct ContentView : View {
    @StateObject var synth = Synth()
    
    var body: some View {
        ZStack {
            ARViewContainer()
            VStack() {
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
        }
        .environmentObject(synth)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        
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
