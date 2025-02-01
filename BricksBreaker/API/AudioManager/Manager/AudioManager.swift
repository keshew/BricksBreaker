import AVFoundation
import SwiftUI

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    var backgroundPlayer: AVAudioPlayer?
    var losePlayer: AVAudioPlayer?
    var winPlayer: AVAudioPlayer?
    var yellowBallPlayer: AVAudioPlayer?
    var blockPlayer: AVAudioPlayer?
    var ballPlayer: AVAudioPlayer?
    
    
    @Published var backgroundVolume: Float {
        didSet {
            backgroundPlayer?.volume = backgroundVolume
            losePlayer?.volume = backgroundVolume
            winPlayer?.volume = backgroundVolume
        }
    }
    
    @Published var soundEffectVolume: Float {
        didSet {
            yellowBallPlayer?.volume = soundEffectVolume
            blockPlayer?.volume = soundEffectVolume
            ballPlayer?.volume = soundEffectVolume
        }
    }
    
    init() {
        self.backgroundVolume = UserDefaultsManager().loadVolumeSettings().0
        self.soundEffectVolume = UserDefaultsManager().loadVolumeSettings().1
        
        loadBackgroundMusic()
        loadWinMusic()
        loadLoseMusic()
        loadYellowBallMusic()
        loadBlockMusic()
        loadBallMusic()
    }
    
    private func loadBackgroundMusic() {
        if let url = Bundle.main.url(forResource: "bg", withExtension: "wav") {
            do {
                backgroundPlayer = try AVAudioPlayer(contentsOf: url)
                backgroundPlayer?.numberOfLoops = -1
                backgroundPlayer?.volume = backgroundVolume
                backgroundPlayer?.prepareToPlay()
            } catch {
                print("Ошибка \(error)")
            }
        }
    }
    
    private func loadBallMusic() {
        if let url = Bundle.main.url(forResource: "ball", withExtension: "wav") {
            do {
                ballPlayer = try AVAudioPlayer(contentsOf: url)
                ballPlayer?.volume = backgroundVolume
                ballPlayer?.prepareToPlay()
            } catch {
                print("Ошибка \(error)")
            }
        }
    }
    
    private func loadLoseMusic() {
        if let url = Bundle.main.url(forResource: "lose", withExtension: "wav") {
            do {
                losePlayer = try AVAudioPlayer(contentsOf: url)
                losePlayer?.volume = backgroundVolume
                losePlayer?.prepareToPlay()
            } catch {
                print("Ошибка \(error)")
            }
        }
    }
    
    private func loadBlockMusic() {
        if let url = Bundle.main.url(forResource: "block", withExtension: "wav") {
            do {
                blockPlayer = try AVAudioPlayer(contentsOf: url)
                blockPlayer?.volume = soundEffectVolume
                blockPlayer?.prepareToPlay()
            } catch {
                print("Ошибка \(error)")
            }
        }
    }
    
    private func loadWinMusic() {
        if let url = Bundle.main.url(forResource: "win", withExtension: "wav") {
            do {
                winPlayer = try AVAudioPlayer(contentsOf: url)
                winPlayer?.volume = backgroundVolume
                winPlayer?.prepareToPlay()
            } catch {
                print("Ошибка \(error)")
            }
        }
    }
    
    private func loadYellowBallMusic() {
        if let url = Bundle.main.url(forResource: "yellowBall", withExtension: "wav") {
            do {
                yellowBallPlayer = try AVAudioPlayer(contentsOf: url)
                yellowBallPlayer?.prepareToPlay()
                yellowBallPlayer?.volume = soundEffectVolume
            } catch {
                print("Ошибка \(error)")
            }
        }
    }
    
    func playBackgroundMusic() {
        backgroundPlayer?.play()
    }
    
    func stopBackgroundMusic() {
        backgroundPlayer?.stop()
    }
    
    func playYellowBallMusic() {
        yellowBallPlayer?.play()
    }
    
    func stopYellowBallMusic() {
        yellowBallPlayer?.stop()
    }
    
    func playLoseMusic() {
        losePlayer?.play()
    }
    
    func stopLoseMusic() {
        losePlayer?.stop()
    }
    
    func playWinMusic() {
        winPlayer?.play()
    }
    
    func stopWinMusic() {
        winPlayer?.stop()
    }
    
    func playBlockMusic() {
        blockPlayer?.play()
    }
    
    func stopBlockMusic() {
        blockPlayer?.stop()
    }
    
    func playBallMusic() {
        ballPlayer?.play()
    }
    
    func stopBallkMusic() {
        ballPlayer?.stop()
    }
}
