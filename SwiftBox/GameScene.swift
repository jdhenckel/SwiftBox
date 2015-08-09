//
//  GameScene.swift
//  SwiftBox
//
//  Created by John Henckel on 7/18/15.
//  Copyright (c) 2015 John Henckel. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    
    var touchCollector: TouchCollector!
    
    
    override func didMoveToView(view: SKView) {
        
        /* Setup your scene here */
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -1)

        // Create a single worldNode with origin in the middle of the frame. This will be the root
        // of everything with physics or collision, including the terrain.
        // The pan/zoom function works by changing the position/scale of this node.
        
        let worldNode = SKNode()
        worldNode.position = CGPoint(x: frame.midX, y: frame.midY)

        let menuNode = SKNode()
        menuNode.position = CGPoint(x: Menu.fontSize / 2, y: frame.height / 2 - Menu.fontSize * 1.2)

        addChild(worldNode)   // child 0 of the scene is always the WORLD
        addChild(menuNode)    // child 1 of the scene is always the MENU
        
        // Create a few test bodies
        
        let box = SKSpriteNode(color: UIColor.blueColor(), size: CGSize(width: 200, height: 100))
        box.position = CGPoint(x: 10, y: 80)
        let boxBody = SKPhysicsBody(rectangleOfSize: box.size)
        boxBody.dynamic = true
        boxBody.mass = 1
        boxBody.linearDamping = 0
        boxBody.angularDamping = 0
        boxBody.restitution = 1
        boxBody.friction = 0
        box.physicsBody = boxBody
        worldNode.addChild(box)
        

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
        worldNode.addChild(ball)

        // Create the TERRAIN

        worldNode.addChild(createBoundary())

        //------------
        // menu
        
        menuNode.add(Menu("first menu", { (x:SKNode) in println("test") }))
        
        menuNode.add("test2")
        menuNode.add("a test3")
        menuNode.add("this is a very long title to see how crazy it can be.")
    
        dumpNodes()

        // Create the touch collector. This is a utility to manage all the touches and
        // send high level event indicators to the touch client.
        // The touch client performs actions based on the touches.
        
        touchCollector = TouchCollector(TouchClient(self))
        
    }
    

    // Utility to dump out scene graph for debugging
    func dumpNodes() {
        dumpNode(self, "")
    }
    
    func dumpNode(node: SKNode?, _ prefix: String) {
        if let nn = node {
            println(prefix + "\(nn.dynamicType) nc=\(nn.children.count) pos=\(nn.position)")
            for xx in nn.children {
                dumpNode(xx as? SKNode, prefix + " _ ")
            }
        }
        else {
            println(prefix + "nil")
        }
    }
    
    
    // Create a node that represents the boundary of the world. It could be a single
    // path node, or a heirarchy of non-dynamic shape nodes
    func createBoundary() -> SKNode {
        return createBoundaryPath()
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

    // Low level touch callbacks.  NOTE I decided not to use gestures because I want to be able
    // to seamlessly morph actions like pan,rotate,zoom into a single action.  For example you can 
    // use a single touch to start dragging a body, and then add another touch to rotate it, and then
    // pull the fingers apart to scale it, all in a single gesture.
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for t in touches {
            if let touch = t as? UITouch {
                touchCollector.begin(touch)
            }
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for t in touches {
            if let touch = t as? UITouch {
                touchCollector.move(touch)
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for t in touches {
            if let touch = t as? UITouch {
                touchCollector.end(touch)
            }
        }
    }
    
    override func touchesCancelled(touches: Set<NSObject>, withEvent event: UIEvent) {
        for t in touches {
            if let touch = t as? UITouch {
                touchCollector.cancel(touch)
            }
        }
    }
    
    /*
    Called before each frame is rendered
    */
    override func update(currentTime: CFTimeInterval) {
        touchCollector.update()
    }
    
}










































