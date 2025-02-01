import SpriteKit
import SwiftUI

extension BrickGameSpriteKit {
    
    func createMutatingNodes() {
        scoreLabel = SKLabelNode(fontNamed: "FredokaOne-Regular")
        scoreLabel.text = "\(game!.currentScore)"
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = UIColor(red: 101/255, green: 255/255, blue: 218/255, alpha: 1)
        scoreLabel.position = CGPoint(x: size.width / 4, y: size.height / 1.15)
        addChild(scoreLabel)
        
        countOfBalls = SKLabelNode(fontNamed: "FredokaOne-Regular")
        countOfBalls.name = "countOfBalls"
        countOfBalls.text = "x\(game!.countOfBalls)"
        countOfBalls.fontSize = 20
        countOfBalls.fontColor = .white
        countOfBalls.position = CGPoint(x: size.width / 1.65, y: size.height / 6.5)
        addChild(countOfBalls)
        
        circleNode = SKShapeNode()
        circleNode = SKShapeNode()
        circleNode.position = CGPoint(x: size.width / 1.2, y: size.height / 16)
              circleNode.strokeColor = .white
              circleNode.lineWidth = 2
              circleNode.fillColor = .clear
              addChild(circleNode)
    }
    
    func createTappedNodes() {
        let returnBallTool = SKSpriteNode(texture: SKTexture(imageNamed: BrickImageName.returnBallTool.rawValue))
        returnBallTool.name = "returnBallTool"
        returnBallTool.size = CGSize(width: 59, height: 59)
        returnBallTool.position = CGPoint(x: size.width / 6, y: size.height / 16)
        addChild(returnBallTool)
        
        rocketTool = SKSpriteNode(texture: SKTexture(imageNamed: BrickImageName.rocketTool.rawValue))
        rocketTool.name = "rocketTool"
        rocketTool.size = CGSize(width: 59, height: 59)
        rocketTool.position = CGPoint(x: size.width / 1.2, y: size.height / 16)
        addChild(rocketTool)
        
        let pause = SKSpriteNode(texture: SKTexture(imageNamed: BrickImageName.pause.rawValue))
        pause.name = "pause"
        pause.size = CGSize(width: 34, height: 34)
        pause.position = CGPoint(x: size.width / 1.13, y: size.height / 1.125)
        addChild(pause)
    }
    
    func createMovingNodes() {
        ball = SKSpriteNode(texture: SKTexture(imageNamed: UserDefaultsManager().getSelectedBall()?.image ?? BrickImageName.ball1.rawValue))
        ball.size = CGSize(width: 20, height: 20)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 8)
        ball.physicsBody?.contactTestBitMask = CBitMask.obstacle | CBitMask.yellowBall
        ball.physicsBody?.categoryBitMask = CBitMask.ball
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.friction = 0.0
        ball.physicsBody?.affectedByGravity = false
        ball.position = CGPoint(x: size.width / 2, y: size.height / 7.3)
        addChild(ball)

        arrow = SKSpriteNode(texture: SKTexture(imageNamed: BrickImageName.lineBall.rawValue))
        arrow.name = "arrow"
        arrow.size = CGSize(width: 10,
                            height: 348)
        arrow.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        arrow.position = CGPoint(x: size.width / 2, y: size.height / 6)
        arrow.isHidden = true
        addChild(arrow)
    }
    
    func setupView() {
        createMainNodes()
        createMovingNodes()
        createTappedNodes()
        createMutatingNodes()
        startGame()
        updateCirclePath()
    }
    
    func startGame() {
        if levels == 1 {
            createFirstLevel()
        } else {
            gameBlocksForNextLevels()
        }
    }
    
    func gameBlocksForNextLevels() {
        let imageForObstacle = BrickImageName.block1.rawValue
        
        for i in 0...1 {
            let node = SKSpriteNode(texture: SKTexture(imageNamed: imageForObstacle))
            node.size = CGSize(width: 70, height: 40)
            node.position.y = 0
            node.position.x = 0

            let numberOnNode = SKLabelNode(fontNamed: "FredokaOne-Regular")
            numberOnNode.name = "numberNode"
            numberOnNode.text = String(imageForObstacle.last ?? Character("_"))
            numberOnNode.fontSize = 24
            numberOnNode.position.y = -9
            numberOnNode.position.x = -2

            obstacle = SKNode()
            obstacle.name = "obstacle"
            obstacle.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.size)
            obstacle.userData = NSMutableDictionary()
            obstacle.userData?.setObject(String(imageForObstacle.last ?? Character("_")), forKey: "originalValue" as NSCopying & NSObjectProtocol)
            obstacle.physicsBody?.isDynamic = false
            obstacle.physicsBody?.categoryBitMask = CBitMask.obstacle
            obstacle.addChild(node)
            obstacle.addChild(numberOnNode)
            obstacle.position = CGPoint(x: size.width / 6.8 + CGFloat((220 - 2) * CGFloat(i)),
                                        y: size.height / 1.25 - CGFloat(40))
            addChild(obstacle)
        }
    }

    func returnAllBlocks() -> String {
        let blocks = [BrickImageName.block1.rawValue,
                      BrickImageName.block2.rawValue,
                      BrickImageName.block3.rawValue,
                      BrickImageName.block4.rawValue,
                      BrickImageName.block5.rawValue,
                      BrickImageName.block6.rawValue,
                      BrickImageName.block7.rawValue,
                      BrickImageName.block8.rawValue]
        return blocks.randomElement() ?? ""
    }
    
    func createNewBlocks() {
        let randomValueForStart = [0,1].randomElement()
        let randomValue = [1,2,3,4].randomElement()
        var block: SKNode?
        for row in (randomValueForStart ?? 0)...(randomValue ?? 1) {
            block = returnBlock(row: row,
                                column: 1,
                                positionX: 7,
                                positionY: 1.25,
                                size: CGSize(width: 70, height: 40),
                                imageForObstacle: returnAllBlocks())
            
         
        }
        
        if randomValue == 3 || randomValue == 2 {
            let yellowBall = SKSpriteNode(texture: SKTexture(imageNamed: BrickImageName.yellowBall.rawValue))
            yellowBall.size = CGSize(width: 40, height: 40)
            yellowBall.name = "yellowBall"
            yellowBall.physicsBody = SKPhysicsBody(circleOfRadius: 20)
            yellowBall.physicsBody?.contactTestBitMask = CBitMask.ball
            yellowBall.physicsBody?.categoryBitMask = CBitMask.yellowBall
            yellowBall.physicsBody?.isDynamic = false
            yellowBall.physicsBody?.affectedByGravity = false
            yellowBall.position = CGPoint(x: (block?.position.x)! + 60, y: (block?.position.y)!)
            addChild(yellowBall)
            
            yellowBall.alpha = 0
            let fadeIn = SKAction.fadeIn(withDuration: TimeInterval(1))
            let showAnimation = SKAction.sequence([fadeIn])
            yellowBall.run(showAnimation)
        } else if randomValueForStart == 1 {
            let yellowBall = SKSpriteNode(texture: SKTexture(imageNamed: BrickImageName.yellowBall.rawValue))
            yellowBall.size = CGSize(width: 40, height: 40)
            yellowBall.name = "yellowBall"
            yellowBall.physicsBody = SKPhysicsBody(circleOfRadius: 20)
            yellowBall.physicsBody?.contactTestBitMask = CBitMask.ball
            yellowBall.physicsBody?.categoryBitMask = CBitMask.yellowBall
            yellowBall.physicsBody?.isDynamic = false
            yellowBall.physicsBody?.affectedByGravity = false
            yellowBall.position = CGPoint(x: size.width / 7, y: (block?.position.y)!)
            addChild(yellowBall)
            
            yellowBall.alpha = 0
            let fadeIn = SKAction.fadeIn(withDuration: TimeInterval(1))
            let showAnimation = SKAction.sequence([fadeIn])
            yellowBall.run(showAnimation)
        }
    }
    
    func returnBall(touchLocation: CGPoint) {
        if let tappedNode = self.atPoint(touchLocation) as? SKSpriteNode,
           tappedNode.name == "returnBallTool" {
            guard game!.isFlying else { return }
            game?.isFlying = false
            removeNodes(named: "additionalBall")
            
            for node in arrayOfYellowBalls {
                node.removeFromParent()
            }
            
            game!.countOfBalls = arrayOfYellowBalls.count + 1
            countOfBalls.text = "x\(game!.countOfBalls)"
            
            ball.removeFromParent()
            ball.physicsBody = nil
            ball = SKSpriteNode(texture: SKTexture(imageNamed: UserDefaultsManager().getSelectedBall()?.image ?? BrickImageName.ball1.rawValue))
            ball.size = CGSize(width: 20, height: 20)
            ball.name = "ball"
            ball.physicsBody = SKPhysicsBody(circleOfRadius: 8)
            ball.physicsBody?.contactTestBitMask = CBitMask.obstacle
            ball.physicsBody?.categoryBitMask = CBitMask.ball
            ball.physicsBody?.restitution = 1
            ball.physicsBody?.affectedByGravity = false
            ball.position = CGPoint(x: size.width / 2, y: size.height / 7.3)
            addChild(ball)
            
            guard levels != 1 else { return }
            
            self.enumerateChildNodes(withName: "obstacle") { (node, stop) in
                let moveUp = SKAction.moveBy(x: 0, y: -50, duration: 1.0)
                node.run(moveUp)
            }
            
            self.enumerateChildNodes(withName: "yellowBall") { (node, stop) in
                let moveUp = SKAction.moveBy(x: 0, y: -50, duration: 1.0)
                node.run(moveUp)
            }
            createNewBlocks()
        }
    }
    
    func updateCirclePath() {
        let progress = CGFloat(game!.tapCount) / CGFloat(maxTaps)
        let startAngle = CGFloat.pi / 2
        let endAngle = startAngle + progress * 2 * -CGFloat.pi
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint.zero,
                    radius: 28,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false)

        circleNode.path = path.cgPath
    }
    
    func tappedRocketBonus(touchLocation: CGPoint) {
        if let tappedNode = self.atPoint(touchLocation) as? SKSpriteNode,
           tappedNode.name == "rocketToolReady" {
            game?.isRocketUsing = true
            
            let namesToHide = ["ball", "countOfBalls", "arrow"]
            for name in namesToHide {
                self.enumerateChildNodes(withName: name) { (node, stop) in
                    node.isHidden = true
                }
            }
            
            let arrayOfImage = [BrickImageName.rocketRectangle1.rawValue,
                                BrickImageName.rocketRectangle2.rawValue,
                                BrickImageName.rocketRectangle1.rawValue,
                                BrickImageName.rocketRectangle2.rawValue,
                                BrickImageName.rocketRectangle1.rawValue]
            
            for i in 0...4 {
                let rocketRectangle1 = SKSpriteNode(imageNamed: arrayOfImage[i])
                rocketRectangle1.name = "\(i)"
                rocketRectangle1.size = CGSize(width: 67, height: 600)
                rocketRectangle1.position = CGPoint(x: size.width / 6.8 + CGFloat(i * 67), y: size.height / 2.1)
                addChild(rocketRectangle1)
            }
        }
    }
    
    func removeWithRocket(touchLocation: CGPoint, name: String, nameNodeToRemove: String) {
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let removeFromParent = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeOut, removeFromParent])
        if let tappedNode = self.atPoint(touchLocation) as? SKSpriteNode,
           tappedNode.name == name {
            self.enumerateChildNodes(withName: "obstacle") { node, _ in
                for child in node.children {
                    if let name = child.name, name == nameNodeToRemove {
                        node.run(sequence)
                        
                        let namesToDelete = ["0", "1", "2", "3", "4"]
                        for name in namesToDelete {
                            self.enumerateChildNodes(withName: name) { node, _ in
                                node.run(sequence)
                            }
                        }
                        
                        let namesToHide = ["ball", "countOfBalls"]
                        for name in namesToHide {
                            self.enumerateChildNodes(withName: name) { (node, stop) in
                                node.isHidden = false
                                
                             
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                            self!.game?.isRocketUsing = false
                      
                        }
                    }
                }
            }
            
            self.rocketTool.removeFromParent()
            self.game?.tapCount = -1
            self.rocketTool = SKSpriteNode(texture: SKTexture(imageNamed: BrickImageName.rocketTool.rawValue))
            self.rocketTool.name = "rocketTool"
            self.rocketTool.size = CGSize(width: 59, height: 59)
            self.rocketTool.position = CGPoint(x: self.size.width / 1.2, y: self.size.height / 16)
            self.addChild(self.rocketTool)
        }
    }
    
    func updateRocketTool() {
        guard game!.tapCount < maxTaps else { return }
        game!.tapCount += 1
        updateCirclePath()
        
        if game?.tapCount == 20 {
            rocketTool.removeFromParent()
            
            rocketTool = SKSpriteNode(texture: SKTexture(imageNamed: BrickImageName.rocketToolReady.rawValue))
            rocketTool.name = "rocketToolReady"
            rocketTool.size = CGSize(width: 59, height: 59)
            rocketTool.position = CGPoint(x: size.width / 1.2, y: size.height / 16)
            addChild(rocketTool)
        }
    }
    
    func useRocketBonus(touchLocation: CGPoint) {
        if !game!.isFlying {
            tappedRocketBonus(touchLocation: touchLocation)
            
            removeWithRocket(touchLocation: touchLocation, name: "0", nameNodeToRemove: "node0")
            removeWithRocket(touchLocation: touchLocation, name: "1", nameNodeToRemove: "node1")
            removeWithRocket(touchLocation: touchLocation, name: "2", nameNodeToRemove: "node2")
            removeWithRocket(touchLocation: touchLocation, name: "3", nameNodeToRemove: "node3")
            removeWithRocket(touchLocation: touchLocation, name: "4", nameNodeToRemove: "node4")
        }
    }
    
    func pauseTapped(touchLocation: CGPoint) {
        if let tappedNode = self.atPoint(touchLocation) as? SKSpriteNode,
           tappedNode.name == "pause" {
            game!.isPause = true
            game!.scene = scene!
            scene?.isPaused = true
        }
    }
    
    func isBallOutside() {
        if !ball.intersects(scene!) {
            ball.position = CGPoint(x: size.width / 2, y: size.height / 7.3)
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
    }
    
    func isIntrejectLine() {
        enumerateChildNodes(withName: "obstacle") { (node, stop) in
            if node.position.y - 18 < self.line.position.y {
                self.game?.isLose = true
                self.scene?.isPaused = true
            }
        }
    }
    
    func isWin() {
        if game!.currentScore >= levels * 100 {
            game?.isWin = true
            scene?.isPaused = true
        }
    }
    
    func createMainNodes() {
        let gameBackground = SKSpriteNode(texture: SKTexture(imageNamed: BrickImageName.mainBackground.rawValue))
        gameBackground.size = CGSize(width: size.width, height: size.height)
        gameBackground.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(gameBackground)
        
        line = SKSpriteNode(texture: SKTexture(imageNamed: BrickImageName.line.rawValue))
        line.size = CGSize(width: size.width, height: 5)
        line.physicsBody = SKPhysicsBody(texture: line.texture!, size: line.size)
        line.physicsBody?.isDynamic = false
        line.physicsBody?.affectedByGravity = false
        line.position = CGPoint(x: size.width / 2, y: size.height / 8)
        addChild(line)
        
        let topLine = SKSpriteNode(texture: SKTexture(imageNamed: BrickImageName.line.rawValue))
        topLine.size = CGSize(width: size.width, height: 5)
        topLine.physicsBody = SKPhysicsBody(texture: topLine.texture!, size: topLine.size)
        topLine.physicsBody?.isDynamic = false
        topLine.physicsBody?.affectedByGravity = false
        topLine.position = CGPoint(x: size.width / 2, y: size.height / 1.2)
        addChild(topLine)
        
        let goalLabel = SKLabelNode(fontNamed: "FredokaOne-Regular")
        goalLabel.text = "\(levels * 100)/ "
        goalLabel.fontSize = 20
        goalLabel.position = CGPoint(x: size.width / 8, y: size.height / 1.155)
        addChild(goalLabel)
    }
    
    func createFirstLevel() {
        for column in 0...2 {
            for row in 0...5 {
                let _  = returnBlock(row: row,
                                     column: column,
                                     positionX: 5,
                                     positionY: 1.6,
                                     size: CGSize(width: 45, height: 40),
                                     imageForObstacle: BrickImageName.squareBlock1.rawValue)
            }
        }
        
        for column in 0...1 {
            let _  = returnBlock(row: 1,
                                 column: column,
                                 positionX: -40,
                                 positionY: 1.73,
                                 size: CGSize(width: 45, height: 40),
                                 imageForObstacle: BrickImageName.squareBlock1.rawValue)
        }
        
        for column in 0...1 {
            let _  = returnBlock(row: 1,
                                 column: column,
                                 positionX: 1.33,
                                 positionY: 1.73,
                                 size: CGSize(width: 45, height: 40),
                                 imageForObstacle: BrickImageName.squareBlock1.rawValue)
        }
        
        for column in 0...3 {
            let _  = returnBlock(row: column,
                                 column: 1,
                                 positionX: 3.18,
                                 positionY: 1.395,
                                 size: CGSize(width: 45, height: 40),
                                 imageForObstacle: BrickImageName.squareBlock1.rawValue)
        }
        
        for column in 0...1 {
            let _  = returnBlock(row: column,
                                 column: 1,
                                 positionX: 2.34,
                                 positionY: 1.309,
                                 size: CGSize(width: 45, height: 40),
                                 imageForObstacle: BrickImageName.squareBlock1.rawValue)
        }
        
        let _  = returnBlock(row: 1,
                             column: 1,
                             positionX: 2.72,
                             positionY: 1.235,
                             size: CGSize(width: 45, height: 40),
                             imageForObstacle: BrickImageName.squareBlock1.rawValue)
        
        for row in 0...1 {
            let yellowBall = SKSpriteNode(texture: SKTexture(imageNamed: BrickImageName.yellowBall.rawValue))
            yellowBall.size = CGSize(width: 40, height: 40)
            yellowBall.name = "yellowBall"
            yellowBall.physicsBody = SKPhysicsBody(circleOfRadius: 20)
            yellowBall.physicsBody?.contactTestBitMask = CBitMask.ball
            yellowBall.physicsBody?.categoryBitMask = CBitMask.yellowBall
            yellowBall.physicsBody?.isDynamic = false
            yellowBall.physicsBody?.affectedByGravity = false
            yellowBall.position = CGPoint(x: size.width / 12 + CGFloat(315 * row) , y: size.height / 1.6)
            addChild(yellowBall)
        }
        
        for row in 0...1 {
            let yellowBall = SKSpriteNode(texture: SKTexture(imageNamed: BrickImageName.yellowBall.rawValue))
            yellowBall.name = "yellowBall"
            yellowBall.size = CGSize(width: 40, height: 40)
            yellowBall.physicsBody = SKPhysicsBody(circleOfRadius: 20)
            yellowBall.physicsBody?.contactTestBitMask = CBitMask.ball
            yellowBall.physicsBody?.categoryBitMask = CBitMask.yellowBall
            yellowBall.physicsBody?.isDynamic = false
            yellowBall.physicsBody?.affectedByGravity = false
            yellowBall.position = CGPoint(x: size.width / 3.16 + CGFloat(133 * row) , y: size.height / 1.4)
            addChild(yellowBall)
        }
    }
    
    func returnBlock(row: Int, column: Int, positionX: CGFloat, positionY: CGFloat, size: CGSize, imageForObstacle: String) -> SKNode {
        let node = SKSpriteNode(texture: SKTexture(imageNamed: imageForObstacle))
        node.size = size
        node.position.y = 0
        node.name = "node\(row)"
        node.position.x = 0

        let numberOnNode = SKLabelNode(fontNamed: "FredokaOne-Regular")
        numberOnNode.name = "numberNode"
        numberOnNode.text = String(imageForObstacle.last ?? Character("_"))
        numberOnNode.fontSize = 24
        numberOnNode.position.y = -9
        numberOnNode.position.x = -2

        obstacle = SKNode()
        obstacle.name = "obstacle"
        obstacle.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.size)
        obstacle.userData = NSMutableDictionary()
        obstacle.userData?.setObject(String(imageForObstacle.last ?? Character("_")), forKey: "originalValue" as NSCopying & NSObjectProtocol)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = CBitMask.obstacle
        obstacle.addChild(node)
        obstacle.addChild(numberOnNode)
        obstacle.position = CGPoint(x: self.size.width / positionX + CGFloat((size.width - 2) * CGFloat(row)),
                                    y: self.size.height / positionY - CGFloat(40 * column))
        addChild(obstacle)
        obstacle.alpha = 0
        let fadeIn = SKAction.fadeIn(withDuration: TimeInterval(1))
        let showAnimation = SKAction.sequence([fadeIn])
        obstacle.run(showAnimation)
        return obstacle
    }
    
    func updateArrowRotation(to touchLocation: CGPoint) {
        if let tappedNode = self.atPoint(touchLocation) as? SKSpriteNode,
           tappedNode.name != "returnBallTool" {
            let dx = touchLocation.x - arrow.position.x
            let dy = touchLocation.y - arrow.position.y
            var angle = atan2(dy, dx) + .pi / 2
            
            let minAngle: CGFloat = 90 * (.pi / 180)
            let maxAngle: CGFloat = -90 * (.pi / 180)
            if angle < minAngle && angle > maxAngle {
                angle = minAngle
            } else if angle > maxAngle && angle < minAngle {
                angle = maxAngle
            }
            
            arrow.isHidden = false
            arrow.zRotation = angle
        }
    }
    
    func removeNodes(named name: String) {
        self.enumerateChildNodes(withName: name) { node, _ in
            node.removeFromParent()
        }
    }
    
    func moveNodeTo(location: CGPoint) {
        let dx = location.x - ball.position.x
        let dy = location.y - ball.position.y
        let impulseScale: CGFloat = 0.1
        let impulse = CGVector(dx: dx * impulseScale, dy: dy * impulseScale)
     
        if game!.countOfBalls == 1 {
            ball.physicsBody?.applyImpulse(impulse)
        } else {
            for _ in 0..<game!.countOfBalls - 1 {
                ball.physicsBody?.applyImpulse(impulse)
                let ball = SKSpriteNode(texture: SKTexture(imageNamed: UserDefaultsManager().getSelectedBall()?.image ?? BrickImageName.ball1.rawValue))
                ball.size = CGSize(width: 20, height: 20)
                ball.name = "additionalBall"
                ball.physicsBody = SKPhysicsBody(circleOfRadius: 8)
                ball.physicsBody?.contactTestBitMask = CBitMask.obstacle
                ball.physicsBody?.categoryBitMask = CBitMask.ball
                ball.physicsBody?.restitution = 1
                ball.physicsBody?.friction = 0.0
                ball.physicsBody?.affectedByGravity = false
                ball.position = CGPoint(x: size.width / 2, y: size.height / 7.3)
                addChild(ball)
                ball.physicsBody?.applyImpulse(impulse)
            }
        }
        
        arrayOfYellowBalls.removeAll()
        game!.countOfBalls = 0
        countOfBalls.text = "x\(game!.countOfBalls)"
        arrow.isHidden = true
        game?.isFlying = true
        updateRocketTool()
    }
    
    func contactWithBlock(contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == CBitMask.ball && contact.bodyB.categoryBitMask == CBitMask.obstacle) ||
            (contact.bodyA.categoryBitMask == CBitMask.obstacle && contact.bodyB.categoryBitMask == CBitMask.ball) {
     
            let obstacleNode = (contact.bodyA.node?.name == "obstacle") ? contact.bodyA.node : contact.bodyB.node
            if let obstacle = obstacleNode {
                if let numberNode = obstacle.childNode(withName: "numberNode") as? SKLabelNode {
                    if let numberText = numberNode.text {
                        if let number = Int(numberText) {
                            let pointWin = SKLabelNode(fontNamed: "FredokaOne-Regular")
                            var score = 0
                            let originalValue = obstacleNode!.userData?.object(forKey: "originalValue") as? String
                                switch originalValue {
                                case "1":
                                    pointWin.text = "+10"
                                    score = 10
                                    pointWin.fontColor = UIColor(red: 101/255, green: 255/255, blue: 218/255, alpha: 1)
                                case "2":
                                    pointWin.text = "+20"
                                    score = 20
                                    pointWin.fontColor = UIColor(red: 113/255, green: 255/255, blue: 100/255, alpha: 1)
                                case "3":
                                    pointWin.text = "+30"
                                    score = 30
                                    pointWin.fontColor = UIColor(red: 233/255, green: 255/255, blue: 101/255, alpha: 1)
                                case "4":
                                    pointWin.text = "+40"
                                    score = 40
                                    pointWin.fontColor = UIColor(red: 243/255, green: 248/255, blue: 254/255, alpha: 1)
                                case "5":
                                    pointWin.text = "+50"
                                    score = 50
                                    pointWin.fontColor = UIColor(red: 101/255, green: 255/255, blue: 180/255, alpha: 1)
                                case "6":
                                    pointWin.text = "+60"
                                    score = 60
                                    pointWin.fontColor = UIColor(red: 255/255, green: 193/255, blue: 101/255, alpha: 1)
                                case "7":
                                    pointWin.text = "+70"
                                    score = 70
                                    pointWin.fontColor = UIColor(red: 252/255, green: 101/255, blue: 255/255, alpha: 1)
                                case "8":
                                    pointWin.text = "+80"
                                    score = 80
                                    pointWin.fontColor = UIColor(red: 255/255, green: 101/255, blue: 101/255, alpha: 1)
                                default:
                                    pointWin.text = "+10"
                                    score = 10
                                }
                            
                             
                            if number == 1 {
                                obstacle.removeFromParent()
                                game!.audioManager.playBlockMusic()
                                game?.currentScore += score
                               
                                if scoreLabel.text?.count == 2 {
                                    scoreLabel.position = CGPoint(x: size.width / 3.7, y: size.height / 1.15)
                                } else if scoreLabel.text?.count == 3 {
                                    scoreLabel.position = CGPoint(x: size.width / 3.4, y: size.height / 1.15)
                                } else if scoreLabel.text?.count == 4 {
                                    scoreLabel.position = CGPoint(x: size.width / 3.1, y: size.height / 1.15)
                                }
                                scoreLabel.text = "\(game!.currentScore)"
                                
                                pointWin.fontSize = 24
                                pointWin.position = obstacle.position
                                addChild(pointWin)
                                let fadeOutOriginal = SKAction.fadeOut(withDuration: 0.5)
                                
                                pointWin.run(fadeOutOriginal) {
                                    pointWin.removeFromParent()
                                }
                            } else {
                                numberNode.text = "\(number - 1)"
                            }
                        }
                    }
                }
            }
        }
    }
    
    func contactWithYellowBall(contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == CBitMask.ball && contact.bodyB.categoryBitMask == CBitMask.yellowBall) ||
            (contact.bodyA.categoryBitMask == CBitMask.yellowBall && contact.bodyB.categoryBitMask == CBitMask.ball) {
            let yellowNode = (contact.bodyA.node?.name == "yellowBall") ? contact.bodyA.node : contact.bodyB.node
            if let yellowBall = yellowNode {
                yellowBall.physicsBody = nil
                let moveToLineAction = SKAction.move(to: CGPoint(x: yellowBall.position.x,
                                                                 y: size.height / 7.3),
                                                     duration: 2)
                yellowBall.run(moveToLineAction)
                game!.audioManager.playYellowBallMusic()
                arrayOfYellowBalls.append(yellowBall)
                
                countOfBalls.text = "x\(game!.countOfBalls)"
            }
        }
    }
}
