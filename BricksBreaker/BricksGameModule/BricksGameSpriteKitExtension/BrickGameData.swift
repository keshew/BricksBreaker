import SwiftUI
import SpriteKit

class BrickGameData: ObservableObject {
    @Published var isPause = false
    @Published var isMenu = false
    @Published var isWin = false
    @Published var isLose = false
    @Published var isFlying = false
    @Published var isRocketUsing = false
    @Published var currentScore = 0
    @Published var countOfBalls = 1
    @Published var tapCount = 0
    @Published var scene = SKScene()
    @ObservedObject var audioManager = AudioManager.shared
}
