//
//  Navigator.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 2/10/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit


class Navigate {
    
   

    static func setupRulesButton(_ scene:SKNode)
    {
 
        let rulesButton = PopupButton(imageNamed:"Rules1", altNamed:"",popup:RuleScreen())
        rulesButton.setScale(ButtonSize.small.scale)
        rulesButton.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        scene.addChild(rulesButton)
    }
    static func setupOptionButton(_ scene:SKNode)
    {
   
        let optionsButton = PopupButton(imageNamed:"Options1", altNamed:"",popup:OptionScreen())
        optionsButton.setScale(ButtonSize.small.scale)
        optionsButton.anchorPoint = CGPoint(x: 1.0,  y: 1.0)
        scene.addChild(optionsButton)
    }
    static func setupExitButton(_ scene:SKNode)
    {
        let exitButton = PopupButton(imageNamed:"Exit", altNamed:"X",popup:ExitScreen())
        exitButton.setScale(ButtonSize.small.scale)
        exitButton.anchorPoint = CGPoint(x: 1.0,  y: 1.0)
        scene.addChild(exitButton)
    }
    
}
