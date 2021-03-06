import SwiftUI
import RealityKit
import Combine

struct ChemicalWaveView : View {
    @State var showMenu = false
    @StateObject var viewModel = ChemicalWaveViewModel()
    var body: some View {
        ZStack {
            ChemicalWaveContainer(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    viewModel.buildScene()
                }.navigationBarItems(leading: Picker("press action", selection: $viewModel.pressAction) {
                    ForEach(PressAction.allCases, id: \.self) { action in
                        Text("\(action.rawValue)")
                    }
                }.pickerStyle(SegmentedPickerStyle()), trailing: Button("menu", action: {
                    showMenu = true
                }) )
                .sheet(isPresented: $showMenu) {
                    ChemicalWaveMenu().environmentObject(viewModel)
                }
        }
    }
}

struct ChemicalWaveContainer: UIViewRepresentable {
    let viewModel: ChemicalWaveViewModel
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .ar,  automaticallyConfigureSession: true)
        viewModel.setView(arView)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}
