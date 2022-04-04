import SwiftUI

struct ChemicalWaveMenu: View {
    @EnvironmentObject var viewModel: ChemicalWaveViewModel
    var body: some View {
        VStack {
            Slider(value: $viewModel.chargeTime, in: 1...10)
            Stepper("rows \(viewModel.numRows)", value: $viewModel.numRows)
            Stepper("cols \(viewModel.numCols)", value: $viewModel.numCols)
            Stepper("layers \(viewModel.numLayer)", value: $viewModel.numLayer)
            Button("Create new grid") {
                viewModel.createGrid()
            }
        }
    }
}

struct ChemicalWaveMenu_Previews: PreviewProvider {
    static var previews: some View {
        ChemicalWaveMenu()
    }
}
