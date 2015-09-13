//
//  CardPlayer.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 11/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import Foundation


extension Array {
    var randomItem: T? {
        
    let count = self.count
        
    switch self.count
        {
        case 0 : return nil
        case 1 : return self.first
        default :
  
            let index = Int(arc4random_uniform(UInt32(self.count)))
            return self[index]
        }
    }
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


public class CardPlayer :ICardPlayer, Equatable, Hashable
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
}

public class HumanPlayer :CardPlayer
{
    static let sharedInstance = HumanPlayer()
    private init() {

        super.init(name: "You")
    }
}

protocol TrickPlayingStrategy
{
    func chooseCard(stateOfPlay:StateOfPlay,player:CardPlayer,table:CardTable) -> PlayingCard?
  
}
public class RandomStrategy : TrickPlayingStrategy
{
    static let sharedInstance = RandomStrategy()
    private init() { }
    func chooseCard(stateOfPlay:StateOfPlay,player:CardPlayer,table:CardTable) -> PlayingCard?
    {
        if let suite: PlayingCard.Suite = stateOfPlay.leadingSuite
        {
            var validCards = player.hand.filter {$0.suite == suite}
            if let choosenCard:PlayingCard = validCards.randomItem
            {
                return choosenCard
            }
        }
        // no leading suite or player has no cards in leading suite
         return player.hand.randomItem
    }
}
// Todo finish this strategy
public class EarlyGameLeadingStrategy : TrickPlayingStrategy
{
    static let sharedInstance = EarlyGameLeadingStrategy()
    private init() { }
    func chooseCard(stateOfPlay:StateOfPlay,player:CardPlayer,table:CardTable) -> PlayingCard?
    {

            return nil

        
    }
}
// Todo finish this strategy
public class EarlyGameFollowingStrategy : TrickPlayingStrategy
{
    static let sharedInstance = LateGameFollowingStrategy()
    private init() { }
    func chooseCard(stateOfPlay:StateOfPlay,player:CardPlayer,table:CardTable) -> PlayingCard?
    {
        
        return nil
        
        
    }
}
public class LateGameLeadingStrategy : TrickPlayingStrategy
{
    static let sharedInstance = LateGameLeadingStrategy()
    private init() { }
    func chooseCard(stateOfPlay:StateOfPlay,player:CardPlayer,table:CardTable) -> PlayingCard?
    {
        if(!table.tricksPile.isEmpty)
        {
          return nil
        }
        let orderedCards = sorted(player.hand,{$0.value < $1.value})
        
        return orderedCards.first

    }
}

public class LateGameFollowingStrategy : TrickPlayingStrategy
{
    static let sharedInstance = LateGameFollowingStrategy()
    private init() { }
    func chooseCard(stateOfPlay:StateOfPlay,player:CardPlayer,table:CardTable) -> PlayingCard?
    {
        if let suite = stateOfPlay.leadingSuite
        {
            let cardsInSuite = player.hand.filter { $0.suite == suite}
            let canFollowSuite = !cardsInSuite.isEmpty
            if(canFollowSuite)
            {
                let pileInSuite = table.tricksPile.filter { $0.playedCard.suite == suite }
                let orderedPile = sorted(pileInSuite,{$0.playedCard.value > $1.playedCard.value})
                let highCard = orderedPile.first!.playedCard
                
                let cardsLessThanHighCard = cardsInSuite.filter { $0.value < highCard.value }
                let canGoLow = !cardsLessThanHighCard.isEmpty
                if canGoLow
                {
                    let orderedLowCards = sorted(cardsLessThanHighCard,{$0.value > $1.value})
                    return orderedLowCards.first
                }
                else
                {
                    let isLastPlayer = table.tricksPile.count >= 3
                    if isLastPlayer
                    {
                        let orderedCards = sorted(cardsInSuite,{$0.value > $1.value})
                        return orderedCards.first
                    }
                    let reverseOrderedCards = sorted(cardsInSuite,{$0.value < $1.value})
                    return reverseOrderedCards.first
                }
            }
       
                let RicketyKate = player.hand.filter { $0.imageName == "QS"}
                if !RicketyKate.isEmpty
                {
                    return RicketyKate.first
                }
                 let Spades = player.hand.filter { $0.suite == PlayingCard.Suite.Spades }
                if !Spades.isEmpty
                {
                    let orderedSpades = sorted(Spades,{$0.value > $1.value})
                    return orderedSpades.first
                }
                let orderedHand = sorted(player.hand,{$0.value > $1.value})
                
                return orderedHand.first
           
      
        
        }
        
        return nil
    }
    
}
public class ComputerPlayer :CardPlayer
{

    var strategies : [TrickPlayingStrategy] = [
  /*      EarlyGameLeadingStrategy.sharedInstance,
        EarlyGameFollowingStrategy.sharedInstance,*/
        LateGameLeadingStrategy.sharedInstance,
        LateGameFollowingStrategy.sharedInstance]
    
    public func playCard(stateOfPlay:StateOfPlay,table:CardTable) -> PlayingCard?
    {
        for strategy in strategies
        {
            if let card : PlayingCard = strategy.chooseCard(stateOfPlay, player: self,table:table)
            {
                return card
            }
        }
        return RandomStrategy.sharedInstance.chooseCard(stateOfPlay, player: self,table:table)
    }
    public override init(name s: String) {
       super.init(name: s)
    }
    
}