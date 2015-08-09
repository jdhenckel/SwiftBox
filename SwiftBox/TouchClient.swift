//
//  TouchClient.swift
//  SwiftBox
//
//  Created by John Henckel on 8/9/15.
//  Copyright (c) 2015 John Henckel. All rights reserved.
//

import SpriteKit

class TouchClient {

    var scene: SKScene
    var target: SKNode?
    
    init(_ scene: SKScene) {
        self.scene = scene
        target = nil
    }

    /*  
    This is called when a touch (or multi-touch) remains idle for a certain
    period of time. 
    */
    func longTouch(tc: TouchCollector) {
        print("@ long touch ")
        if target == nil {
            println("nil")
        }
        else if let label = target as? SKLabelNode {
            println("menu \(label.text)")
        }
        else if let node = target {
            println("body \(node.dynamicType)")
        }
        else {
            println("unknown?!?")
        }
    }
    
    /*
    This is called whenever the touch count goes from 0 to 1. by the time this is 
    called, the touch count might be greater than 1. But the 0th touch is always
    the first one, and that it the one we use for determining the target.
    The target can be a menu or a body.
    */
    func beginFirstTouch(tc: TouchCollector) {
        let tap = tc.touches[0].tapCount
        print("*begin touch \(tap) ")
        if let menuRoot = scene.children[1] as? SKNode {
            let menuPos = tc.touches[0].locationInNode(menuRoot)
            let hits = menuRoot.nodesAtPoint(menuPos)
            for hit in hits {
                if let node = hit as? SKLabelNode {
                    println("menu \(node.text)")
                    target = node
                    return
                }
            }
        }
        if let worldRoot = scene.children[0] as? SKNode {
            let worldPos = tc.touches[0].locationInNode(worldRoot)
            let hits = worldRoot.nodesAtPoint(worldPos)
            for hit in hits {
                if let node = hit as? SKNode {
                    println("body \(node.dynamicType)")
                    target = node
                    return
                }
            }
        }
        println("nil")
    }

    /*
    This is called when something changes (other than begin or end). For instance if a 
    touch is moved, or another touch is added, or a touch (not the 0th) is removed.
    When the 0th touch is removed, this function is NOT called. The 'end' is called instead.
    */
    func changeTouch(tc: TouchCollector) {
        print("change touch \(tc.touches.count) ")
        if target == nil {
            println("nil")
        }
        else if let label = target as? SKLabelNode {
            println("menu \(label.text)")
        }
        else if let node = target {
            println("body \(node.dynamicType)")
        }
        else {
            println("unknown?!?")
        }
    }
    
    /*
    This is called when the main touch, the 0th touch, is about to end.
    */
    func endFirstTouch(tc: TouchCollector) {
        print("** end touch ")
        if target == nil {
            println("nil")
        }
        else if let label = target as? SKLabelNode {
            println("menu \(label.text)")
        }
        else if let node = target {
            println("body \(node.dynamicType)")
        }
        else {
            println("unknown?!?")
        }
        tc.clear()
        target = nil
    }


}
