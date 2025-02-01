import SwiftUI
import SpriteKit

struct BrickGameView: View {
    @StateObject var brickGameModel =  BrickGameViewModel()
    @StateObject var gameModel =  BrickGameData()
    var level: Int
    
    var body: some View {
        if gameModel.isWin {
            BricksWinView(level: level)
        } else {
            ZStack {
                SpriteView(scene: brickGameModel.createBrickGameScene(gameData: gameModel, level: level))
                    .ignoresSafeArea()
                    .navigationBarBackButtonHidden(true)
                    
                if gameModel.isPause {
                    BrocksPauseView(game: gameModel, scene: gameModel.scene)
                }
                
                if gameModel.isLose {
                    BricksLoseView(level: level)
                }
            }
        }
    }
}

#Preview {
    BrickGameView(level: 1)
}

