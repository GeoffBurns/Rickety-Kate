//
//  PassYourThreeWorstCardPhase.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 30/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

public class PassYourThreeWorstCardsPhase
{
var players : [CardPlayer]
var scene : SKNode
var cardsPassed = [CardPile]()
var isCurrentlyActive = true

    
    init(scene : SKNode, players:[CardPlayer])
    {
        self.players = players
        self.scene = scene
        setPassedCards()
    }


    func setPassedCards()
    {
    cardsPassed.append(CardFan(name: CardPileType.Passing.description))
    for _ in players
        {
        cardsPassed.append(CardPile(name: CardPileType.Passing.description))
        }
    }
    func resetPassedCards()
    {
    
    for (cardTrioPassed,_) in Zip2Sequence(cardsPassed,players)
       {
       cardTrioPassed.cards = []
    }
    }
    func setupCardPilesSoPlayersCanPassTheir3WorstCards()
    {
    for (passPile,player) in Zip2Sequence( cardsPassed, players )
      {
      let side = player.sideOfTable
    
      if let passFan = passPile as? CardFan
        {
        passFan.setup(scene, sideOfTable: SideOfTable.Center, isUp: true, sizeOfCards: CardSize.Medium)
        }
      else
        {
        passPile.setup(scene,
        direction: side.direction,
        position: side.positionOfPassingPile( 80, width: scene.frame.width, height: scene.frame.height),
        isUp: false)
        }
      }
   
    }
    
    func takePassedCards()
    {
    
      let noOfPlayer = players.count
      for (next,toPlayer) in  players.enumerate()
        {
    
        var previous = next - 1
        if previous < 0
          {
           previous = noOfPlayer - 1
          }
    
        let fromPlayersCards = cardsPassed[previous].cards
    
    
        for card in fromPlayersCards
          {
          scene.cardSprite(card)!.player = toPlayer
          }
    
    
        toPlayer.appendContentsToHand(fromPlayersCards)
        }
      resetPassedCards()
    }
    
    func unpassCard(seatNo:Int, passedCard:PlayingCard) -> PlayingCard?
    {
    if let removedCard = self.cardsPassed[seatNo].remove(passedCard)
      {
      players[seatNo]._hand.append(removedCard)
      return removedCard
      }
    
    return nil
    }
    
    func passCard(seatNo:Int, passedCard:PlayingCard) -> PlayingCard?
    {
    if let removedCard = players[seatNo].removeFromHand(passedCard)
      {
      self.cardsPassed[seatNo].cards.append(removedCard)
      return removedCard
      }
    
    return nil
    }
    
    func passOtherCards()
    {
    for (i,player) in  players.enumerate()
      {
      if let compPlayer = player as? ComputerPlayer
        {
        for card in compPlayer.passCards()
          {
          passCard(i, passedCard:card)
          }
        }
      }
    }
    
    func endCardPassingPhase()
    {
        passOtherCards()
        takePassedCards()
        isCurrentlyActive  = false
        Bus.sharedInstance.send(GameEvent.NotYourTurn)
        
    }
    
    func transferCardSprite(cardsprite:CardSprite, isTargetHand:Bool) -> Bool
    {
        if let sourceFanName = cardsprite.fan?.name
        {
            if sourceFanName == CardPileType.Hand.description  && isTargetHand
            {
                if let _ = passCard(0, passedCard: cardsprite.card)
                {
                    return true
                }
            }
            if sourceFanName == CardPileType.Passing.description  && !isTargetHand
            {
                if let _ = unpassCard(0, passedCard: cardsprite.card)
                {
                    return true
                }
            }
        }
        
        return false
    }
    func isPassingPhaseContinuing() -> Bool
    {
        let count = cardsPassed[0].cards.count
      
        if  count < 3
          {
          Bus.sharedInstance.send(GameEvent.DiscardWorstCards(3-count))
          return true
          }
        else
          {
          endCardPassingPhase()
          //  startTrickPhase()
          return false
          }
    }
}