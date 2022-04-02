import Foundation

class ChemicalNode {
    var position: (x: Int, y: Int, z: Int)
    init(position: (x: Int, y: Int, z: Int)) {
        self.position = position
    }
    var state = NodeState.idle
}

enum NodeState: Equatable {
    case idle
    case firing
    case charging(timeLeft: Int)
    case blocked
}
