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
    
    @IBAction func resume() {
        scene.physicsWorld.speed = 1
        scene.isPaused = false
        UIView.animate(withDuration: 0.2,animations:{
            self.parentVC.dimmer?.alpha = 0
        })
        parentVC.pauseView.isHidden = true
    }
    
    @IBAction func restart() {
        scene.physicsWorld.speed = 1
        scene.isPaused = false
        UIView.animate(withDuration: 0.2,animations:{
            self.parentVC.dimmer?.alpha = 0
        })
        parentVC.pauseView.isHidden = true
        scene.restart()
    }
    
    @IBAction func quit() {
        navigationController!.popViewController(animated: true)
    }
}
