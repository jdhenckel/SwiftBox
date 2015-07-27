//
//  GameScene.swift
//  SwiftBox
//
//  Created by John Henckel on 7/18/15.
//  Copyright (c) 2015 John Henckel. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var touchList: [UITouch] = []
    
    override func didMoveToView(view: SKView) {
        /* detect gestures */
        //view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap"))
        //view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "handleLongPress"))
        //view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePan"))
        
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"helv")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 10;
        myLabel.position = CGPoint(x:CGRectGetMidX(frame), y:CGRectGetMidY(frame))
        addChild(myLabel)

        physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        
        let box = SKSpriteNode(color: UIColor.blueColor(), size: CGSize(width: 200, height: 100))
        box.position = CGPoint(x: 120, y: 450)
        let px = SKPhysicsBody(rectangleOfSize: box.size)
        px.dynamic = true
        px.mass = 1
        px.linearDamping = 0
        px.angularDamping = 0
        px.restitution = 1
        px.friction = 0
        box.physicsBody = px
        println(children.count)
        addChild(box)
        
        let py = SKPhysicsBody(circleOfRadius: 40)
        py.dynamic = true
        py.mass = 0.5
        py.linearDamping = 0
        py.angularDamping = 0
        py.restitution = 1
        py.friction = 0
        let ball = SKShapeNode(circleOfRadius: 40)
        ball.fillColor = UIColor.redColor()
        ball.strokeColor = UIColor.clearColor()
        ball.physicsBody = py
        ball.position = CGPoint(x: 120, y: 250)
        println(children.count)
        addChild(ball)

        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
    }

    
    func handleTap() {
        (children[0] as SKNode).physicsBody?.applyAngularImpulse(1)
    }
    
    func handleLongPress() {
        
    }
    
    func handlePan() {
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let t = touch as UITouch
            touchList.append(t)
            let pos = t.locationInView(self.view)
            println(" at \(pos.x) \(pos.y)")
        //    self.size = CGSize(width:pos.x, height: pos.y)
            let p2 = self.convertPointFromView(pos)
            for i in 0...children.count-1 {
                let ok = children[i].containsPoint(p2)
                println(" hit child \(i) is \(ok)")
            }
        }
        println(touchList.count)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let t = touch as UITouch
            for i in 0...touchList.count-1 {
                if touchList[i] == t {
                    touchList.removeAtIndex(i)
                    break
                }
            }
        }
        println(touchList.count)
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        /* */
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}










































