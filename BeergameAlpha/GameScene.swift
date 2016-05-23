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
    
    enum ColliderType:UInt32{
        case player = 1
        case Verkehr = 2
    }
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
     
    endOfScreenBottom = (self.size.height) * CGFloat(-1)
    endOfScreenTop = (self.size.height)
        
    
    addPlayer()    
    addPkws()
    addBG()
    
       
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        gameOver = true
        print("Kontakt")
    }
    
    func addPkws(){
        
        
        let randomX = CGFloat(Float(arc4random()) / 0xFFFFFFFF) * (2.1 - 1.9) + 1.9
        addPkw("hol den", speed: 4.0, xPos: CGFloat(self.size.width/randomX))
        
    }
    func addPkw(named: String, speed: Float,xPos: CGFloat){
        let pkwNode = SKSpriteNode(imageNamed: "Auto")
        
        pkwNode.physicsBody = SKPhysicsBody(circleOfRadius: pkwNode.size.height/2)
        pkwNode.physicsBody!.affectedByGravity = false
        pkwNode.physicsBody!.categoryBitMask = ColliderType.Verkehr.rawValue
        pkwNode.physicsBody!.contactTestBitMask = ColliderType.player.rawValue
        pkwNode.physicsBody!.collisionBitMask = ColliderType.player.rawValue
        
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
        player.position = CGPoint(x: size.width/6,y:size.height/2)
        car = Car(car: player)
        addChild(player)
    
    }
    
    
    func addBG() {
        let bg = SKSpriteNode(imageNamed: "Kreuzung")
        bg.position = CGPoint(x:size.width/2,y:size.height/2)
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
        if !gameOver {
            
            updateVerkehrsPosition()
            
        }
    }
        func updateVerkehrsPosition()
        {
            for pkw in pkwArray {
                if !pkw.moving{
                    pkw.currentFrame += 1
                   
                    if pkw.currentFrame > pkw.randomFrame{
                        pkw.moving = true
                        addPkws()
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

