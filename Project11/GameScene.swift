//
//  GameScene.swift
//  Project11
//
//  Created by Jonathan Deguzman on 12/1/16.
//  Copyright © 2016 Jonathan Deguzman. All rights reserved.
//

import SpriteKit
import GameplayKit // Allows randomness

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Labels to display the score and edit mode
    var scoreLabel: SKLabelNode!
    
    var editLabel: SKLabelNode!
    
    // Property observers to make the labels update themselves when needed
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
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
        
        // Assign the current scene to be the contact delegate. i.e. Tells us when contact occurs between two bodies.
        physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // This is new to me and it's really cool. When a user touches the screen, the location of where the touch occurs will be stored in a constant named location.
        if let touch = touches.first {
            let location = touch.location(in:self)
            
            // Get a list of all the nodes that were tapped and check if it contains the editing label. This will tell us if we're in editing mode or not.
            let objects = nodes(at: location)
            
            if objects.contains(editLabel) {
                editingMode = !editingMode
            } else {
                // If we're in editing mode, we create boxes. If not, we create balls.
                if editingMode {
                    // Create a box with a random size and random color
                    let size = CGSize(width: GKRandomDistribution(lowestValue: 16, highestValue: 128).nextInt(), height: 16)
                    let box = SKSpriteNode(color: RandomColor(), size: size)
                    
                    // Give the box a random rotation and place it at the location that was touched on the screen.
                    box.zRotation = RandomCGFloat(min: 0, max: 3)
                    box.position = location
                    
                    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                    box.physicsBody!.isDynamic = false
                    
                    addChild(box)
                } else {
                    let ball = SKSpriteNode(imageNamed: "ballRed")
                    // We use SKPhysicsBody(circleOfRadius:) to give circular physics to the ball we're creating and restitution to give it a level of bounciness.
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    
                    // Set the collisionBitMask to be the contactBitMask so that we are notified about every collision.
                    ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                    ball.physicsBody!.restitution = 0.4
                    
                    ball.position = location
                    ball.name = "ball"
                    
                    addChild(ball)
                }
            }
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
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        // SKPhysicsBody(rectangleOf:) method will allow us to add rectangle physics to the slots.
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody!.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        // SKAction class will allow us to rotate the slot glow
        let spin = SKAction.rotate(byAngle: CGFloat.pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "ball" {
            collisionBetween(ball: contact.bodyA.node!, object: contact.bodyB.node!)
        } else if contact.bodyB.node?.name == "ball" {
            collisionBetween(ball: contact.bodyB.node!, object: contact.bodyA.node!)
        }
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        }
    }
    
    func destroy(ball: SKNode) {
        ball.removeFromParent()
    }
    
}
