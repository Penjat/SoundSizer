import Combine
import RealityKit
import SwiftUI

class ARProofViewModel: ObservableObject {
    var arView: ARView?
    var cubeposition = false
    var entities = [(ModelEntity, PositionRef)]()
    let gridSacing: Float = 0.25
    var planeAnchor: AnchorEntity?
    let numberCubes = 5
    func createGrid() {
        let gridProvider = GridProvider()
        let grid = gridProvider.createGrid(numberCubes)
        planeAnchor = AnchorEntity(world: [0.5,-1,0.5])
        
        for gridElement in grid {
            let boxMesh = MeshResource.generateBox(size: 0.2)
            let boxMaterial = SimpleMaterial(color: cubeColor(gridElement.cubeID), roughness: 0.2, isMetallic: true)
            
            let x: Float = Float(cubeposition ? gridElement.cubePosition.x : gridElement.squarePosition.x)*gridSacing
            let y: Float = Float(cubeposition ? gridElement.cubePosition.y : gridElement.squarePosition.y)*gridSacing
            let z: Float = Float(cubeposition ? gridElement.cubePosition.z : gridElement.squarePosition.z)*gridSacing
            
            let boxEntity = ModelEntity(mesh: boxMesh, materials: [boxMaterial])
            entities.append((boxEntity, gridElement))
            boxEntity.position = [x,y,z]
            
            
            arView?.scene.addAnchor(planeAnchor!)
            
            planeAnchor?.addChild(boxEntity)
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
                
            entity.move(to: Transform(scale: [1,1,1], rotation: simd_quatf.init(), translation: [x,y,z]), relativeTo: planeAnchor, duration: 2.0)
            
        }
    }
    
    func cubeColor(_ id: Int) -> UIColor {
        let theta = Double(id)/Double(numberCubes) * Double.pi*2 + 0.14
        let red = ((sin(theta)+1)/2)
        let blue = ((sin(theta + Double.pi*2/3)+1)/2)
        let green = ((sin(theta + Double.pi*2/3*2)+1)/2)
        
        return UIColor.init(_colorLiteralRed: Float(red), green: Float(green), blue: Float(blue), alpha: 1.0)
    }
}
