import Combine
import RealityKit

class ARProofViewModel: ObservableObject {
    var arView: ARView?
    
    func createGrid() {
        let gridProvider = GridProvider()
        let grid = gridProvider.createGrid(3)
        
        for gridElement in grid {
            let boxMesh = MeshResource.generateBox(size: 0.2)
            let boxMaterial = SimpleMaterial(color: .purple, roughness: 0.2, isMetallic: true)
            let gridSacing: Float = 0.25
            let x: Float = Float(gridElement.cubePosition.x)*gridSacing
            let y: Float = Float(gridElement.cubePosition.y)*gridSacing
            let z: Float = Float(gridElement.cubePosition.z)*gridSacing
            
            let boxEntity = ModelEntity(mesh: boxMesh, materials: [boxMaterial])
            boxEntity.position = [x,y,z]
            
            let planeAnchor = AnchorEntity(world: [4,-2,2])
            arView?.scene.addAnchor(planeAnchor)
            
            planeAnchor.addChild(boxEntity)
        }
    }
}
