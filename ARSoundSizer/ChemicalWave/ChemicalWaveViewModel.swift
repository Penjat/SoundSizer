import SwiftUI
import RealityKit
import Combine

enum PressAction: String, CaseIterable {
    case fire
    case block
}

class ChemicalWaveViewModel: ObservableObject {
    private enum Constants {
        static let sphereSize: Float = 0.05
        static let numRows = 30
        static let numCols = 30
        static let gridSpace: Float = 0.02
        static let scaleAmt: Float = 3.0
        static let waveSpeed = 0.3
        static let chargeTime = 4
    }
    
    var arView: ARView?
    var gridAnchor: AnchorEntity?
    var entities = [Entity: ChemicalNode]()
    var bag = Set<AnyCancellable>()
    
    @Published var pressAction = PressAction.fire

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
        for row in 0..<Constants.numRows {
            for col in 0..<Constants.numCols {
                let x: Float = Float(row)*gridSpacing
                let y: Float = Float(0)
                let z: Float = Float(col)*(-1)*gridSpacing
                
                let boxEntity = node!.clone(recursive: true)
                let node = ChemicalNode(position: (x: row, y: 0, z: col))
                entities[boxEntity] = node
                
                boxEntity.position = [x,y,z]
                gridAnchor?.addChild(boxEntity)
            }
        }
        
        Timer.publish(every: 0.5, on: .main, in: .default)
            .autoconnect().sink { click in
                self.entities.forEach { (entity, chemicalNode) in
                    switch chemicalNode.state {
                    case .charging(let timeLeft):
                        if timeLeft == 0 {
                            chemicalNode.state = .idle
                        } else {
                            chemicalNode.state = .charging(timeLeft: timeLeft - 1)
                        }
                    default:
                        break
                    }
                }
                
                self.entities.filter{ $0.value.state == .firing }.forEach { (entity, chemicalNode) in
                    switch chemicalNode.state {
                    case .firing:
                        self.entities.filter { (_, value) in
                            value.state == .idle && abs(value.position.x - chemicalNode.position.x) <= 1 && abs(value.position.y - chemicalNode.position.y) <= 1 && abs(value.position.z - chemicalNode.position.z) <= 1
                        }.forEach { (key: Entity, value: ChemicalNode) in
                            value.state = .firing
                            let rotation = Transform(scale: SIMD3<Float>(1.0, Constants.scaleAmt, 1.0), translation: key.position)
                            
                            
                            key.move(to: rotation,
                                        relativeTo: self.gridAnchor,
                                        duration: 0.5,
                                        timingFunction: .easeInOut)
                        }
                        chemicalNode.state = .charging(timeLeft: Constants.chargeTime)
                        entity.move(to: Transform(scale: SIMD3<Float>(1.0, 1.0, 1.0), translation: entity.position),
                                    relativeTo: self.gridAnchor,
                                    duration: Constants.waveSpeed*Double(Constants.chargeTime),
                                timingFunction: .easeInOut)
                    default:
                        break
                    }
                }
            }.store(in: &bag)
    }
    
    @objc func handleTap(rec: UITapGestureRecognizer){
        let location = rec.location(in: arView!)
        print(location)
        guard let entity = arView!.entities(at: location).first else {
            print("hit nothing")
            return
        }
        switch pressAction {
        case .fire:
            fireNode(entity: entity)
        case .block:
            guard let node = entities[entity] else {
                return
            }
            if node.state == .blocked {
                node.state = .idle
                entity.setScale(SIMD3<Float>(1.0, 1.0, 1.0), relativeTo: self.gridAnchor)
            } else {
                node.state = .blocked
                entity.setScale(SIMD3<Float>(0.5, 0.5, 0.5), relativeTo: self.gridAnchor)
            }
        }
    }
    
    func fireNode(entity: Entity) {
        guard let node = entities[entity] else {
            return
        }
        node.state = .firing
        let rotation = Transform(scale: SIMD3<Float>(1.0, Constants.scaleAmt, 1.0), translation: entity.position)
        
        entity.move(to: rotation,
                    relativeTo: self.gridAnchor,
                    duration: 0.5,
                    timingFunction: .easeInOut)
    }
}
