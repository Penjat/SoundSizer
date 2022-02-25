import SwiftUI
import RealityKit
import Combine

struct ChemicalWaveView : View {
    
    var body: some View {
        
        ARChemicalWaveViewContainer()
            
        
        .edgesIgnoringSafeArea(.all)
    }
}

struct ARChemicalWaveViewContainer: UIViewRepresentable {
//    let viewModel: SoundSizerViewModel
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .ar,  automaticallyConfigureSession: true)
//        viewModel.arView = arView
        arView.environment.background = .color(.blue)
        
        let pointLight = PointLight()
        pointLight.light.intensity = 10000
        
        let lightAnchor = AnchorEntity(world: [0,0,0])
        lightAnchor.addChild(pointLight)
        arView.scene.addAnchor(lightAnchor)
        
        let planeMesh = MeshResource.generatePlane(width: 10, depth: 10)
        let planeMaterial = SimpleMaterial(color: .white, roughness: 0.5, isMetallic: true)
        
        let planeEntity = ModelEntity(mesh: planeMesh, materials: [planeMaterial])
        let planeAnchor = AnchorEntity(world: [0,-5,0])
        
        planeAnchor.addChild(planeEntity)
        arView.scene.addAnchor(planeAnchor)
        
        let sphereMesh = MeshResource.generateSphere(radius: 0.8)
        let sphereMaterial = SimpleMaterial(color: .purple, roughness: 0.2, isMetallic: true)
        
        let sphereEntity = ModelEntity(mesh: sphereMesh, materials: [sphereMaterial])
        let shpereAnchor = AnchorEntity(world: [0,1,-2])
        
        shpereAnchor.addChild(sphereEntity)
        arView.scene.addAnchor(shpereAnchor)
        
//        let camera = PerspectiveCamera()
//        let cameraAnchor = AnchorEntity(world: [0,1,1])
//        cameraAnchor.addChild(camera)
        
//        arView.scene.addAnchor(cameraAnchor)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}
