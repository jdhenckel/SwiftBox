//
//  TouchClient.swift
//  SwiftBox
//
//  Created by John Henckel on 8/9/15.
//  Copyright (c) 2015 John Henckel. All rights reserved.
//

import SpriteKit

class TouchClient {

//    var scene: SKScene
    let menuRoot: SKNode
    let worldRoot: SKNode
    var target: SKNode?
    var mode: String
    var sticky: Bool
    let HOME = "home"
    let NAV = "nav"
    let DRAG = "drag"
    
    init(menu: SKNode, world: SKNode) {
        menuRoot = menu
        worldRoot = world
        target = nil
        mode = HOME
        sticky = false
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
        print("*begin touch \(tap) \(mode) ")
        
        if mode == HOME {
            for hit in menuRoot.nodesAtPoint(tc.touches[0].locationInNode(menuRoot)) {
                if let node = hit as? SKLabelNode {
                    println("menu \(node.text)")
                    setTargetMenu(node)
                    mode = NAV
                    // TODO - double tap for sticky? or long tap?
                    return
                }
            }
        }

        mode = DRAG
        for hit in worldRoot.nodesAtPoint(tc.touches[0].locationInNode(worldRoot)) {
            // TODO - sort by z order?
            if let node = hit as? SKNode {
                println("body \(node.dynamicType)")
                target = node
                return
            }
        }
        target = nil
        println("nil")
    }
    
    
    private func setTargetMenu(t: SKNode?) {
        if target === t { return }
        if let prevNode = target as? SKLabelNode {
            prevNode.invert()
        }
        if let newNode = t as? SKLabelNode {
            newNode.invert()
        }
        target = t
    }
    

    /*
    This is called when something changes (other than begin or end). For instance if a
    touch is moved, or another touch is added, or a touch (not the 0th) is removed.
    When the 0th touch is removed, this function is NOT called. The 'end' is called instead.
    */
    func changeTouch(tc: TouchCollector) {
        
        if (mode == NAV) {
            for hit in menuRoot.nodesAtPoint(tc.touches[0].locationInNode(menuRoot)) {
                if let node = hit as? SKLabelNode {
                    if target !== node { println("change menu \(node.text)") }
                    setTargetMenu(node)
                    return
                }
            }
            if target != nil { println("change menu nil") }
            setTargetMenu(nil)
            return
        }
        else if mode == DRAG {

            print("change touch \(tc.touches.count) mode=\(mode) ")

            
            
            if target == nil {
                println("nil")
            }
            else if let node = target {
                println("body \(node.dynamicType)")
            }
            else {
                println("unknown?!?")
            }
        }
    }
    
    /*
    This is called when the main touch, the 0th touch, is about to end.
    */
    func endFirstTouch(tc: TouchCollector) {
        print("** end touch \(mode) ")
        if mode == NAV {
            if let label = target as? SKLabelNode {
                mode = label.text
                println(" => \(label.text)")
                return
            }
        }
        else if let node = target {
            println("body \(node.dynamicType)")
        }
        else {
            println("unknown?!?")
        }
        tc.clear()
        target = nil
        mode = HOME
    }


}
