//
//  PauseViewController.swift
//  Owls-iOS
//
//  Created by Howard Shan on 5/9/17.
//  Copyright © 2017 Howard. All rights reserved.
//

import Foundation
import UIKit

class PauseViewController: UIViewController {
    var scene: GameScene!
    var parentVC: GameViewController!
    
    @IBAction func resume(_ sender: AnyObject) {
        print("resume")
        scene.physicsWorld.speed = 1
        scene.isPaused = false
        UIView.animate(withDuration: 0.2,animations:{
            self.parentVC.dimmer?.alpha = 0
        })
        parentVC.pauseView.isHidden = true
        if sender is UIButton {
            SocketIOManager.sharedInstance.sendPause(scene.opponent, pauseOption: "resume")
        }
    }
    
    @IBAction func restart(_ sender: AnyObject) {
        print("restart")
        scene.physicsWorld.speed = 1
        scene.isPaused = false
        UIView.animate(withDuration: 0.2,animations:{
            self.parentVC.dimmer?.alpha = 0
        })
        parentVC.pauseView.isHidden = true
        scene.restart()
        if sender is UIButton {
            SocketIOManager.sharedInstance.sendPause(scene.opponent, pauseOption: "restart")
        }
    }
    
    @IBAction func quit(_ sender: AnyObject) {
        print("quit")
        navigationController!.popViewController(animated: true)
        if sender is UIButton {
            SocketIOManager.sharedInstance.sendPause(scene.opponent, pauseOption: "quit")
        }
    }
}
