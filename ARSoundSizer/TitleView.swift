import SwiftUI

struct TitleView: View {
    var body: some View {
        NavigationView {
        VStack {
                NavigationLink("Sound Sizer") {
                    ARSoundSizerView()
                }
                NavigationLink("Wave Maker") {
                    WaveMakerContainerView()
                }
            }
        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
