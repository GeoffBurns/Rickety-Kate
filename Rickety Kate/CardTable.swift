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


public class CardTable : GameStateEngine, GameState
{
    lazy var deck: Deck = PlayingCard.BuiltCardDeck()
    var playerOne: CardPlayer = HumanPlayer.sharedInstance;
    var _players: [CardPlayer] = []

    // if non-nil StateOfPlay is frozen awaiting user input
    var currentStateOfPlay:StateOfPlay? = nil
    var cardTossDuration = Double(0.7)


    var newGame :  Publink<Void> =  Publink<Void>()
    var resetGame :  Publink<Void> =  Publink<Void>()
 
    var isInDemoMode = false
    func nop() {}
 
    var startPlayerNo = 1
    let cardScale = CGFloat(0.9)
    let cardScaleForSelected = CGFloat(1.05)
    var cardsPassed : [CardFan] = []

    
    public var players : [CardPlayer] {
        get {
            return _players
        }
        
    }
    
 
    static public func makeTable() -> CardTable {
     return CardTable(players: CardPlayer.gamePlayers(GameSettings.sharedInstance.noOfPlayersAtTable))
}

    static public func makeDemo() -> CardTable  {
     return CardTable(players: CardPlayer.demoPlayers(GameSettings.sharedInstance.noOfPlayersAtTable))
    }
    private init(players: [CardPlayer]) {
    _players = players
    playerOne = _players[0]
    isInDemoMode = playerOne.name != "You"

    Scorer.sharedInstance.setupScorer(_players)
    super.init()
    setPassedCards()
    }
    
    // everyone except PlayerOne
    var otherPlayers : [CardPlayer]
    {
        return players.filter {$0 != self.playerOne}
    }
    
    func setPassedCards()
    {
        for _ in _players
        {
            cardsPassed.append(CardFan())
        }
    }
    func resetPassedCards()
    {
        var i = 0
        for _ in _players
        {
            cardsPassed[i].cards = []
            i++
        }
    }
    func setupPassedCards(scene:SKNode)
    {
       for (passFan,player) in Zip2Sequence( cardsPassed, players )
       {
        let side = player.sideOfTable
        let center = player.sideOfTable.center
        passFan.setup(scene, sideOfTable: center, isUp: side == SideOfTable.Bottom, isBig: false)
        }
       trickFan.setup(scene, sideOfTable: SideOfTable.Center, isUp: true, isBig: false)
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
        
       let sideOfTable = winner.sideOfTable
      
        var parent: SKNode? = nil
        for trick in self.tricksPile
        {
            let card =  trick.playedCard
            let sprite =  CardSprite.sprite(card)
            
                if parent == nil{
                    parent = sprite.parent
                }
      /*
            sprite.runAction(SKAction.sequence([SKAction.waitForDuration(cardTossDuration), SKAction.runBlock({
                winner.wonCards.cards.append(card)
            })]))
            */
          
            let moveAction = (SKAction.moveTo(sideOfTable.positionOfWonCards( sprite.parent!.frame.width, height: sprite.parent!.frame.height), duration:(cardTossDuration)))
            
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
        
        let noOfPlayer = players.count
        for (next,toPlayer) in  Zip2Sequence(0...10,players)
        {

            var previous = next - 1
            if previous < 0
            {
                previous = noOfPlayer - 1
            }
            
            let fromPlayersCards = cardsPassed[previous].cards
           
            
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
    
    
    func nextPlayerAction(state:StateOfPlay, currentSuite:PlayingCard.Suite?) -> SKAction
    {
        var remainingPlayers = state.remainingPlayers
        remainingPlayers.removeAtIndex(0)
        let nextPlayers = remainingPlayers
        let doneAction = nextPlayers.isEmpty ?
            (SKAction.runBlock({
                self.trickWon()
            })) :
            
            (SKAction.runBlock({
                
                self.playTrick(StateOfPlay(remainingPlayers: nextPlayers))
            }))
        
        return doneAction
    }
    func playTrickCard(playerWithTurn:CardPlayer, trickcard:PlayingCard,state:StateOfPlay, willAnimate:Bool = true)
    {
        addToTrickPile(playerWithTurn,cardName: trickcard.imageName)
        
        let displayedCard = CardSprite.sprite(trickcard)
        
        let doneAction =  nextPlayerAction(state , currentSuite: trickcard.suite)
       
        let  moveActionWithDone = SKAction.sequence([
                        SKAction.waitForDuration(cardTossDuration*2.0),
                        doneAction])
        displayedCard.runAction(moveActionWithDone)
        }
    
    func passCard(seatNo:Int, passedCard:PlayingCard) -> PlayingCard?
    {
    let displayed = CardSprite.sprite(passedCard)
     
           if let removedCard = players[seatNo].removeFromHand(displayed.card)
            {
            self.cardsPassed[seatNo].cards.append(removedCard)
            return removedCard
            }
     
        return nil
    }
    func passOtherCards()
    {
       for (i,player) in  Zip2Sequence(0...10,players)
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