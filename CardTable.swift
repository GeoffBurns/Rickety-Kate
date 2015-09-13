//
//  CardTable.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 11/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import Foundation
import SpriteKit

public struct StateOfPlay
{
    let leadingSuite:PlayingCard.Suite?
    let remainingPlayers:[CardPlayer]
  //  let table:CardTable
}

public class CardTable
{
    var deck: Deck = PlayingCard.Standard52CardDeck.sharedInstance
    var playerOne: CardPlayer = HumanPlayer.sharedInstance;
    public var players: [CardPlayer] = [HumanPlayer.sharedInstance,ComputerPlayer(name:"Fred"),ComputerPlayer(name:"Molly"),ComputerPlayer(name:"Greg")]
    var tricksPile : [(player:CardPlayer,playedCard:PlayingCard, cardSprite: SKSpriteNode)] = []
    // if non-nil StateOfPlay is frozen awaiting user input
    var currentStateOfPlay:StateOfPlay? = nil
    var displayedCards : Dictionary<String,(sprite: SKSpriteNode, card: PlayingCard)> = [:]
    var displayedCardsIsFaceUp : Dictionary<String,Bool> = [:]
    var cardTossDuration = Double(1.3)
    var statusInfo = Publink<(String,String)>()
    // TODO replace - repeat generator does not work so great with classes
    var scoreUpdates : [Publink<Int>] = [Publink<Int>](count: 4, repeatedValue: Publink<Int>())
    var tidyup :  Publink<Void> =  Publink<Void>()
    var newGame :  Publink<Void> =  Publink<Void>()
    var resetGame :  Publink<Void> =  Publink<Void>()
    var scores : [Int] = [Int](count: 4, repeatedValue: 0)
    var gameTracker = GameProgressTracker.sharedInstance
    
    func nop() {}
 
    var startPlayerNo = 1
    let cardScale = CGFloat(0.9)
    let cardScaleForSelected = CGFloat(1.05)
    static public let sharedInstance = CardTable()
    
    private init() {
    
   
    }
    // everyone except PlayerOne
    var otherPlayers : [CardPlayer]
    {
        return players.filter {$0 != self.playerOne}
    }
    
    func trickWon()
    {
        if let winner = self.playerThatWon()
        {
            let winnersName = winner.name
            
            if let winnerIndex = find(players,winner)
            {
            var score = 0
            
            var ricketyKate = tricksPile.filter{$0.playedCard.imageName == "QS"}
            
            var spades = tricksPile.filter{$0.playedCard.suite == PlayingCard.Suite.Spades && $0.playedCard.imageName != "QS"}
            if !ricketyKate.isEmpty
            {
                score = 10
            }
            score += spades.count
            
            if !ricketyKate.isEmpty
            {
                self.statusInfo.publish("\(winnersName) won Rickety Kate","Poor \(winnersName)")
            }
            else if spades.count == 1
            {
                self.statusInfo.publish("\(winnersName) won a spade","Bad Luck")
            }
            else if spades.count > 1
            {
                self.statusInfo.publish("\(winnersName) won \(spades.count) spades","Bad Luck")
            }
            else
            {
            self.statusInfo.publish("\(winnersName) won the Trick","")
            }
            if(score>0)
            {
                self.scores[winnerIndex] += score
                self.scoreUpdates[winnerIndex].publish(self.scores[winnerIndex])
            }
            }
            self.removeTricksPile(winner)
        }
    }
    func removeTricksPile(winner:CardPlayer)
    {
        
        var direction = SideOfTable.Top
        if let index = find(players,winner), side = SideOfTable(rawValue: index)
        {
            direction = side
            
        }
        
        var parent: SKNode? = nil
        for trick in self.tricksPile
        {
            if let displayedCard =  self.displayedCards[trick.playedCard.imageName],
                
                    scene = displayedCard.sprite.parent
                   {
                    
                    let sprite = displayedCard.sprite
                    if parent == nil{
                        parent = scene
                    }

                    let moveAction = (SKAction.moveTo(direction.positionOfWonCards( scene.frame.width, height: scene.frame.height), duration:(cardTossDuration)))
                /*    let doneAction = (SKAction.runBlock({
                       
                        self.displayedCards[trick.playedCard.imageName] = nil
                        displayedCard.sprite.removeFromParent()
                   
                       
                    }))*/
               let moveActionWithDone = (SKAction.sequence([SKAction.waitForDuration(cardTossDuration) ,moveAction /*, doneAction*/]))
               sprite.runAction(moveActionWithDone)

            }
        }
        if parent != nil
        {
        parent!.runAction(SKAction.sequence([SKAction.waitForDuration(cardTossDuration), SKAction.runBlock({
            
            if(self.playerOne.hand.isEmpty)
            {
                self.startPlayerNo++
                if self.startPlayerNo > 3
                {
                   self.startPlayerNo = 0
                }
                self.gameTracker.reset()
                self.dealNewCardsToPlayers()
                self.resetGame.publish()
            }
            else
            {
            self.playTrickLeadBy(winner)
            }
            
        })]))
        }

              self.tricksPile = []
    }
    func isMoveValid(player:CardPlayer,cardName:String) -> Bool
    {
        if self.tricksPile.isEmpty
        {
          return true
        }
        if let trick = self.tricksPile.first
        {
            let leadingSuite = trick.playedCard.suite
            let cardsInSuite = player.hand.filter { $0.suite == leadingSuite}
            if cardsInSuite.isEmpty
            {
                return true
            }
           if let displayedCard = self.displayedCards[cardName]
           {
           return displayedCard.card.suite == leadingSuite
           }
        }
        return false
    }
    // return four players starting with the one that has the lead
    public func trickPlayersLeadBy(playerWithLead:CardPlayer) -> [CardPlayer]
    {
        var trickPlayers = [CardPlayer]()
        
        var i = 0
        var leaderFound = false
        for player in players
        {
            if(!leaderFound)
            {
                leaderFound = playerWithLead == player
            
            }
           if(leaderFound)
           {
            trickPlayers.append(player)
            i++
            }
        }
        for player in players
        {
            if(i>=4)
            {
                break
            }
            trickPlayers.append(player)
            i++
        }
        return trickPlayers
    }
    
    func addToTrickPile(player:CardPlayer,cardName:String)
    {
        if let displayedCard = self.displayedCards[cardName]
        {
            
            self.gameTracker.cardCounter.publish(displayedCard.card.suite)
            tricksPile.append((player:player,playedCard:displayedCard.card, cardSprite: displayedCard.sprite))
        }
    }
   
    func playerThatWon() -> CardPlayer?
    {
        if let trick = self.tricksPile.first
        {
            let leadingSuite = trick.playedCard.suite
            let followingTricks = self.tricksPile.filter { $0.playedCard.suite == leadingSuite }
            
            let orderedTricks = sorted(followingTricks, { $0.playedCard.value > $1.playedCard.value })
            if let highest = orderedTricks.first
            {
                return highest.player
            }
        }
        return nil
    }
    
    
    func nextPlayerAction(state:StateOfPlay, currentSuite:PlayingCard.Suite?) -> SKAction
    {
        var leadingSuite = state.leadingSuite
        var remainingPlayers = state.remainingPlayers
        remainingPlayers.removeAtIndex(0)
        let nextPlayers = remainingPlayers
        let doneAction = nextPlayers.isEmpty ?
            (SKAction.runBlock({
                self.tidyup.publish()
                
                self.trickWon()
            })) :
            
            (SKAction.runBlock({
                
                self.tidyup.publish()
                if let newSuite = currentSuite where leadingSuite == nil
                {
                    leadingSuite = newSuite // trickcard.suite
                }
                self.playTrick(StateOfPlay(leadingSuite: leadingSuite, remainingPlayers: nextPlayers))
            }))
        
        return doneAction
    }
    func playTrickCard(playerWithTurn:CardPlayer, trickcard:PlayingCard,state:StateOfPlay, willAnimate:Bool = true)
    {
        var leadingSuite = state.leadingSuite
        var remainingPlayers = state.remainingPlayers
            addToTrickPile(playerWithTurn,cardName: trickcard.imageName)
            if let displayedCard = displayedCards[trickcard.imageName]
            {
                var fullHand = CGFloat(13)
                var positionInSpread = (fullHand - 4 ) * 0.5 + CGFloat(self.tricksPile.count - 1)
                
                let sprite = displayedCard.sprite
                let spriteHeight = sprite.size.height
                
                if let scene = sprite.parent
                {
                    let width = scene.frame.width
                    let height =  scene.frame.height
                    
                    
                    let newPosition = SideOfTable.Center.positionOfCard(positionInSpread, spriteHeight: spriteHeight, width: width , height:height)
                    let moveAction = (SKAction.moveTo(newPosition, duration:(cardTossDuration)))
                    let rotationAngle = SideOfTable.Center.rotationOfCard(positionInSpread) //+ CGFloat(M_PI * 2.0)
                    let rotateAction = (SKAction.rotateToAngle(rotationAngle, duration:cardTossDuration))
                 //   let scaleAction =  (SKAction.scaleTo(cardScale*0.5, duration: cardTossDuration))
                    
                    let flipAction = (SKAction.sequence([
                        SKAction.scaleXTo(0.0, duration: cardTossDuration*0.5),
                        SKAction.runBlock({
                            self.displayedCardsIsFaceUp.updateValue(true, forKey: trickcard.imageName)
                            sprite.texture = SKTexture(imageNamed:trickcard.imageName)
                            }) ,
                        SKAction.scaleXTo(cardScale*0.5, duration: cardTossDuration*0.5)
                        ]))
                
                    let doneAction =  nextPlayerAction(state , currentSuite: trickcard.suite)
                    
                    if(willAnimate)
                    {
                        let moveActionWithDone = SKAction.sequence([
                            SKAction.group([moveAction,rotateAction,flipAction]),
                            SKAction.waitForDuration(cardTossDuration),
                            doneAction])
                        sprite.runAction(moveActionWithDone)
                    }
                    else
                    {
                       // sprite.runAction(SKAction.sequence([SKAction.waitForDuration(cardTossDuration),doneAction]))
                        sprite.runAction(doneAction)
                    }
                }
        }
    }
    
    func playTrick(state:StateOfPlay)
    {
        var leadingSuite = state.leadingSuite
        var remainingPlayers = state.remainingPlayers
   
        if let playerWithTurn = remainingPlayers.first,
            computerPlayer = playerWithTurn as? ComputerPlayer
        {
            if let card = computerPlayer.playCard(state,table: self)
            {
                /// computerPlayer.hand.indexOf(card) // in swift 2.0
                if let index = find(computerPlayer.hand,card)
                {
                    let trickcard = computerPlayer.hand.removeAtIndex(index)
                    playTrickCard(playerWithTurn, trickcard:trickcard,state:state)
                                       return
                    
                }
            }
            
            // player has run out of cards
            let doneAction =  nextPlayerAction(state , currentSuite: nil)
            displayedCards["QS"]!.sprite.runAction(doneAction)
 //           remainingPlayers.removeAtIndex(0)
        }
        else
        {
            currentStateOfPlay = StateOfPlay(leadingSuite: leadingSuite, remainingPlayers: remainingPlayers)
            statusInfo.publish("Your Turn","")
        }
        
    }
    
    // start playing a new Trick
    func playTrickLeadBy(playerWithLead:CardPlayer)
    {
        let players = trickPlayersLeadBy(playerWithLead)
        var remainingPlayers = players
        var leadingSuite : PlayingCard.Suite? = nil
   
        var state = StateOfPlay(leadingSuite: leadingSuite, remainingPlayers: remainingPlayers)
        playTrick(state)
        
    }

    public func dealNewCardsToPlayers()
    {
        var hands = deck.dealFor(players.count)
        var i = 0
        for player in players
        {
            
          let sortedHand = sorted(hands[i])
            player.newHand( sortedHand.reverse())
            i++
        }
    }
}