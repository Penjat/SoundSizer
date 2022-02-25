import Foundation

struct PositionRef: Equatable {
    static func == (lhs: PositionRef, rhs: PositionRef) -> Bool {
        return lhs.cubePosition == rhs.cubePosition
    }
    
    typealias GridPosition = (x: Int, y: Int, z: Int)
    let cubePosition: GridPosition
    //    let SquarePosition: GridPosition
}

class GridProvider {
    func createGrid(_ numElemnts: Int) -> [PositionRef] {
        var grid = [PositionRef]()
        for i in 0..<numElemnts {
            //create cube
            let index = i+1
            for x in 0..<index {
                for y in 0..<index {
                    for z in 0..<index {
                        let offset = ((i+1)*i)/2
                        print("i = \(i) , offset = \(offset)")
                        grid.append(PositionRef(cubePosition: (x + offset, y, z + offset )))
                    }
                }
            }
        }
        return grid
    }
}
