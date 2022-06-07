//
//  GameElements.swift
//  FlappyCoronavirus
//
//  Created by mac02 on 2020/6/17.
//  Copyright © 2020 mac02. All rights reserved.
//

import SpriteKit

struct CollisionBitMask {
    static let virusCategory:UInt32 = 0x1 << 0
    static let pillarCategory:UInt32 = 0x1 << 1
    static let flowerCategory:UInt32 = 0x1 << 2
    static let groundCategory:UInt32 = 0x1 << 3
}

extension GameScene {
    
    func createVirus() -> SKSpriteNode {
        let virus = SKSpriteNode(texture: SKTextureAtlas(named: "player").textureNamed("virus1"))
        virus.size = CGSize(width: 50, height: 50)
        virus.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        virus.physicsBody = SKPhysicsBody(circleOfRadius: virus.size.width / 2)
        virus.physicsBody?.linearDamping = 1.1
        virus.physicsBody?.categoryBitMask = CollisionBitMask.virusCategory
        virus.physicsBody?.collisionBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.groundCategory
        virus.physicsBody?.contactTestBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.flowerCategory | CollisionBitMask.groundCategory
        virus.physicsBody?.affectedByGravity = false
        virus.physicsBody?.isDynamic = true
        
        return virus
    }
    
    func createSettingMenu() {
        settingBg.position = CGPoint(x: 0, y: 0)
        settingBg.path = CGPath(roundedRect: CGRect(x: CGFloat(0), y: CGFloat(0), width: self.frame.width, height: self.frame.height), cornerWidth: 50, cornerHeight: 50, transform: nil)
        let settingBgColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: CGFloat(0.4))
        settingBg.strokeColor = UIColor.clear
        settingBg.fillColor = settingBgColor
        settingBg.zPosition = 7
        self.addChild(settingBg)
        
        settingLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 3)
        settingLbl.text = "Choose game mode"
        settingLbl.zPosition = 8
        settingLbl.fontSize = 32
        settingLbl.fontName = "HelveticaNeue-Bold"
        self.addChild(settingLbl)
        
        easyBtn = SKSpriteNode(imageNamed: "easy")
        easyBtn.size = CGSize(width: 100, height: 100)
        easyBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 100)
        easyBtn.zPosition = 9
        easyBtn.setScale(0)
        self.addChild(easyBtn)
        easyBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
        
        hardBtn = SKSpriteNode(imageNamed: "hard")
        hardBtn.size = CGSize(width: 100, height: 100)
        hardBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 100)
        hardBtn.zPosition = 9
        hardBtn.setScale(0)
        self.addChild(hardBtn)
        hardBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func createRestartBtn() {
        restartBtn = SKSpriteNode(imageNamed: "restart")
        restartBtn.size = CGSize(width: 100, height: 100)
        restartBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
        
    }
    
    func createPauseBtn() {
        pauseBtn = SKSpriteNode(imageNamed: "pause")
        pauseBtn.size = CGSize(width: 40, height: 40)
        pauseBtn.position = CGPoint(x: self.frame.width - 30, y: 30)
        pauseBtn.zPosition = 6
        self.addChild(pauseBtn)
    }
    
    func createSettingBtn() {
        settingBtn = SKSpriteNode(imageNamed: "settings")
        settingBtn.size = CGSize(width: 40, height: 40)
        settingBtn.position = CGPoint(x: 30, y: self.frame.height - 30)
        settingBtn.zPosition = 6
        self.addChild(settingBtn)
    }
    
    func createScoreLabel() -> SKLabelNode {
        let scoreLbl = SKLabelNode()
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.6)
        scoreLbl.text = "\(score)"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 50
        scoreLbl.fontName = "HelveticaNeue-Bold"
        
        let scoreBg = SKShapeNode()
        scoreBg.position = CGPoint(x: 0, y: 0)
        scoreBg.path = CGPath(roundedRect: CGRect(x: CGFloat(-50), y: CGFloat(-30), width: CGFloat(100), height: CGFloat(100)), cornerWidth: 50, cornerHeight: 50, transform: nil)
        let scoreBgColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: CGFloat(0.2))
        scoreBg.strokeColor = UIColor.clear
        scoreBg.fillColor = scoreBgColor
        scoreBg.zPosition = -1
        self.addChild(scoreBg)
        return scoreLbl
    }
    
    func createHighscoreLabel() -> SKLabelNode {
        let highscoreLbl = SKLabelNode()
        highscoreLbl.position = CGPoint(x: self.frame.width - 80, y: self.frame.height - 22)
        if let highestScore = UserDefaults.standard.object(forKey: "highestScore") {
            highscoreLbl.text = "Highest Score: \(highestScore)"
        } else {
            highscoreLbl.text = "Highest Score: 0"
        }
        highscoreLbl.zPosition = 5
        highscoreLbl.fontSize = 15
        highscoreLbl.fontName = "Helvetica-Bold"
        return highscoreLbl
    }
    
    func createLogo() {
        logoImg = SKSpriteNode()
        logoImg = SKSpriteNode(imageNamed: "logo")
        logoImg.size = CGSize(width: 266, height: 100)
        logoImg.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 100)
        logoImg.setScale(0.5)
        self.addChild(logoImg)
        logoImg.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func createTaptoplayLabel() -> SKLabelNode {
        let taptoplaylbl = SKLabelNode()
        taptoplaylbl.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
        taptoplaylbl.text = "Tap anywhere to play"
        taptoplaylbl.fontColor = UIColor(red: 63/255, green: 79/255, blue: 145/255, alpha: 1.0)
        taptoplaylbl.zPosition = 5
        taptoplaylbl.fontSize = 20
        taptoplaylbl.fontName = "HelveticaNeue"
        return taptoplaylbl
    }
    
    func createWalls() -> SKNode {
        var space = 420
        if gameMode == 2 {
            space = 395
        }
        wallPair = SKNode()
        wallPair.name = "wallPair"
        
        let topWall = SKSpriteNode(imageNamed: "pillar")
        let btmWall = SKSpriteNode(imageNamed: "pillar")
        
        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + CGFloat(space))
        btmWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - CGFloat(space))
        
        topWall.setScale(0.5)
        btmWall.setScale(0.5)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        topWall.physicsBody?.collisionBitMask = CollisionBitMask.virusCategory
        topWall.physicsBody?.contactTestBitMask = CollisionBitMask.virusCategory
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        btmWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        btmWall.physicsBody?.collisionBitMask = CollisionBitMask.virusCategory
        btmWall.physicsBody?.contactTestBitMask = CollisionBitMask.virusCategory
        btmWall.physicsBody?.isDynamic = false
        btmWall.physicsBody?.affectedByGravity = false
        
        topWall.zPosition = CGFloat(Double.pi)
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.zPosition = 1
        
        let randomPosition = random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y + randomPosition
        
        wallPair.run(moveAndRemove)
        
        return wallPair
    }
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
}
