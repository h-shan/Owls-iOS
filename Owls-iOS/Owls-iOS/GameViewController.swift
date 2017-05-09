//
//  GameViewController.swift
//  Owls-iOS
//
//  Created by Howard Shan on 5/4/17.
//  Copyright © 2017 Howard. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var fireButton: UIButton!
    @IBOutlet weak var controlView: UIView!
    var gameScene = GameScene(size: CGSize(width: scalerX * 1000, height: scalerY * 1800))
    
    let timeBetweenMoves = 0.05
    var timer = Timer()
    var fireTimer: Timer!
    
    @IBAction func buttonDown(sender: UIButton) {
        var runFunc: Selector!
        switch sender {
        case upButton:
            print("Up")
            runFunc = #selector(GameViewController.moveUp)
            moveUp()
            break
        case downButton:
            print("Down")
            runFunc = #selector(GameViewController.moveDown)
            moveDown()
            break
        case rightButton:
            print("Right")
            runFunc = #selector(GameViewController.moveRight)
            moveRight()
            break
        case leftButton:
            print("Left")
            runFunc = #selector(GameViewController.moveLeft)
            moveLeft()
            break
        default:
            print("Unknown Button, will crash.")
            break
        }
        timer.invalidate()
        //timer = Timer.scheduledTimer(timeInterval: timeBetweenMoves, target: self, selector: runFunc, userInfo: nil, repeats: true)
    }
    
    @IBAction func fireButtonDown(sender: UIButton) {
        fire()
        fireTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(GameViewController.fire), userInfo: nil, repeats: true)
    }
    
    @IBAction func buttonUp(sender: UIButton) {
        timer.invalidate()
        stop()
    }
    
    @IBAction func fireButtonUp(sender: UIButton) {
        fireTimer.invalidate()
    }
    
    func moveUp() {
        gameScene.moveUp()
    }
    
    func moveDown() {
        gameScene.moveDown()
    }
    
    func moveLeft() {
        gameScene.moveLeft()
    }
    
    func moveRight() {
        gameScene.moveRight()
    }
    
    func stop() {
        gameScene.stop()
    }
    func fire() {
        gameScene.fire()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = self.view as! SKView
        skView.presentScene(gameScene)
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        //controlView.arrows = [upButton, rightButton, downButton, leftButton]
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
