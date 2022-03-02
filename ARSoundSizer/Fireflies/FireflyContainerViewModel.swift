import SwiftUI
import RealityKit
import Combine

class FireflyContainerViewModel: ObservableObject {
    var arView: ARView?
    var gridAnchor: AnchorEntity?
    let sphereSize: Float = 0.2
    var fireflies = [Firefly]()
    
    func setView(_ view: ARView) {
        self.arView = view
        
        gridAnchor = AnchorEntity(world: [0,0,-0.5])
        arView?.scene.addAnchor(gridAnchor!)
        //        for gridElement in grid {
        let boxMesh = MeshResource.generateSphere(radius: sphereSize)
        let boxMaterial = SimpleMaterial(color: .red, roughness: 0.2, isMetallic: true)
        
        let x: Float = Float(0)
        let y: Float = Float(0)
        let z: Float = Float(-2)
        
        let boxEntity = ModelEntity(mesh: boxMesh, materials: [boxMaterial])
        //            entities.append((boxEntity, gridElement))
        boxEntity.position = [x,y,z]
        gridAnchor?.addChild(boxEntity)
    }
}
