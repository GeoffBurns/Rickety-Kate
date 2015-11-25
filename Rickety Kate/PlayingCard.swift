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
        case Picks
        case Trumps
        case Jokers
        case NoOfSuites
        case None
        
        
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
                case .Picks : return "P"
                case .Trumps : return "T"
                case .Jokers : return "J"
                case .NoOfSuites : return ""
                case .None : return ""
                }
        }
        
        var description : String
            // Used to help create imagename for a card
            {
                switch(self)
                {
                case .Spades: return "Spades".localize
                case .Hearts: return "Hearts".localize
                case .Clubs:  return "Clubs".localize
                case .Diamonds: return "Diamonds".localize
                case .Suns: return "Suns".localize
                case .Anchors: return "Anchors".localize
                case .Stars : return "Stars".localize
                case .Picks : return "Picks".localize
                case .Trumps : return "Trumps".localize
                case .Jokers : return "Jokers".localize
                case .NoOfSuites : return "Not_Applicable".localize
                case .None : return "None".localize
                }
        }
        
        static var standardSuites : [Suite]
        {
            return [Spades,Hearts,Clubs,Diamonds]
        }
        static var normalSuites : [Suite]
        {
            return [Spades,Hearts,Clubs,Diamonds,Suns,Anchors,Stars,Picks]
        }
        static var allSuites : [Suite]
        {
            return [Spades,Hearts,Clubs,Diamonds,Suns,Anchors,Stars,Picks,Trumps,Jokers]
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
        var localLetterRaw : String
        {
                switch(self)
                {
                case CourtCard(let cardLetter):
                    
                    switch cardLetter
                    {
                    case "J" : return "Jack_Letter".localize
                    case "KN" : return "Knight_Letter".localize
                    case "AR" : return "Archer_Letter".localize
                    case "PS" : return "Princess_Letter".localize
                    case "PR" : return "Prince_Letter".localize
                    case "Q" : return "Queen_Letter".localize
                    case "K" : return "King_Letter".localize
                    default : return ""
                    }
                default : return ""
                }
        }
        var localLetter : String
        {
            let raw = localLetterRaw

            if raw == "" { return ""}
            switch(self)
               {
               case CourtCard(let cardLetter):
                      return cardLetter==raw ? "" : raw
               default : return ""
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
                    case "J" : return "Jack".localize
                    case "KN" : return "Knight".localize
                    case "AR" : return "Archer".localize
                    case "PS" : return "Princess".localize
                    case "PR" : return "Prince".localize
                    case "Q" : return "Queen".localize
                    case "K" : return "King".localize
                    default : return "Page".localize
                    }
                case Pip(let faceValue):
                    switch faceValue
                    {
                    case 2 : return "Deuce".localize
                    case 3 : return "Three".localize
                    case 4 : return "Four".localize
                    case 5 : return "Five".localize
                    case 6 : return "Six".localize
                    case 7 : return "Seven".localize
                    case 8 : return "Eight".localize
                    case 9 : return "Nine".localize
                    case 10 : return "Ten".localize
                    case 11 : return "Eleven".localize
                    default : return faceValue.description
                    }
                case Ace: return "Ace".localize
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
            case 18: return values18CardInASuite
            default: return standardValues
            }
        }
        static var standardValues : [CardValue] {
            return [Ace] + (2...10).map { Pip($0) } + ["J","Q","K"].map { CourtCard($0) }
        }
        static var values10CardInASuite : [CardValue] {
            return [Ace] + (2...7).map { Pip($0) } + ["J","Q","K"].map { CourtCard($0) }
        }
        static var values11CardInASuite : [CardValue] {
            return [Ace] + (2...8).map { Pip($0) } + ["J","Q","K"].map { CourtCard($0) }
        }
        static var values12CardInASuite : [CardValue] {
            return [Ace] + (2...9).map { Pip($0) } + ["J","Q","K"].map { CourtCard($0) }
        }
        static var values14CardInASuite : [CardValue] {
            return [Ace] + (2...11).map { Pip($0) } + ["J","Q","K"].map { CourtCard($0) }
        }
        static var values15CardInASuite : [CardValue] {
            return [Ace] + (2...11).map { Pip($0) } + ["J","KN","Q","K"].map { CourtCard($0) }
        }
        static var values16CardInASuite : [CardValue] {
            return [Ace] + (2...11).map { Pip($0) } + ["J","KN","PS","Q","K"].map { CourtCard($0) }
        }
        static var values17CardInASuite : [CardValue] {
            return [Ace] + (2...11).map { Pip($0) } + ["J","KN","AR","PS","Q","K"].map { CourtCard($0) }
        }
        static var values18CardInASuite : [CardValue]{
            return [Ace] + (2...11).map { Pip($0) } + ["J","KN","AR","PS","PR","Q","K"].map { CourtCard($0) }
        }
    }
    
    public let suite: Suite
    public let value: CardValue
    
    public var imageName : String
        // create imagename for a card
        {
            return value.imageCode +  suite.imageCode
    }
    public var whiteImageName : String
        // create imagename for a card
        {
            return imageName +  "_"
    }
    public var description : String
        // create description for a card
        {
            switch(suite)
            {
            case PlayingCard.Suite.Jokers:
                switch value.rank
                {
                case 0 : return "Fool".localize
                case 1 : return "Joker1".localize
                case 2 : return "Joker2".localize
                default:
                    return  "_ of _".localizeWith(value.description,suite.description)
                }
            case PlayingCard.Suite.Trumps:
                switch value.rank
                {
                case 1 : return "Magician".localize
                case 2 : return "Priestess".localize
                case 3 : return "Empress".localize
                case 4 : return "Emperor".localize
                case 5 : return "Hierophant".localize
                case 6 : return "Lovers".localize
                case 7 : return "Chariot".localize
                case 8 : return "Strength".localize
                case 9 : return "Hermit".localize
                case 10 : return "Fortune".localize
                case 11 : return "Justice".localize
                case 12 : return "Hanged_Man".localize
                case 13 : return "Death".localize
                case 14 : return "Temperance".localize
                case 15 : return "Devil".localize
                case 16 : return "Tower".localize
                case 17 : return "The_Star".localize
                case 18 : return "Moon".localize
                case 19 : return "The_Sun".localize
                case 20 : return "Judgement".localize
                case 21 : return "World".localize
                default:
                    return  "_ of _".localizeWith(value.description,suite.description)
                }
            default:
                return  "_ of _".localizeWith(value.description,suite.description)
            }
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
            return !isRicketyKate
    }
    
    public class DeckBase : Deck
    {
        var noInSuites = [13,13,13,13,13,13,13,13,21,3]
        func noCardIn(suite:PlayingCard.Suite) -> Int
        {
            return noInSuites[suite.rawValue]
        }
        func middleCardIn(suite:PlayingCard.Suite) -> PlayingCard
        {
            return PlayingCard(suite:suite,value:PlayingCard.CardValue.Pip((noInSuites[suite.rawValue]+1)/2))
        }
        func lowerMiddleCardIn(suite:PlayingCard.Suite) -> PlayingCard
        {
            return PlayingCard(suite:suite,value:PlayingCard.CardValue.Pip((noInSuites[suite.rawValue]-1)/2))
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
        var gameSettings:IGameSettings? = nil
        public var setOfSuitesInDeck = Set<PlayingCard.Suite>()
        public var suitesInDeck : [PlayingCard.Suite] = []
        public var normalSuitesInDeck : [PlayingCard.Suite] = []
    
        var noOfPossibleCardsInDeck : Int {
            var result = (gameSettings!.noOfSuitesInDeck * gameSettings!.noOfCardsInASuite)
             if gameSettings!.hasTrumps
                {
                result += 22
                }
             if gameSettings!.hasJokers
                 {
                 result += 2
                 }
            return result
        }
        public init(gameSettings:IGameSettings )
        {
            self.gameSettings = gameSettings
            normalSuitesInDeck = Array(PlayingCard.Suite.normalSuites[0..<gameSettings.noOfSuitesInDeck])
            suitesInDeck = normalSuitesInDeck
            if gameSettings.hasTrumps
            {
                suitesInDeck.append(PlayingCard.Suite.Trumps)
               
            }
            if gameSettings.hasJokers
            {
                suitesInDeck.append(PlayingCard.Suite.Jokers)
        
            }
            
            setOfSuitesInDeck = Set<PlayingCard.Suite>(suitesInDeck)
            
        }
        
        func calculateNoOfCardsInEachSuite()
        {
            for s in normalSuitesInDeck
            {
                noInSuites[s.rawValue]  = gameSettings!.noOfCardsInASuite
            }
            noInSuites[PlayingCard.Suite.Jokers.rawValue] = 0
            if gameSettings!.hasTrumps
            {
                noInSuites[PlayingCard.Suite.Trumps.rawValue] = 21
                noInSuites[PlayingCard.Suite.Jokers.rawValue] = 1
            }
            if gameSettings!.hasJokers
            {
                noInSuites[PlayingCard.Suite.Jokers.rawValue]  += 2
            }
        }
        override public var orderedDeck:[PlayingCard]
            {
                var deck = [PlayingCard]();
       
                calculateNoOfCardsInEachSuite()
                
                let toRemove = gameSettings!.makeDeckEvenlyDevidable
                                   ? noOfPossibleCardsInDeck % gameSettings!.noOfPlayersAtTable
                                   : 0
                
                var removedCards = Set<PlayingCard>()
                var removedSoFar = 0
                
                var pip = 2
                /// Make sure than the cards divide evenly between the players by removing low value cards until the pack size is a multiple of the number of players
                repeat
                {
                  for s in normalSuitesInDeck
                  {
                    if removedSoFar >= toRemove
                    {
                        break
                    }
                    if s == gameSettings!.rules.trumpSuite
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
             
                for s in normalSuitesInDeck
                {
                    for v in PlayingCard.CardValue.valuesFor(gameSettings!.noOfCardsInASuite)
                    {
                       let c = PlayingCard(suite: s, value: v)
                        if removedCards.contains(c)
                        {
                            continue
                        }
                        deck.append(c)
                    }
                }
                
                if gameSettings!.hasTrumps
                {
                    deck.append(PlayingCard(suite: PlayingCard.Suite.Jokers, value : PlayingCard.CardValue.Pip(0)))
                    for v in 1...21
                    {
                        deck.append(PlayingCard(suite: PlayingCard.Suite.Trumps, value : PlayingCard.CardValue.Pip(v)))
                    }
                }
                if gameSettings!.hasJokers
                {
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


extension Int
{
    public func of(suite :PlayingCard.Suite) -> PlayingCard
    {
        return PlayingCard(suite: suite,value: cardValue)
    }
    
    public var cardValue : PlayingCard.CardValue
    {
        return PlayingCard.CardValue.Pip(self)
    }
}

public enum CardName
{
    case Ace
    case King
    case Queen
    case Prince
    case Princess
    case Archer
    case Knight
    case Jack
    
    public var letter : String
        {
            switch(self)
            {
            case .Ace :
                return "A"
            case .King :
                return "K"
            case .Queen :
                return "Q"
            case .Prince :
                return "PR"
            case .Princess :
                return "PS"
            case .Archer :
                return "AR"
            case .Knight :
                return "KN"
            case .Jack :
                return "J"
            } 
    }
    public var cardValue : PlayingCard.CardValue
        {
            switch(self)
            {
            case Ace :
                return PlayingCard.CardValue.Ace
            default :
                 return PlayingCard.CardValue.CourtCard(letter)
            }
    }

    public func of(suite :PlayingCard.Suite) -> PlayingCard?
    {
        return PlayingCard(suite: suite,value: cardValue)

    }
}




