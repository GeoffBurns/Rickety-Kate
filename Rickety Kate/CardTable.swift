//
//  CardTable.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 11/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

public struct StateOfPlay
{
    let remainingPlayers:[CardPlayer]
}

/// controls the flow of the game
public class CardTable : GameStateBase, GameState
{
    lazy var deck: Deck = PlayingCard.BuiltCardDeck()
    var playerOne: CardPlayer = HumanPlayer.sharedInstance;
    var _players = [CardPlayer]()
    var scene : SKNode? = nil
    var newGame :  Publink<Void> =  Publink<Void>()
    var resetGame :  Publink<Void> =  Publink<Void>()
 
    var isInDemoMode = false
    func nop() {}
 
    var startPlayerNo = 1
 //   var cardsPassed = [CardPile]()
    // if non-nil StateOfPlay is frozen awaiting user input
    var currentStateOfPlay:StateOfPlay? = nil
    var cardTossDuration = Double(0.7)
    
    
    public var players : [CardPlayer] {
        get {
            return _players
        }
        
    }
    
 
    static public func makeTable(scene:SKNode, gameSettings: IGameSettings = GameSettings.sharedInstance ) -> CardTable {
     return CardTable(players: CardPlayer.gamePlayers(gameSettings.noOfPlayersAtTable), scene:scene)
}

    static public func makeDemo(scene:SKNode, gameSettings: IGameSettings = GameSettings.sharedInstance ) -> CardTable  {
     return CardTable(players: CardPlayer.demoPlayers(gameSettings.noOfPlayersAtTable), scene:scene )
    }
    private init(players: [CardPlayer],  scene:SKNode) {
    _players = players
    playerOne = _players[0]
    isInDemoMode = playerOne.name != "You"
    self.scene  = scene

    Scorer.sharedInstance.setupScorer(_players)
    super.init()
  //  setPassedCards()
    }
    
    // everyone except PlayerOne
    var otherPlayers : [CardPlayer]
    {
        return players.filter {$0 != self.playerOne}
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

    func addToTrickPile(player:CardPlayer,cardName:String)
    {
        if let displayedCard = scene!.cardSpriteNamed(cardName)
        {
            
            self.gameTracker.cardCounter.publish(displayedCard.card.suite)
            
            if let firstcard = tricksPile.first
            {
                let leadingSuite = firstcard.playedCard.suite
                if displayedCard.card.suite != leadingSuite
                {
                    self.gameTracker.notFollowingTracker.publish(displayedCard.card.suite,player)
                }
            }
            displayedCard.player=player
            let playedCard = displayedCard.card
            tricksPile.append(player:player,playedCard:playedCard)
            
        }
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
            let displayedCard = scene!.cardSpriteNamed(cardName)
            
            return displayedCard!.card.suite == leadingSuite
            
        }
        return false
    }
    func playTrickCard(playerWithTurn:CardPlayer, trickcard:PlayingCard,state:StateOfPlay, willAnimate:Bool = true)
    {
        addToTrickPile(playerWithTurn,cardName: trickcard.imageName)
       
   
        let doneAction =  nextPlayerAction(state , currentSuite: trickcard.suite)
        
        let  waitThenDo = SKAction.sequence([
            SKAction.waitForDuration(cardTossDuration*2.0),
            doneAction])
        scene!.runAction(waitThenDo)

    
        
    }
    
    func nextPlayerAction(state:StateOfPlay, currentSuite:PlayingCard.Suite?) -> SKAction
    {
        var remainingPlayers = state.remainingPlayers
        remainingPlayers.removeAtIndex(0)
        let nextPlayers = remainingPlayers
        let doneAction = nextPlayers.isEmpty ?
            (SKAction.runBlock({ [unowned self] in
                self.trickWon()
            })) :
            
            (SKAction.runBlock({ [unowned self] in
                
                self.playTrick(StateOfPlay(remainingPlayers: nextPlayers))
            }))
        
        return doneAction
    }
    func trickWon()
    {
        if let winner = Scorer.winnerIs(self)
        {
            self.removeTricksPile(winner)
        }
    }
    func removeTricksPile(winner:CardPlayer)
    {
        
        var parent: SKNode? = nil
        for trick in self.tricksPile
        {
            let card =  trick.playedCard
            let sprite =  scene!.cardSprite(card)!
            
            if parent == nil{
                parent = sprite.parent
            }
            
            sprite.runAction(SKAction.sequence([SKAction.waitForDuration(cardTossDuration), SKAction.runBlock({
                winner.wonCards.append(card)
            })]))
            
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
           scene!.runAction(doneAction)
        }
        else
        {
            currentStateOfPlay = StateOfPlay( remainingPlayers: remainingPlayers)
            StatusDisplay.publish("Your Turn")
        }
        
    }
    // return four players starting with the one that has the lead
    public func trickPlayersLeadBy(playerWithLead:CardPlayer) -> [CardPlayer]
    {
        var trickPlayers = [CardPlayer]()
        
        var i = 0
        var leaderFound = false
        let noOfplayers = players.count
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
            if(i>=noOfplayers)
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
    func setupCardPilesSoPlayersCanPlayTricks()
    {
       trickFan.setup(scene!, sideOfTable: SideOfTable.Center, isUp: true, sizeOfCards: CardSize.Medium)
    }
    //////////
    // Pass 3 worst cards phase
    //////////
    /*
    func setPassedCards()
    {
        cardsPassed.append(CardFan(name: CardPileType.Passing.description))
        for _ in 0..<(_players.count-1)
        {
            cardsPassed.append(CardPile(name: CardPileType.Passing.description))
        }
    }
    func resetPassedCards()
    {
        
        for i in 0..<(_players.count)
        {
            cardsPassed[i].cards = []
        }
    }
    func setupCardPilesSoPlayersCanPassTheir3WorstCards()
    {
        for (passPile,player) in Zip2Sequence( cardsPassed, players )
        {
            let side = player.sideOfTable
            
            if let passFan = passPile as? CardFan
            {
                passFan.setup(scene!, sideOfTable: SideOfTable.Center, isUp: true, sizeOfCards: CardSize.Medium)
            }
            else
            {
                passPile.setup(scene!,
                    direction: side.direction,
                    position: side.positionOfPassingPile( 80, width: scene!.frame.width, height: scene!.frame.height),
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
                scene!.cardSprite(card)!.player = toPlayer
                
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
*/
    
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
        deck = PlayingCard.BuiltCardDeck()
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