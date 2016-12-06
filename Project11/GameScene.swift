//
//  GameScene.swift
//  Project11
//
//  Created by Jonathan Deguzman on 12/1/16.
//  Copyright © 2016 Jonathan Deguzman. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        // Similar to UIImage, SKSpriteNode is a class that we use that can load any picture from the app bundle into our game. Then, we can modify that image's properties to our liking.
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y:384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        var slotIsGood = true
        
        for placeSlot in 0...3 {
            makeSlot(at: CGPoint(x: 128 + placeSlot * 256, y: 0), isGood: slotIsGood)
            slotIsGood = !slotIsGood
        }
        
        for placeBouncer in 0...4 {
            // Place 5 evenly spaced bouncers to the bottom of our screen
            makeBouncer(at: CGPoint(x: placeBouncer * Int(frame.width) / 4, y: 0))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // This is new to me and it's really cool. When a user touches the screen, the location of where the touch occurs will be stored in a constant named location.
        if let touch = touches.first {
            let location = touch.location(in:self)
            let ball = SKSpriteNode(imageNamed: "ballRed")
            // Then, we use SKPhysicsBody(circleOfRadius:) to give circular physics to the ball we're creating and restitution to give it a level of bounciness.
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            ball.physicsBody!.restitution = 0.4
            ball.position = location
            addChild(ball)
        }
    }
    
    /// makeBouncer(at:) will create identical bouncers at any provided location
    /// - Returns: Nil
    /// - Parameters:
    ///   - position: The position of where the bouncer is to be placed
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        // Setting the isDynamic property to false will still allow the bouncer object to collide with other things, but it won't ever be moved.
        bouncer.physicsBody!.isDynamic = false
        addChild(bouncer)
    }
    
    /// makeSlot(at:) will create either good (green) slots or bad (red) slots at any provided location
    /// - Returns: Nil
    /// - Parameters:
    ///   - position: The position of where the slot will be placed
    ///   - isGood: Determines whether the slot placed will be good or bad
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: CGFloat.pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
}
