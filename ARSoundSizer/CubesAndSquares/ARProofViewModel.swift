import Combine
import RealityKit

class ARProofViewModel: ObservableObject {
    var arView: ARView?
    var cubeposition = false
    var entities = [(ModelEntity, PositionRef)]()
    let gridSacing: Float = 0.25
    func createGrid() {
        let gridProvider = GridProvider()
        let grid = gridProvider.createGrid(4)
        
        for gridElement in grid {
            let boxMesh = MeshResource.generateBox(size: 0.2)
            let boxMaterial = SimpleMaterial(color: .purple, roughness: 0.2, isMetallic: true)
            
            
            let x: Float = Float(cubeposition ? gridElement.cubePosition.x : gridElement.squarePosition.x)*gridSacing
            let y: Float = Float(cubeposition ? gridElement.cubePosition.y : gridElement.squarePosition.y)*gridSacing
            let z: Float = Float(cubeposition ? gridElement.cubePosition.z : gridElement.squarePosition.z)*gridSacing
            
            let boxEntity = ModelEntity(mesh: boxMesh, materials: [boxMaterial])
            entities.append((boxEntity, gridElement))
            boxEntity.position = [x,y,z]
            
            let planeAnchor = AnchorEntity(world: [2,-2,2])
            arView?.scene.addAnchor(planeAnchor)
            
            planeAnchor.addChild(boxEntity)
        }
    }
    
    func toggleSquare() {
        cubeposition.toggle()
        positionElements()
    }
    
    func positionElements() {
        entities.forEach { (entity, position) in
            let x: Float = Float(cubeposition ? position.cubePosition.x : position.squarePosition.x)*gridSacing
            let y: Float = Float(cubeposition ? position.cubePosition.y : position.squarePosition.y)*gridSacing
            let z: Float = Float(cubeposition ? position.cubePosition.z : position.squarePosition.z)*gridSacing
            entity.position = [x,y,z]
        }
        
    }
}
