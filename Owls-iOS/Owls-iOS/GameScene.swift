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
    var owl2: Player!
    var deadOwls = [Player]()
    var width:CGFloat = 1000
    var height:CGFloat = 1260
    var walls = [CGRect]()
    var topWall: SKSpriteNode!
    var rightWall: SKSpriteNode!
    var bottomWall: SKSpriteNode!
    var leftWall: SKSpriteNode!
    var maxX: CGFloat!
    var maxY: CGFloat!
    let velocity:CGFloat = 200
    var gameVC: GameViewController!
    var opponent: String!
    
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
                    deadOwls.append(player)
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
                    deadOwls.append(player)
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
        owl = Player(scene: self, ownPlayer: true)
        owl2 = Player(scene: self, ownPlayer: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        restart()
        addChild(owl)
        addChild(owl2)
        print(self.position)
        self.maxX = self.view!.frame.maxX
        self.maxY = self.view!.frame.maxY
        leftWall = makeWall(startX: 0, startY: 0, endX: 20, endY: height)
        rightWall = makeWall(startX: width-20, startY: 0, endX: width, endY: height)
        topWall = makeWall(startX: 20, startY: height, endX: width-20, endY: height - 20)
        bottomWall = makeWall(startX: 20, startY: 0, endX: width-20, endY: 20)
        _ = makeWall(startX: width*0.2, startY: height*0.5-10, endX: width*0.8, endY: height*0.5+10)
        _ = makeWall(startX: width*0.2, startY: height*0.2-10, endX: width*0.8, endY: height*0.2+10)
        _ = makeWall(startX: width*0.2, startY: height*0.8-10, endX: width*0.8, endY: height*0.8+10)
    }
    
    func moveUp() {
        owl.moveUp()
    }
    
    func moveDown() {
        owl.moveDown()
    }
    
    func moveLeft() {
        owl.moveLeft()
    }
    
    func moveRight() {
        owl.moveRight()
    }
    
    func stop() {
        owl.stop()
    }
    func fire() {
        print("Fire!")
        owl.shoot()
    }
    
    func makeWall(startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat) -> SKSpriteNode {
        let beginY = min(startY, endY)
        let finishY = max(startY, endY)
        let beginX = min(startX, endX)
        let finishX = max(startX, endX)
        // start and end scaled!
        let wallSize = CGSize(width: scalerX * CGFloat(endX - startX + 1), height: scalerY * CGFloat(finishY - beginY + 1))
        let texture = SKTexture(image: UIImage(named: "Wall")!)
        let wall = Wall(texture: texture, color: .clear, size: wallSize)
        wall.position = CGPoint(x: scalerX * (beginX + finishX)/2, y: scalerY * (beginY + finishY)/2)
        wall.zPosition = 3
        wall.physicsBody = SKPhysicsBody(rectangleOf: wallSize)
        wall.physicsBody?.isDynamic = false
        wall.physicsBody!.friction = 0
        wall.physicsBody!.collisionBitMask = 1
        wall.physicsBody!.contactTestBitMask = 1
        wall.physicsBody!.categoryBitMask = 1
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
    
    func restart() {
        owl.setPosition(x: 500, y: 200)
        owl2.setPosition(x: 500, y: 1060)
        owl.reset()
        owl2.reset()
        for dead in deadOwls {
            addChild(dead)
        }
        deadOwls.removeAll()
    }
}

class Wall: SKSpriteNode {
    var orientation: Orientation!
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DPadView: UIView {
    var scene: GameScene!
    @IBOutlet weak var arrowUp: UIImageView!
    @IBOutlet weak var arrowRight: UIImageView!
    @IBOutlet weak var arrowDown: UIImageView!
    @IBOutlet weak var arrowLeft: UIImageView!
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        activateMove(touches, event: event)
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        scene.stop()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touch!")
        activateMove(touches, event: event)
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return frame.contains(point)
    }
    func activateMove(_ touches: Set<UITouch>, event: UIEvent?) {
        for touch: UITouch in touches {
            let locationPoint = touch.location(in: self)
            let specificView = hitTest(locationPoint, with: event)
            print(touch.location(in: self))
            if inUpArrow(locationPoint) {
                print("Up...")
                scene.moveUp()
            } else if inRightArrow(locationPoint) {
                print("Right...")
                scene.moveRight()
            } else if inDownArrow(locationPoint) {
                print("Down...")
                scene.moveDown()
            }else if inLeftArrow(locationPoint) {
                print("Left...")
                scene.moveLeft()
            }
            
        }
    }
    
    func inUpArrow(_ point: CGPoint) -> Bool {
        return point.x > frame.maxX*0.3 && point.x < frame.maxX * 0.7 && point.y < frame.midY
    }
    func inDownArrow(_ point: CGPoint) -> Bool {
        return point.x > frame.maxX*0.3 && point.x < frame.maxX * 0.7 && point.y > frame.midY
    }
    func inLeftArrow(_ point: CGPoint) -> Bool{
        return point.y > frame.maxY*0.3 && point.y < frame.maxX * 0.7 && point.x < frame.midX
    }
    func inRightArrow(_ point: CGPoint) -> Bool{
        return point.y > frame.maxY*0.3 && point.y < frame.maxX * 0.7 && point.x > frame.midX
    }
    func inSubview(_ pointInSuperview: CGPoint, _ subview: UIView) -> Bool{
        let pointInSubview: CGPoint = subview.convert(pointInSuperview, from: self)
        if subview.frame.contains(pointInSubview) {
            print("We have a winner!")
            return true
        }
        return false
    }
}
