import SwiftUI

struct OctaveView: View {
    @EnvironmentObject var synth: Synth
    let octave: Int
    var body: some View {
        ZStack(alignment: .top) {
            HStack(spacing:10) {
                WhiteKey(octave: octave, keyNumber: 0, function: pressedKey)
                WhiteKey(octave: octave, keyNumber: 2, function: pressedKey)
                WhiteKey(octave: octave, keyNumber: 4, function: pressedKey)
                WhiteKey(octave: octave, keyNumber: 5, function: pressedKey)
                WhiteKey(octave: octave, keyNumber: 7, function: pressedKey)
                WhiteKey(octave: octave, keyNumber: 9, function: pressedKey)
                WhiteKey(octave: octave, keyNumber: 11, function: pressedKey)
            }
            HStack(spacing:20) {
                BlackKey(octave: octave, keyNumber: 1, function: pressedKey)
                BlackKey(octave: octave, keyNumber: 3, function: pressedKey)
                spacerKey
                BlackKey(octave: octave, keyNumber: 6, function: pressedKey)
                BlackKey(octave: octave, keyNumber: 8, function: pressedKey)
                BlackKey(octave: octave, keyNumber: 10, function: pressedKey)
                spacerKey
            }.offset(CGSize(width: 30, height: 0))
        }
    }
    
    var spacerKey: some View {
        Rectangle().fill(Color.clear).frame(width: 40, height: 60)
    }
    
    func pressedKey(_ keyNumber: Int, down: Bool) {
        print("pressed \(keyNumber)")
        if down {
            let halfStepsFromA4 = (keyNumber - 69)
            let a = 1.059463094359
            synth.frequency = Float(440.0 * pow(a, Double(halfStepsFromA4)))
            synth.startPlaying()
            return
        }
        synth.frequency = 0
        synth.stopPlaying()
    }
    
    private struct WhiteKey: View {
        let octave: Int
        let keyNumber: Int
        let function: (Int, Bool) -> Void
        @State var isTouched = false
        var body: some View {
            Rectangle().fill(Color.white).frame(width: 50, height: 120).gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if( !isTouched) {
                            isTouched = true
                            function(keyNumber+(octave*12), isTouched)
                        }
                        
                    }
                    .onEnded { value in
                        isTouched = false
                        function(keyNumber, isTouched)
                    }
            )
        }
    }
    
    private struct BlackKey: View {
        let octave: Int
        let keyNumber: Int
        let function: (Int, Bool) -> Void
        @State var isTouched = false
        var body: some View {
            Rectangle().fill(Color.black).frame(width: 40, height: 70).gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if( !isTouched) {
                            isTouched = true
                            function(keyNumber+(octave*12), isTouched)
                        }
                    }
                    .onEnded { value in
                        isTouched = false
                        function(keyNumber+(octave*12), isTouched)
                    }
            )
        }
    }
}

struct OctaveView_Previews: PreviewProvider {
    static var previews: some View {
        OctaveView(octave: 0)
    }
}
