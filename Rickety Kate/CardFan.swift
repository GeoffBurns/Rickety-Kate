//
//  CardFan.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 21/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

/// How the cards are displayed in a fan
/// Cards positions need to be calculated more frequently in a fan as opposed to a pile
class CardFan : CardPile
{
    
     static let fanAnchorPoint = CGPoint(x: 0.5,y: -0.7)
     override var cardAnchorPoint : CGPoint { get { return CardFan.fanAnchorPoint }}
    
    
    func setup(scene:HasDiscardArea, sideOfTable: SideOfTable, isUp: Bool, sizeOfCards: CardSize = CardSize.Small)
    {
        self.discardAreas = scene
        self.scene = scene as? SKNode
        self.sideOfTable = sideOfTable
        self.isUp = isUp
        self.sizeOfCards = sizeOfCards
        self.direction = sideOfTable.direction
        self.zPositon = self.sizeOfCards.zOrder
        tableSize = self.scene!.frame.size
    }

    
    override func append(card:PlayingCard)
    {
        var updatedCards = cards
        updatedCards.append(card)
        let sortedHand = updatedCards.sort()
        cards = ( Array(sortedHand.reverse()))
    }
    override func update()
    {
       rearrange()
    }
    override func positionOfCard(positionInSpread:CGFloat, spriteHeight:CGFloat,fullHand:CGFloat) -> CGPoint
    {
        return sideOfTable.positionOfCard(positionInSpread, spriteHeight: spriteHeight,
            width: tableSize.width, height: tableSize.height, fullHand:fullHand)
    }
    override func rotationOfCard(positionInSpread:CGFloat, fullHand:CGFloat) -> CGFloat
    {
        return direction.rotationOfCard(positionInSpread, fullHand:fullHand)
    }
    override func appendContentsOf(newCards:[PlayingCard])
    {
        var updatedCards = cards
        updatedCards.appendContentsOf(newCards)
        let sortedHand = updatedCards.sort()
        cards = ( Array(sortedHand.reverse()))
    }
    override func replaceWithContentsOf(newCards:[PlayingCard])
    {
        let updatedCards = newCards
        let sortedHand = updatedCards.sort()
        cards = ( Array(sortedHand.reverse()))
    }
    func rearrange()
    {
        if(scene==nil)
        {
            return
        }
        var fullHand = CardPile.defaultSpread
        let noCards = CGFloat(cards.count)
        var positionInSpread = CGFloat(0)
        
        if isFanOpen
        {
            positionInSpread = (fullHand - noCards + 1) * 0.5
            if fullHand < noCards
            {
                fullHand = noCards
                positionInSpread = CGFloat(0)
            }
        }
        for card in cards
        {
            rearrangeFor(card,positionInSpread:positionInSpread, fullHand:fullHand)
            positionInSpread++
            
        }
    }
}

