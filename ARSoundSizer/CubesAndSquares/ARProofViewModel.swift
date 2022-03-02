import Combine
import RealityKit
import SwiftUI

class ARProofViewModel: ObservableObject {
    @Published var showMenu = false
    @Published var arBackground = false
    var backgroundCancellable: AnyCancellable?
    private var arView: ARView?
    var cubeposition = false
    var entities = [(ModelEntity, PositionRef)]()
    var gridSacing: Float {
        return cubeSize + 0.02
    }
    let cubeSize: Float = 0.1
    var planeAnchor: AnchorEntity?
    let numberCubes = 7
    func createGrid() {
        let gridProvider = GridProvider()
        let grid = gridProvider.createGrid(numberCubes)
        planeAnchor = AnchorEntity(world: [-0.5,-1,-0.5])
        arView?.scene.addAnchor(planeAnchor!)
        for gridElement in grid {
            let boxMesh = MeshResource.generateBox(size: cubeSize)
            let boxMaterial = SimpleMaterial(color: cubeColor(gridElement.cubeID), roughness: 0.2, isMetallic: true)
            
            let x: Float = Float(cubeposition ? gridElement.cubePosition.x : gridElement.squarePosition.x)*(-gridSacing)
            let y: Float = Float(cubeposition ? gridElement.cubePosition.y : gridElement.squarePosition.y)*(gridSacing)
            let z: Float = Float(cubeposition ? gridElement.cubePosition.z : gridElement.squarePosition.z)*(-gridSacing)
            
            let boxEntity = ModelEntity(mesh: boxMesh, materials: [boxMaterial])
            entities.append((boxEntity, gridElement))
            boxEntity.position = [x,y,z]
            planeAnchor?.addChild(boxEntity)
        }
    }
    
    func setARView(_ view: ARView) {
        self.arView = view
        self.backgroundCancellable = $arBackground.sink { hasARBackground in
            self.arView?.environment.background = hasARBackground ? .cameraFeed() : .color(.gray)
        }
    }
    
    func toggleSquare() {
        cubeposition.toggle()
        positionElements()
    }
    
    func positionElements() {
        
        entities.forEach { (entity, position) in
            let x: Float = Float(cubeposition ? position.cubePosition.x : position.squarePosition.x)*(-gridSacing)
            let y: Float = Float(cubeposition ? position.cubePosition.y : position.squarePosition.y)*gridSacing
            let z: Float = Float(cubeposition ? position.cubePosition.z : position.squarePosition.z)*(-gridSacing)
                
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
