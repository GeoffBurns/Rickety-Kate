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

public class CardPlayer :CardHolderBase,  CardHolder , Equatable, Hashable
{
    public var score : Int = 0
    public var sideOfTable = SideOfTable.Bottom
    public var name : String = "Base"
    var wonCards : CardFan = CardFan()
    
    public var hashValue: Int {
        return self.name.hashValue
    }

    func setup(scene: SKNode, sideOfTable: SideOfTable)
    {
        self.sideOfTable = sideOfTable
        let isUp = sideOfTable == SideOfTable.Bottom
        _hand.setup(scene, sideOfTable: sideOfTable, isUp: isUp, isBig: isUp)
        wonCards.setup(scene, direction: sideOfTable.direction, position: sideOfTable.positionOfWonCards(scene.frame.width, height: scene.frame.height), isUp: false, isBig: false)
    }
    
    init(name s: String) {
        self.name = s
    }

    public func newHand(h: [PlayingCard]  )
    {
        hand  = h;
    }
    public func resetScore()
    {
        score = 0
    }
    
    public func removeFromHand(card:PlayingCard) -> PlayingCard?
    {
    if let index = _hand.cards.indexOf(card)
        {
            return _hand.cards.removeAtIndex(index)
         }
    return nil
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