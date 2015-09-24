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
    
    func setup(scene:SKNode, sideOfTable: SideOfTable, isUp: Bool, sizeOfCards: CardSize = CardSize.Small)
    {
        self.scene = scene
        self.sideOfTable = sideOfTable
        self.isUp = isUp
        self.sizeOfCards = sizeOfCards
        self.direction = sideOfTable.direction
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
            width: scene!.frame.width, height: scene!.frame.height, fullHand:fullHand)
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
}

