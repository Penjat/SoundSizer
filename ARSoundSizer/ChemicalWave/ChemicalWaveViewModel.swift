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
    
    
    var gridSpacing: Float {
        return Constants.sphereSize*2 + Constants.gridSpace
    }
    
    func setView(_ view: ARView) {
        self.arView = view
        
    }
    
    func buildScene() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))

        //Add recognizer to sceneview
        arView?.addGestureRecognizer(tap)
        arView?.environment.background = .color(.blue)
        gridAnchor = AnchorEntity(world: [0,-1,-0.5])
        arView?.scene.addAnchor(gridAnchor!)
        for row in 0..<Constants.numRows {
            for col in 0..<Constants.numCols {
                let boxMesh = MeshResource.generateSphere(radius: Constants.sphereSize)
                let boxMaterial = SimpleMaterial(color: .blue, roughness: 0.2, isMetallic: true)
                
                let x: Float = Float(row)*gridSpacing
                let y: Float = Float(0)
                let z: Float = Float(col)*(-1)*gridSpacing
                
                let boxEntity = ModelEntity(mesh: boxMesh, materials: [boxMaterial])
    //            entities.append((boxEntity, gridElement))
                boxEntity.position = [x,y,z]
                boxEntity.collision = CollisionComponent(
                    shapes: [.generateSphere(radius: Constants.sphereSize)],
                    mode: .trigger,
                    filter: .sensor
                )
                
                gridAnchor?.addChild(boxEntity)
            }
        }

    }
    
   

    //Method called when tap
    @objc func handleTap(rec: UITapGestureRecognizer){
        
        
        
        let location = rec.location(in: arView!)
        print(location)
        guard let entity = arView!.entities(at: location).first else {
            print("hit nothing")
            return
        }
        
        entity.removeFromParent()
    }
}
