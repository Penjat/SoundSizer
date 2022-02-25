import XCTest

@testable import ARSoundSizer
class ARSoundSizerTests: XCTestCase {
    func testCreate1x1Cube() {
        let gridProvider = GridProvider()
        
        let grid = gridProvider.createGrid(1)
        
        XCTAssertEqual(grid, [PositionRef(cubePosition: (0,0,0))])
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
}
