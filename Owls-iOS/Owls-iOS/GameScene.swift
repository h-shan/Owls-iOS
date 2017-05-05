//
//  GameScene.swift
//  Owls-iOS
//
//  Created by Howard Shan on 5/4/17.
//  Copyright © 2017 Howard. All rights reserved.
//

import SpriteKit
import GameplayKit

extension CGPoint {
    func validPosition() -> Bool{
        if x > 900 * scalerX || x < 100 * scalerX || y > 1700 * scalerY || y < 100 * scalerY {
            return false
        }
        return true
    }
}

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var owl = Player()
   
    override init(size: CGSize) {
        super.init(size: size)
        let background = SKSpriteNode(color: .white, size: self.frame.size)
        background.position = CGPoint(x:frame.midX, y:frame.midY)
        background.zPosition=1.1
        addChild(background)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {
        self.addChild(owl.node)
        owl.node.position = CGPoint(x: scalerX * 500, y: scalerY * 900)
        owl.node.zPosition = 3
        print(owl.node.position)
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
    
    func fire() {
        print("Fire!")
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
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
