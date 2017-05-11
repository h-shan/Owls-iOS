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
    @IBOutlet weak var pauseView: UIView!
    @IBOutlet weak var dimmer: UIView!
    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var dPadView:DPadView!
    var gameScene = GameScene(size: CGSize(width: scalerX * 1000, height: scalerY * 1260))
    var parentVC: PlayViewController!
    var holdingMove = false
    let timeBetweenMoves = 0.05
    var timer = Timer()
    var fireTimer: Timer!
    
    @IBAction func buttonDown(sender: UIButton) {
        holdingMove = true
        switch sender {
        case upButton:
            print("Up")
            moveUp()
            break
        case downButton:
            print("Down")
            moveDown()
            break
        case rightButton:
            print("Right")
            moveRight()
            break
        case leftButton:
            print("Left")
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
        holdingMove = false
        timer.invalidate()
        stop()
    }
    
    @IBAction func fireButtonUp(sender: UIButton) {
        fireTimer.invalidate()
    }
    
    @IBAction func pauseClicked(sender: AnyObject) {
        gameScene.physicsWorld.speed = 0
        gameScene.isPaused = true
        pauseView.isHidden = false
        UIView.animate(withDuration: 0.2,animations:{
            self.dimmer?.alpha = 0.5
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pause" {
            let pauseVC = segue.destination as! PauseViewController
            pauseVC.parentVC = self
            pauseVC.scene = self.gameScene
        }
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
        pauseView.isHidden = true
        UIView.animate(withDuration: 0.2,animations:{
            self.dimmer?.alpha = 0
        })
    }
}
