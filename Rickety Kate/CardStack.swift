//
//  CardStack.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 30/10/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

/// How the cards are displayed in a stack
/// Only certain cards are accepted on the stack
/// Used in Sevens and Penalty Games
typealias ValidNextCardCalculator = (PlayingCard) -> Set<PlayingCard>

class CardStack : CardPile
{
    
    var baseCard : PlayingCard? = nil  { didSet { updateBase() } }
    
    var baseSprite : CardSprite? { if baseCard == nil {return nil}; return scene!.whiteCardSprite(baseCard!) }
    
    var validNextCardCalculator : ValidNextCardCalculator = {
        lastCard in
        let nextcards = GameSettings.sharedInstance.deck?.orderedDeck
            .filter { $0.suite == lastCard.suite && $0.value > lastCard.value }
            .sort {$0.value < $1.value}
        
        return Set<PlayingCard>([nextcards!.first!])
    }
    
    func updateBase()
    {
        if let sprite = baseSprite
        {
            sprite.fan = self
            
            if (sprite.state != CardState.AtRest)
            {
                sprite.zPosition = 140
                sprite.state = CardState.AtRest
            }
            
            
            sprite.positionInSpread = 0
            
            // PlayerOne's cards are larger
            let newScale =  sizeOfCards.scale
            
            let newHeight = newScale * sprite.size.height / sprite.yScale
            sprite.updateAnchorPoint(cardAnchorPoint)
            sprite.color = UIColor.whiteColor()
            sprite.colorBlendFactor = 0
            
            
            sprite.position =  positionOfCard(0, spriteHeight: newHeight, fullHand:fullHand)
            
            sprite.zRotation = rotationOfCard(0, fullHand:fullHand)
            sprite.setScale(sizeOfCards.scale)
            
        }
    }
}