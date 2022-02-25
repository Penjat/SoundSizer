import Foundation

typealias GridPosition = (x: Int, y: Int, z: Int)

struct PositionRef: Equatable {
    static func == (lhs: PositionRef, rhs: PositionRef) -> Bool {
        return lhs.cubePosition == rhs.cubePosition && lhs.squarePosition == rhs.squarePosition
    }
    
    let cubePosition: GridPosition
    let squarePosition: GridPosition
    let cubeID: Int
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
                        print("\(x) \(y) \(z)")
                        let offset = ((i+1)*i)/2
                        
                        let squarePosition: GridPosition = {
                            // Bottom layer stays
                            if y == 0 {
                                return (x: x + offset, y: 0, z: z + offset)
                            }
                            
                            // if last layer and even
                            if y == i && index%2 == 0 {
                                //if bottom half
                                if z < index/2 {
                                    print("bottom to bottom index = \(index) , y \(y) , z \(z) , x+offset \(x + offset) ")
                                    return (x: x + offset, y: 0, z: z)
                                }
                                // top half
                                print("top to left index = \(index) , y \(y) , z \(z) , new z = \(z - (index)/2)")
                                return (x: z - (index)/2, y: 0, z: x + offset)
                            }
                            
                            // odd layers not base
                            if y%2 == 1 {
                                // if even sided
                                if index % 2 == 0 {
                                    return (x: x + offset, y: 0, z: z + (index / 2) + index*(y-1)/2)
                                }
                                return (x: x + offset, y: 0, z: z + index*(y-1)/2)
                            }
                            
                            // even layers not base
                            
                            // if even sided
                            if index % 2 == 0 {
                                return (x: x + index*(y-1)/2, y: 0, z: z + offset )
                            }
                            return (x: x + index*(y-2)/2, y: 0, z: z + offset)
                            
                        }()
                        grid.append(PositionRef(cubePosition: (x + offset, y, z + offset ), squarePosition: squarePosition, cubeID: i))
                    }
                }
            }
        }
        return grid
    }
}
