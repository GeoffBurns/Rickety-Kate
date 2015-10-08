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
        case Stars
        case Trumps
        case Jokers
        case NoOfSuites
        

        var imageCode : String
        // Used to help create imagename for a card
        {
            switch(self)
            {
            case .Spades: return "S"
            case .Hearts: return "H"
            case .Clubs:  return "C"
            case .Diamonds: return "D"
            case .Suns: return "U"
            case .Anchors: return "A"
            case .Stars : return "R"
            case .Trumps : return "T"
            case .Jokers : return "J"
            case .NoOfSuites : return ""
            }
        }
        
        var description : String
            // Used to help create imagename for a card
            {
                switch(self)
                {
                case .Spades: return "Spades"
                case .Hearts: return "Hearts"
                case .Clubs:  return "Clubs"
                case .Diamonds: return "Diamonds"
                case .Suns: return "Suns"
                case .Anchors: return "Anchors"
                case .Stars : return "Stars"
                case .Trumps : return "Trumps"
                case .Jokers : return "Jokers"
                case .NoOfSuites : return "None"
                }
        }

        static var standardSuites : [Suite]
            {
                return [Spades,Hearts,Clubs,Diamonds]
        }
        static var normalSuites : [Suite]
        {
            return [Spades,Hearts,Clubs,Diamonds,Suns,Anchors,Stars]
        }
        static var allSuites : [Suite]
        {
            return [Spades,Hearts,Clubs,Diamonds,Suns,Anchors,Stars,Trumps,Jokers]
        }
    }
    public enum CardValue : Equatable, Comparable
    {
        case CourtCard(String)
        case Pip(Int)
        case Ace
        
        
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
        
        var description : String
        // Used to help create imagename for a card
            {
                switch(self)
                {
                case CourtCard(let cardLetter):
                    
                    switch cardLetter
                    {
                    case "J" : return "Jack"
                    case "KN" : return "Knight"
                    case "AR" : return "Archer"
                    case "PS" : return "Princess"
                    case "PR" : return "Prince"
                    case "Q" : return "Queen"
                    case "K" : return "King"
                    default : return "Page"
                    }
                case Pip(let faceValue): return faceValue.description
                case Ace: return "Ace"
                }
        }
        
        
        var rank : Int
        {
            switch(self)
            {
            case CourtCard(let cardLetter):
                
                switch cardLetter
                {
                case "K" : return 18
                case "Q" : return 17
                case "PR" : return 16
                case "PS" : return 15
                case "AR" : return 14
                case "KN" : return 13
                case "J" : return 12
                default: return 0
                }
                
            case Pip(let faceValue): return faceValue
            case Ace: return 19
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
        static var courtCardExtra5Values : [String]
        {
            return ["J","KN","PS","Q","K"]
        }
        static var courtCardExtra6Values : [String]
        {
            return ["J","KN","AR","PS","Q","K"]
        }
        static var courtCardExtra7Values : [String]
        {
            return ["J","KN","AR","PS","PR","Q","K"]
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
                case 16: return values16CardInASuite
                case 17: return values17CardInASuite
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
        static var values16CardInASuite : [CardValue]
        {
            
            var values = [Ace]
            for faceValue in 2...11
            {
                values.append(Pip(faceValue))
                
            }
            for cardLetter in courtCardExtra5Values
            {
                values.append(CourtCard(cardLetter))
                
            }
            return values
        }
        static var values17CardInASuite : [CardValue]
        {
            
            var values = [Ace]
            for faceValue in 2...11
            {
                values.append(Pip(faceValue))
                
            }
            for cardLetter in courtCardExtra6Values
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
    public var description : String
    // create description for a card
    {
       if suite == PlayingCard.Suite.Jokers
       {
        switch value.rank
         {
         case 0 : return "The Fool"
         case 1 : return "Joker (1)"
         case 2 : return "Joker (2)"
         default:
            return value.description + " of " +  suite.description
         }
       }
       return value.description + " of " +  suite.description
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
        var noInSuites = [13,13,13,13,13,13,13,22,3]
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
            var deck = [PlayingCard]();

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
        var gameSettings:IGameSettings = GameSettings.sharedInstance
        var suitesInDeck : [PlayingCard.Suite] = []
        public init(gameSettings:IGameSettings = GameSettings.sharedInstance )
        {
            self.gameSettings = gameSettings
        }
        
        
        override public var orderedDeck:[PlayingCard]
            {
                var deck = [PlayingCard]();
                var noOfPossibleCardsInDeck = (gameSettings.noOfSuitesInDeck * gameSettings.noOfCardsInASuite)
                if gameSettings.hasTrumps
                {
                  noOfPossibleCardsInDeck += 22
                }
                if gameSettings.hasJokers
                {
                    noOfPossibleCardsInDeck += 2
                }
                
                let toRemove = noOfPossibleCardsInDeck % gameSettings.noOfPlayersAtTable
                var removedCards = Set<PlayingCard>()
                let suites = PlayingCard.Suite.normalSuites[0..<gameSettings.noOfSuitesInDeck]
                suitesInDeck.appendContentsOf(suites)
                for s in suites
                {
                    noInSuites[s.rawValue]  = gameSettings.noOfCardsInASuite
                }
                
                var removedSoFar = 0
                var pip = 2
                /// Make sure than the cards divide evenly between the players by removing low value cards until the pack size is a multiple of the number of players
                repeat
                {
                  for s in suites
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
             
                for s in suites
                {
                    for v in PlayingCard.CardValue.valuesFor(gameSettings.noOfCardsInASuite)
                    {
                       let c = PlayingCard(suite: s, value: v)
                        if removedCards.contains(c)
                        {
                            continue
                        }
                        deck.append(c)
                    }
                }
                
                if gameSettings.hasTrumps
                {
                    deck.append(PlayingCard(suite: PlayingCard.Suite.Jokers, value : PlayingCard.CardValue.Pip(0)))
                    suitesInDeck.append(PlayingCard.Suite.Trumps)
                    for v in 1...21
                    {
                        deck.append(PlayingCard(suite: PlayingCard.Suite.Trumps, value : PlayingCard.CardValue.Pip(v)))
                    }
                }
                if gameSettings.hasJokers
                {
                    suitesInDeck.append(PlayingCard.Suite.Jokers)
                    for v in 1...2
                    {
                        deck.append(PlayingCard(suite: PlayingCard.Suite.Jokers, value : PlayingCard.CardValue.Pip(v)))
                    }
                }
                return deck
        }
    }
    
    public class TestCardDeck : DeckBase
    {
    var deck = [PlayingCard]();
        
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







