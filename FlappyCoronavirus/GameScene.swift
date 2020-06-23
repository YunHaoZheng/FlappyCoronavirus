//
//  GameScene.swift
//  FlappyCoronavirus
//
//  Created by mac02 on 2020/6/17.
//  Copyright © 2020 mac02. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var isGameStarted = Bool(false)
    var isDied = Bool(false)
    var gameMode = 1
    
    var repeatProtect = false
    let playSound = SKAction.playSoundFileNamed("站起來2", waitForCompletion: false)
    let playＧameOverSound = SKAction.playSoundFileNamed("你眼睛瞎了嗎", waitForCompletion: false)
    let playEasySound = SKAction.playSoundFileNamed("小牙籤", waitForCompletion: false)
    let playHardSound = SKAction.playSoundFileNamed("困難2", waitForCompletion: false)
    let playbeginSound = SKAction.playSoundFileNamed("Yes I Do", waitForCompletion: false)
    
    var score = Int(0)
    var scoreLbl = SKLabelNode()
    var highscoreLbl = SKLabelNode()
    var taptoplayLbl = SKLabelNode()
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var settingBtn = SKSpriteNode()
    var logoImg = SKSpriteNode()
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    
    let virusAtlas = SKTextureAtlas(named: "player")
    var virusSprites = [SKTexture]()
    var virus = SKSpriteNode()
    var repeatActionVirus = SKAction()
    
    var settingBg = SKShapeNode()
    var settingLbl = SKLabelNode()
    var easyBtn = SKSpriteNode()
    var hardBtn = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        createScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            if settingBtn.contains(location) {
                createSettingMenu()
            } else {
                if easyBtn.parent == self && easyBtn.contains(location) {
                    gameMode = 1
                    restartScene()
                    self.run(playEasySound)
                }
                else if hardBtn.parent == self && hardBtn.contains(location) {
                    gameMode = 2
                    restartScene()
                    self.run(playHardSound)
                } else {
                    if isGameStarted == false {
                        isGameStarted = true
                        self.run(playbeginSound)
                        virus.physicsBody?.affectedByGravity = true
                        createPauseBtn()
                        logoImg.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
                            self.logoImg.removeFromParent()
                        })
                        taptoplayLbl.removeFromParent()
                        settingBtn.removeFromParent()
                        self.virus.run(repeatActionVirus)
                        
                        // Add pillars
                        let spawn = SKAction.run({
                            () in
                            self.wallPair = self.createWalls()
                            self.addChild(self.wallPair)
                        })
                        
                        let delay = SKAction.wait(forDuration: 1.5)
                        let SpawnDelay = SKAction.sequence([spawn,delay])
                        let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
                        self.run(spawnDelayForever)
                        
                        let distance = CGFloat(self.frame.width + wallPair.frame.width)
                        let movePillars = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
                        let addPoint = SKAction.run {
                            self.score += 1
                            self.scoreLbl.text = "\(self.score)"
                        }
                        let removePillars = SKAction.removeFromParent()
                        moveAndRemove = SKAction.sequence([movePillars,addPoint,removePillars])
                        
                        virus.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                        virus.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
                        } else {
                            if isDied == false {
                                virus.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                                virus.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
                            }
                        }
                        
                        if isDied == true {
                            if restartBtn.contains(location) {
                                if UserDefaults.standard.object(forKey: "highestScore") != nil {
                                    let hscore = UserDefaults.standard.integer(forKey: "highestScore")
                                    if hscore < score {
                                        UserDefaults.standard.set(score, forKey: "highestScore")
                                    }
                                } else {
                                    UserDefaults.standard.set(0, forKey: "highestScore")
                                }
                                restartScene()
                            }
                        } else {
                            if pauseBtn.contains(location) {
                                if self.isPaused == false {
                                    self.isPaused = true
                                    pauseBtn.texture = SKTexture(imageNamed: "play")
                                } else {
                                    self.isPaused = false
                                    pauseBtn.texture = SKTexture(imageNamed: "pause")
                                }
                            }
                        }
                    }
                }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == CollisionBitMask.virusCategory && secondBody.categoryBitMask == CollisionBitMask.pillarCategory || firstBody.categoryBitMask == CollisionBitMask.pillarCategory && secondBody.categoryBitMask == CollisionBitMask.virusCategory {
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if repeatProtect == false {
                let gameOverText = SKAction.run {
                    self.scoreLbl.text = "你眼睛瞎了嗎"
                }
                let gameOver = SKAction.sequence([playＧameOverSound,gameOverText])
                self.run(gameOver)
                repeatProtect = true
            }
            if isDied == false {
                isDied = true
                createRestartBtn()
                pauseBtn.removeFromParent()
                self.virus.removeAllActions()
            }
        }
        if firstBody.categoryBitMask == CollisionBitMask.virusCategory && secondBody.categoryBitMask == CollisionBitMask.groundCategory || firstBody.categoryBitMask == CollisionBitMask.groundCategory && secondBody.categoryBitMask == CollisionBitMask.virusCategory {
            if isDied == false && repeatProtect == false {
                let tmpText = SKAction.run {
                    self.scoreLbl.text = "站起來"
                    self.repeatProtect = true
                }
                let delay = SKAction.wait(forDuration: 0.25)
                let recover = SKAction.run {
                    self.score -= 1
                    self.scoreLbl.text = "\(self.score)"
                    self.repeatProtect = false
                }
                let standUp = SKAction.sequence([playSound,tmpText,delay,recover])
                self.run(standUp)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isGameStarted == true {
            if isDied == false {
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    let bg = node as! SKSpriteNode
                    bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                    if bg.position.x <= -bg.size.width {
                        bg.position = CGPoint(x: bg.position.x + bg.size.width * 2, y: bg.position.y)
                    }
                }))
            }
        }
    }
    
    func createScene() {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
        self.physicsBody?.collisionBitMask = CollisionBitMask.virusCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.virusCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        // Create background
        var bgImgName:String
        if gameMode == 1 {
            bgImgName = "indoor"
        }
        else {
            bgImgName = "outdoor"
        }
        for i in 0..<2 {
                
                let background = SKSpriteNode(imageNamed: bgImgName)
                background.anchorPoint = CGPoint.init(x: 0, y: 0)
                background.position = CGPoint(x: CGFloat(i) * self.frame.width, y: 0)
                background.name = "background"
            background.size = (self.view?.bounds.size)!
                self.addChild(background)
        }
        
        // Create player
        virusSprites.append(virusAtlas.textureNamed("virus1"))
        virusSprites.append(virusAtlas.textureNamed("virus2"))
        virusSprites.append(virusAtlas.textureNamed("virus3"))
        virusSprites.append(virusAtlas.textureNamed("virus4"))
        self.virus = createVirus()
        self.addChild(virus)
        let animateVirus = SKAction.animate(with: self.virusSprites, timePerFrame: 0.1)
        self.repeatActionVirus = SKAction.repeatForever(animateVirus)
        
        scoreLbl = createScoreLabel()
        self.addChild(scoreLbl)
        highscoreLbl = createHighscoreLabel()
        self.addChild(highscoreLbl)
        createLogo()
        taptoplayLbl = createTaptoplayLabel()
        self.addChild(taptoplayLbl)
        createSettingBtn()
    }
    
    func restartScene() {
        self.removeAllChildren()
        self.removeAllActions()
        isDied = false
        isGameStarted = false
        repeatProtect = false
        score = 0
        createScene()
    }
}
