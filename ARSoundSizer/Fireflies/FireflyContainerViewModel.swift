import SwiftUI
import RealityKit
import Combine

class FireflyContainerViewModel: ObservableObject {
    var arView: ARView?
    var gridAnchor: AnchorEntity?
    let sphereSize: Float = 0.2
    var fireflies = [Firefly]()
    var timer: AnyCancellable?
    
    func setView(_ view: ARView) {
        self.arView = view
        createFireflies()
        timer = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink(receiveValue: { click in
                
            })
    }
    
    func createFireflies() {
        gridAnchor = AnchorEntity(world: [0,0,-0.5])
        arView?.scene.addAnchor(gridAnchor!)
        let boxMesh = MeshResource.generateSphere(radius: sphereSize)
        let boxMaterial = SimpleMaterial(color: .red, roughness: 0.2, isMetallic: true)
        
        let x: Float = Float(0)
        let y: Float = Float(0)
        let z: Float = Float(-2)
        
        let boxEntity = ModelEntity(mesh: boxMesh, materials: [boxMaterial])
        let firefly = Firefly(entity: boxEntity)
        fireflies.append(firefly)
        boxEntity.position = [x,y,z]
        gridAnchor?.addChild(boxEntity)
    }
}
