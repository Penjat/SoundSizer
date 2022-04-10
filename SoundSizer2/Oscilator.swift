import Foundation

typealias Signal = (_ frequency: Float, _ time: Float) -> Float

enum Waveform: Int {
    case sine, triangle, sawtooth, square, whiteNoise
}

struct Oscillator {
    
    static var amplitude: Float = 1
    
    static var sine: Signal = { frequency, time in
        let theta = Double(2.0 * Float.pi * frequency * time)
        return Oscillator.amplitude * Float(sin(theta))
    }
}

func triangleWave(_ input: Double) -> Double {
    return (abs((input + Double.pi/2).remainder(dividingBy:Double.pi*2)/Double.pi)-0.5)*2
}

func squareWave(_ input: Double) -> Double  {
    return (input.remainder(dividingBy: Double.pi*2) >= 0) ? 1 : -1
}

func sawWave(_ input: Double) -> Double {
    return (input).truncatingRemainder(dividingBy: Double.pi*2)/(Double.pi)-1
}

func noise(_ input: Double) -> Double {
    return Double.random(in: -1...1)
}

