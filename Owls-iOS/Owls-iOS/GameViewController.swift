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
    
    @IBOutlet weak var fireButton: UIButton!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var pauseView: UIView!
    @IBOutlet weak var dimmer: UIView!
    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var dPadView:DPadView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    
    var gameScene = GameScene(size: CGSize(width: scalerX * 1000, height: scalerY * 1260))
    var pauseVC: PauseViewController!
    var parentVC: PlayViewController!
    var holdingMove = false
    let timeBetweenMoves = 0.05
    var timer = Timer()
    var fireTimer: Timer!
    var testing = false

    @IBAction func fireButtonDown(sender: UIButton) {
        fire()
        fireTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(GameViewController.fire), userInfo: nil, repeats: true)
    }
    
    @IBAction func fireButtonUp(sender: UIButton) {
        fireTimer.invalidate()
    }
    
    @IBAction func pauseClicked(_ sender: AnyObject) {
        gameScene.physicsWorld.speed = 0
        gameScene.isPaused = true
        pauseView.isHidden = false
        
        UIView.animate(withDuration: 0.2,animations:{
            self.dimmer?.alpha = 0.5
        })
        if sender is UIButton {
            SocketIOManager.sharedInstance.sendPause(gameScene.opponent, pauseOption: "pause")
        }
    }
    
    @IBAction func leave(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pause" {
            pauseVC = segue.destination as! PauseViewController
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
        gameScene.gameVC = self
        skView.presentScene(gameScene)
        skView.showsFPS = true
        skView.showsNodeCount = true
        dPadView.scene = gameScene
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
        resultView.isHidden = true
        UIView.animate(withDuration: 0.2,animations:{
            self.dimmer?.alpha = 0
        })
    }
}
