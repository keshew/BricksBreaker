import SwiftUI
import SpriteKit

class BrickGameSpriteKit: SKScene, SKPhysicsContactDelegate {
    var game: BrickGameData?
    let levels: Int
    var scoreLabel: SKLabelNode!
    var countOfBalls: SKLabelNode!
    var ball: SKSpriteNode!
    var obstacle: SKNode!
    var arrow: SKSpriteNode!
    var line: SKSpriteNode!
    var rocketTool: SKSpriteNode!
    var arrayOfYellowBalls: [SKNode] = []
    let maxTaps = 20
    var circleNode: SKShapeNode!
    
    init(levels: Int) {
        self.levels = levels
        super.init(size: UIScreen.main.bounds.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        setupView()
    }
    
    override func willMove(from view: SKView) {
        game!.audioManager.stopBallkMusic()
        game!.audioManager.stopYellowBallMusic()
        game!.audioManager.stopBlockMusic()
    }
    
    override func update(_ currentTime: TimeInterval) {
        isIntrejectLine()
        isBallOutside()
        isWin()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            returnBall(touchLocation: touchLocation)
            useRocketBonus(touchLocation: touchLocation)
            pauseTapped(touchLocation: touchLocation)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            if !game!.isFlying {
                updateArrowRotation(to: touchLocation)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            if let tappedNode = self.atPoint(touchLocation) as? SKSpriteNode,
               tappedNode.name != "returnBallTool" {
                if !game!.isFlying, !game!.isRocketUsing, !game!.isPause {
                    moveNodeTo(location: touchLocation)
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        game!.audioManager.playBallMusic()
        
        contactWithBlock(contact: contact)
        contactWithYellowBall(contact: contact)
    }
}
