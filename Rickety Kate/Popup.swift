//
//  Popup.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 24/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

// Popup screen for user input
class Popup: SKSpriteNode {
    
    var gameScene : GameScene? = nil
    var button =  SKSpriteNode(imageNamed:"Exit")
    
    
    init()
    {
        super.init(texture: nil, color: UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9), size:  CGSize(width: 1, height: 1))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}