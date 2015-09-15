//
//  CardPlayer.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 11/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import Foundation


public protocol CardHolder
{
    func cardsIn(suite:PlayingCard.Suite) -> [PlayingCard]
    var RicketyKate : PlayingCard? {get}
    var hand : [PlayingCard] { get }
    // return player.hand.filter {$0.suite == suite}
}


public protocol ICardPlayer
{
    var hand : [PlayingCard] {get set}
    var wonCards : [PlayingCard] {get set}
    var score : Int {get set}
    var name : String {get set}
    var sideOfTable : SideOfTable {get set}
    func clearHand()
    func newHand([PlayingCard])
    func resetScore()
}



public func ==(lhs: ICardPlayer, rhs: ICardPlayer) -> Bool
{

    return lhs.name == rhs.name
}

public func !=(lhs: ICardPlayer, rhs: ICardPlayer) -> Bool
{
    
    return lhs.name != rhs.name
}
public func ==(lhs: CardPlayer, rhs: CardPlayer) -> Bool
{
    
    return lhs.name == rhs.name
}


public class CardPlayer :ICardPlayer, CardHolder, Equatable, Hashable
{
    public var hand : [PlayingCard] = []
    public var wonCards : [PlayingCard] = []
    public var score : Int = 0
    public var sideOfTable = SideOfTable.Bottom
    public var name : String = "Base"
    public var hashValue: Int {
        return self.name.hashValue
    }

    init(name s: String) {
        self.name = s
    }
    public func clearHand()
    {
        hand  = [];
    }
    public func newHand(h: [PlayingCard]  )
    {
        hand  = h;
    }
    public func resetScore()
    {
        score = 0
    }
    
    public func cardsIn(suite:PlayingCard.Suite) -> [PlayingCard]
    {
    return hand.filter {$0.suite == suite}
    }
    public var RicketyKate : PlayingCard?
        {
            let RicketyKate = hand.filter { $0.isRicketyKate}
          
                return RicketyKate.first
          
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
    public init(name s: String,margin:Int) {
       super.init(name: s)
        strategies  = [
        EarlyGameLeadingStrategy(margin:margin),
        EarlyGameFollowingStrategy(margin:margin),
        LateGameLeadingStrategy.sharedInstance,
        LateGameFollowingStrategy.sharedInstance]
    }
    
}