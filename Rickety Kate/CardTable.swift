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
    let remainingPlayers:[CardPlayer]
}


public class CardTable : GameStateEngine, GameState
{
    var deck: Deck = PlayingCard.Standard52CardDeck.sharedInstance
    var playerOne: CardPlayer = HumanPlayer.sharedInstance;
    var _players: [CardPlayer] = []

    // if non-nil StateOfPlay is frozen awaiting user input
    var currentStateOfPlay:StateOfPlay? = nil
    var cardTossDuration = Double(0.7)


    var tidyup :  Publink<Void> =  Publink<Void>()
    var newGame :  Publink<Void> =  Publink<Void>()
    var resetGame :  Publink<Void> =  Publink<Void>()
 
    var isInDemoMode = false
    func nop() {}
 
    var startPlayerNo = 1
    let cardScale = CGFloat(0.9)
    let cardScaleForSelected = CGFloat(1.05)
    var cardsPassed : [[ PlayingCard ]] = [[],[],[],[]]
    
    public var players : [CardPlayer] {
        get {
            return _players
        }
        
    }
    static public func makeTable() -> CardTable {
     return CardTable(players: [HumanPlayer.sharedInstance,ComputerPlayer(name:"Fred",margin: 2),ComputerPlayer(name:"Molly",margin: 3),ComputerPlayer(name:"Greg",margin: 1)])
}

    static public func makeDemo() -> CardTable  {
     return CardTable(players: [ComputerPlayer(name:"Sarah",margin: 4),ComputerPlayer(name:"Fred",margin: 2),ComputerPlayer(name:"Molly",margin: 3),ComputerPlayer(name:"Greg",margin: 1)])
    }
    private init(players: [CardPlayer]) {
    _players = players
    playerOne = _players[0]
    isInDemoMode = playerOne.name != "You"
        
    Scorer.sharedInstance.setupScorer(_players)
    }
    
    // everyone except PlayerOne
    var otherPlayers : [CardPlayer]
    {
        return players.filter {$0 != self.playerOne}
    }
    
    func resetPassedCards()
    {
        cardsPassed = [[],[],[],[]]
    }
    //////////
    // GameState Protocol
    //////////
    public var noOfPlayers : Int
    {
            return players.count
    }

    
    public var unplayedCardsInTrick : Int
    {
    return  noOfPlayers - playedCardsInTrick
    }
    
    public var isLastPlayer : Bool {
     return tricksPile.count >= noOfPlayers - 1
    }
    
 

    
    //////////
    // internal functions
    //////////
    func removeTricksPile(winner:CardPlayer)
    {
        
        var direction = SideOfTable.Top
        if let index = players.indexOf(winner), side = SideOfTable(rawValue: index)
        {
            direction = side
            
        }
        
        var parent: SKNode? = nil
        for trick in self.tricksPile
        {
            let sprite =  CardSprite.sprite(trick.playedCard)
            
                if parent == nil{
                    parent = sprite.parent
                }
                
                let moveAction = (SKAction.moveTo(direction.positionOfWonCards( sprite.parent!.frame.width, height: sprite.parent!.frame.height), duration:(cardTossDuration)))
          
                let moveActionWithDone = (SKAction.sequence([SKAction.waitForDuration(cardTossDuration) ,moveAction /*, doneAction*/]))
                sprite.runAction(moveActionWithDone)
                
           
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
                    
                    Scorer.sharedInstance.hasShotTheMoon()
                                       
                    
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
    

    
    func takePassedCards()
    {
        for previous in 0...3
        {
            var next = previous+1
            if next > 3
            {
                next = 0
            }
            
            let fromPlayersCards = cardsPassed[previous]
            let toPlayer = players[next]
            
            for card in fromPlayersCards
            {
                CardSprite.sprite(card).player = toPlayer
                toPlayer.hand.append(card)
            }
            
            let sortedHand = toPlayer.hand.sort()
            toPlayer.newHand( Array(sortedHand.reverse()))
        }
        resetPassedCards()
    }
    func trickWon()
    {
        if let winner = Scorer.winnerIs(self)
        {
            self.removeTricksPile(winner)
        }
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
    

   
    func playerThatWon() -> CardPlayer?
    {
        if let trick = self.tricksPile.first
        {
            let leadingSuite = trick.playedCard.suite
            let followingTricks = self.tricksPile.filter { $0.playedCard.suite == leadingSuite }
            
            let orderedTricks = followingTricks.sort({ $0.playedCard.value > $1.playedCard.value })
            if let highest = orderedTricks.first
            {
                return highest.player
            }
        }
        return nil
    }
    
    
    func nextPlayerAction(state:StateOfPlay, currentSuite:PlayingCard.Suite?) -> SKAction
    {
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
             
                self.playTrick(StateOfPlay(remainingPlayers: nextPlayers))
            }))
        
        return doneAction
    }
    func playTrickCard(playerWithTurn:CardPlayer, trickcard:PlayingCard,state:StateOfPlay, willAnimate:Bool = true)
    {

        addToTrickPile(playerWithTurn,cardName: trickcard.imageName)
        
        let displayedCard = CardSprite.sprite(trickcard)
        
                let fullHand = CGFloat(13)
                let positionInSpread = (fullHand - 4 ) * 0.5 + CGFloat(self.tricksPile.count - 1)
                
                let sprite = displayedCard
                let isFaceUp = displayedCard.isUp
                let spriteHeight = isFaceUp ? sprite.size.height*0.5 :  sprite.size.height
                
                if let scene = sprite.parent
                {
                    let width = scene.frame.width
                    let height =  scene.frame.height
                    
                    
                    let newPosition = SideOfTable.Center.positionOfCard(positionInSpread, spriteHeight: spriteHeight, width: width , height:height)
                    let moveAction = (SKAction.moveTo(newPosition, duration:(cardTossDuration)))
                    let rotationAngle = SideOfTable.Center.rotationOfCard(positionInSpread) //+ CGFloat(M_PI * 2.0)
                    let rotateAction = (SKAction.rotateToAngle(rotationAngle, duration:cardTossDuration))
                    let scaleAction =  (SKAction.scaleTo(cardScale*0.5, duration: cardTossDuration))
                    
                    let flipAction = (SKAction.sequence([
                        SKAction.scaleXTo(0.0, duration: cardTossDuration*0.5),
                        SKAction.runBlock({
                            
                            let sprite = CardSprite.sprite(trickcard)
                            sprite.flipUp()
                            }) ,
                        SKAction.scaleXTo(cardScale*0.5, duration: cardTossDuration*0.5)
                        ]))
                
                    let doneAction =  nextPlayerAction(state , currentSuite: trickcard.suite)
                    
                    if(willAnimate)
                    {
                        let moveActionWithDone = isFaceUp
                   
                            ? SKAction.sequence([
                                    SKAction.group([moveAction,rotateAction,scaleAction]),
                                    SKAction.waitForDuration(cardTossDuration),
                                    doneAction])
                        : SKAction.sequence([
                            SKAction.group([moveAction,rotateAction,flipAction]),
                            SKAction.waitForDuration(cardTossDuration),
                            doneAction])
                        sprite.runAction(moveActionWithDone)
                    }
                    else
                    {
                        sprite.runAction(doneAction)
                    }
                }
        }
    
    func passCard(seatNo:Int, passedCard:PlayingCard) -> PlayingCard?
    {
    let displayed = CardSprite.sprite(passedCard)
     

           if let removedCard = players[seatNo].removeFromHand(displayed.card)
            {
            self.cardsPassed[seatNo].append(removedCard)
            return removedCard
            }
     
        return nil
    }
    func passOtherCards()
    {
       for i in 0...3
       {
        if let player = players[i] as? ComputerPlayer
          {
            for card in player.passCards()
              {
                passCard(i, passedCard:card)
              }
            }
          }
        }
    
    func playTrick(state:StateOfPlay)
    {

        let remainingPlayers = state.remainingPlayers
   
        if let playerWithTurn = remainingPlayers.first,
            computerPlayer = playerWithTurn as? ComputerPlayer
        {
            if let card = computerPlayer.playCard( self)
            {
          
                if let trickcard = computerPlayer.removeFromHand(card)
                {
        
                    playTrickCard(playerWithTurn, trickcard:trickcard,state:state)
                                       return
                    
                }
            }
            
            // player has run out of cards
            let doneAction =  nextPlayerAction(state , currentSuite: nil)
            CardSprite.register["QS"]!.runAction(doneAction)
        }
        else
        {
            currentStateOfPlay = StateOfPlay( remainingPlayers: remainingPlayers)
            StatusDisplay.publish("Your Turn")
        }
        
    }
    
    // start playing a new Trick
    func playTrickLeadBy(playerWithLead:CardPlayer)
    {
        let players = trickPlayersLeadBy(playerWithLead)
        let remainingPlayers = players
      
   
        let state = StateOfPlay( remainingPlayers: remainingPlayers)
        playTrick(state)
        
    }

    public func dealNewCardsToPlayers()
    {
        var hands = deck.dealFor(players.count)
        var i = 0
        for player in players
        {
            
          let sortedHand = hands[i].sort()
            player.newHand( Array(sortedHand.reverse()))
            i++
        }
    }
}