//
//  CardGameScene.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 19/7/18.
//  Copyright © 2018 Nereids Gold. All rights reserved.
//

import SpriteKit

class CardGameScene : CardScene, HasDealersArea {
    
    var table : RicketyKateCardTable!
    var dealtPiles = [CardPile]()
    
    func createCardPilesToProvideStartPointForCardAnimation(_ size:CGSize )
    {
        setupDealersAreaFor(table.players.count,size:size )
        deal(table.dealtHands)
    }
    
    /// at end of game return sprites to start
    func discard()
    {
        for player in table.players
        {
            player._hand.discardAll()
            player.wonCards.discardAll()
        }
        table.trickFan.discardAll()
    }
    internal func redealThen(_ cards:[[PlayingCard]],  whenDone: @escaping ([CardPile]) -> Void)
    {
        for player in table.players
        {
            player._hand.clear()
            player.wonCards.clear()
        }
        table.trickFan.clear()
        discardPile.clear()
        discardWhitePile.clear()
        deal(cards)
        scene?.schedule(delay:  Game.settings.tossDuration*1.2) { whenDone(self.dealtPiles) }
    }
}

