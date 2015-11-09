//
//  RuleScreen.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 20/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

// Help Screen
class RuleScreen: Popup {
    
    var rulesText : SKMultilineLabel? = nil


    override func setup(scene:SKNode)
    {
        self.gameScene = scene
        color = UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9)
        size = scene.frame.size
        position = CGPointZero
        anchorPoint = CGPointZero
        let fontsize : CGFloat = FontSize.Medium.scale
        let leading : Int = Int(FontSize.Medium.scale)
        
        rulesText  = SKMultilineLabel(text: GameSettings.sharedInstance.rules.description, labelWidth: Int(scene.frame.width * 0.88), pos: CGPoint(x:CGRectGetMidX(scene.frame),y:scene.frame.size.height*0.8),fontSize:fontsize,fontColor:UIColor.whiteColor(),leading:leading)
      
        name = "Rules Background"
  
        self.addChild(rulesText!)
   
        rulesText!.name = "RulesText"
        rulesText!.userInteractionEnabled = false
 
        
        Navigate.setupCardDisplayButton(self)

    }
}
