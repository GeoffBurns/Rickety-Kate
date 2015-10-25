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
    lazy var deck = PlayingCard.BuiltCardDeck()
    var playerOne: CardPlayer = HumanPlayer.sharedInstance;
    var _players = [CardPlayer]()
    var scene : SKNode? = nil
 
    var isInDemoMode = false
    func nop() {}
 
    var startPlayerNo = 1


    var cardTossDuration = Double(0.7)
    var currentPlayer : CardPlayer? = nil
    
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
    func trackNotFollowingBehaviourForAIStrategy(player: CardPlayer, suite: PlayingCard.Suite )
    {
        if let firstcard = tricksPile.first
        {
            let leadingSuite = firstcard.playedCard.suite
            if suite != leadingSuite
            {
                self.gameTracker.playerNotFollowingSuite(player, suite: suite)
            }
        }
    }
    
    func addToTrickPile(player:CardPlayer,cardName:String)
    {
        if let displayedCard = scene!.cardSpriteNamed(cardName)
        {
            
            self.gameTracker.countCardIn(displayedCard.card.suite)
            trackNotFollowingBehaviourForAIStrategy(player, suite: displayedCard.card.suite)
            
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
            /// If the player has no cards in the suite they do not need to follow
            if cardsInSuite.isEmpty
            {
                return true
            }
            let displayedCard = scene!.cardSpriteNamed(cardName)
            
            return displayedCard!.card.suite == leadingSuite
            
        }
        return false
    }
    func playTrickCard(playerWithTurn:CardPlayer, trickcard:PlayingCard)
    {
        addToTrickPile(playerWithTurn,cardName: trickcard.imageName)
        nextPlayerAction2(playerWithTurn)
    
    }
    
    func nextPlayerAction2( playerWithTurn:CardPlayer)
    {

        var nextNo = playerWithTurn.playerNo + 1
        if nextNo >= noOfPlayers
        {
          nextNo = 0
        }
        
        let firstNo = tricksPile[0].player.playerNo
        if firstNo == nextNo
        {
            NSTimer.schedule(delay: cardTossDuration*2.0) { [unowned self] timer in
                self.trickWon()
            }
            
        } else {
            NSTimer.schedule(delay: cardTossDuration*2.0) { [unowned self] timer in
                self.playTrick(self.players[nextNo])
            }
        }
    }

    func trickWon()
    {
        if let winner = Scorer.sharedInstance.trickWon(self)
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
                    Scorer.sharedInstance.hasGameBeenWon()
                    
                    self.gameTracker.reset()
                    self.dealNewCardsToPlayers()
                    Bus.sharedInstance.send(GameEvent.NewHand)
                }
                else
                {
                    self.playTrick(winner)
                } 
            })]))
        }
        self.tricksPile = []
    }
    
    func playTrick(playerWithTurn: CardPlayer)
    {
        currentPlayer = playerWithTurn
        if let computerPlayer = playerWithTurn as? ComputerPlayer
        {
            if let card = computerPlayer.playCard( self)
            {
                if let trickcard = computerPlayer.removeFromHand(card)
                {
                    playTrickCard(playerWithTurn, trickcard:trickcard)
                    return
                }
            }
            
            // player has run out of cards
            nextPlayerAction2(playerWithTurn)
   
        }
        else
        {
     
            Bus.sharedInstance.send(GameEvent.YourTurn)
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

    
    // start playing a new Trick
    func playTrickLeadBy(playerWithLead:CardPlayer)
    {
        playTrick(playerWithLead)
        
    }

    public func dealNewCardsToPlayers()
    {
       // deck = PlayingCard.BuiltCardDeck()
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