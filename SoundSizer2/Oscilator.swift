import Foundation

typealias Signal = (_ frequency: Float, _ time: Float) -> Float

enum Waveform: Int {
    case sine, triangle, sawtooth, square, whiteNoise
}

struct Oscillator {
    
    static var amplitude: Float = 1
    
    static let sine: Signal = { frequency, time in
        let theta = Double(2.0 * Float.pi * frequency * time)
        let wav1 = sin(theta)
        let wav2 = sin(theta*4.9)
        let wav3 = squareWave(theta*6)/4
        
        return Oscillator.amplitude * Float(wav1 + wav2 + wav3)/2
    }
    
    static let triangle: Signal = { frequency, time in
        let period = 1.0 / Double(frequency)
        let currentTime = fmod(Double(time), period)
        
        let value = currentTime / period
        
        var result = 0.0
        if value < 0.25 {
            result = value * 4
        } else if value < 0.75 {
            result = 2.0 - (value * 4.0)
        } else {
            result = value * 4 - 4.0
        }
        
        return Oscillator.amplitude * Float(result)
    }

    static let sawtooth: Signal = { frequency, time in
        let period = 1.0 / frequency
        let currentTime = fmod(Double(time), Double(period))
        return Oscillator.amplitude * ((Float(currentTime) / period) * 2 - 1.0)
    }
    
    static let square: Signal = { frequency, time in
        let period = 1.0 / Double(frequency)
        let currentTime = fmod(Double(time), period)
        return ((currentTime / period) < 0.5) ? Oscillator.amplitude : -1.0 * Oscillator.amplitude
    }
    
    static let whiteNoise: Signal = { frequency, time in
        return Oscillator.amplitude * Float.random(in: -1...1)
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
