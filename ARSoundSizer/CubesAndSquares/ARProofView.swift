import SwiftUI
import RealityKit
import Combine

struct ARProofView : View {
    @StateObject var viewModel = ARProofViewModel()
    var body: some View {
        MyARViewContainer(viewModel: viewModel)
        .edgesIgnoringSafeArea(.all)
        .navigationBarItems(leading: Button(action: {viewModel.showMenu = true}, label: {
            Text("menu")
        }), trailing: Button("swap", action: {
            viewModel.toggleSquare()
        }))
        .onAppear {
            viewModel.createGrid()
        }.sheet(isPresented: $viewModel.showMenu) {
            VStack {
                Toggle("AR background", isOn: $viewModel.arBackground)
            }
        }
    }
}

struct MyARViewContainer: UIViewRepresentable {
    let viewModel: ARProofViewModel
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .ar,  automaticallyConfigureSession: true)
        viewModel.setARView(arView)
        
        arView.environment.background = .color(.gray)
        let pointLight = PointLight()
        pointLight.light.intensity = 10000
        
        let lightAnchor = AnchorEntity(world: [0,0,0])
        lightAnchor.addChild(pointLight)
        arView.scene.addAnchor(lightAnchor)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}
