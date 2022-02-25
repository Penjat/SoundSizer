import SwiftUI
import Combine

class WaveMakerViewModel: ObservableObject {
    @Published var wav1: (Double) -> Double = {_ in 0}
    @Published var wav2: (Double) -> Double = {_ in 0}
    @Published var wav3: (Double) -> Double = {_ in 0}
    @Published var wav4: (Double) -> Double = {_ in 0}
}

struct WaveMakerView: View {
    @Binding var wav: (Double) -> Double
    @StateObject var viewModel = WaveMakerViewModel()
    @State var bag = Set<AnyCancellable>()
    var maxMagnitude: Double = 2.0
    var body: some View {
        VStack {
            HStack {
                WaveControllerView(wav: $viewModel.wav1, maxMagnitude: maxMagnitude)
                WaveControllerView(wav: $viewModel.wav2, isOn: false, maxMagnitude: maxMagnitude)
            }
            HStack {
                WaveControllerView(wav: $viewModel.wav3, isOn: false, maxMagnitude: maxMagnitude)
                WaveControllerView(wav: $viewModel.wav4, isOn: false, maxMagnitude: maxMagnitude)
            }
        }.onAppear {
            viewModel.$wav1.eraseToAnyPublisher().merge(with: viewModel.$wav2, viewModel.$wav3, viewModel.$wav4).sink { _ in
                self.setWav()
            }.store(in: &bag)
            setWav()
        }
    }
    
    func setWav() {
        wav = {(input: Double) -> Double in
            viewModel.wav1(input)  + viewModel.wav2(input) + viewModel.wav3(input) + viewModel.wav4(input)
        }
    }
}
