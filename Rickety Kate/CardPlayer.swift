//
//  CardPlayer.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 11/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit



public func ==(lhs: CardPlayer, rhs: CardPlayer) -> Bool
{
    return lhs.name == rhs.name
}

// Models the state and behaviour of each of the players in the game
public class CardPlayer :CardHolderBase,  CardHolder , Equatable, Hashable
{
    public var score : Int = 0
    public var sideOfTable = SideOfTable.Bottom
    public var name : String = "Base"
    var wonCards : CardPile = CardPile(name: CardPileType.Won.description)
    static let computerPlayers = [ComputerPlayer(name:"Fred",margin: 2),ComputerPlayer(name:"Molly",margin: 3),ComputerPlayer(name:"Greg",margin: 1),ComputerPlayer(name:"Sarah",margin: 4),ComputerPlayer(name:"Warren",margin: 5),ComputerPlayer(name:"Linda",margin: 3)]
    
    
    static func demoPlayers(noOfPlayers:Int) -> [CardPlayer]
    {
        return Array(computerPlayers[0..<noOfPlayers])
    }
    
    static func gamePlayers(noOfPlayers:Int) -> [CardPlayer]
    {
        let noOfComputerPlayers = noOfPlayers - 1
        return [HumanPlayer.sharedInstance] + Array(computerPlayers[0..<noOfComputerPlayers])
    }
    
    public var hashValue: Int {
        return self.name.hashValue
    }

    func setup(scene: SKNode, sideOfTable: SideOfTable)
    {
        self.sideOfTable = sideOfTable
        let isUp = sideOfTable == SideOfTable.Bottom
        _hand.setup(scene, sideOfTable: sideOfTable, isUp: isUp, sizeOfCards: isUp ? CardSize.Big : CardSize.Small)
        wonCards.setup(scene, direction: sideOfTable.direction, position: sideOfTable.positionOfWonCards(scene.frame.width, height: scene.frame.height))
    }
    
    init(name s: String) {
        self.name = s
    }

    public func newHand(cards: [PlayingCard]  )
    {
        _hand.replaceWithContentsOf(cards)
    }
    public func appendContentsToHand(cards: [PlayingCard]  )
    {
        _hand.appendContentsOf(cards);
    }

    public func resetScore()
    {
        score = 0
    }
    
    public func removeFromHand(card:PlayingCard) -> PlayingCard?
    {
      return _hand.remove(card)
    }
}

public class HumanPlayer :CardPlayer
{
    static let sharedInstance = HumanPlayer()
    private init() {

        super.init(name: "You")
    }
}

public class ComputerPlayer :CardPlayer
{
    
    var strategies : [TrickPlayingStrategy] = []
    var passingStrategy = HighestCardsPassingStrategy.sharedInstance
    public func playCard(gameState:GameState) -> PlayingCard?
    {
        for strategy in strategies
        {
            if let card : PlayingCard = strategy.chooseCard( self, gameState:gameState)
            {
                return card
            }
        }
        return RandomStrategy.sharedInstance.chooseCard(self,gameState:gameState)
    }
    public func passCards() -> [PlayingCard]
    {

        return passingStrategy.chooseWorstCards(self)
    }

    public init(name s: String,margin:Int) {
       super.init(name: s)
        strategies  = [
        EarlyGameLeadingStrategy(margin:margin),
        EarlyGameFollowingStrategy(margin:margin),
        LateGameLeadingStrategy.sharedInstance,
        LateGameFollowingStrategy.sharedInstance]
    }
    
}