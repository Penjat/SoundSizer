import SwiftUI
import RealityKit
import Combine

class ARProofViewModel: ObservableObject {
    var arView: ARView?
}

struct ARProofView : View {
    @StateObject var viewModel = ARProofViewModel()
    var body: some View {
        MyARViewContainer(viewModel: viewModel)
        .edgesIgnoringSafeArea(.all)
    }
}

struct MyARViewContainer: UIViewRepresentable {
    let viewModel: ARProofViewModel
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .ar,  automaticallyConfigureSession: true)
        
        let pointLight = PointLight()
        pointLight.light.intensity = 10000
        
        let lightAnchor = AnchorEntity(world: [0,0,0])
        lightAnchor.addChild(pointLight)
        arView.scene.addAnchor(lightAnchor)
        
        let planeMesh = MeshResource.generatePlane(width: 10, depth: 10)
        let planeMaterial = SimpleMaterial(color: .white, roughness: 0.5, isMetallic: true)
        
        let planeEntity = ModelEntity(mesh: planeMesh, materials: [planeMaterial])
        let planeAnchor = AnchorEntity(world: [10,-2,2])
        
        planeAnchor.addChild(planeEntity)
        arView.scene.addAnchor(planeAnchor)
        
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}
