import SwiftUI
import RealityKit
import Combine

class ChemicalWaveViewModel: ObservableObject {
    private enum Constants {
        static let sphereSize: Float = 0.2
        static let numRows = 5
        static let numCols = 5
        static let gridSpace: Float = 0.02
    }
    
    var arView: ARView?
    var gridAnchor: AnchorEntity?
    var entities = [Entity: ChemicalNode]()
    
    var gridSpacing: Float {
        return Constants.sphereSize*2 + Constants.gridSpace
    }
    
    func setView(_ view: ARView) {
        self.arView = view
        
    }
    
    func buildScene() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
        arView?.addGestureRecognizer(tap)
        arView?.environment.background = .color(.blue)
        gridAnchor = AnchorEntity(world: [0,-1,-0.5])
        arView?.scene.addAnchor(gridAnchor!)
        let node = try! ARAssets.loadBox().chemicalNode
        print(node?.availableAnimations)
        for row in 0..<Constants.numRows {
            for col in 0..<Constants.numCols {
                //                let boxMesh = MeshResource.generateSphere(radius: Constants.sphereSize)
                //                let boxMaterial = SimpleMaterial(color: .blue, roughness: 0.2, isMetallic: true)
                
                let x: Float = Float(row)*gridSpacing
                let y: Float = Float(0)
                let z: Float = Float(col)*(-1)*gridSpacing
                
                let boxEntity = node!.clone(recursive: true)//ModelEntity(mesh: boxMesh, materials: [boxMaterial])
                let node = ChemicalNode(position: (x: row, y: 0, z: col))
                entities[boxEntity] = node
                
                boxEntity.position = [x,y,z]
                
                gridAnchor?.addChild(boxEntity)
            }
        }
    }
    
    @objc func handleTap(rec: UITapGestureRecognizer){
        let location = rec.location(in: arView!)
        print(location)
        guard let entity = arView!.entities(at: location).first else {
            print("hit nothing")
            return
        }
        
        fireNode(entity: entity)
    }
    
    func fireNode(entity: Entity) {
        guard let node = entities[entity] else {
            return
        }
        node.state = .charging
        let rotation = Transform(scale: SIMD3<Float>(2.0, 2.0, 2.0), translation: entity.position)
        
        entity.move(to: rotation,
                    relativeTo: gridAnchor,
                    duration: 0.5,
                    timingFunction: .easeInOut)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
                entity.move(to: Transform(scale: SIMD3<Float>(1.0, 1.0, 1.0), translation: entity.position),
                            relativeTo: self.gridAnchor,
                        duration: 0.5,
                        timingFunction: .easeInOut)
        }
        
        let neighbors = entities.filter { (_, value) in
            abs(value.position.x - node.position.x) <= 1 && abs(value.position.y - node.position.y) <= 1 && abs(value.position.z - node.position.z) <= 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            neighbors.filter{ $0.value.state == .idle }.forEach { (entity, _) in
                self.fireNode(entity: entity)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            neighbors.forEach { (_, node) in
                node.state = .idle
            }
        }
    }
}
