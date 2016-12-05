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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // This is new to me and it's really cool. When a user touches the screen, the location of where the touch occurs will be stored in a constant named location. Then, we create a red box that will appear at that location and, using the physicsBody property, will fall to the bottom of the screen.
        if let touch = touches.first {
            let location = touch.location(in:self)
            let box = SKSpriteNode(color: UIColor.red, size: CGSize(width: 64, height: 64))
            box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
            box.position = location
            addChild(box)
        }
    }
    
}
