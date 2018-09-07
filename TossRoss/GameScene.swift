//
//  GameScene.swift
//  TossRoss
//
//  Created by Kammeron Nhieu on 9/6/18.
//  Copyright © 2018 Kammeron Nhieu. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    var motionManager = CMMotionManager()
    let opQueue = OperationQueue()
    var gravity = CGVector(dx: 0, dy: 0)
    
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startReadingMotionData()
    }
    
    func startReadingMotionData() {
        // set read speed
        motionManager.deviceMotionUpdateInterval = 0.01
        // start reading
        motionManager.startDeviceMotionUpdates(to: opQueue) {
            (data: CMDeviceMotion?, error: Error?) in
            
            if let mydata = data {
                print("mydata", mydata.gravity)
                self.gravity = CGVector(dx: mydata.gravity.x * 100, dy: mydata.gravity.y * 100)
                self.physicsWorld.gravity = self.gravity
            }
        }
    }
    func degrees(_ radians: Double) -> Double {
        return 180/Double.pi * radians
    }
}
