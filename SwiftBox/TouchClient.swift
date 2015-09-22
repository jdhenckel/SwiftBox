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
    let prompt: SKLabelNode
    var targetBody: SKNode?
    var targetMenu: SKLabelNode?
    var mode: String
    var sticky: Bool
    
    // Mode constants
    let HOME = "home"
    let NAV = "nav"
    let DRAG = "drag"
    
    init(menu: SKNode, world: SKNode, prompt: SKLabelNode) {
        menuRoot = menu
        worldRoot = world
        self.prompt = prompt
        targetMenu = nil
        targetBody = nil
        mode = HOME
        sticky = false
    }

    /*  
    This is called when a touch (or multi-touch) remains idle for a certain
    period of time. 
    */
    func longTouch(tc: TouchCollector) {
        print("@ long touch \(mode) ")
        
        if mode == NAV {
            println("menu \(targetMenu!.text)")
        }
        else if mode == DRAG {
            println("body \(targetBody!.dynamicType)")
        }
        else if mode == "box" {
            println()
        }
        else {
            println()
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
            if let node = findMenu(tc.touches[0]) {
                setTargetMenu(node)
                mode = NAV
                // TODO - double tap for sticky? or long tap?
                return
            }
            mode = DRAG
            if let node = findBody(tc.touches[0]) {
                targetBody = node
                return
            }
            targetBody = nil
            targetMenu = nil
            println("nil")
        }
        else if mode == DRAG || mode == NAV {
            println("this should never happen ??!!?")
        }
        else if mode == "box" {
            // TODO -- create a box
            println("create a box")
        }
    }
    

    /*
    This is called when something changes (other than begin or end). For instance if a
    touch is moved, or another touch is added, or a touch (not the 0th) is removed.
    When the 0th touch is removed, this function is NOT called. The 'end' is called instead.
    */
    func changeTouch(tc: TouchCollector) {
        
        if mode == NAV {
            print("change menu ")
            if let node = findMenu(tc.touches[0]) {
                setTargetMenu(node)
                return
            }
            println("nil")
            targetMenu!.brighten(false)
            return
        }
        else if mode == DRAG {

            print("change touch \(tc.touches.count) mode=\(mode) ")

            
            
            if targetBody == nil {
                println("nil")
            }
            else if let node = targetBody {
                println("body \(node.dynamicType)")
            }
            else {
                println("unknown?!?")
            }
        }
        else {
            println("change touch unhandled mode \(mode)")
        }
    }
    
    /*
    This is called when the main touch, the 0th touch, is ending.
    */
    func endFirstTouch(tc: TouchCollector) {
        print("** end touch \(mode) ")
        if mode == NAV {
            if let label = targetMenu {
                mode = label.text
                println(" => \(label.text)")
                menuRoot.setTreeHidden()
                prompt.text = "Mode: " + mode
                prompt.setHide(false)
                return
            }
            println(" => nil")
        }
        else if let node = targetBody {
            println("body \(node.dynamicType)")
        }
        else {
            println("nil")
        }
        tc.clear()
        targetMenu = nil
        mode = HOME
        menuRoot.setTreeHidden()
        prompt.setHide(true)
    }
    
    
    private func findBody(touch: UITouch) -> SKNode? {
        let pos = touch.locationInNode(worldRoot)
        for hit in worldRoot.nodesAtPoint(pos) {
            // TODO - sort by z order?
            if let node = hit as? SKNode {
                println("found body \(node.dynamicType)")
                return node
            }
        }
        return nil
    }
    
    private func findMenu(touch: UITouch) -> SKLabelNode? {
        let pos = touch.locationInNode(menuRoot)
        for hit in menuRoot.nodesAtPoint(pos) {
            if let shape = hit as? SKShapeNode {
                if !shape.hidden || shape.parent?.parent == menuRoot {
                    if let node = shape.parent as? SKLabelNode {
                        println("found menu \(node.text)")
                        return node
                    }
                }
            }
        }
        return nil
    }
    
    
    private func setTargetMenu(t: SKLabelNode?) {
        if targetMenu === t { return }
        menuRoot.setTreeHidden()
        targetMenu = t
        if let newTarget = t {
            newTarget.setLineageVisible()
            newTarget.brighten()
        }
    }
        
    

}
