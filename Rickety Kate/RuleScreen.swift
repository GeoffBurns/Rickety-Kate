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
        let fontsize : CGFloat = GameSettings.isPad ?  24 : (GameSettings.isPhone6Plus ? 42 : 28)
        let leading : Int = GameSettings.isPad ?  32 : (GameSettings.isPhone6Plus ? 55 : 38)
        
        rulesText  = SKMultilineLabel(text: "Rickety Kate is a trick taking card game. This means every player tosses in a card and the player with the highest card in the same suite as the first card wins the trick and the cards. But wait! the person with the lowest running score wins. So winning a trick is not necessarially good.  The Queen of Spades (Rickety Kate) is worth 10 points against you and the other spades are worth 1 point against you. When you run out of cards you are dealt another hand. If you obtain all the spades in a hand it is called 'Shooting the Moon' and your score drops to zero. At the beginning of each hand the player pass their three worst cards to their neighbour. Aces and King are the worst cards.", labelWidth: Int(scene.frame.width * 0.88), pos: CGPoint(x:CGRectGetMidX(scene.frame),y:scene.frame.size.height*0.8),fontSize:fontsize,fontColor:UIColor.whiteColor(),leading:leading)
      
        name = "Rules Background"
  
        self.addChild(rulesText!)
   
        rulesText!.name = "RulesText"
        rulesText!.userInteractionEnabled = false
 
        
        Navigate.setupCardDisplayButton(self)

    }
}
