//
//  CardTable.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 11/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit
import Cards

/// controls the flow of the game
open class CardTable: GameStateBase
{
    open var players = [CardPlayer]()
    var scene : CardScene? = nil
    var playerOne: CardPlayer = HumanPlayer()

    var isInDemoMode = false
    
    lazy var dealtHands : [[PlayingCard]] = self.dealHands()
    
    public init(players: [CardPlayer],  scene:CardScene) {
        self.players = players
        playerOne = self.players[0]
        isInDemoMode = !(playerOne is HumanPlayer)
        self.scene  = scene
        
        super.init()
        //  setPassedCards()
    }
    var cardTossDuration = Game.settings.tossDuration*1.8
    
    var areCardsShowing : Bool
    {
        for player in players where player.sideOfTable == SideOfTable.bottom
        {
            return player._hand.isUp
        }
        return false
    }
    
    func turnOverCards()
    {
        for player in players where player.sideOfTable == SideOfTable.bottom
          {
            return player.turnOverCards()
          }
    }
    func dealHands()->[[PlayingCard]] {
        return Game.deck.dealFor(players.count)
    }
    
    func redealHands()->[[PlayingCard]] {
        dealtHands = self.dealHands()
        return dealtHands
    }
    // everyone except PlayerOne
/*    var otherPlayers : [CardPlayer]
    {
        return players.filter {$0 != self.playerOne}
    }
   */
    open var noOfPlayers : Int
    {
            return players.count
    }
}
