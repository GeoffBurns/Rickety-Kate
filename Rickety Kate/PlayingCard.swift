//
//  PlayingCard.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 11/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import Foundation

public protocol Deck
{
    var cards: [PlayingCard] {get}
    func dealFor(numberOfPlayers:Int) -> [[PlayingCard]]
}



public struct PlayingCard : Equatable, Comparable, Hashable
{
    
    public enum Suite : Int, Equatable, Comparable
    {
        case Spades
        case Hearts
        case Clubs
        case Diamonds
        case Suns
        case Anchors
        
        // TODO add more Suites e.g. Suns, Anchors (for 5 & 6 Suite Decks), TarotTrumps, NonSoite (for Jockers and Fools)
        var imageCode : String
        // Used to help create imagename for a card
        {
            switch(self)
            {
            case Spades: return "S"
            case Hearts: return "H"
            case Clubs:  return "C"
            case Diamonds: return "D"
            case Suns: return "U"
            case Anchors: return "A"
            }
        }
   
        static var standardSuites : [Suite]
            {
                return [Spades,Hearts,Clubs,Diamonds]
        }
        static var allSuites : [Suite]
        {
            return [Spades,Hearts,Clubs,Diamonds,Suns,Anchors]
        }

    }
    public enum CardValue : Equatable, Comparable
    {
        case Court(String)
        case Pip(Int)
        case Ace
        
        // TODO add more ValueType e.g.  TarotTrumps,  Jockers
        
       var imageCode : String
        // Used to help create imagename for a card
        {
            switch(self)
            {
            case Court(let cardLetter): return cardLetter
            case Pip(let faceValue): return faceValue.description
            case Ace: return "A"
            }
        }
        static var standardValues : [CardValue]
        {
            
            var values = [Ace]
            for faceValue in 2...10
            {
                values.append(Pip(faceValue))
                
            }
            for cardLetter in ["J","Q","K"]
            {
                values.append(Court(cardLetter))
                
            }
            return values
        }
    }
    
    public let suite: Suite
    public let value: CardValue
    
    public var imageName : String
    // create imagename for a card
    {
        return value.imageCode +  suite.imageCode
    }
    public var hashValue: Int
    {
            return imageName.hashValue;
    }
    
    public var isRicketyKate : Bool
    {
        return imageName == "QS"
    }
    
    public var isntRicketyKate : Bool
    {
        return imageName != "QS"
    }
    
    public class DeckBase : Deck
    {
        var noInSuites = [13,13,13,13,13,13]
        func noCardIn(suite:PlayingCard.Suite) -> Int
        {
            return noInSuites[suite.rawValue]
        }
        public var cards: [PlayingCard] {
           
            return orderedDeck.shuffle();
        }
        
        public func dealFor(numberOfPlayers:Int ) -> [[PlayingCard]]
        {
            let pack = cards;
            var hands: [[PlayingCard]] = [[PlayingCard]](count: numberOfPlayers, repeatedValue: [])
            
            var i:Int = 0
            for card in pack
            {
                hands[i].append(card)
                i++;
                if(i>=numberOfPlayers)
                {
                    i=0
                }
            }
            return hands
        }
        public var orderedDeck:[PlayingCard]
        // override in derived class
        {
            return [];
        }
    }
    public class Standard52CardDeck : DeckBase
    {
        
        public static let sharedInstance = Standard52CardDeck()
        override public var orderedDeck:[PlayingCard]
        {
            var deck: [PlayingCard] = [];

            for s in PlayingCard.Suite.standardSuites
            {
                for v in PlayingCard.CardValue.standardValues
                {
                   deck.append(PlayingCard(suite: s, value: v))
                }
            }
            return deck
        }
    }
    public class BuiltCardDeck : DeckBase
    {
        var noOfSuites = 0
        var noOfPlayers = 0
    
        
        init(noOfSuites:Int,noOfPlayers:Int)
        {
            self.noOfPlayers = noOfPlayers
            self.noOfSuites = noOfSuites
        }
        
        
        
        override public var orderedDeck:[PlayingCard]
            {
                var deck: [PlayingCard] = [];
                let removed = (noOfSuites * 13) % noOfPlayers
                var removedCards = Set<PlayingCard>()
                
                var i = 0
                var pip = 2
                repeat
                {
                for s in PlayingCard.Suite.allSuites
                {
                    if i >= removed
                    {
                        break
                    }
                    if s == PlayingCard.Suite.Spades
                    {
                        continue
                    }
                    removedCards.insert(PlayingCard(suite: s, value: PlayingCard.CardValue.Pip(pip)))
                    noInSuites[s.rawValue]  = noInSuites[s.rawValue] - 1
                    i++
                }
                 pip++
                }
                while i < removed 
                i = 0
                for s in PlayingCard.Suite.allSuites
                {
                    for v in PlayingCard.CardValue.standardValues
                    {
                       let c = PlayingCard(suite: s, value: v)
                        if removedCards.contains(c)
                        {
                            continue
                        }
                        deck.append(PlayingCard(suite: s, value: v))
                    }
                    i++
                    if(i >= noOfSuites)
                    {
                        break
                    }
                }
                return deck
        }
    }
    
    public class TestCardDeck : DeckBase
    {
    var deck: [PlayingCard] = [];
        
    public init(cards:[PlayingCard])
        {
            deck.appendContentsOf(cards)
        }
    override public var orderedDeck:[PlayingCard]
    {

    return deck

    }
    }
 
}







