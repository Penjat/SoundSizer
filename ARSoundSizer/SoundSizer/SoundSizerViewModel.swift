import Foundation
import Combine
import RealityKit
import ARKit

class SoundSizerViewModel: ObservableObject {
    var soundBox: Entity?
    var arView: ARView?
    @Published var showBackground = false
    @Published var waveSize = 0.0
    @Published var showingMenu = false
    var bag = Set<AnyCancellable>()
    
    func loadScene() {
        
        let note = try! Experience.loadBox().note
////        boxAnchor.position = SIMD3(0.0, 0.0, -0.2)
////        arView?.scene. pointOfView?.addChildNode(boxAnchor)
//        arView?.scene.anchors.append(boxAnchor)
        
        arView?.environment.background = .color(.blue)
        
        let pointLight = PointLight()
        pointLight.light.intensity = 10000
        
        let lightAnchor = AnchorEntity(world: [0,0,0])
        lightAnchor.addChild(pointLight)
        arView?.scene.addAnchor(lightAnchor)
        
//        let planeMesh = MeshResource.generatePlane(width: 10, depth: 10)
//        let planeMaterial = SimpleMaterial(color: .white, roughness: 0.5, isMetallic: true)
//        
//        let planeEntity = ModelEntity(mesh: planeMesh, materials: [planeMaterial])
//        let planeAnchor = AnchorEntity(world: [0,-5,0])
//        
//        planeAnchor.addChild(planeEntity)
//        arView?.scene.addAnchor(planeAnchor)
        
        
        let sphereMesh = MeshResource.generateSphere(radius: 0.5)
        let sphereMaterial = SimpleMaterial(color: .purple, roughness: 0.2, isMetallic: true)
        
        let sphereEntity = ModelEntity(mesh: sphereMesh, materials: [sphereMaterial])
        sphereEntity.name = "note"
        let shpereAnchor = AnchorEntity(world: [0,0,0])
        
        shpereAnchor.addChild(note!)
        arView?.scene.addAnchor(shpereAnchor)
        
        $showBackground.sink { value in
            self.arView?.environment.background = value ? .color(.blue) : .cameraFeed()
        }.store(in: &bag)
    }
    
    func setObjectSize(size: Float) {
        if let anchor = arView?.scene.findEntity(named: "note") {
            anchor.setScale(SIMD3(size, 1, size), relativeTo: nil)
        }
    }
}
