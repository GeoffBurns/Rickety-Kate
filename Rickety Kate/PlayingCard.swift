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
        case CourtCard(String)
        case Pip(Int)
        case Ace
        
        // TODO add more ValueType e.g.  TarotTrumps,  Jockers
        
       var imageCode : String
        // Used to help create imagename for a card
        {
            switch(self)
            {
            case CourtCard(let cardLetter): return cardLetter
            case Pip(let faceValue): return faceValue.description
            case Ace: return "A"
            }
        }
        static var courtCard2Values : [String]
        {
            return ["Q","K"]
        }
        static var courtCardStandard3Values : [String]
        {
            return ["J","Q","K"]
        }
        static var courtCardExtra4Values : [String]
        {
            return ["J","KN","Q","K"]
        }
        static func valuesFor(noOfCardsInASuite:Int = 13) -> [CardValue]
        {
           switch noOfCardsInASuite
            {
                case 10: return values10CardInASuite
                case 11: return values11CardInASuite
                case 12: return values12CardInASuite
                case 14: return values14CardInASuite
                case 15: return values15CardInASuite
                default: return standardValues
            }
        }
        static var standardValues : [CardValue]
        {
            
            var values = [Ace]
            for faceValue in 2...10
            {
                values.append(Pip(faceValue))
                
            }
            for cardLetter in courtCardStandard3Values
            {
                values.append(CourtCard(cardLetter))
                
            }
            return values
        }
        static var values10CardInASuite : [CardValue]
        {
            
            var values = [Ace]
            for faceValue in 2...8
            {
                values.append(Pip(faceValue))
                
            }
            for cardLetter in courtCard2Values
            {
                values.append(CourtCard(cardLetter))
                
            }
            return values
        }
        static var values11CardInASuite : [CardValue]
        {
            
            var values = [Ace]
            for faceValue in 2...9
            {
                values.append(Pip(faceValue))
                
            }
            for cardLetter in courtCard2Values
            {
                values.append(CourtCard(cardLetter))
                
            }
            return values
        }
        static var values12CardInASuite : [CardValue]
        {
            
            var values = [Ace]
            for faceValue in 2...10
            {
                values.append(Pip(faceValue))
                
            }
            for cardLetter in courtCard2Values
            {
                values.append(CourtCard(cardLetter))
                
            }
            return values
        }
        static var values14CardInASuite : [CardValue]
        {
            
            var values = [Ace]
            for faceValue in 2...11
            {
                values.append(Pip(faceValue))
                
            }
            for cardLetter in courtCardStandard3Values
            {
                values.append(CourtCard(cardLetter))
                
            }
            return values
        }
        static var values15CardInASuite : [CardValue]
        {
            
            var values = [Ace]
            for faceValue in 2...11
            {
                values.append(Pip(faceValue))
                
            }
            for cardLetter in courtCardExtra4Values
            {
                values.append(CourtCard(cardLetter))
                
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
        var noInSuites = [13,13,13,13,13,13,13]
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
        var noOfCardsInASuite = 0
    
        
        override init()
        {
            self.noOfPlayers = GameSettings.sharedInstance.noOfPlayersAtTable
            self.noOfSuites = GameSettings.sharedInstance.noOfSuitesInDeck
            self.noOfCardsInASuite = GameSettings.sharedInstance.noOfCardsInASuite
        }
        
        
        override public var orderedDeck:[PlayingCard]
            {
                var deck: [PlayingCard] = [];
                let toRemove = (noOfSuites * self.noOfCardsInASuite) % noOfPlayers
                var removedCards = Set<PlayingCard>()
                for s in PlayingCard.Suite.allSuites
                {
                    noInSuites[s.rawValue]  = self.noOfCardsInASuite
                }
                
                var removedSoFar = 0
                var pip = 2
                /// Make sure than the cards divide evenly between the players by removing low value cards until the pack size is a multiple of the number of players
                repeat
                {
                  for s in PlayingCard.Suite.allSuites
                  {
                    if removedSoFar >= toRemove
                    {
                        break
                    }
                    if s == PlayingCard.Suite.Spades
                    {
                        continue
                    }
                    removedCards.insert(PlayingCard(suite: s, value: PlayingCard.CardValue.Pip(pip)))
                    noInSuites[s.rawValue]  = noInSuites[s.rawValue] - 1
                    removedSoFar++
                  }
                  pip++
                }
                while removedSoFar < toRemove
             
                for s in  PlayingCard.Suite.allSuites[0..<noOfSuites]
                {
                    for v in PlayingCard.CardValue.valuesFor(noOfCardsInASuite)
                    {
                       let c = PlayingCard(suite: s, value: v)
                        if removedCards.contains(c)
                        {
                            continue
                        }
                        deck.append(PlayingCard(suite: s, value: v))
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







