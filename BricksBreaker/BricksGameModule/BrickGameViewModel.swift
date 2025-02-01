import SwiftUI

class BrickGameViewModel: ObservableObject {
    let contact = BrickGameModel()

    func createBrickGameScene(gameData: BrickGameData, level: Int) -> BrickGameSpriteKit {
        let scene = BrickGameSpriteKit(levels: level)
        scene.game  = gameData
        return scene
    }
}
