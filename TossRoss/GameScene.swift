//
//  GameScene.swift
//  TossRoss
//
//  Created by Edward Shin on 9/6/18.
//  Copyright © 2018 Edward Shin. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var screenTouched: Bool = false;
    
    var motionManager = CMMotionManager()
    let opQueue = OperationQueue()
    var gravity = CGVector(dx: 0, dy: 0)
    var oof = SKAction.playSoundFileNamed("oof.mp3", waitForCompletion: false)
    var oofed: Bool = false
    
    // body parts
    var body: SKShapeNode?
    var head: SKShapeNode?
    var leftArm: SKShapeNode?
    var rightArm: SKShapeNode?
    var leftLeg: SKShapeNode?
    var rightLeg: SKShapeNode?
    
    var face: SKLabelNode?
    var faceText: String = ": /";
    
    // pin joints
    var headJoint: SKPhysicsJointPin?
    var leftArmJoint: SKPhysicsJointPin?
    var rightArmJoint: SKPhysicsJointPin?
    var leftLegJoint: SKPhysicsJointPin?
    var rightLegJoint: SKPhysicsJointPin?
    
    let bodyMass: CGFloat = 200;
    let limbMass: CGFloat = 8.0;
    let headMass: CGFloat = 4.0;
    let headJointMaxLength: CGFloat = 2.0;
    
    override func didMove(to view: SKView) {
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame);
        self.buildBody();
        startReadingMotionData()
        
    }
    
    func buildBody() {
        let w = (self.size.width + self.size.height) * 0.05
        
        // body details
        self.body = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w * 2), cornerRadius: w * 0.3);
        self.body?.fillColor = .blue;
        self.body?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: w, height: w * 2));
        self.body?.physicsBody?.mass = self.bodyMass;
        
        // head details
        self.head = SKShapeNode.init(ellipseOf: CGSize.init(width: w, height: w * 1.25));
        self.head?.fillColor = .red;
        self.head?.position = CGPoint(x: 0, y: w * 1.5);
        self.head?.physicsBody = SKPhysicsBody(circleOfRadius: w / 2)
        
        self.head?.physicsBody?.mass = self.headMass;
        self.face = SKLabelNode(text: self.faceText);
        self.face?.fontSize = 70;
        self.face?.fontColor = .black;
        self.face?.position = CGPoint(x: 0, y: -(w * 0.25));
        
        // left arm details
        self.leftArm = SKShapeNode.init(rectOf: CGSize.init(width: w * 1.5, height: w / 3), cornerRadius: w * 0.1);
        self.leftArm?.fillColor = .red;
        self.leftArm?.position = CGPoint(x: -(w), y: (w / 1.5));
        self.leftArm?.physicsBody =  SKPhysicsBody(rectangleOf: CGSize(width: w * 1.5, height: w / 3));
        self.leftArm?.physicsBody?.mass = self.limbMass;
        
        // right arms details
        self.rightArm = SKShapeNode.init(rectOf: CGSize.init(width: w * 1.5, height: w / 3), cornerRadius: w * 0.1);
        self.rightArm?.fillColor = .red;
        self.rightArm?.position = CGPoint(x: (w), y: (w / 1.5));
        self.rightArm?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: w * 1.5, height: w / 3));
        self.rightArm?.physicsBody?.mass = self.limbMass;
        
        // left leg details
        self.leftLeg = SKShapeNode.init(rectOf: CGSize.init(width: w / 3, height: w * 1.5), cornerRadius: w * 0.1);
        self.leftLeg?.fillColor = .red;
        self.leftLeg?.position = CGPoint(x: -w / 2, y: -w * 1.5);
        self.leftLeg?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: w / 3, height: w * 1.5));
        self.leftLeg?.physicsBody?.mass = self.limbMass;
        
        // right leg details
        self.rightLeg = SKShapeNode.init(rectOf: CGSize.init(width: w / 3, height: w * 1.5), cornerRadius: w * 0.1);
        self.rightLeg?.fillColor = .red;
        self.rightLeg?.position = CGPoint(x: w / 2, y: -w * 1.5);
        self.rightLeg?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: w / 3, height: w * 1.5));
        self.rightLeg?.physicsBody?.mass = self.limbMass;
        
        // put ross's body parts in game scene
        if let player = self.body {
            self.addChild(player);
        }
        
        if let armL = self.leftArm {
            self.addChild(armL);
        }
        
        if let armR = self.rightArm {
            self.addChild(armR);
        }
        if let legL = self.leftLeg {
            self.addChild(legL);
        }
        if let legR = self.rightLeg {
            self.addChild(legR);
        }
        
        if let f = self.face {
            self.head?.addChild(f);
        }
        
        if let h = self.head {
            self.addChild(h);
        }
        
        let headPos = self.body?.convert(CGPoint(x: 0, y: (w / 3)), to: self)
        headJoint = SKPhysicsJointPin.joint(withBodyA: (self.body?.physicsBody!)!, bodyB: (self.head?.physicsBody!)!, anchor: (headPos)!);
        self.physicsWorld.add((headJoint)!);
        
        // left arm joint
        let pinPos1 = self.body?.convert(CGPoint(x: -(w / 2), y: (w / 1.5)), to: self);
        leftArmJoint = SKPhysicsJointPin.joint(withBodyA: (self.body?.physicsBody!)!, bodyB: (self.leftArm?.physicsBody!)!, anchor: (pinPos1)!);
        self.physicsWorld.add((leftArmJoint)!);
        
        // right arm joint
        let pinPos2 = self.body?.convert(CGPoint(x: (w / 2), y: (w / 1.5)), to: self);
        rightArmJoint = SKPhysicsJointPin.joint(withBodyA: (self.body?.physicsBody!)!, bodyB: (self.rightArm?.physicsBody!)!, anchor: (pinPos2)!);
        self.physicsWorld.add((rightArmJoint)!);
        
        // left leg joint
        let pinPos3 = self.body?.convert(CGPoint(x: -(w / 2), y: -(w * 1.5) / 2), to: self);
        leftLegJoint = SKPhysicsJointPin.joint(withBodyA: (self.body?.physicsBody!)!, bodyB: (self.leftLeg?.physicsBody!)!, anchor: (pinPos3)!);
        self.physicsWorld.add((leftLegJoint)!);
        
        // right leg joint
        let pinPos4 = self.body?.convert(CGPoint(x: (w / 2), y: -(w * 1.5) / 2), to: self);
        rightLegJoint = SKPhysicsJointPin.joint(withBodyA: (self.body?.physicsBody!)!, bodyB: (self.rightLeg?.physicsBody!)!, anchor: (pinPos4)!);
        self.physicsWorld.add((rightLegJoint)!);
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if(!self.screenTouched) {
            if let ross = self.body {
                ross.position = pos;
                self.screenTouched = true;
                print(pos)
            }
        }
        
    }
//
    func touchMoved(toPoint pos : CGPoint) {
        if let ross = self.body {
            ross.position = pos;
        }
    }
//
    func touchUp(atPoint pos : CGPoint) {
        self.screenTouched = false;
    }
//
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        playSound(sound: oof)

        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
//
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    func startReadingMotionData() {
        // set read speed
        motionManager.deviceMotionUpdateInterval = 0.01
        // start reading
        motionManager.startDeviceMotionUpdates(to: opQueue) {
            (data: CMDeviceMotion?, error: Error?) in
            
            if let mydata = data {
                self.gravity = CGVector(dx: mydata.gravity.x * 100, dy: mydata.gravity.y * 100)
                self.physicsWorld.gravity = self.gravity
            }
            self.goOOf()
        }
    }
    func playSound(sound : SKAction)
    {
        run(sound)
    }
    func goOOf() {
        if let x = self.head?.position.x {
            if x > 320 || x < -320 {
                if self.oofed == false {
                    playSound(sound: oof)
                    self.oofed = true
                }
            }
            else {
                self.oofed = false
            }
        }
        if let y = self.head?.position.y {
            if y > 600 || y < -600 {
                if self.oofed == false {
                    playSound(sound: oof)
                    self.oofed = true
                }
            }
            else {
                self.oofed = false
            }
        }
    }
}
