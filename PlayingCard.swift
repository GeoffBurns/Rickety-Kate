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

extension Array {
    mutating func shuffleThis () {
        for i in stride(from:self.count-1, to:0, by:-1) {
            let ix1 = i
            let ix2 = Int(arc4random_uniform(UInt32(i+1)))
            (self[ix1], self[ix2]) = (self[ix2], self[ix1])
        }
    } }
extension Array {
    func shuffle () -> Array {
        var temp = self
        for i in stride(from:temp.count-1, to:0, by:-1) {
            let ix1 = i
            let ix2 = Int(arc4random_uniform(UInt32(i+1)))
            (temp[ix1], temp[ix2]) = (temp[ix2], temp[ix1])
        }
        return temp
    } }

public func < <T: RawRepresentable where T.RawValue: Comparable>(a: T, b: T) -> Bool {
    return a.rawValue < b.rawValue
}
public func <= <T: RawRepresentable where T.RawValue: Comparable>(a: T, b: T) -> Bool {
    return a.rawValue <= b.rawValue
}
public func >= <T: RawRepresentable where T.RawValue: Comparable>(a: T, b: T) -> Bool {
    return a.rawValue >= b.rawValue
}

public func > <T: RawRepresentable where T.RawValue: Comparable>(a: T, b: T) -> Bool {
    return a.rawValue > b.rawValue
}
public struct PlayingCard : Equatable, Comparable, Hashable
{
    
    public enum Suite : Int, Equatable, Comparable
    {
        case Spades
        case Hearts
        case Clubs
        case Diamonds
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
            }
        }
        static var standardSuites : [Suite]
            {
                return [Spades,Hearts,Clubs,Diamonds]
        }

    }
    public enum CardValue : Equatable, Comparable
    {
        case PictureCard(String)
        case NumberCard(Int)
        case Ace
        
        // TODO add more ValueType e.g.  TarotTrumps,  Jockers
        
       var imageCode : String
        // Used to help create imagename for a card
        {
            switch(self)
            {
            case PictureCard(let cardLetter): return cardLetter
            case NumberCard(let faceValue): return faceValue.description
            case Ace: return "A"
            }
        }
        static var standardValues : [CardValue]
        {
            
            var values = [Ace]
            for faceValue in 2...10
            {
                values.append(NumberCard(faceValue))
                
            }
            for cardLetter in ["J","Q","K"]
            {
                values.append(PictureCard(cardLetter))
                
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
    
    public class DeckBase : Deck
    {
        public var cards: [PlayingCard] {
           
            return orderedDeck.shuffle();
        }
        
        public func dealFor(numberOfPlayers:Int ) -> [[PlayingCard]]
        {
            var pack = cards;
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
 
}


public func ==(lhs: PlayingCard.CardValue, rhs: PlayingCard.CardValue) -> Bool {
    switch (lhs, rhs) {
    case let (.PictureCard(la), .PictureCard(ra)): return la == ra
    case let (.NumberCard(la), .NumberCard(ra)): return la == ra
    case (.Ace, .Ace): return true

    default: return false
    }
}

public func <=(lhs: PlayingCard.Suite, rhs: PlayingCard.Suite) -> Bool
{
    return lhs.rawValue <= rhs.rawValue
}
public func >=(lhs: PlayingCard.Suite, rhs: PlayingCard.Suite) -> Bool
{
    return lhs.rawValue >= rhs.rawValue
}
public func >(lhs: PlayingCard.Suite, rhs: PlayingCard.Suite) -> Bool
{
    return lhs.rawValue > rhs.rawValue
}

extension PlayingCard.Suite: Comparable {
    
}

func pictureLetterToRank(letter:String) -> Int
{
    switch letter
    {
    case "K" : return 13
    case "Q" : return 12
    case "J" : return 11
    default: return 0

    }
}

public func <=(lhs: PlayingCard.CardValue, rhs: PlayingCard.CardValue) -> Bool
{
    switch (lhs, rhs) {
    case (.Ace, .Ace): return true
    case (.Ace, _): return false
    case (_, .Ace): return true
    case let (.PictureCard(la), .PictureCard(ra)): return pictureLetterToRank(la) <= pictureLetterToRank(ra)
    case (.PictureCard, _): return false
    case let (.NumberCard(la), .NumberCard(ra)): return la <= ra
    default: return false
    }
}

public func >=(lhs: PlayingCard.CardValue, rhs: PlayingCard.CardValue) -> Bool
{
    switch (lhs, rhs) {
    case (.Ace, .Ace): return true
    case (.Ace, _): return true
    case (_, .Ace): return false
    case let (.PictureCard(la), .PictureCard(ra)): return pictureLetterToRank(la) >= pictureLetterToRank(ra)
    case (.PictureCard, _): return true
    case let (.NumberCard(la), .NumberCard(ra)): return la >= ra
    default: return false
    }
}
public func >(lhs: PlayingCard.CardValue, rhs: PlayingCard.CardValue) -> Bool
{
    switch (lhs, rhs) {
    case (.Ace, .Ace): return false
    case (.Ace, _): return true
    case (_, .Ace): return false
    case let (.PictureCard(la), .PictureCard(ra)): return pictureLetterToRank(la) > pictureLetterToRank(ra)
    case (.PictureCard, _): return true
    case let (.NumberCard(la), .NumberCard(ra)): return la > ra
    default: return false
    }
}
public func < (lhs: PlayingCard.CardValue, rhs: PlayingCard.CardValue) -> Bool
{
    switch (lhs, rhs) {
    case (.Ace, .Ace): return false
    case (.Ace, _): return false
    case (_, .Ace): return true
    case let (.PictureCard(la), .PictureCard(ra)): return pictureLetterToRank(la) < pictureLetterToRank(ra)
    case (.PictureCard, _): return false
    case let (.NumberCard(la), .NumberCard(ra)): return la < ra
    default: return false
    }
}
extension PlayingCard.CardValue: Comparable {
    
}

public func ==(lhs: PlayingCard, rhs: PlayingCard) -> Bool
{
    let areEqual = lhs.suite == rhs.suite &&
        lhs.value == rhs.value
    
    return areEqual
}
public func <=(lhs: PlayingCard, rhs: PlayingCard) -> Bool
{
    if(lhs.suite < rhs.suite)
    {
        return true
    }
    
    if(lhs.suite > rhs.suite)
    {
        return false
    }
    
    return lhs.value <= rhs.value

}
public func >=(lhs: PlayingCard, rhs: PlayingCard) -> Bool
{
    if(lhs.suite.rawValue < rhs.suite.rawValue)
    {
        return false
    }
    
    if(lhs.suite > rhs.suite)
    {
        return true
    }
    
    return lhs.value >= rhs.value
}
public func >(lhs: PlayingCard, rhs: PlayingCard) -> Bool
{
    if(lhs.suite.rawValue < rhs.suite.rawValue)
    {
        return false
    }
    
    if(lhs.suite > rhs.suite)
    {
        return true
    }
    
    return lhs.value  > rhs.value
}
public func <(lhs: PlayingCard, rhs: PlayingCard) -> Bool
{
    if(lhs.suite.rawValue < rhs.suite.rawValue)
    {
        return true
    }
    
    if(lhs.suite > rhs.suite)
    {
        return false
    }
    
    return lhs.value  > rhs.value
}

extension PlayingCard: Comparable {
    
}

