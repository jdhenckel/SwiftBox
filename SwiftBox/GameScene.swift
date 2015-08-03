//
//  GameScene.swift
//  SwiftBox
//
//  Created by John Henckel on 7/18/15.
//  Copyright (c) 2015 John Henckel. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
//    var touchList: [Touch] = []
//    var touchMoved: [Bool] = []
    var world: SKNode!
    
    
    override func didMoveToView(view: SKView) {
        
        /* detect gestures */
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
//        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "handleLongPress:"))
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePan:"))
//        view.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: "handleRotate:"))
        
        /* Setup your scene here */
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        
//        let worldFrame =
        world = SKNode()
            //SKSpriteNode(color: UIColor.blackColor(), size: self.frame.size)
        world.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(world)
        
        let box = SKSpriteNode(color: UIColor.blueColor(), size: CGSize(width: 200, height: 100))
        box.position = CGPoint(x: 0, y: 80)
        let boxBody = SKPhysicsBody(rectangleOfSize: box.size)
        boxBody.dynamic = true
        boxBody.mass = 1
        boxBody.linearDamping = 0
        boxBody.angularDamping = 0
        boxBody.restitution = 1
        boxBody.friction = 0
        box.physicsBody = boxBody
        world.addChild(box)
        
        let ballBody = SKPhysicsBody(circleOfRadius: 40)
        ballBody.dynamic = true
        ballBody.mass = 0.5
        ballBody.linearDamping = 0
        ballBody.angularDamping = 0
        ballBody.restitution = 1
        ballBody.friction = 0
        let ball = SKShapeNode(circleOfRadius: 40)
        ball.fillColor = UIColor.redColor()
        ball.strokeColor = UIColor.clearColor()
        ball.physicsBody = ballBody
        ball.position = CGPoint(x: 0, y: 0)
        world.addChild(ball)
        
//        let edgeBody = SKPhysicsBody(edgeLoopFromRect: worldFrame)
//        edgeBody.dynamic = false
//        edgeBody.restitution = 1
//        edgeBody.friction = 0
//        let edge = SKNode()
//        edge.physicsBody = edgeBody
//        world.addChild(edge)
        
        world.addChild(createBoundary())
        
        /* build the menu here */
        let myLabel = SKLabelNode(fontNamed:"helv")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 10;
        myLabel.position = world.position
        addChild(myLabel)
        

    }
    
    
    
    // Create a node that represents the boundary of the world. It could be a single
    // path node, or a heirarchy of non-dynamic shape nodes
    
    
    func createBoundary() -> SKNode {
        return createBoundarySet()
    }
    
    func createBoundarySet() -> SKNode {
        let shape = SKNode()
        let t = frame.width
        let h = frame.height
        shape.addChild(createBoundaryBox(x: -t, y: 0, w: t, h: h))
        shape.addChild(createBoundaryBox(x: t, y: 0, w: t, h: h))
        shape.addChild(createBoundaryBox(x: 0, y: (h + t) / 2, w: 3 * t, h: t))
        shape.addChild(createBoundaryBox(x: 0, y: -(h + t) / 2, w: 3 * t, h: t))
        return shape
    }
    
    func createBoundaryBox(#x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) -> SKNode {
        let shape = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: w,height: h))
        shape.position = CGPoint(x: x,y: y)
        let body = SKPhysicsBody(rectangleOfSize: CGSize(width: w,height: h))
        body.dynamic = false
        body.restitution = 1
        body.friction = 0
        shape.physicsBody = body
        return shape
    }
    
    func createBoundaryPath() -> SKNode {
        let path = CGPathCreateMutable()
        let inner = frame.rectByOffsetting(dx: -frame.midX, dy: -frame.midY)
        let outer = inner.rectByInsetting(dx: -frame.midX, dy: -frame.midX)
        CGPathMoveToPoint(path, nil, inner.origin.x, inner.origin.y)
        CGPathAddLineToPoint(path, nil, inner.origin.x, inner.origin.y + inner.size.height)
        CGPathAddLineToPoint(path, nil, inner.origin.x + inner.size.width, inner.origin.y + inner.size.height)
        CGPathAddLineToPoint(path, nil, inner.origin.x + inner.size.width, inner.origin.y)
        CGPathCloseSubpath(path)
        CGPathMoveToPoint(path, nil, outer.origin.x, outer.origin.y)
        CGPathAddLineToPoint(path, nil, outer.origin.x + outer.size.width, outer.origin.y)
        CGPathAddLineToPoint(path, nil, outer.origin.x + outer.size.width, outer.origin.y + outer.size.height)
        CGPathAddLineToPoint(path, nil, outer.origin.x, outer.origin.y + outer.size.height)
        CGPathCloseSubpath(path)
        let shape = SKShapeNode(path: path)
        shape.fillColor = UIColor.blackColor()
        shape.strokeColor = UIColor.whiteColor()
        let body = SKPhysicsBody(edgeLoopFromRect: inner)
        body.dynamic = false
        body.restitution = 1
        body.friction = 0
        shape.physicsBody = body
        return shape
    }

    
    func handleTap(sender:UITapGestureRecognizer) {
        let world = children[0] as! SKNode
        let box = world.children[0] as! SKNode
        box.physicsBody?.applyAngularImpulse(1)
    }
    
    
    func handleLongPress(sender:UILongPressGestureRecognizer) {
        println("begin long press")
        
    }
    
    func handleRotation(sender:UIRotationGestureRecognizer) {
        println("begin rotation")
        
    }
    
    
    
    func handlePan(sender:UIPanGestureRecognizer) {
        let world = children[0] as! SKNode
        struct Save {
            static var node: SKNode? = nil
            static var pos = CGPointZero
        }
        var pos = convertPointFromView(sender.locationInView(self.view!))
        switch sender.state {
        case .Began:
            Save.node = world
            Save.pos = pos
            let posInWorld = world.convertPoint(pos, fromNode: self)
            for i in 0...world.children.count-1 {
                if world.children[i].containsPoint(posInWorld) {
                    Save.node = world.children[i] as? SKNode
                    Save.node?.physicsBody?.dynamic = false
                    break
                }
            }
        case .Changed:
            Save.node?.position += pos - Save.pos
            Save.pos = pos
        case .Ended:
            if var body = Save.node?.physicsBody {
                body.dynamic = true
            }
        default: break
        }
    }
    
    
    // Find id of child at given point in world (or -1 if none)
//    func childAtPos(pos: CGPoint) -> Int {
//        for i in 0...children.count-1 {
//            if children[i].containsPoint(pos) {
//                return i
//            }
//        }
//        return -1
//    }

    
//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        for t in touches {
//            if let touch = t as? UITouch {
//                let pos = convertPointFromView(touch.locationInView(self.view!))
//                let posInWorld = world.convertPoint(pos, fromNode: self)
//                let pos =
//            }
//            
//            let u = touch as! UITouch
//            let p = self.convertPointFromView(u.locationInView(view))
//            let t = Touch(uit:u, pos:p)
//            let c = childAtPos(p)
//            if c >= 0 {
//                t.bodyId = c
//                t.offset = (p - children[c].position).rotate(-children[c].zRotation)
//            }
//            touchList.append(t)
//        }
//        (children[1] as! SKNode).physicsBody?.applyAngularImpulse(1)
//    }
//    
//    
//    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
//        for touch: AnyObject in touches {
//            let t = touch as! UITouch
//            for i in 0...touchList.count-1 {
//                if touchList[i].touch == t {
//                    touchList.removeAtIndex(i)
//                    break
//                }
//            }
//        }
//    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* */
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
//        println(currentTime)
//        println("box \(children[1].zRotation) ball \(children[2].zRotation)")
        
    }
}










































