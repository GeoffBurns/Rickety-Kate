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
    var isShowing = false

    override init()
    {
        
        super.init()
        button =  SKSpriteNode(imageNamed:"Rules1")
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flipButton()
    {
    if(isShowing)
    {
    button.texture = SKTexture(imageNamed: "Rules1")
    alpha = 0.0
    zPosition = -10
    button.zPosition = 300
    isShowing = false
    }
    else
    {
    button.texture = SKTexture(imageNamed: "X")
    alpha = 1.0
    zPosition = 400
    button.zPosition = 450
    isShowing = true
    }
    }
    
    func  setup(scene:GameScene)
    {
        self.gameScene = scene
        color = UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9)
        size = scene.frame.size
        position = CGPoint(x:CGRectGetMidX(scene.frame),y:CGRectGetMidY(scene.frame))
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        rulesText  = SKMultilineLabel(text: "Rickety Kate is a trick taking card game. This means every player tosses in a card and the player with the highest card in the same suite as the first card wins the trick and the cards. But wait! the person with the lowest running score wins. So winning a trick is not necessarially good.  The Queen of Spades (Rickety Kate) is worth 10 points against you and the other spades are worth 1 point against you. When you run out of cards you are dealt another hand. If you obtain all the spades in a hand it is called 'Shooting the Moon' and your score drops to zero. At the beginning of each hand the player pass their three worst cards to their neighbour. Aces and King are the worst cards.", labelWidth: Int(scene.frame.width * 0.88), pos: CGPoint(x:0.0,y:scene.frame.size.height*0.3),fontSize:30,fontColor:UIColor.whiteColor(),leading:40)
      
        name = "Rules Background"
        zPosition = -10
        
        self.addChild(rulesText!)
        alpha = 0.0
        
        rulesText!.name = "Rules text"
        rulesText!.userInteractionEnabled = false
  
    
        button.setScale(0.5)
        button.anchorPoint = CGPoint(x: 0.0,
            y:
            UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad ?
                1.6 :
            2.2)
        button.position = CGPoint(x:0.0,y:self.frame.size.height)
        
        button.name = "Rules"
        
        button.zPosition = 300
        button.userInteractionEnabled = false
        
        scene.addChild(button)
        scene.addChild(self)
        
    }
}
