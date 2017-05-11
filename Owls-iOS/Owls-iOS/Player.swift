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
    var currentX:CGFloat = 50
    var currentY:CGFloat = 90
    var dir: Direction = .NONE
    var gameScene: GameScene!
    var body: SKPhysicsBody!
    var shootVelocity: CGFloat = 300
    var lives = 5
    let velocity:CGFloat = 200
    let startLives = 5
    var ownPlayer: Bool!
    
    init(scene: GameScene, ownPlayer: Bool) {
        let texture = SKTexture(imageNamed: "Owl")
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: scalerX * 60, height: scalerX * 60))
        print(self.size)
        gameScene = scene
        self.ownPlayer = ownPlayer
        self.zPosition = 3
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        physicsBody?.friction = 0
        physicsBody?.linearDamping = 0
        body = self.physicsBody!
        body.allowsRotation = false
        body.collisionBitMask = 1
        body.categoryBitMask = 1
        body.contactTestBitMask = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        lives = startLives
    }
    
    func moveUp() {
        self.dir = Direction.UP
        self.setVelocity(dx: 0, dy: velocity)
        self.zRotation = 0
        if ownPlayer {
            sendMove()
        }
    }
    
    func moveDown() {
        self.dir = Direction.DOWN
        self.setVelocity(dx: 0, dy: -velocity)
        self.zRotation = CGFloat(Double.pi)
        if ownPlayer {
            sendMove()
        }
    }
    
    func moveLeft() {
        self.dir = Direction.LEFT
        self.setVelocity(dx: -velocity, dy: 0)
        self.zRotation = CGFloat(Double.pi/2.0)
        if ownPlayer {
            sendMove()
        }
    }
    
    func moveRight() {
        self.dir = Direction.RIGHT
        self.setVelocity(dx: velocity, dy: 0)
        self.zRotation = CGFloat(Double.pi*3.0/2.0)
        if ownPlayer {
            sendMove()
        }
    }
    
    func stop() {
        //self.dir = Direction.NONE
        self.body.velocity = CGVector(dx: 0, dy: 0)
        if ownPlayer {
            sendMove()
        }
    }
    func sendMove() {
        SocketIOManager.sharedInstance.sendMove(gameScene.opponent, position: CGPoint(x: self.position.x / scalerX, y: self.position.y / scalerY), velocity: CGVector(dx: self.body.velocity.dx / scalerX, dy: self.body.velocity.dy / scalerY))
    }
    func shoot() {
        
        let bullet = Bullet()
        let horizBuffer = 10 * scalerX
        let vertiBuffer = 10 * scalerY
        
        switch dir {
        case .UP:
            print ("Shoot up")
            bullet.position = CGPoint(x: self.position.x, y: self.position.y + self.size.height/2 + bullet.size.height/2 + vertiBuffer)
            bullet.body.velocity = CGVector(dx: 0, dy: shootVelocity)
            break
        case .RIGHT:
            print ("Shoot right")
            bullet.position = CGPoint(x: self.position.x + self.size.width/2 + bullet.size.height/2 + horizBuffer, y: self.position.y)
            bullet.body.velocity = CGVector(dx: shootVelocity, dy: 0)
            break
        case .DOWN:
            print ("Shoot down")
            bullet.position = CGPoint(x: self.position.x, y: self.position.y - self.size.height/2 - bullet.size.height/2 - vertiBuffer)
            bullet.body.velocity = CGVector(dx: 0, dy: -shootVelocity)
            break
        case .LEFT:
            print ("Shoot left")
            bullet.position = CGPoint(x: self.position.x - self.size.width/2 - bullet.size.height/2 - horizBuffer, y: self.position.y)
            bullet.body.velocity = CGVector(dx: -shootVelocity, dy: 0)
            break
        default:
            print("No shoot direction")
            break
        }
        if ownPlayer {
            SocketIOManager.sharedInstance.sendShoot(gameScene.opponent, pos: CGPoint(x: bullet.position.x/scalerX, y: bullet.position.y/scalerY), vel: CGVector(dx: bullet.body.velocity.dx/scalerX, dy: bullet.body.velocity.dy/scalerY))
        }
        gameScene.addChild(bullet)
        
    }
    
    func shoot(pos: CGPoint, vel: CGVector) {
        let bullet = Bullet()
        bullet.setPosition(x: pos.x, y: pos.y)
        bullet.setVelocity(dx: vel.dx, dy: vel.dy)
        gameScene.addChild(bullet)
    }
}

class Bullet: SKSpriteNode {
    var body: SKPhysicsBody!
    init() {
        let texture = SKTexture(imageNamed: "Bullet")
        let bulletSize = CGSize(width: scalerX * 20, height: scalerX * 20)
        super.init(texture: texture, color: UIColor.clear, size: bulletSize)
        self.physicsBody = SKPhysicsBody(circleOfRadius: bulletSize.width/2)
        body = self.physicsBody!
        body.collisionBitMask = 0
        body.contactTestBitMask = 1
        body.categoryBitMask = 0
        self.zPosition = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SKSpriteNode {
    func setPosition(x: CGFloat, y: CGFloat) {
        position.x = x * scalerX
        position.y = y * scalerY
    }
    
    func setVelocity(dx: CGFloat, dy: CGFloat) {
        self.physicsBody?.velocity = CGVector(dx: dx * scalerX, dy: dy * scalerY)
    }
}
