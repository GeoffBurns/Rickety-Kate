//
//  PopupButton.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 2/10/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

class PopupButton : SKSpriteNode
{
    var popupScene : Popup? = nil
    var unpressed = ""
    var pressed = ""
    
    init(imageNamed: String, altNamed: String, popup:Popup)
    {
       unpressed = imageNamed
       pressed = altNamed
       popupScene = popup
 
        let texture =  SKTexture(imageNamed: unpressed)
        super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size())
        self.name = imageNamed
        userInteractionEnabled = true
        popupScene?.button = self
        zPosition = 350
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    func press()
    {
        popupScene!.setup(self.parent!)
        popupScene!.zPosition = 400
        self.parent?.addChild(popupScene!)
        self.texture =  SKTexture(imageNamed: pressed)
        popupScene!.onEnter()
        zPosition = 450
    }
    func unpress()
    {
        zPosition = 350
        popupScene!.onExit()
        self.texture =  SKTexture(imageNamed: unpressed)
        popupScene?.removeFromParent()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        
        if popupScene!.parent == nil
        {
            press()
        }
        else
        {
            unpress()
        }
        
    }

}
