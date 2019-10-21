//
//  RicketyKateCardTable.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 18/10/19.
//  Copyright © 2019 Geoff Burns All rights reserved.
//
import SpriteKit
import Cards

/// controls the flow of the game
open class RicketyKateCardTable : CardTable, GameState
{

    let bus = Bus.sharedInstance



    static public func makeTable(_ scene:CardScene, gameSettings: IGameSettings = Game.moreSettings ) -> RicketyKateCardTable {
     return RicketyKateCardTable(players: CardPlayer.gamePlayers(gameSettings.noOfPlayersAtTable), scene:scene)
}

    static public func makeDemo(_ scene:CardScene, gameSettings: IGameSettings = Game.moreSettings ) -> RicketyKateCardTable  {
     return RicketyKateCardTable(players: CardPlayer.demoPlayers(gameSettings.noOfPlayersAtTable), scene:scene )
    }
    fileprivate override init(players: [CardPlayer],  scene:CardScene) {

    Scorer.sharedInstance.setupScorer(players)
    super.init(players: players,scene: scene)

    }
    

     //////////
    // GameState Protocol
    //////////


    open var unplayedCardsInTrick : Int
    {
    return  noOfPlayers - playedCardsInTrick
    }
    
    open var isLastPlayer : Bool {
     return tricksPile.count >= noOfPlayers - 1
    }
    
    //////////
    // internal functions
    //////////

    
    func addToTrickPile(_ player:CardPlayer,trickcard:PlayingCard)
    {
        if let card = player.removeFromHand(trickcard),
            let displayedCard = scene!.cardSpriteNamed(card.imageName)
        {
            
           
            self.gameTracker.trackProgress(tricksPile.first,player:player, playedCard:displayedCard.card)
            
            displayedCard.player=player
            let playedCard = displayedCard.card
            tricksPile.append(TrickPlay(player:player,playedCard:playedCard))
            
        }
    }
    
    func isMoveValid(_ player:CardPlayer,card:PlayingCard) -> Move
    {
     
        if self.tricksPile.isEmpty
        {
            
            if !gameTracker.trumpsHaveBeenBroken &&
               !Game.moreSettings.allowBreakingTrumps &&
               card.suite == Game.moreSettings.rules.trumpSuite
            
            {
                return Move.trumpsHaveNotBeenBroken
            }
            
            return Move.cardPlayed(player, card)
        }
        if let trick = self.tricksPile.first
        {
            let leadingSuite = trick.playedCard.suite
            let cardsInSuite = player.hand.filter { $0.suite == leadingSuite}
            
            /// If the player has no cards in the suite they do not need to follow
            if cardsInSuite.isEmpty || card.suite == leadingSuite  {
                return Move.cardPlayed(player, card)
            }
            if let cardScene = scene {
            
            for card in cardsInSuite {
                if let sprite =  cardScene.cardSprite(card,isUp: true)  {
                    sprite.tintGreen()
                }
            }
            
            if let displayedCard = cardScene.cardSprite(card) {
               displayedCard.tintRed()
                }
            }
            
            return Move.cardDoesNotFollowSuite(leadingSuite)
        }
        
        /// Shoold never get here
        print("trick pile is non empty and has on first")
        return Move.cardPlayed(player, card)
    }
    
    func playTrickCard(_ playerWithTurn:CardPlayer, trickcard:PlayingCard)
    {
        addToTrickPile(playerWithTurn,trickcard: trickcard)
        endPlayersTurn(playerWithTurn)
    }


func nextPlayerAfter(_ playerWithTurn:CardPlayer) -> CardPlayer
{
    var nextNo = playerWithTurn.playerNo + 1
    if nextNo >= noOfPlayers
    {
        nextNo = 0
    }
    return self.players[nextNo]
}
    
func endPlayersTurn(_ playerWithTurn:CardPlayer)
    {

        let nextPlayer = nextPlayerAfter(playerWithTurn)
        
        if let trick = tricksPile.first
          {
          let firstNo = trick.player.playerNo
          if firstNo == nextPlayer.playerNo
            {
            scene!.schedule(delay: cardTossDuration*1.1) {
                self.trickWon()
               }
            
            } else {
            
           
               scene!.schedule(delay: cardTossDuration*1.1) {
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
        self.startPlayerNo += 1
        if self.startPlayerNo >= self.noOfPlayers
        {
            self.startPlayerNo = 0
        }

        _ = Scorer.sharedInstance.hasShotTheMoon()
        Scorer.sharedInstance.endHand()

        Scorer.sharedInstance.hasGameBeenWon()
        
        self.gameTracker.reset()
        
        if let cardscene = scene! as? CardGameScene
        {
        hideCards()
        cardscene.redealThen(self.redealHands())
            {
              dealtPiles in
                
            self.dealNewCardsToPlayersThen(dealtPiles) {
                self.bus.send(GameEvent.newHand)
            }
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
    func removeTricksPile(_ winner:CardPlayer)
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
    
    func playTrick(_ playerWithTurn: CardPlayer)
    {
        self.bus.send(GameEvent.turnFor(playerWithTurn))
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
    if let human = playerWithTurn as? HumanPlayer
    {
        if gameSettings.noOfHumanPlayers > 1 && human.sideOfTable != SideOfTable.bottom
        {
           reseatPlayers(human.playerNo)
        }
        
    }
    }


   
    func playerThatWon() -> CardPlayer?
    {
        if let winningPlay = self.tricksPile.winningPlay
        {
           return winningPlay.player
        }
        return nil
    }
    func setupCardPilesSoPlayersCanPlayTricks()
    {
        trickFan.setup(scene!)
        trickFan.seat(sideOfTable: SideOfTable.center, isUp: true, sizeOfCards: CardSize.medium)
    }

    open func dealNewCardsToPlayersThen(_ dealtPiles: [CardPile], whenDone: @escaping () -> Void)
    {
   

        for (i,(player,pile)) in zip(players,dealtPiles).enumerated()
        {
            scene?.schedule(delay: TimeInterval(i) * Game.settings.tossDuration*1.2 + 0.1) {
            let sortedHand = pile.cards.sorted()
            pile.clear()
            player.newHand( Array(sortedHand.reversed()))
            }
     
        }
        scene?.schedule(delay: TimeInterval(players.count-1) * Game.settings.tossDuration*1.2, handler: whenDone)
    }
}

