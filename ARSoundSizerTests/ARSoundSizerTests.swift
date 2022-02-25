import XCTest

@testable import ARSoundSizer
class ARSoundSizerTests: XCTestCase {
    func testCreate1x1Cube() {
        let gridProvider = GridProvider()
        
        let grid = gridProvider.createGrid(1)
        
        XCTAssertEqual(grid, [PositionRef(cubePosition: (0,0,0), squarePosition: (0,0,0))])
        XCTAssertEqual(1, grid.count)
    }
    
    func testCreate2x2Cube() {
        let gridProvider = GridProvider()
        
        let grid = gridProvider.createGrid(2)
        
        // 1x1
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (0,0,0) }))
        
        // 2x2
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (1,0,1) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (2,0,2) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (2,0,1) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (1,0,2) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (1,1,1) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (2,1,2) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (2,1,1) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (1,1,2) }))
        
        XCTAssertEqual(9, grid.count)
    }
    
    func testCreate3x3Cube() {
        let gridProvider = GridProvider()
        
        let grid = gridProvider.createGrid(3)
        
        // 1x1
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (0,0,0) }))

        // 2x2
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (1,0,1) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (2,0,2) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (2,0,1) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (1,0,2) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (1,1,1) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (2,1,2) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (2,1,1) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (1,1,2) }))
        
        // 3x3
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (5,0,5) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (4,0,5) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (3,0,5) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (5,0,4) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (5,0,3) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (3,0,3) }))
        
        print(grid)
        XCTAssertEqual(36, grid.count)
    }
    
    func testCreate4x4Cube() {
        let gridProvider = GridProvider()
        
        let grid = gridProvider.createGrid(4)
        
        // 1x1
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (0,0,0) }))

        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (6,0,6) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (9,0,9) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (9,0,6) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (6,0,9) }))
        
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (6,3,6) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (9,3,9) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (9,3,6) }))
        XCTAssertTrue(grid.contains(where: { $0.cubePosition == (6,3,9) }))
        
        XCTAssertEqual(100, grid.count)
    }
    
    func testCreate1x1Square() {
        let gridProvider = GridProvider()
        
        let grid = gridProvider.createGrid(1)
        
        // 1x1
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (0,0,0) }))
    }
    
    func testCreate2x2Square() {
        let gridProvider = GridProvider()
        
        let grid = gridProvider.createGrid(2)
        
        // Base
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (1,0,1) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (2,0,2) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (2,0,1) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (1,0,2) }))
        
        // Bottom half shifted down
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (1,0,0) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (2,0,0) }))
        
        // top half shifted over and fliped
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (0,0,1) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (0,0,2) }))
    }
    
    func testCreate3x3Square() {
        let gridProvider = GridProvider()
        
        let grid = gridProvider.createGrid(3)
        
        // Base
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (3,0,3) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (3,0,4) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (3,0,5) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (4,0,4) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (5,0,3) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (4,0,4) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (5,0,5) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (4,0,5) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (5,0,4) }))
        
        // middle shifted down
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (3,0,0) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (3,0,1) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (3,0,2) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (4,0,1) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (5,0,0) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (4,0,1) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (5,0,2) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (4,0,2) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (5,0,1) }))
        
        //top shifted left
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (0,0,3) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (0,0,4) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (0,0,5) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (1,0,4) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (2,0,3) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (1,0,4) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (2,0,5) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (1,0,5) }))
        XCTAssertTrue(grid.contains(where: { $0.squarePosition == (2,0,4) }))
    }
    
    func testCreate4x4Square() {
        let gridProvider = GridProvider()
        
        let grid = gridProvider.createGrid(4)
        
        for x in 6..<10 {
            for z in 6..<10 {
                // base
                XCTAssertTrue(grid.contains(where: { $0.squarePosition == (x,0,z) }))
                
                // bottom side
                XCTAssertTrue(grid.contains(where: { $0.squarePosition == (x,0,0) }))
                XCTAssertTrue(grid.contains(where: { $0.squarePosition == (x,0,1) }))
                
                // left side
                XCTAssertTrue(grid.contains(where: { $0.squarePosition == (0,0,z) }))
                XCTAssertTrue(grid.contains(where: { $0.squarePosition == (1,0,z) }))
                
            }
        }
    }
}
