import SwiftUI

struct TitleView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                NavigationLink("Sound Sizer") {
                    ARSoundSizerView()
                }
                NavigationLink("Wave Maker") {
                    WaveMakerContainerView()
                }
                NavigationLink("Chemical Wave") {
                    ChemicalWaveView()
                }
            }.font(.title.bold())
        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
