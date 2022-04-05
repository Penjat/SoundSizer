import SwiftUI

struct WaveView: View {
    var title: String = ""
    let frequency: Double
    var wav: (Double) -> Double = sin
    var color: Color
    var magnitude = 1.0
    var body: some View {
        VStack {
            Text(title)
            HStack(spacing: 0) {
                ForEach(0..<100){ index in
                    let wavOutput = (wav(Double(index)/100.0*Double.pi*2*frequency)/magnitude+1)/2
                    let height = wavOutput*30
                    
                    VStack(spacing: 0.0) {
                        VStack(spacing: 1.0) {
                            Spacer()
                            Rectangle().fill(color).frame(width: 4, height: max(0, height))
                        }
                        VStack {
                            Rectangle().fill(color).frame(width: 4, height: max(0,-height))
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}
