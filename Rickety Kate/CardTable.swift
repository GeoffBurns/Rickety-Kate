//
//  CardTable.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 11/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit


/// controls the flow of the game
public class CardTable: GameStateBase
{
    public var players = [CardPlayer]()
    var scene : CardScene? = nil
    var playerOne: CardPlayer = HumanPlayer.sharedInstance;

    var isInDemoMode = false
    
    lazy var dealtHands : [[PlayingCard]] = self.dealHands()
    
    private init(players: [CardPlayer],  scene:CardScene) {
        self.players = players
        playerOne = self.players[0]
        isInDemoMode = !playerOne.isYou
        self.scene  = scene
        

        super.init()
        //  setPassedCards()
    }
    var cardTossDuration = GameSettings.sharedInstance.tossDuration*1.8
    
    func dealHands()->[[PlayingCard]]
    {
        return GameSettings.sharedInstance.deck!.dealFor(players.count)
    }
    
    func redealHands()
    {
        dealtHands = self.dealHands()
    }
}

/// controls the flow of the game
public class RicketyKateCardTable : CardTable, GameState
{

    let bus = Bus.sharedInstance

    var startPlayerNo = 1

    static public func makeTable(scene:CardScene, gameSettings: IGameSettings = GameSettings.sharedInstance ) -> RicketyKateCardTable {
     return RicketyKateCardTable(players: CardPlayer.gamePlayers(gameSettings.noOfPlayersAtTable), scene:scene)
}

    static public func makeDemo(scene:CardScene, gameSettings: IGameSettings = GameSettings.sharedInstance ) -> RicketyKateCardTable  {
     return RicketyKateCardTable(players: CardPlayer.demoPlayers(gameSettings.noOfPlayersAtTable), scene:scene )
    }
    private override init(players: [CardPlayer],  scene:CardScene) {

    Scorer.sharedInstance.setupScorer(players)
    super.init(players: players,scene: scene)

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

    
    func addToTrickPile(player:CardPlayer,trickcard:PlayingCard)
    {
        if let card = player.removeFromHand(trickcard),
            displayedCard = scene!.cardSpriteNamed(card.imageName)
        {
            
           
            self.gameTracker.trackProgress(tricksPile.first,player:player, playedCard:displayedCard.card)
            
            displayedCard.player=player
            let playedCard = displayedCard.card
            tricksPile.append(player:player,playedCard:playedCard)
            
        }
    }
    
    func isMoveValid(player:CardPlayer,card:PlayingCard) -> GameEvent
    {
     
        if self.tricksPile.isEmpty
        {
            
            if !gameTracker.trumpsHaveBeenBroken &&
               !GameSettings.sharedInstance.allowBreakingTrumps &&
               card.suite == GameSettings.sharedInstance.rules.trumpSuite
            
            {
                return GameEvent.TrumpsHaveNotBeenBroken
            }
            
            return GameEvent.CardPlayed(player, card)
        }
        if let trick = self.tricksPile.first
        {
            let leadingSuite = trick.playedCard.suite
            let cardsInSuite = player.hand.filter { $0.suite == leadingSuite}
            
               let displayedCard = scene!.cardSprite(card)
            
            /// If the player has no cards in the suite they do not need to follow
            if cardsInSuite.isEmpty || displayedCard!.card.suite == leadingSuite
            {
                return GameEvent.CardPlayed(player, card)
            }
        }
        return GameEvent.CardDoesNotFollowSuite
    }
    
    func playTrickCard(playerWithTurn:CardPlayer, trickcard:PlayingCard)
    {
        addToTrickPile(playerWithTurn,trickcard: trickcard)
        endPlayersTurn(playerWithTurn)
    }


func nextPlayerAfter(playerWithTurn:CardPlayer) -> CardPlayer
{
    var nextNo = playerWithTurn.playerNo + 1
    if nextNo >= noOfPlayers
    {
        nextNo = 0
    }
    return self.players[nextNo]
}
    
func endPlayersTurn(playerWithTurn:CardPlayer)
    {

        let nextPlayer = nextPlayerAfter(playerWithTurn)
        
        if let trick = tricksPile.first
          {
          let firstNo = trick.player.playerNo
          if firstNo == nextPlayer.playerNo
            {
            scene!.schedule(delay: cardTossDuration*1.1) { [unowned self] timer in
                self.trickWon()
               }
            
            } else {
               scene!.schedule(delay: cardTossDuration*1.1) { [unowned self] timer in
                 self.playTrick(nextPlayer)
               }
            }
        } else {
            
             print("nextPlayer call after trickPile removed - this shouldn't happen")
             self.endOfHand()
        }
        
    }
    func endOfHand()
    {
        self.startPlayerNo++
        if self.startPlayerNo > 3
        {
            self.startPlayerNo = 0
        }

        Scorer.sharedInstance.hasShotTheMoon()
        Scorer.sharedInstance.endHand() 

        Scorer.sharedInstance.hasGameBeenWon()
        
        self.gameTracker.reset()
        self.redealHands()
        self.dealNewCardsToPlayersThen{
                self.bus.send(GameEvent.NewHand)
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
    
        for trick in self.tricksPile
        {
            let card =  trick.playedCard
            let sprite =  scene!.cardSprite(card)!
            
        
            sprite.schedule(delay: cardTossDuration) {
                winner.wonCards.append(card)
            }
            
        }
         scene!.schedule(delay: cardTossDuration*2.2)
            {
      
                if(self.playerOne.hand.isEmpty)
                {
                    self.endOfHand()
                }
                else
                {
                    self.playTrick(winner)
                }
        }
        self.tricksPile = []
    }
    
    func playTrick(playerWithTurn: CardPlayer)
    {
       
        if let computerPlayer = playerWithTurn as? ComputerPlayer
        {
            if let card = computerPlayer.playCard( self)
            {
                playTrickCard(playerWithTurn, trickcard:card)
                return
            
            }
            print(playerWithTurn.name + " has run out of cards - this shouldn't happen")
            endPlayersTurn(playerWithTurn)
        }
        else
        {
     
            self.bus.send(GameEvent.YourTurn)
        }
        
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

    public func dealNewCardsToPlayersThen(whenDone: () -> Void)
    {
   

        for (i,(player,hand)) in Zip2Sequence(players,dealtHands).enumerate()
        {
            scene?.schedule(delay: NSTimeInterval(i) * GameSettings.sharedInstance.tossDuration*1.2 + 0.1) {
            let sortedHand = hand.sort()
            player.newHand( Array(sortedHand.reverse()))
            }
     
        }
        scene?.schedule(delay: NSTimeInterval(players.count-1) * GameSettings.sharedInstance.tossDuration*1.2, handler: whenDone)
    }
}