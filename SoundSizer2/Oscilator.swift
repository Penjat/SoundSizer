import Foundation

typealias Signal = (_ frequency: Float, _ time: Float) -> Float

enum Waveform: Int {
    case sine, triangle, sawtooth, square, whiteNoise
}

struct Oscillator {
    
    static var amplitude: Float = 1
    
    static var sine: Signal = { frequency, time in
        let theta = Double(2.0 * Float.pi * frequency * time)
        let wav1 = sin(theta)
        let wav2 = sin(theta*4.9)
        let wav3 = sawWave(theta*6.2)/4
        
        return Oscillator.amplitude * Float(wav1 + wav2 + wav3)/2
    }
}


func triangleWave(_ input: Double) -> Double {
    return abs((input + Double.pi/2).remainder(dividingBy:Double.pi*2)/Double.pi)-0.5
}

func squareWave(_ input: Double) -> Double  {
    return (input.remainder(dividingBy: Double.pi*2) >= 0) ? 1 : -1
}

func sawWave(_ input: Double) -> Double {
    return input.remainder(dividingBy: Double.pi*2)/(Double.pi*2)
}

func noise(_ input: Double) -> Double {
    return Double.random(in: -1...1)
}
