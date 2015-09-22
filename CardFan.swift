//
//  CardFan.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 21/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

class CardFan : CardPile
{
    
    func setup(scene:SKNode, sideOfTable: SideOfTable, isUp: Bool, isBig: Bool)
    {
        self.scene = scene
        self.sideOfTable = sideOfTable
        self.isUp = isUp
        self.isBig = isBig
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
    func appendContentsOf(newCards:[PlayingCard])
    {
        var updatedCards = cards
        updatedCards.appendContentsOf(newCards)
        let sortedHand = updatedCards.sort()
        cards = ( Array(sortedHand.reverse()))
    }
    func replaceWithContentsOf(newCards:[PlayingCard])
    {
        let updatedCards = newCards
        let sortedHand = updatedCards.sort()
        cards = ( Array(sortedHand.reverse()))
    }
}

