//
//  Navigator.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 2/10/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit


class Navigate {
    
   
    static func setupCardDisplayButton(scene:SKNode)
    {
        let cardDisplayButton = PopupButton(imageNamed:"More1", altNamed:"Rules1",popup:CardDisplayScreen())
        cardDisplayButton.setScale(0.5)
        cardDisplayButton.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        cardDisplayButton.position = CGPoint(x:scene.frame.size.width,y:0.0)
        scene.addChild(cardDisplayButton)
    }
    static func setupRulesButton(scene:SKNode)
    {
   
        let rulesButton = PopupButton(imageNamed:"Rules1", altNamed:"X",popup:RuleScreen())
        rulesButton.setScale(0.5)
        rulesButton.anchorPoint = CGPoint(x: 0.0, y: GameSettings.isPad ? 1.6 : 2.2)
        rulesButton.position = CGPoint(x:0.0,y:scene.frame.size.height * (GameSettings.isPad ?  1.06 :  1.0))
        scene.addChild(rulesButton)
    }
    static func setupOptionButton(scene:SKNode)
    {
        let optionsButton = PopupButton(imageNamed:"Options1", altNamed:"X",popup:OptionScreen())
        optionsButton.setScale(0.5)
        optionsButton.anchorPoint = CGPoint(x: 1.0, y: GameSettings.isPad ? 1.6 : 2.2)
        optionsButton.position = CGPoint(x:scene.frame.size.width,y:scene.frame.size.height * (GameSettings.isPad ?  1.06 :  1.0))
        scene.addChild(optionsButton)
    }
    static func setupExitButton(scene:SKNode)
    {
        let exitButton = PopupButton(imageNamed:"Exit", altNamed:"X",popup:ExitScreen())
        exitButton.setScale(0.5)
        exitButton.anchorPoint = CGPoint(x: 1.0, y: GameSettings.isPad ? 1.6 : 2.2)
        exitButton.position = CGPoint(x:scene.frame.size.width,y:scene.frame.size.height * (GameSettings.isPad ?  1.06 :  1.0))
        scene.addChild(exitButton)
    }
    
}
