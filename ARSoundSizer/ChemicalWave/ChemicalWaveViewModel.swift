import SwiftUI
import RealityKit
import Combine

enum PressAction: String, CaseIterable {
    case fire
    case block
    case blockRow
    case blockCol
    case blockLayer
    
}

class ChemicalWaveViewModel: ObservableObject {
    private enum Constants {
        static let sphereSize: Float = 0.1
        static let numRows = 10
        static let numCols = 10
        static let numLayer = 5
        static let gridSpace: Float = 0.02
        static let scaleAmt: Float = 1.4
        static let blockedSize: Float = 1.0
        static let idleSize: Float = 1.0
        static let waveSpeed = 0.3
        static let chargeTime = 4
        static let idleMaterial = SimpleMaterial(color: .gray, isMetallic: false)
        static let activeMaterial = SimpleMaterial(color: .orange, isMetallic: false)
        static let chargingMaterial = SimpleMaterial(color: .blue, isMetallic: false)
        static let blockedMaterial = SimpleMaterial(color: SimpleMaterial.Color(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.0)), isMetallic: false)
        
    }
    
    var arView: ARView?
    var gridAnchor: AnchorEntity?
    var entities = [ModelEntity: ChemicalNode]()
    var bag = Set<AnyCancellable>()
    
    @Published var pressAction = PressAction.fire
    
    var gridSpacing: Float {
        return Constants.sphereSize + Constants.gridSpace
    }
    
    func setView(_ view: ARView) {
        self.arView = view
        
    }
    
    func buildScene() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
        arView?.addGestureRecognizer(tap)
        arView?.environment.background = .cameraFeed()//.color(.blue)
        gridAnchor = AnchorEntity(world: [0,-1,-0.5])
        arView?.scene.addAnchor(gridAnchor!)
//        let node = try! ARAssets.loadBox().chemicalNode
        // Create the cube
        let cubeModel = ModelEntity(
            mesh: .generateBox(size: Constants.sphereSize),
         materials: []
        )
        // Fetch the default metal library
        let mtlLibrary = MTLCreateSystemDefaultDevice()!
          .makeDefaultLibrary()!
        // Fetch the default metal library
        // Fetch the default metal library
        
        let geometryShader = CustomMaterial.SurfaceShader(
          named: "myShader", in: mtlLibrary
        )
        
        cubeModel.model?.materials = [
            Constants.idleMaterial]
        cubeModel.collision = CollisionComponent(shapes: [.generateBox(size: SIMD3<Float>(Constants.sphereSize, Constants.sphereSize, Constants.sphereSize))])
        cubeModel.setScale(SIMD3<Float>(Constants.idleSize, Constants.idleSize, Constants.idleSize), relativeTo: gridAnchor)
        for row in 0..<Constants.numRows {
            for col in 0..<Constants.numCols {
                for lay in 0..<Constants.numLayer {
                    let x: Float = Float(row)*gridSpacing
                    let y: Float = Float(lay)*gridSpacing
                    let z: Float = Float(col)*(-1)*gridSpacing
                    
                    let boxEntity = cubeModel.clone(recursive: true)
                    let node = ChemicalNode(position: (x: row, y: lay, z: col))
                    entities[boxEntity] = node
                    
                    boxEntity.position = [x,y,z]
                    gridAnchor?.addChild(boxEntity)
                }
            }
        }
        
        Timer.publish(every: 0.5, on: .main, in: .default)
            .autoconnect().sink { click in
                self.entities.forEach { (entity, chemicalNode) in
                    switch chemicalNode.state {
                    case .charging(let timeLeft):
                        if timeLeft == 0 {
                            chemicalNode.state = .idle
                            entity.model?.materials = [Constants.idleMaterial]
                        } else {
                            chemicalNode.state = .charging(timeLeft: timeLeft - 1)
                            entity.model?.materials = [Constants.chargingMaterial]
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
                        }.forEach { (key: ModelEntity, value: ChemicalNode) in
                            value.state = .firing
                            let rotation = Transform(scale: SIMD3<Float>(Constants.scaleAmt, Constants.scaleAmt, Constants.scaleAmt), translation: key.position)
                            
                            key.model?.materials = [Constants.activeMaterial]
                            key.move(to: rotation,
                                     relativeTo: self.gridAnchor,
                                     duration: 0.5,
                                     timingFunction: .easeInOut)
                            
                        }
                        chemicalNode.state = .charging(timeLeft: Constants.chargeTime)
                        entity.move(to: Transform(scale: SIMD3<Float>(Constants.idleSize, Constants.idleSize, Constants.idleSize), translation: entity.position),
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
        guard let selectedEntity = arView!.entities(at: location).first as? ModelEntity, let node = entities[selectedEntity] else {
            print("hit nothing")
            return
        }
        let toggleState = node.state == .blocked ? NodeState.idle : .blocked
        switch pressAction {
        case .fire:
            fireNode(entity: selectedEntity)
        case .block:
            
            setState(entity: selectedEntity, node: node, state: toggleState)
        break
        case .blockRow:
            entities.filter{ $0.value.position.y == node.position.y && $0.value.position.z == node.position.z }.forEach { (key: ModelEntity, value: ChemicalNode) in
                setState(entity: key, node: value, state: toggleState)
            }
        case .blockCol:
            entities.filter{ $0.value.position.x == node.position.x && $0.value.position.z == node.position.z }.forEach { (key: ModelEntity, value: ChemicalNode) in
                setState(entity: key, node: value, state: toggleState)
            }
        case .blockLayer:
            entities.filter{ $0.value.position.y == node.position.y && $0.value.position.x == node.position.x }.forEach { (key: ModelEntity, value: ChemicalNode) in
                setState(entity: key, node: value, state: toggleState)
            }
        }
    }
    
    func setState(entity: ModelEntity, node: ChemicalNode, state: NodeState) {
            node.state = state
        entity.model?.materials = [state == .blocked ? Constants.blockedMaterial : Constants.idleMaterial]
        entity.setScale(state == .blocked ? SIMD3<Float>(Constants.blockedSize, Constants.blockedSize, Constants.blockedSize) : SIMD3<Float>(Constants.idleSize, Constants.idleSize, Constants.idleSize), relativeTo: self.gridAnchor)
        
    }
    
    func fireNode(entity: ModelEntity) {
        guard let node = entities[entity] else {
            return
        }
        node.state = .firing
        let rotation = Transform(scale: SIMD3<Float>(Constants.scaleAmt, Constants.scaleAmt, Constants.scaleAmt), translation: entity.position)
        entity.model?.materials = [Constants.activeMaterial]
        entity.move(to: rotation,
                    relativeTo: self.gridAnchor,
                    duration: 0.5,
                    timingFunction: .easeInOut)
    }
}
