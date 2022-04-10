import SwiftUI
import ARKit
import RealityKit
import Combine

class ARPianoViewModel: NSObject, ObservableObject, ARSessionDelegate {
    var keyboardAnchor: AnchorEntity?
    var arView: ARView?
    
    private enum Constants {
        static let keySpacing: Float = 0.02
        static let whiteKeySize = SIMD3<Float>(0.1, 0.02, 0.2)
    }
    func setView(_ view: ARView) {
        self.arView = view
        self.arView?.environment.background = .color(.gray)
        keyboardAnchor = AnchorEntity(world: [-0.5,-1,-0.5])
        arView?.scene.addAnchor(keyboardAnchor!)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.vertical]
        arView?.session.run(configuration)
        arView?.session.delegate = self
        let box = MeshResource.generateBox(size: 0.3) // Generate mesh
        let color = Color(red: 1.0, green: 1.0, blue: 1.0)
//        let prefab = ModelEntity(mesh: box, materials: [SimpleMaterial(color: color, isMetallic: false)])
//        prefab.setScale(Constants.whiteKeySize, relativeTo: nil)
        
//        for i in 0..<88 {
////            let keyNode = prefab.clone(recursive: true) as
//            
//            keyNode.position = SIMD3<Float>(Float(0.0), Constants.whiteKeySize[1]*Float(i) + Constants.keySpacing, Float(0.0))
//            keyboardAnchor?.addChild(keyNode)
//        }
        
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        anchors.forEach { anchor in
            if let planeAnchor = anchor as? ARPlaneAnchor {
                let anchorEntity = AnchorEntity(anchor: planeAnchor)
                let node = try! ARAssets.loadBox().chemicalNode
                anchorEntity.addChild(node!)
                arView?.scene.anchors.append(anchorEntity)
                print("added a plane")
            } else {
                print("not a plane")
            }
        }
    }
}

struct ARPianoView : View {
    @StateObject var viewModel = ARPianoViewModel()
    @State var bag = Set<AnyCancellable>()
    var body: some View {
        ARPianoViewContainer(viewModel: viewModel)
            .edgesIgnoringSafeArea(.all)
    }
    
}

struct ARPianoViewContainer: UIViewRepresentable {
    let viewModel: ARPianoViewModel
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .ar,  automaticallyConfigureSession: true)
        
        viewModel.setView(arView)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}
