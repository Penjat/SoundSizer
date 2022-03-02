import SwiftUI
import RealityKit
import Combine

struct ChemicalWaveView : View {
    @StateObject var viewModel = ChemicalWaveViewModel()
    var body: some View {
        ChemicalWaveContainer(viewModel: viewModel)
            .edgesIgnoringSafeArea(.all).onAppear {
                viewModel.buildScene()
            }
    }
}

struct ChemicalWaveContainer: UIViewRepresentable {
    let viewModel: ChemicalWaveViewModel
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .ar,  automaticallyConfigureSession: true)
        viewModel.setView(arView)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}
