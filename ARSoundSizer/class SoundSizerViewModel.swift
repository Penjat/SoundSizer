import Foundation
import Combine
import RealityKit

class SoundSizerViewModel: ObservableObject {
    var soundBox: Entity?
    var arView: ARView?
    @Published var waveSize = 0.0
    
    func loadScene() {
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        
        arView?.scene.anchors.append(boxAnchor)
    }
    
    func setObjectSize(size: Float) {
        if let anchor = arView?.scene.findEntity(named: "note") {
            anchor.setScale(SIMD3(size, size, size), relativeTo: nil)
        }
    }
}
