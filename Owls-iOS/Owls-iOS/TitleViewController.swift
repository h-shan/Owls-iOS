//
//  TitleViewController.swift
//  Owls-iOS
//
//  Created by Howard Shan on 5/4/17.
//  Copyright © 2017 Howard. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class TitleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        screenWidth = self.view.frame.maxX
        screenHeight = self.view.frame.maxY
        
        scalerX = screenWidth/1000
        scalerY = screenHeight/1800
    }
}
