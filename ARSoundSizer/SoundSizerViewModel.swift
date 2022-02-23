import Foundation
import Combine
import RealityKit
import ARKit

class SoundSizerViewModel: ObservableObject {
    var soundBox: Entity?
    var arView: ARView?
    @Published var waveSize = 0.0
    
    func loadScene() {
        let boxAnchor = try! Experience.loadBox()
        arView?.scene.anchors.append(boxAnchor)
        
        if let session = arView?.session {
            let config = ARWorldTrackingConfiguration()
            config.planeDetection = [.vertical]
            session.run(config)
            
            let coachingOverlay = ARCoachingOverlayView()
            coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            coachingOverlay.session = session
            coachingOverlay.goal = .verticalPlane
            arView?.addSubview(coachingOverlay)
        }
    }
    
    func setObjectSize(size: Float) {
        if let anchor = arView?.scene.findEntity(named: "note") {
            anchor.setScale(SIMD3(size, size, size), relativeTo: nil)
        }
    }
}
