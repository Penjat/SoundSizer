import SwiftUI
import Combine

class WaveMakerContainerViewModel: ObservableObject {
    @Published var wav1: (Double) -> Double = {_ in 0}
    @Published var wav2: (Double) -> Double = {_ in 0}
    @Published var wav3: (Double) -> Double = {_ in 0}
    @Published var wav4: (Double) -> Double = {_ in 0}
}


struct WaveMakerContainerView: View {
    @StateObject var synth = Synth()
    @StateObject var viewModel = WaveMakerContainerViewModel()
    @State var bag = Set<AnyCancellable>()
    var body: some View {
        VStack {
            Toggle("wav cap", isOn: $synth.wavCap)
            ZStack {
                WaveView(frequency: 1.0, wav: synth.wav, color: .white)
                    
                
                WaveView(frequency: 1.0, wav: viewModel.wav1, color: Color(red: 1.0, green: 0.0, blue: 1.0, opacity: 0.3))
                    
                WaveView(frequency: 1.0, wav: viewModel.wav2, color: Color(red: 0.0, green: 0.0, blue: 1.0, opacity: 0.3))
                    
                WaveView(frequency: 1.0, wav: viewModel.wav3, color: Color(red: 0.0, green: 1.0, blue: 0.0, opacity: 0.3))
                    
                WaveView(frequency: 1.0, wav: viewModel.wav4, color: Color(red: 1.0, green: 0.0, blue: 0.0, opacity: 0.3))
                    
            }.frame(width: 400, height: 200).border(.blue)
            
            TabView {
                WaveControllerView(wav: $viewModel.wav1, maxMagnitude: 1)
                WaveControllerView(wav: $viewModel.wav2, isOn: false, maxMagnitude: 1)
                WaveControllerView(wav: $viewModel.wav3, isOn: false, maxMagnitude: 1)
                WaveControllerView(wav: $viewModel.wav4, isOn: false, maxMagnitude: 1)
            }.tabViewStyle(PageTabViewStyle())
            
            Spacer()
            ScrollView(.horizontal, showsIndicators: true) {
                LazyHStack {
                    ForEach(0..<8, id: \.self) { index in
                        OctaveView(octave: index)
                    }
                }
            }
            .frame(height: 200)
            .background(.ultraThinMaterial)
        }
        .environmentObject(synth)
        .onAppear {
            viewModel.$wav1.merge(with: viewModel.$wav2, viewModel.$wav3, viewModel.$wav4).sink { _ in
                synth.wav = { viewModel.wav1($0) + viewModel.wav2($0) + viewModel.wav3($0) + viewModel.wav4($0) }
            }.store(in: &bag)
        }
    }
}

struct WaveMakerContainerView_Previews: PreviewProvider {
    static var previews: some View {
        WaveMakerContainerView()
    }
}
