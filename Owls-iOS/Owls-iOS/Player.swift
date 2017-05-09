//
//  Player.swift
//  Owls-iOS
//
//  Created by Howard Shan on 5/4/17.
//  Copyright © 2017 Howard. All rights reserved.
//

import Foundation
import SpriteKit

enum Direction {
    case UP, RIGHT, DOWN, LEFT, NONE;
}
class Player: SKSpriteNode {
    var moveConstant:CGFloat = 20
    var currentX:CGFloat = 50
    var currentY:CGFloat = 90
    var dir: Direction = .NONE
    var gameScene: GameScene!
    var body: SKPhysicsBody!
    
    init(scene: GameScene) {
        
        let texture = SKTexture(imageNamed: "Owl")
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: scalerX * 60, height: scalerY * 60))
        gameScene = scene as! GameScene

        self.zPosition = 3
        self.moveConstant = CGFloat(1000)/CGFloat(gameScene.width)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        physicsBody?.friction = 0
        physicsBody?.linearDamping = 0
        body = self.physicsBody!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveUp() {
        let nextPosition = CGPoint(x: position.x, y: position.y + moveConstant * scalerY)
        if gameScene.validPosition(x: currentX, y: currentY + 1, size: size) {
            self.position = nextPosition
            currentY += 1
        }
    }
    
    func moveDown() {
        let nextPosition = CGPoint(x: position.x, y: position.y - moveConstant * scalerY)
        if gameScene.validPosition(x: currentX, y: currentY - 1, size: size){
            self.position = nextPosition
            currentY -= 1
        }
    }
    
    func moveLeft() {
        let nextPosition = CGPoint(x: position.x - moveConstant * scalerX, y: position.y)
        if gameScene.validPosition(x: currentX - 1, y: currentY, size: size) {
            position = nextPosition
            currentX -= 1
        }
    }
    
    func moveRight() {
        let nextPosition = CGPoint(x: position.x + moveConstant * scalerX, y: position.y)
        if gameScene.validPosition(x: currentX + 1, y: currentY, size: size) {
            position = nextPosition
            currentX += 1
        }
    }
    
    func setPosition(x: CGFloat, y: CGFloat) {
        if gameScene.validPosition(x: x, y: y, size: size) {
            currentX = x
            currentY = y
            position.x = CGFloat(x) * moveConstant * scalerX
            position.y = CGFloat(y) * moveConstant * scalerY
        }
    }
}
