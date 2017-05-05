//
//  Player.swift
//  Owls-iOS
//
//  Created by Howard Shan on 5/4/17.
//  Copyright © 2017 Howard. All rights reserved.
//

import Foundation
import SpriteKit

class Player {
    var node: SKSpriteNode!
    var moveConstant:CGFloat = 20
    init() {
        let texture = SKTexture(imageNamed: "Owl")
        node = SKSpriteNode(texture: texture, color: UIColor.clear, size: CGSize(width: scalerX * 60, height: scalerY * 60))
    }
    
    func moveUp() {
        let nextPosition = CGPoint(x: node.position.x, y: node.position.y + moveConstant * scalerY)
        if nextPosition.validPosition() {
            node.position = nextPosition
        }
    }
    func moveDown() {
        let nextPosition = CGPoint(x: node.position.x, y: node.position.y - moveConstant * scalerY)
        if nextPosition.validPosition() {
            node.position = nextPosition
        }
    }
    func moveLeft() {
        let nextPosition = CGPoint(x: node.position.x - moveConstant * scalerX, y: node.position.y)
        if nextPosition.validPosition() {
            node.position = nextPosition
        }
    }
    func moveRight() {
        let nextPosition = CGPoint(x: node.position.x + moveConstant * scalerX, y: node.position.y)
        if nextPosition.validPosition() {
            node.position = nextPosition
        }
    }
}
