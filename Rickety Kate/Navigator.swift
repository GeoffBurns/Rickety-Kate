//
//  Navigator.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 2/10/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit


class Navigate {
    
   

    static func setupRulesButton(scene:SKNode)
    {
   
        let rulesButton = PopupButton(imageNamed:"Rules1".symbol, altNamed:"",popup:RuleScreen())
        rulesButton.setScale(ButtonSize.Small.scale)
        rulesButton.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        rulesButton.position = CGPoint(x:0.0,y:scene.frame.size.height * 0.95)
        scene.addChild(rulesButton)
    }
    static func setupOptionButton(scene:SKNode)
    {
        let optionsButton = PopupButton(imageNamed:"Options1".symbol, altNamed:"",popup:OptionScreen())
        optionsButton.setScale(ButtonSize.Small.scale)
        optionsButton.anchorPoint = CGPoint(x: 1.0,  y: 1.0)
        optionsButton.position = CGPoint(x:scene.frame.size.width,y:scene.frame.size.height * 0.95)
        scene.addChild(optionsButton)
    }
    static func setupExitButton(scene:SKNode)
    {
        let exitButton = PopupButton(imageNamed:"Exit".symbol, altNamed:"X",popup:ExitScreen())
        exitButton.setScale(ButtonSize.Small.scale)
        exitButton.anchorPoint = CGPoint(x: 1.0,  y: 1.0)
        exitButton.position = CGPoint(x:scene.frame.size.width,y:scene.frame.size.height * 0.95)
        scene.addChild(exitButton)
    }
    
}
