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
        scalerX = self.view.frame.width/1000
        scalerY = self.view.frame.height/1800
    }
}
