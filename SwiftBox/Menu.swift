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
    
    var name: String
    var callback: (SKNode) -> ()
    
    init(_ name: String, _ callback: (SKNode) -> ()) {
        self.name = name
        self.callback = callback
    }
    
    
    static func invert(node: SKLabelNode?) {
        if let labelNode = node  {
            if let shape = labelNode.children[0] as? SKShapeNode {
                let temp = shape.fillColor
                if let color = labelNode.color {
                    shape.fillColor = color
                    labelNode.color = temp
                }
            }
        }
    }
    
    static func appendValue(node: SKLabelNode) {
        var tx = node.text
        let pair = tx.componentsSeparatedByString(":")
        if pair.count == 2 {
            tx = pair[0]
        }
        if let val: AnyObject = node.userData?.valueForKey("value") {
            node.text = tx + ": " + val.description
        }
    }
    

}

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
    
    
    func add(menu: Menu) -> SKLabelNode {
        let labelNode = add(menu.name)
        labelNode.userData = NSMutableDictionary(capacity: 1)
        labelNode.userData?.setValue(menu, forKey: "menu")
        return labelNode
    }    
}

