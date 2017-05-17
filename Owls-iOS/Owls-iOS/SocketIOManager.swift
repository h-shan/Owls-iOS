//
//  SocketIOManager.swift
//  Owls-iOS
//
//  Created by Howard Shan on 5/9/17.
//  Copyright © 2017 Howard. All rights reserved.
//

import SocketIO
import UIKit

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "https://strategicsoccer.me:4000")! as URL)
    
    override init() {
        super.init()
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func connectToServerWithUsername(_ username: String, completionHandler: @escaping (_ userList: [[String: AnyObject]]?) -> Void) {
        socket.emit("connectUser", username)
        socket.on("userList") { ( dataArray, ack) -> Void in
            completionHandler(dataArray[0] as? [[String: AnyObject]])
        }
    }
    
    func exitChatWithUsername(_ username: String, completionHandler: () -> Void) {
        socket.emit("exitUser", username)
        completionHandler()
    }
    
    func connectGame(_ username: String, otherUsername: String) {
        socket.emit("connectGame", username, otherUsername)
    }
    
    func inviteToGame(_ username: String, opponentName: String) {
        socket.emit("inviteToGame", username, opponentName)
    }
    
    func sendPause(_ opponentName: String, pauseOption: String) {
        socket.emit("pause", opponentName, pauseOption)
    }
    
    func sendShoot(_ opponentName: String, pos: CGPoint, vel: CGVector) {
        let bulletInfo = [pos.x, pos.y, vel.dx, vel.dy]
        socket.emit("shoot", opponentName, bulletInfo, Date.timeIntervalSinceReferenceDate)
    }
    
    func sendMove(_ opponentName: String, position: CGPoint, velocity: CGVector) {
        let moveInfo = [position.x, position.y, velocity.dx, velocity.dy]
        socket.emit("move", opponentName, moveInfo, Date.timeIntervalSinceReferenceDate)
    }
    
    func sendGotHit(_ opponentName: String) {
        socket.emit("gotHit", opponentName)
    }
    func sendDead(_ opponentName: String) {
        socket.emit("dead", opponentName)
    }
}

extension CGFloat: SocketData {}
extension Float: SocketData {}
