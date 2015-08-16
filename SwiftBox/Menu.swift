//
//  Menu.swift
//  SwiftBox
//
//  Created by John Henckel on 8/3/15.
//  Copyright (c) 2015 John Henckel. All rights reserved.
//

import SpriteKit


// The menu is a tree of label nodes, child[0] of each is a shape node.
// and child[1] is a node with a list of descendants

// Pretty good fonts (iosfonts.com)
// *ArialMT, **ChalkboardSE-Regular, *DevanagariSangamMN, *Kailasa, *Palatino-Roman, **Verdana, Zapfino
//"*Courier" // "*Chalkduster"
//

class Menu {
    
    static let font = "ChalkboardSE-Regular"
    static let fontSize = 14 as CGFloat
    
    /*
    Note: the first parameter to callback is the label node.  The second parameter is the
    recent movement of the second touch, or nil if the first touch is ending.
    */
//    var name: String
//    var callback: (SKNode, UITouch) -> ()
//    
//    init(_ name: String, _ callback: (SKNode, UITouch) -> ()) {
//        self.name = name
//        self.callback = callback
//    }
    

}

extension SKLabelNode {
    
    func invert() {
        if let shape = children[1] as? SKShapeNode {
            let temp = shape.fillColor
            if let mycolor = color {
                shape.fillColor = mycolor
                color = temp
            }
        }
    }
    
//    func invokeCallback(touch: UITouch) {
//        if let menu = userData?.valueForKey("menu") as? Menu {
//            menu.callback(self, touch)
//        }
//        else {
//            
//            if children.count > 2 {
//                // toggle hidden submenu
//                // hide siblings
//            }
//        }
//    }

    
    func addSubmenu() -> SKNode {
        let sub = SKNode()
        sub.hidden = true
        addChild(sub)
        return sub
    }

    // Expand (unhide) the submenu of self (and hide menus of all siblings)
    func expand() {
        if let p = parent {
            for n in p.children {
                if let label = n as? SKLabelNode {
                    label.showSubmenu(label === self)
                }
            }
        }
    }
    
    // Contract the submenu (set hidden = true)
    func showSubmenu(val: Bool) {
        if children.count == 3 {
            if let root = children[2] as? SKNode {
                root.hidden = val
            }
        }
    }

    
    func prefix() -> String {
        let pair = text.componentsSeparatedByString(":")
        if pair.count == 2 {
            return pair[0]
        }
        return text
    }
    
    
    func appendValue(value: String) {
        text = prefix() + ": " + value
    }
    
    
}

/*
These extensions are so you can make menus. The root of the menu is a regular SKNode
*/
extension SKNode {
    
    func add(name: String) -> SKLabelNode {
        let nameLen = CGFloat(name.lengthOfBytesUsingEncoding(name.smallestEncoding))
        let boxWidth = nameLen * Menu.fontSize * 0.6
        let boxHeight = Menu.fontSize * 1.4
        let shapeNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: boxWidth, height: boxHeight), cornerRadius: Menu.fontSize/3)
        shapeNode.position = CGPoint(x: Menu.fontSize * -0.5, y: Menu.fontSize * -0.2)
        shapeNode.fillColor = UIColor.blackColor()
        let labelNode = SKLabelNode(fontNamed:Menu.font)
        labelNode.color = UIColor.whiteColor()
        labelNode.text = name as String
        labelNode.fontSize = Menu.fontSize
        labelNode.verticalAlignmentMode = .Bottom
        labelNode.horizontalAlignmentMode = .Left
        labelNode.position = CGPoint(x: position.x,
            y: position.y - CGFloat(children.count) * CGFloat(boxHeight * 1.2))
        labelNode.addChild(shapeNode)
        addChild(labelNode)
        return labelNode
    }
    
    
//    func add(menu: Menu) -> SKLabelNode {
//        let labelNode = add(menu.name)
//        labelNode.userData = NSMutableDictionary(capacity: 1)
//        labelNode.userData?.setValue(menu, forKey: "menu")
//        return labelNode
//    }
    
}

