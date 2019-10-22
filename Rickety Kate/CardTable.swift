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
    var seatRotation : Int = 0
    var isInDemoMode = false
    var bannerHeight = CGFloat(0)
    var size : CGSize = CGSize()
    var startPlayerNo = 1
    lazy var dealtHands : [[PlayingCard]] = self.dealHands()
    
    public init(players: [CardPlayer],  scene:CardScene) {
        self.players = players
        playerOne = self.players[0]
        isInDemoMode = !(playerOne is HumanPlayer)
        self.scene  = scene
        
        startPlayerNo = players.reduce(0) { $1 is HumanPlayer ? $0 + 1 : $0 }
        if startPlayerNo >= players.count { startPlayerNo = 1 }
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
    func hideCards()
    {
    if Game.settings.noOfHumanPlayers > 1 && !isInDemoMode
     {
         for player in players
         {
             player._hand.isUp = false
         }
     }
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
    public func seatPlayers(_ isPortrait:Bool)
    {
        changeOperator(0)
        
        if let target = scene as? HasBackgroundSpread
        {
        target.backgroundFan.updateBackgrounds()
        }
        Seater.seatPlayers(scene!, isPortrait:isPortrait, players:players)
    }
    public func seatPlayers()
     {
        seatPlayers(scene!.isPortrait)
     }
    
    public func reseatPlayers(_ rotate:Int)
       {
         reseatPlayers( rotate, isPortrait:scene!.isPortrait)
         
       }
    func changeOperator(_ newValue:Int)
    {
        seatRotation = newValue
        Game.currentOperator = newValue
        if let audioPlayer = scene as? HasMusic
                      {
                        audioPlayer.playMusic(newValue)
                      }
    }
    public func reseatPlayers(_ rotate:Int, isPortrait:Bool)
        {
          changeOperator(rotate)
          if let target = scene as? HasBackgroundSpread
                {
                target.backgroundFan.updateBackgrounds()
                }
           Seater.reseatPlayers(scene!, isPortrait:isPortrait, players:players, rotate:rotate)
           ScoreDisplay.sharedInstance.resetScoreLabels(players, size: size, bannerHeight:bannerHeight )
        }
    public func reseatPlayers(_ rotate:Int, isPortrait:Bool, isCardsShown: Bool)
       {
          changeOperator(rotate)
        if let target = scene as? HasBackgroundSpread
               {
               target.backgroundFan.updateBackgrounds()
               }
          Seater.reseatPlayers(scene!, isPortrait:isPortrait, players:players, rotate:rotate, isCardsShown: isCardsShown)
          ScoreDisplay.sharedInstance.resetScoreLabels(players, size: size, bannerHeight:bannerHeight )
       }
    func adjustPlayerPosition(_ bannerHeight: CGFloat, _ newSize: CGSize, _ isPortrait:Bool) {
        for (i,player) in players.enumerated()
        {
            scene!.schedule(delay: 0.4 * Double(i) )
            {
                player._hand.bannerHeight = bannerHeight
                player._hand.tableSize = newSize
                player._hand.rearrangeFast()
                player.wonCards.bannerHeight = bannerHeight
                player.wonCards.tableSize = newSize
                player.wonCards.rearrange()
            }
        }
      
        reseatPlayers(Game.currentOperator, isPortrait:isPortrait, isCardsShown: self.areCardsShowing)
        
        self.size = newSize
        self.bannerHeight = bannerHeight
        ScoreDisplay.sharedInstance.resetScoreLabels(players, size: newSize, bannerHeight:bannerHeight )
    }
}

