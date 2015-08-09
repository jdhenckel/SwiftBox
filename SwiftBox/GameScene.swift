//
//  GameScene.swift
//  SwiftBox
//
//  Created by John Henckel on 7/18/15.
//  Copyright (c) 2015 John Henckel. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // A list of up to 5 touch objects. The oldest touch is always the first in the array.
    var touchList: [Touch] = []

    // All nodes with physicsBody are under this node.
    var worldNode: SKNode!
    
    // All menu nodes are beneath this node
    var menuNode: SKNode!
    
    var touchState: UIGestureRecognizerState = .Possible
    enum TouchTarget { case None, Menu, Body, Joint, World }
    var touchTarget = TouchTarget.None
    var touchLabel: SKLabelNode?
    var touchNode: SKNode?
    
    
    override func didMoveToView(view: SKView) {
        
        /* detect gestures */
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
//        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "handleLongPress:"))
 //       view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePan:"))
//        view.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: "handleRotate:"))
        
        /* Setup your scene here */
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        
//        let worldFrame =
        worldNode = SKNode()
            //SKSpriteNode(color: UIColor.blackColor(), size: self.frame.size)
        worldNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(worldNode)
        
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

        worldNode.addChild(createBoundary())

        //------------
        // menu
        menuNode = SKNode()
        menuNode.position = CGPoint(x: Menu.fontSize / 2, y: frame.height / 2 - Menu.fontSize * 1.2)
        addChild(menuNode)
        
        menuNode.add(Menu("first menu", { (x:SKNode) in println("test") }))
        
        menuNode.add("test2")
        menuNode.add("a test3")
        menuNode.add("this test4")
        
        
//        let edgeBody = SKPhysicsBody(edgeLoopFromRect: worldFrame)
//        edgeBody.dynamic = false
//        edgeBody.restitution = 1
//        edgeBody.friction = 0
//        let edge = SKNode()
//        edge.physicsBody = edgeBody
//        world.addChild(edge)
        
        
//        /* build the menu here */
//        let myLabel = SKLabelNode(fontNamed:"Courier")
//        myLabel.text = "Hello, World!"
//        myLabel.fontSize = 10;
//        myLabel.position = worldNode.position
//   //     addChild(myLabel)
//        ;
//        if true    {
//            /* build the menu here */
//            let myLabel = SKLabelNode(fontNamed:"Times")
//            myLabel.text = "Gravity: 9.8527 m/s"
//            myLabel.fontSize = 10
//            myLabel.position = worldNode.position + CGPoint(x: 0,y: 20)
//          //  addChild(myLabel)
//        }
//        
//        if true    {
//            /* build the menu here */
//            
//            let myLabel = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 1, height: 1), cornerRadius: 0)
//            myLabel.position = worldNode.position + CGPoint(x: 0,y: 0)
//            addChild(myLabel)
//        }
//        if true    {
//            /* build the menu here */
//            let t = "This is jaypkq: 1.234 m/s"
//            let n = CGFloat(t.lengthOfBytesUsingEncoding(t.smallestEncoding))
//            println(n)
//            let w = n * fontSize * fontWidthFactor
//            let h = fontSize * 1.4
////            let top = SKSpriteNode(color: UIColor.brownColor(), size: CGSize(width: 100,height: 10))
//            let top = SKShapeNode(rect: CGRect(x: 0, y: 0, width: w, height: h), cornerRadius: fontSize/3)
//            let myLabel = SKLabelNode(fontNamed:font)
//            myLabel.text = t
//            myLabel.fontSize = fontSize
//            myLabel.verticalAlignmentMode = .Bottom
//            myLabel.horizontalAlignmentMode = .Left
//            myLabel.position = worldNode.position + CGPoint(x: 0,y: 0)
//            myLabel.addChild(top)
//            addChild(myLabel)
//        }
//        

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

    
    func handleTap(sender:UITapGestureRecognizer) {
        let box = worldNode.children[0] as! SKNode
        box.physicsBody?.applyAngularImpulse(1)
    }
    
    
    func handleLongPress(sender:UILongPressGestureRecognizer) {
        println("begin long press")
        
    }
    
    func handleRotation(sender:UIRotationGestureRecognizer) {
        println("begin rotation")
        
    }
    
    
    
    func handlePan(sender:UIPanGestureRecognizer) {
        struct Save {
            static var node: SKNode? = nil
            static var pos = CGPointZero
        }
        var pos = convertPointFromView(sender.locationInView(self.view!))
        switch sender.state {
        case .Began:
            Save.node = worldNode
            Save.pos = pos
            let posInWorld = worldNode.convertPoint(pos, fromNode: self)
            for i in 0...worldNode.children.count-1 {
                if worldNode.children[i].containsPoint(posInWorld) {
                    Save.node = worldNode.children[i] as? SKNode
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for t in touches {
            if let touch = t as? UITouch {
                let pos = convertPointFromView(touch.locationInView(self.view!))
                touchList.append(Touch(uit: touch, pos: pos))
                if touchList.count == 1 {
                    touchState = .Began
                }
            }
        }
    }

    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for t in touches {
            if let touch = t as? UITouch {
                let pos = convertPointFromView(touch.locationInView(self.view!))
                for (i, item) in enumerate(touchList) {
                    if item.touch == touch {
                        item.endPos = pos
                        item.moveCount += 1
                        touchState = .Changed
                        break
                    }
                }
            }
        }
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for t in touches {
            if let touch = t as? UITouch {
                for (i, item) in enumerate(touchList) {
                    if item.touch == touch {
                        if i == 0 {
                            touchState = .Ended
                        }
                        else {
                            touchList.removeAtIndex(i)
                        }
                        break
                    }
                }
            }
        }
    }
    
    override func touchesCancelled(touches: Set<NSObject>, withEvent event: UIEvent) {
        // handle cancel the same as end
        touchesEnded(touches, withEvent: event)
    }
    
    /*
    Called before each frame is rendered
    */
    override func update(currentTime: CFTimeInterval) {
        for (i, item) in enumerate(touchList) {
            item.update(currentTime)
        }
    
        if touchState == .Began {
            // Test new touch type: world, menu, joint or body
            print("begin touch ")
            let pos = touchList[0].startPos
            if let label = menuNode.find(pos) {
                touchTarget = .Menu
                Menu.invert(label)
            }
            else {
                let posInWorld = worldNode.convertPoint(pos, fromNode: self)
                for (i, node) in enumerate(worldNode.children) {
                    if let shape = node as? SKNode {
                        touchNode = shape
                        shape.physicsBody!.dynamic = false
                        touchTarget = .Body
                        break
                    }
                }
            }
        }
        else if touchState == .Possible && touchList.count > 0 {
            // Test long press
        }
        else if touchState == .Changed {
            
        }
        else if touchState == .Ended {
            
            touchList.removeAll(keepCapacity: true)
        }
        
        // Reset the event type flag
        touchState = .Possible

        
    }
}










































