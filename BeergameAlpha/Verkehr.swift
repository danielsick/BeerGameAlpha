//
//  Verkehr.swift
//  BeergameAlpha
//
//  Created by mojado on 16.05.16.
//  Copyright © 2016 mojado. All rights reserved.
//

import Foundation
import SpriteKit

class Verkehr{
    
    var pkw:SKSpriteNode
    var speed: Float = 0.0
    var currentFrame = 0
    var randomFrame = 320
    var moving = false
    var angle = 0.0
    var range = 2.0
    var yPos = CGFloat()
    
    init(speed:Float, pkw:SKSpriteNode){
        self.speed = speed
        self.pkw = pkw
       // self.setRandomFrame()
    
        
    }
 
    func setRandomFrame(){
        
        let range = UInt32(300)..<UInt32(310)
        self.randomFrame = Int(range.startIndex+arc4random_uniform(range.endIndex - range.startIndex+1))
        
    }

}
