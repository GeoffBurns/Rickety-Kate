//
//  LabelWithFadeInAndOut.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 7/10/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//
import SpriteKit

class LabelWithFadeInAndOut : SKLabelNode
{
    
    override var text : String? { didSet { fadeInOut()}}
    
    
    
    
    /////////////////////////////////////////////////////
    /// Constructors
    /////////////////////////////////////////////////////
    
    override init()
    {
        
        super.init()
        
    }
    override init(fontNamed fontName: String!)
    {
        
        super.init(fontNamed:fontName)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fadeInOut()
    {
        removeAllActions()
        
        alpha = 1.0
        if text != ""
        {
            let action = SKAction.repeatActionForever(
                SKAction.sequence([
                    SKAction.fadeOutWithDuration(6),
                    SKAction.waitForDuration(10),
                    SKAction.fadeInWithDuration(4),
                    SKAction.waitForDuration(5),
                    ] )
            )
            
            runAction(action)
        }
    }
    func resetToScene(scene:SKNode)
    {
        if parent != nil
        {
            removeFromParent()
        }
        text = ""
        scene.addChild(self)
    }

}


