import SwiftUI

struct ContentView: View {
    @State var isPlaying = false
    var body: some View {
        VStack {
            Spacer()
            KeyboardView()
            Spacer()
        }.background(Color.blue) 
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
