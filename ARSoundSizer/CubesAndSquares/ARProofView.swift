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
        let planeAnchor = AnchorEntity(world: [4,-2,2])
        
//        planeAnchor.addChild(planeEntity)
        arView.scene.addAnchor(planeAnchor)
        
        for i in 0..<2 {
            let sphereMesh = MeshResource.generateBox(size: 0.2)
            let sphereMaterial = SimpleMaterial(color: .purple, roughness: 0.2, isMetallic: true)
            let x: Float = -4 + Float(i)*0.25
            let y: Float = 0.5
            let z: Float = -4.0
            
            let sphereEntity = ModelEntity(mesh: sphereMesh, materials: [sphereMaterial])
            sphereEntity.position = [x,y,z]
            planeAnchor.addChild(sphereEntity)
        }
        
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}
