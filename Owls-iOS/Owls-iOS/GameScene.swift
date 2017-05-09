//
//  GameScene.swift
//  Owls-iOS
//
//  Created by Howard Shan on 5/4/17.
//  Copyright © 2017 Howard. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var grid = [[Bool]]()
    var owl: Player!
    var width:CGFloat = 1000
    var height:CGFloat = 1800
    var walls = [CGRect]()
    var topWall: SKSpriteNode!
    var rightWall: SKSpriteNode!
    var bottomWall: SKSpriteNode!
    var leftWall: SKSpriteNode!
    var maxX: CGFloat!
    var maxY: CGFloat!
    let velocity:CGFloat = 200

    override func provideImageData(_ data: UnsafeMutableRawPointer, bytesPerRow rowbytes: Int, origin x: Int, _ y: Int, size width: Int, _ height: Int, userInfo info: Any?) {
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
        if let wall = contact.bodyA.node as? Wall {
            if wall.orientation == Orientation.VERTICAL {
            contact.bodyB.velocity.dx = 0
            } else {
                contact.bodyB.velocity.dy = 0
            }
        }
        if let wall = contact.bodyB.node as? Wall {
            if wall.orientation == Orientation.VERTICAL {
                contact.bodyA.velocity.dx = 0
            } else {
                contact.bodyB.velocity.dy = 0
            }
        }
        if contact.bodyA.node is Bullet {
            contact.bodyA.node?.removeFromParent()
            if let player = contact.bodyB.node as? Player {
                player.lives -= 1
                print(player.lives)
                if player.lives <= 0 {
                    player.removeFromParent()
                }
            }
        }
        if contact.bodyB.node is Bullet {
            contact.bodyB.node?.removeFromParent()
            if let player = contact.bodyA.node as? Player {
                player.lives -= 1
                print(player.lives)
                if player.lives <= 0 {
                    player.removeFromParent()
                }
            }
        }
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyA.node is Wall {
            if let player = contact.bodyB.node as? Player {
                if player.dir == Direction.RIGHT && player.body.velocity.dx < 0{
                    player.body.velocity.dx = 0
                }
                if player.dir == Direction.LEFT && player.body.velocity.dx > 0{
                    player.body.velocity.dx = 0
                }
                if player.dir == Direction.DOWN && player.body.velocity.dy > 0{
                    player.body.velocity.dy = 0
                }
                if player.dir == Direction.UP && player.body.velocity.dy < 0{
                    player.body.velocity.dy = 0
                }
                
            }
        }
        if contact.bodyB.node is Wall  {
            if let player = contact.bodyA.node as? Player {
                if player.dir == Direction.RIGHT && player.body.velocity.dx < 0{
                    player.body.velocity.dx = 0
                }
                if player.dir == Direction.LEFT && player.body.velocity.dx > 0{
                    player.body.velocity.dx = 0
                }
                if player.dir == Direction.DOWN && player.body.velocity.dy > 0{
                    player.body.velocity.dy = 0
                }
                if player.dir == Direction.UP && player.body.velocity.dy < 0{
                    player.body.velocity.dy = 0
                }
                
            }
        }
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        let background = SKSpriteNode(color: .white, size: self.frame.size)
        background.position = CGPoint(x:frame.midX, y:frame.midY)
        background.zPosition=1.1
        addChild(background)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self

        // set up grid
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        owl = Player(scene: self)
        self.addChild(owl)
        
        owl.setPosition(x: 500, y: 900)
        let owl2 = Player(scene: self)
        self.addChild(owl2)
        owl2.setPosition(x: 700, y: 1200)
        print(owl.position)
        self.maxX = self.view!.frame.maxX
        self.maxY = self.view!.frame.maxY
        leftWall = makeWall(startX: 0, startY: height*0.3, endX: 20, endY: height)
        rightWall = makeWall(startX: width-20, startY: height*0.3, endX: width, endY: height)
        topWall = makeWall(startX: 20, startY: height, endX: width-20, endY: height - 20)
        bottomWall = makeWall(startX: 20, startY: height*0.3, endX: width-20, endY: height*0.3+20)
        let temp = makeWall(startX: width/2-10, startY: height*0.8, endX: width/2 + 10, endY: height*0.5)
        temp.name = "hello"
        for node in children{
            if let body = node.physicsBody{
                body.collisionBitMask = 1
                body.contactTestBitMask = 1
                body.categoryBitMask = 1
            }
            
        }
    }
    
    func moveUp() {
        //owl.moveUp()
        owl.dir = Direction.UP
        owl.body.velocity = CGVector(dx: 0, dy: velocity)
    }
    
    func moveDown() {
        //owl.moveDown()
        owl.dir = Direction.DOWN
        owl.body.velocity = CGVector(dx: 0, dy: -velocity)
    }
    
    func moveLeft() {
        //owl.moveLeft()
        owl.dir = Direction.LEFT
        owl.body.velocity = CGVector(dx: -velocity, dy:  0)
    }
    
    func moveRight() {
        //owl.moveRight()
        owl.dir = Direction.RIGHT
        owl.body.velocity = CGVector(dx: velocity, dy: 0)
    }
    
    func stop() {
        //owl.dir = Direction.NONE
        owl.body.velocity = CGVector(dx: 0, dy: 0)
    }
    func fire() {
        print("Fire!")
        owl.shoot()
    }
    
    func validPosition(x: CGFloat, y:CGFloat, size: CGSize) -> Bool {
        if x < 0 || x >= width || y < 0 || y >= height {
            return false
        }
        let fx = CGFloat(x)
        let fy = CGFloat(y)
        let fh = size.height/owl.moveConstant
        let fw = size.width/owl.moveConstant
        let testPoints = [(fx - fw/2, fy - fh/2), (fx + fw/2, fy + fh/2), (fx, fy + fh/2), (fx + fw/2, fy)]
        for rect in walls {
            for pt in testPoints {
                if pt.0 >= rect.minX && pt.0 <= rect.maxX && pt.1 >= rect.minY && pt.1 <= rect.maxY {
                    return false
                }
            }
        }
        return true
    }
    
    func makeWall(startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat) -> SKSpriteNode {
        let beginY = min(startY, endY)
        let finishY = max(startY, endY)
        let beginX = min(startX, endX)
        let finishX = max(startX, endX)
        // start and end scaled!
        let wallSize = CGSize(width: scalerX * owl.moveConstant * CGFloat(endX - startX + 1), height: scalerY * owl.moveConstant * CGFloat(finishY - beginY + 1))
        let texture = SKTexture(image: UIImage(named: "Wall")!)
        let wall = Wall(texture: texture, color: .clear, size: wallSize)
        wall.position = CGPoint(x: scalerX * owl.moveConstant * (beginX + finishX)/2, y: scalerY * owl.moveConstant * (beginY + finishY)/2)
        wall.zPosition = 3
        wall.physicsBody = SKPhysicsBody(rectangleOf: wallSize)
        wall.physicsBody?.isDynamic = false
        wall.physicsBody!.friction = 0
        if finishY - beginY > finishX - beginX {
            wall.orientation = Orientation.VERTICAL
        } else {
            wall.orientation = Orientation.HORIZONTAL
        }
        addChild(wall)
        return wall
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

class Wall: SKSpriteNode {
    var orientation: Orientation!
}
class GameView: UIView {
    var arrows: [UIView]!

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for arrow: UIView in arrows {
            for touch: UITouch in touches {
                if arrow.point(inside: touch.location(in: self), with: event) {
                    print(arrow.tag)
                }
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touch!")
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return frame.contains(point)
    }
}

