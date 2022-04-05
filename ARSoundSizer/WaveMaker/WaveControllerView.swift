import SwiftUI

struct WaveControllerView: View {
    @Binding var wav: (Double) -> Double
    @State var frequency = 1.0
    @State var magnitude = 0.5
    @State var phase = 0.0
    @State var waveType = WaveType.SIN
    @State var isOn = true
    @State var lift = 1.0
    var maxMagnitude: Double = 1.0
    var body: some View {
        VStack(spacing: 0.0) {
            Toggle(isOn: $isOn) {
                Text(isOn ? "on" : "off")
            }
            Picker(selection: $waveType, label: Text("")) {
                ForEach(WaveType.allCases, id: \.rawValue){ waveType in
                    Text("\(waveType.rawValue)").tag(waveType)
                }
            }
            Group {
                HStack {
                    Text(String(format: "%.02f", frequency))
                    Slider(value: $frequency, in: 1.0...8.0).onChange(of: frequency) { _ in
                        setWave()
                    }
                }
                HStack {
                    Text(String(format: "%.02f", magnitude))
                    Slider(value: $magnitude, in: -maxMagnitude...maxMagnitude).onChange(of: magnitude) { _ in
                        setWave()
                    }
                }
                
                HStack {
                    Text(String(format: "%.02f", phase))
                    Slider(value: $phase, in: (Double.pi*(-2))...Double.pi*(2)).onChange(of: phase) { _ in
                        setWave()
                    }
                }
                
                HStack {
                    Text(String(format: "%.02f", lift))
                    Slider(value: $lift, in: (-1...1)).onChange(of: lift) { _ in
                        setWave()
                    }
                }
            }
                .disabled(!isOn)
        }.padding()
            .border(Color.white, width: 4)
            .onChange(of: waveType) { _ in
                setWave()
            }.onChange(of: isOn) { isOn in
                setWave()
            }
    }
    
    func setWave() {
        wav = isOn ? { waveType.waveForm($0*frequency + phase)*magnitude + lift} : { (_:Double) in 0}
    }
}

enum WaveType: String, CaseIterable {
    case SIN
    case TRI
    case SQUARE
    case SAW
    case NOISE
    
    var waveForm: (Double) -> Double {
        switch self {
        case .SIN:
            return sin
        case .TRI:
            return triangleWave
        case .NOISE:
            return noise
        case .SQUARE:
            return squareWave
        case .SAW:
            return sawWave
        }
    }
}
