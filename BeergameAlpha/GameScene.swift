//
//  GameScene.swift
//  BeergameAlpha
//
//  Created by mojado on 15.05.16.
//  Copyright (c) 2016 mojado. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var car: Car!
    var touchLocation = CGFloat()
    var gameOver = false
    var pkwArray: [Verkehr] = []
    var endOfScreenTop = CGFloat()
    var endOfScreenBottom = CGFloat()
    var winPosition = CGFloat()
    var currentPosition = CGFloat()
    

    
    enum ColliderType:UInt32{
        case player = 1
        case Verkehr = 2
    }
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
     
        winPosition = CGFloat(self.size.width) - (40)
    

        
    endOfScreenBottom = (self.size.height) * CGFloat(-1)
    endOfScreenTop = (self.size.height)
    
        addPlayer()
        addPkwsErsteKreuzung()
        addBG()
        
        let wait = SKAction.waitForDuration(1.0)
        let run = SKAction.runBlock {
            
          
            self.addPkwsErsteKreuzung()
            
        }
    self.runAction(SKAction.repeatActionForever(SKAction.sequence([wait, run])))
        
        let wait2 = SKAction.waitForDuration(1.3)
        let run2 = SKAction.runBlock {
            
            
            self.addPkwsZweiteKreuzung()
           
            
        }
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([wait2, run2])))
        
        let wait3 = SKAction.waitForDuration(1.5)
        let run3 = SKAction.runBlock {
            
            self.addPkwsDritteKreuzung()
            
        }
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([wait3, run3])))
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        gameOver = true
        self.view?.presentScene(GameOverScene.init(size: self.view!.frame.size , won: false))
        print("Kontakt")
    }
    
    func addPkwsDritteKreuzung(){
        
        let randomX = CGFloat(Float(arc4random()) / 0xFFFFFFFF) * (1.2 - 1.2) + 1.2
        addPkw("dritterWagen", speed: 6.0, xPos: CGFloat(self.size.width/randomX))
        
    }

    
    func addPkwsZweiteKreuzung(){
        
        let randomX = CGFloat(Float(arc4random()) / 0xFFFFFFFF) * (1.8 - 1.7) + 1.7
        addPkw("zweiterWagen", speed: 5.0, xPos: CGFloat(self.size.width/randomX))
        
    }

    
    func addPkwsErsteKreuzung(){
        
        let randomX = CGFloat(Float(arc4random()) / 0xFFFFFFFF) * (3.3 - 2.8) + 2.8
        addPkw("ersterWagen", speed: 4.0, xPos: CGFloat(self.size.width/randomX))
        
    }
    func addPkw(named: String, speed: Float,xPos: CGFloat){
        let pkwNode = SKSpriteNode(imageNamed: "Auto")
        
        
        pkwNode.physicsBody = SKPhysicsBody(circleOfRadius: pkwNode.size.height/2)
        pkwNode.physicsBody!.affectedByGravity = false
        pkwNode.physicsBody!.categoryBitMask = ColliderType.Verkehr.rawValue
        pkwNode.physicsBody!.contactTestBitMask = ColliderType.player.rawValue
        pkwNode.physicsBody!.collisionBitMask = ColliderType.player.rawValue
        pkwNode.zPosition = 2
        
        let pkw = Verkehr(speed: speed, pkw: pkwNode)
        pkwArray.append(pkw)
        resetVerkehr(pkwNode,xPos: xPos)
        pkw.yPos = pkwNode.position.y
        addChild(pkwNode)
        
    }
    
    func resetVerkehr(pkwNode: SKSpriteNode, xPos:CGFloat){
        pkwNode.position.x = xPos
        pkwNode.position.y = endOfScreenTop
        
    }
    
    func addPlayer(){
    let player = SKSpriteNode(imageNamed: "Player")
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height/2)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = ColliderType.player.rawValue
        player.physicsBody!.contactTestBitMask = ColliderType.Verkehr.rawValue
        player.physicsBody!.collisionBitMask = ColliderType.Verkehr.rawValue
        player.position = CGPoint(x: size.width/8, y:size.height/2)
        player.zPosition = 1
        
    
        car = Car(car: player)
        addChild(player)
    
    }
    
    
    func addBG() {
        let bg = SKSpriteNode(imageNamed: "Kreuzung")
        bg.size = self.frame.size
        bg.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        bg.zPosition = 0
        addChild(bg)
       
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
         for touch in touches {
        if !gameOver{
            touchLocation = (touch.locationInView(self.view!).x)
        }
    }
    
     let moveAction = SKAction.moveToX(touchLocation, duration: car.speed)
        moveAction.timingMode = SKActionTimingMode.EaseOut
        car.car.runAction(moveAction){
            // not do anything
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
      print (winPosition,  "winPosition")
        print(currentPosition,"currentposition")
       
        
        
        if winPosition <= currentPosition
        {
            self.view?.presentScene(GameOverScene.init(size: self.view!.frame.size , won: true))
        }
        if !gameOver {
            
            updateVerkehrsPosition()
            
        }
    }
        func updateVerkehrsPosition()
        {
            for pkw in pkwArray {
                if !pkw.moving{
                    pkw.currentFrame += 1
                   currentPosition = car.car.position.x
                    if pkw.currentFrame >= 100
                    {
                        pkw.moving = true
                        print("zuende")
                    }else{
                        pkw.pkw.position.x = CGFloat(Double(pkw.pkw.position.x))
                       
                        if pkw.pkw.position.y > endOfScreenBottom
                            {
                            
                            pkw.pkw.position.y -= CGFloat(pkw.speed)
                        }else{
                            
                            pkw.pkw.position.x = endOfScreenTop
                            pkw.currentFrame = 0
                            pkw.setRandomFrame()
                            pkw.moving = false
                            pkw.range += 0.1
                            
                        }
                        
                    }
                    
                    
                }
            }
            
            
        }
        
    }

