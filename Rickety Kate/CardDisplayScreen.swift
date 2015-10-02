//
//  CardDisplayScreen.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 2/10/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

// Help Screen
class CardDisplayScreen: Popup {
    

    var moreButton =  SKSpriteNode(imageNamed:"More1")
    var bottomSlide = CardSlide(name: "bottomSlide")
    lazy var deck: Deck = PlayingCard.BuiltCardDeck()
    var topSlide = CardSlide(name: "topSlide")
    
    override func setup(scene:SKNode)
    {
        self.gameScene = scene
        color = UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9)
        size = scene.frame.size
        position = CGPointZero
        anchorPoint = CGPointZero

        
   
       /*
        moreButton.setScale(0.5)
        moreButton.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        moreButton.position = CGPoint(x:self.frame.size.width,y:0.0)
        
        moreButton.name = "More"
        
        moreButton.zPosition = 300
        moreButton.userInteractionEnabled = false
        
        self.addChild(moreButton)
*/
    }
}
