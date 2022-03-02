import SwiftUI
import RealityKit
import Combine

struct FireflyContainerView : View {
    @StateObject var viewModel = FireflyContainerViewModel()
    var body: some View {
        FireflyContainerViewContainer(viewModel: viewModel)
            .edgesIgnoringSafeArea(.all)
    }
}

struct FireflyContainerViewContainer: UIViewRepresentable {
    let viewModel: FireflyContainerViewModel
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .ar,  automaticallyConfigureSession: true)
        viewModel.setView(arView)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}
