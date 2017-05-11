//
//  PlayViewController.swift
//  Owls-iOS
//
//  Created by Howard Shan on 5/9/17.
//  Copyright © 2017 Howard. All rights reserved.
//

import Foundation
import UIKit

class PlayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var scene: GameScene!
    var hostedGames = [[String: AnyObject]]()
    var otherScreenSize : CGRect!
    var scaleFactorX: CGFloat = 0
    var scaleFactorY: CGFloat = 0
    var parentVC: TitleViewController!
    var connectedDevice: String?
    var sentData = false
    var sentPause = false
    var sentPauseAction = false
    let id = UUID().uuidString
    var username = UIDevice.current.name
    var opponent = ""
    var playerDict: [String: String]!
    var movedToScene = false
    
    let timer = Timer()
    
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var InviteToGame: UIButton!
    @IBOutlet weak var SearchOnline: UIButton!
    @IBOutlet weak var inviteView: UIView!
    
    @IBOutlet weak var inviteeName: UILabel!
    
    // MARK: Overrided Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        respondToSocket()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let buttons:[UIButton] = [InviteToGame, SearchOnline]
        formatMenuButtons(buttons)
        
        InviteToGame.alpha = 0.5
        InviteToGame.isUserInteractionEnabled = false
        SearchOnline.isUserInteractionEnabled = true
        SearchOnline.alpha = 1
        inviteView.isHidden = true
        SocketIOManager.sharedInstance.establishConnection()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    // MARK: IBActions
    
    @IBAction func backButton(_ sender: AnyObject){
        _ = navigationController?.popViewController(animated: true)
        SocketIOManager.sharedInstance.closeConnection()
    }
    
    @IBAction func SearchOnline(_ sender: AnyObject){
        //gameService.getServiceAdvertiser().startAdvertisingPeer()
        //gameService.getServiceBrowser().startBrowsingForPeers()
        self.gameTableView.reloadData()
        SearchOnline.isUserInteractionEnabled = false
        SearchOnline.alpha = 0.5
        connectToServer()
    }
    
    @IBAction func InviteToGame(_ sender: AnyObject){
        // rename to invite game, user who clicks join game will be host!
        sentData = true
        InviteToGame.alpha = 0.5
        InviteToGame.isUserInteractionEnabled = false
        gameTableView.deselectRow(at: gameTableView.indexPathForSelectedRow!, animated: false)
        SocketIOManager.sharedInstance.inviteToGame(username, opponentName: opponent)
    }
    
    @IBAction func closeInvite(_ sender: AnyObject) {
        inviteView.isHidden = true
    }
    
    @IBAction func acceptInvite(_ sender: AnyObject) {
        setOpp(inviteeName.text!)
        SocketIOManager.sharedInstance.connectGame(self.username, otherUsername: opponent)
    }
    // MARK: Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setOpp(self.hostedGames[indexPath.row]["username"] as! String)
        self.InviteToGame.alpha = 1
        self.InviteToGame.isUserInteractionEnabled = true
        //gameService.connectToDevice(connectedDevice!)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = hostedGames[indexPath.row]["username"] as? String
        if let txt = cell.textLabel?.text {
            if txt == self.username {
                cell.isUserInteractionEnabled = false
                cell.backgroundColor = UIColor(red: CGFloat(255.0/255), green: CGFloat(200.0/255), blue: CGFloat(200.0/255), alpha: 1.0)
            }
        }
        if let opp = hostedGames[indexPath.row]["opponent"] as? String {
            if opp != "" {
                cell.isUserInteractionEnabled = false
                cell.backgroundColor = UIColor(red: CGFloat(255.0/255), green: CGFloat(200.0/255), blue: CGFloat(200.0/255), alpha: 1.0)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hostedGames.count
    }
    
    // MARK: Custom Methods
    func connectToServer() {
        SocketIOManager.sharedInstance.connectToServerWithUsername(self.username, completionHandler: { (userList) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                print("Updated user list")
                if userList == nil {
                    print("User list is nil")
                }
                if userList != nil {
                    self.hostedGames = userList!
                    self.gameTableView.reloadData()
                }
            })
        })
    }
    
    func setOpp(_ opponent: String) {
        self.opponent = opponent
    }
    
}

// MARK: SocketManager functions

extension PlayViewController {
    func respondToSocket() {
        SocketIOManager.sharedInstance.socket.on("nameChange") { (newName, ack) in
            self.username = newName[0] as! String
        }
        SocketIOManager.sharedInstance.socket.on("inviteToGame") { (opponentName, ack) in
            self.inviteView.isHidden = false
            self.inviteeName.text = opponentName[0] as? String
        }
        SocketIOManager.sharedInstance.socket.on("connectGameUpdate") { (opp, ack) in
            print ("connect game update")
            let opponentName = opp[0] as! String
            self.setOpp(opponentName)
            if self.movedToScene {
                return
            }
            let gameVC = self.storyboard!.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
            self.scene = gameVC.gameScene
            gameVC.parentVC = self
            self.scene.gameVC = gameVC
            self.scene.opponent = self.opponent
            self.movedToScene = true
            self.navigationController?.pushViewController(gameVC, animated: true)
        }
        
        SocketIOManager.sharedInstance.socket.on("moveUpdate") { (opp, ack) in
            print("moveUpdate")
            let moveInfo = opp[0] as! [CGFloat]
            
            let sentTime = opp[1] as! Double
            let timeElapsed = CGFloat(Date.timeIntervalSinceReferenceDate - sentTime)
            
            let vx = moveInfo[2]
            let vy = -moveInfo[3]
            let px = moveInfo[0] + vx * timeElapsed
            let py = moveInfo[1] + vy * timeElapsed
            self.scene.owl2.setPosition(x: px, y: 1260-py)
            if vx > 0 {
                self.scene.owl2.moveRight()
            } else if vx < 0 {
                self.scene.owl2.moveLeft()
            } else if vy > 0 {
                self.scene.owl2.moveUp()
            } else if vy < 0 {
                self.scene.owl2.moveDown()
            } else {
                self.scene.owl2.stop()
            }
            
            
            //self.scene.owl2.setVelocity(dx: vx, dy: -vy)
        }
        
        SocketIOManager.sharedInstance.socket.on("shootUpdate") { (opp, ack) in
            let bulletInfo = opp[0] as! [CGFloat]
            let sentTime = opp[1] as! Double
            let timeElapsed = CGFloat(Date.timeIntervalSinceReferenceDate - sentTime)
            let vel = CGVector(dx: bulletInfo[2], dy: -bulletInfo[3])
            let pos = CGPoint(x: bulletInfo[0] + vel.dx * timeElapsed, y: 1260 - bulletInfo[1] + vel.dy * timeElapsed)
            self.scene.owl2.shoot(pos: pos, vel: vel)
        }
    }
}

func formatMenuButtons(_ buttons: [UIButton]){
    for button in buttons{
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = gold
    }
}
