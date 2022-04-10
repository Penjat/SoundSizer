import SwiftUI

struct TitleView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                NavigationLink("Sound Sizer") {
                    ARSoundSizerView()
                }
                NavigationLink("Piano") {
                    ARPianoView()
                }
                NavigationLink("Wave Maker") {
                    WaveMakerContainerView()
                }
                NavigationLink("Chemical Wave") {
                    ChemicalWaveView()
                }
                NavigationLink("Cubes & Squares") {
                    ARProofView()
                }
                NavigationLink("Fireflies") {
                    FireflyContainerView()
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
