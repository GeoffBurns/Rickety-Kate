//
//  PlayingCard.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 11/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import UIKit

public protocol Deck
{
    var cards: [PlayingCard] {get}
    func dealFor(_ numberOfPlayers:Int) -> [[PlayingCard]]
}

extension UIColor
{
    class func colorFromHexString(_ hexString: String) -> UIColor
    {
        if let rgbValue = UInt32(hexString, radix: 16)
        {
            let red : CGFloat = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green : CGFloat = CGFloat((rgbValue & 0xFF00) >> 8) / 255.0
            let blue : CGFloat  = CGFloat(rgbValue & 0xFF) / 255.0
            return UIColor(red:red, green:green, blue:blue, alpha:1.0);
        }
        return UIColor.black
    }
}

public struct PlayingCard : Equatable, Comparable, Hashable
{
    
    public enum Suite : Int, Equatable, Comparable
    {
        case spades
        case hearts
        case clubs
        case diamonds
        case suns
        case anchors
        case stars
        case picks
        case trumps
        case jokers
        case noOfSuites
        case none
        
        
        var imageCode : String
            // Used to help create imagename for a card
            {
                switch(self)
                {
                case .spades: return "S"
                case .hearts: return "H"
                case .clubs:  return "C"
                case .diamonds: return "D"
                case .suns: return "U"
                case .anchors: return "A"
                case .stars : return "R"
                case .picks : return "P"
                case .trumps : return "T"
                case .jokers : return "J"
                case .noOfSuites : return ""
                case .none : return ""
                }
        }
        var isLight : Bool
        {
            switch(self)
            {
            case .hearts: return true
            case .diamonds: return true
            case .suns: return true
            case .stars : return true
            default : return false
            }
        }
        var isDark : Bool
        {
            switch(self)
            {
            case .spades: return true
            case .clubs: return true
            case .anchors: return true
            case .picks : return true
            default : return false
            }
        }
        var isWild : Bool
        {
            switch(self)
            {
            case .trumps: return true
            case .jokers: return true
            default : return false
            }
        }
        var singular : String
            // Used to help create imagename for a card
            {
                switch(self)
                {
                case .spades: return "Spade".localize
                case .hearts: return "Heart".localize
                case .clubs:  return "Club".localize
                case .diamonds: return "Diamond".localize
                case .suns: return "Sun".localize
                case .anchors: return "Anchor".localize
                case .stars : return "Star".localize
                case .picks : return "Pick".localize
                case .trumps : return "Trump".localize
                case .jokers : return "Joker".localize
                case .noOfSuites : return "Not Applicable".localize
                case .none : return "None".localize
                }
        }
        var description : String
            // Used to help create imagename for a card
            {
                switch(self)
                {
                case .spades: return "Spades".localize
                case .hearts: return "Hearts".localize
                case .clubs:  return "Clubs".localize
                case .diamonds: return "Diamonds".localize
                case .suns: return "Suns".localize
                case .anchors: return "Anchors".localize
                case .stars : return "Stars".localize
                case .picks : return "Picks".localize
                case .trumps : return "Trumps".localize
                case .jokers : return "Jokers".localize
                case .noOfSuites : return "Not Applicable".localize
                case .none : return "None".localize
                }
        }
        var color : UIColor
            {
                switch(self)
                {
                case .spades: return UIColor.black
                case .hearts: return UIColor.colorFromHexString("df0000")
                case .clubs:  return UIColor.colorFromHexString("1ea820")
                case .diamonds: return UIColor.colorFromHexString("16b4b7")
                case .suns: return UIColor.colorFromHexString("ffb002")
                case .anchors: return UIColor.colorFromHexString("0044cd")
                case .stars : return UIColor.colorFromHexString("ff6600")
                case .picks : return UIColor.colorFromHexString("841c00")
                case .trumps : return UIColor.colorFromHexString("5600b6")
                case .jokers : return UIColor.colorFromHexString("fb47f3")
                case .noOfSuites : return UIColor.black
                case .none : return UIColor.black
                }
        }
        static var standardSuites : [Suite]
        {
            return [spades,diamonds,clubs,hearts]
        }
        static var normalSuites : [Suite]
        {
            return [spades,diamonds,clubs,hearts,suns,anchors,stars,picks]
        }
        static var allSuites : [Suite]
        {
            return [spades,diamonds,clubs,hearts,suns,anchors,stars,picks,trumps,jokers]
        }
    }
    public enum CardValue : Equatable, Comparable
    {
        case courtCard(String)
        case pip(Int)
        case ace
        
        var imageCode : String
        // Used to help create imagename for a card
        {
                switch(self)
                {
                case .courtCard(let cardLetter): return cardLetter
                case .pip(let faceValue): return faceValue.description
                case .ace: return "A"
                }
        }
        var localLetterRaw : String
        {
                switch(self)
                {
                case .courtCard(let cardLetter):
                    
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
                case .courtCard(let cardLetter):
                    return cardLetter.lowercased() == raw.lowercased() ? "" : raw
                default : return ""
                }
        }
        var description : String
            // Used to help create imagename for a card
            {
                switch(self)
                {
                case .courtCard(let cardLetter):
                    
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
                case .pip(let faceValue):
                    switch faceValue
                    {
                    case 2 : return "Deuce".localize
                    case 3 : return "Trey".localize
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
                case .ace: return "Ace".localize
                }
        }
        
        
        var rank : Int
            {
                switch(self)
                {
                case .courtCard(let cardLetter):
                    
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
                    
                case .pip(let faceValue): return faceValue
                case .ace: return 19
                }
        }
        
        static func valuesFor(_ noOfCardsInASuite:Int = 13) -> [CardValue]
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
        static func courtLiteValuesFor(_ noOfCardsInASuite:Int = 13) -> [CardValue]
        {
            switch noOfCardsInASuite
            {
            case 10: return values10CardInASuiteAlt
            case 11: return values11CardInASuiteAlt
            case 12: return values12CardInASuiteAlt
            case 14: return values14CardInASuiteAlt
            case 15: return values15CardInASuite
            case 16: return values16CardInASuite
            case 17: return values17CardInASuite
            case 18: return values18CardInASuite
            default: return standardValues
            }
        }
        static func cardsUpTo(_ noOfCards:Int = 10) -> [CardValue]
        {
            return [ace] + (2...noOfCards).map { pip($0) }
        }
        static var standardValues : [CardValue] {
            return  cardsUpTo(10) + ["J","Q","K"].map { courtCard($0) }
        }
        static var values10CardInASuite : [CardValue] {
            
            return  cardsUpTo(7) + ["J","Q","K"].map { courtCard($0) }
        }
        static var values11CardInASuite : [CardValue] {
            
            return  cardsUpTo(8) + ["J","Q","K"].map { courtCard($0) }
        }
        static var values12CardInASuite : [CardValue] {
            
            return  cardsUpTo(9) + ["J","Q","K"].map { courtCard($0) }
        }
        static var values10CardInASuiteAlt : [CardValue] {
            
            return  cardsUpTo(10)
        }
        static var values11CardInASuiteAlt : [CardValue] {
            
            return  cardsUpTo(11)
        }
        static var values12CardInASuiteAlt : [CardValue] {
            
            return  cardsUpTo(10) + ["Q","K"].map { courtCard($0) }
        }
        static var values14CardInASuiteAlt : [CardValue] {
            return cardsUpTo(11) +  ["J","Q","K"].map { courtCard($0) }
        }
        static var values14CardInASuite : [CardValue] {
            
            return  cardsUpTo(10) + ["J","KN","Q","K"].map { courtCard($0) }
        }
        static var values15CardInASuite : [CardValue] {
            
            return  cardsUpTo(11) + ["J","KN","Q","K"].map { courtCard($0) }
        }
        static var values16CardInASuite : [CardValue] {
            
            return  cardsUpTo(11) +  ["J","KN","PS","Q","K"].map { courtCard($0) }
        }
        static var values17CardInASuite : [CardValue] {
            return  cardsUpTo(11) +  ["J","KN","AR","PS","Q","K"].map { courtCard($0) }
        }
        static var values18CardInASuite : [CardValue]{
            return  cardsUpTo(11) + ["J","KN","AR","PS","PR","Q","K"].map { courtCard($0) }
        }
    }
    
    public let suite: Suite
    public let value: CardValue
    
    public var imageName : String
        // create imagename for a card
    {
        let result = value.imageCode +  suite.imageCode
        if result == "0T" { return "0J"}
        return result
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
            case PlayingCard.Suite.jokers:
                switch value.rank
                {
                case 0 : return "Fool".localize
                case 1 : return "Joker1".localize
                case 2 : return "Joker2".localize
                default:
                    return  "%@ of %@".localizeWith(value.description,suite.description)
                }
            case PlayingCard.Suite.trumps:
                switch value.rank
                {
                case 0 : return "Fool".localize
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
                case 12 : return "Hanged Man".localize
                case 13 : return "Death".localize
                case 14 : return "Temperance".localize
                case 15 : return "Devil".localize
                case 16 : return "Tower".localize
                case 17 : return "The Star".localize
                case 18 : return "Moon".localize
                case 19 : return "The Sun".localize
                case 20 : return "Judgement".localize
                case 21 : return "World".localize
                default:
                    return  "%@ of %@".localizeWith(value.description,suite.description)
                }
            default:
                return  "%@ of %@".localizeWith(value.description,suite.description)
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
    
    open class DeckBase : Deck
    {
        var noInSuites = [13,13,13,13,13,13,13,13,21,3]
        func noCardIn(_ suite:PlayingCard.Suite) -> Int
        {
            return noInSuites[suite.rawValue]
        }
        func middleCardIn(_ suite:PlayingCard.Suite) -> PlayingCard
        {
            return PlayingCard(suite:suite,value:PlayingCard.CardValue.pip((noInSuites[suite.rawValue]+1)/2))
        }
        func lowerMiddleCardIn(_ suite:PlayingCard.Suite) -> PlayingCard
        {
            return PlayingCard(suite:suite,value:PlayingCard.CardValue.pip((noInSuites[suite.rawValue]-1)/2))
        }
        open var cards: [PlayingCard] {
           
            return orderedDeck.shuffle();
        }
        
        open func dealFor(_ numberOfPlayers:Int ) -> [[PlayingCard]]
        {
            let pack = cards;
            var hands: [[PlayingCard]] = [[PlayingCard]](repeating: [], count: numberOfPlayers)
            
            var i:Int = 0
            for card in pack
            {
                hands[i].append(card)
                i += 1;
                if(i>=numberOfPlayers)
                {
                    i=0
                }
            }
            return hands
        }
        open var orderedDeck:[PlayingCard]
        // override in derived class
        {
            return [];
        }
    }
    open class Standard52CardDeck : DeckBase
    {
        
        open static let sharedInstance = Standard52CardDeck()
        override open var orderedDeck:[PlayingCard]
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
    open class BuiltCardDeck : DeckBase
    {
        var gameSettings:ICardGameSettings? = nil
        open var setOfSuitesInDeck = Set<PlayingCard.Suite>()
        open var suitesInDeck : [PlayingCard.Suite] = []
        open var normalSuitesInDeck : [PlayingCard.Suite] = []
        open var valuesInSuite : [PlayingCard.CardValue] = []
        
        var noOfPossibleCardsInDeck : Int {
            var result = (gameSettings!.noOfSuitesInDeck * gameSettings!.noOfCardsInASuite)
             if gameSettings!.hasTrumps
                {
                result += Game.settings.noOfTrumps
                }
             if gameSettings!.hasJokers
                 {
                 result += Game.settings.noOfJokers
                 }
            return result
        }
        public init(gameSettings:ICardGameSettings )
        {
            self.gameSettings = gameSettings
            normalSuitesInDeck = Array(PlayingCard.Suite.normalSuites[0..<gameSettings.noOfSuitesInDeck])
            suitesInDeck = normalSuitesInDeck
            if gameSettings.hasTrumps
            {
                suitesInDeck.append(PlayingCard.Suite.trumps)
               
            }
            if gameSettings.hasJokers
            {
                suitesInDeck.append(PlayingCard.Suite.jokers)
        
            }
            
            setOfSuitesInDeck = Set<PlayingCard.Suite>(suitesInDeck)
            
        }
        
        func calculateNoOfCardsInEachSuite()
        {
            for s in normalSuitesInDeck
            {
                noInSuites[s.rawValue]  = gameSettings!.noOfCardsInASuite
            }
            noInSuites[PlayingCard.Suite.jokers.rawValue] = 0
            if gameSettings!.hasTrumps
            {
                noInSuites[PlayingCard.Suite.trumps.rawValue] = Game.settings.noOfStandardTrumps
                if Game.settings.hasFool
                {
                  if Game.settings.isFoolATrump
                  { noInSuites[PlayingCard.Suite.trumps.rawValue] += 1 }
                  else
                  {   noInSuites[PlayingCard.Suite.jokers.rawValue] = 1 }
                  }
            }
            if gameSettings!.hasJokers
            {
                noInSuites[PlayingCard.Suite.jokers.rawValue]  += Game.settings.noOfJokers
            }
        }
        
        open func rankFor(_ card:PlayingCard) -> Int
        {
            switch card.value
            {
            case .ace : return 1
            case .pip(let n) : return n
            case .courtCard :
               return (valuesInSuite.index(of: card.value)  ?? -1) + 1
            }
        }
        override open var orderedDeck:[PlayingCard]
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
                    if s == gameSettings!.specialSuite
                    {
                        continue
                    }
                    removedCards.insert(PlayingCard(suite: s, value: PlayingCard.CardValue.pip(pip)))
                    noInSuites[s.rawValue]  = noInSuites[s.rawValue] - 1
                    removedSoFar+=1
                  }
                  pip+=1
                }
                while removedSoFar < toRemove
                
                valuesInSuite = PlayingCard.CardValue.valuesFor(gameSettings!.noOfCardsInASuite)
                for s in normalSuitesInDeck
                {
                    for v in valuesInSuite
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
                    if gameSettings!.hasFool
                    {
                       if gameSettings!.isFoolATrump
                       {deck.append(PlayingCard(suite: PlayingCard.Suite.trumps, value : PlayingCard.CardValue.pip(0)))}
                       else
                       {deck.append(PlayingCard(suite: PlayingCard.Suite.jokers, value : PlayingCard.CardValue.pip(0)))}
                        
                    }
                    for v in 1...gameSettings!.noOfStandardTrumps
                    {
                        deck.append(PlayingCard(suite: PlayingCard.Suite.trumps, value : PlayingCard.CardValue.pip(v)))
                    }
                }
                if gameSettings!.hasJokers
                {
                    for v in 1...gameSettings!.noOfJokers
                    {
                        deck.append(PlayingCard(suite: PlayingCard.Suite.jokers, value : PlayingCard.CardValue.pip(v)))
                    }
                }
                return deck
        }
    }
    
    open class TestCardDeck : DeckBase
    {
    var deck = [PlayingCard]();
        
    public init(cards:[PlayingCard])
        {
            deck.append(contentsOf: cards)
        }
    override open var orderedDeck:[PlayingCard]
        {
            return deck
        }
    }
 
}

extension String {
    var suite : PlayingCard.Suite
        {
          switch(self)
                    {
                    case "S" : return .spades
                    case "H" : return .hearts
                    case "C" : return .clubs
                    case "D" : return .diamonds
                    case "U" : return .suns
                    case "A" : return .anchors
                    case "R" : return .stars
                    case "P" : return .picks
                    case "T" : return .trumps
                    case "J" : return .jokers
                    default : return .none
                    }
       
    }
    var cardvalue : PlayingCard.CardValue
        {
        
        if self=="A" {
            return PlayingCard.CardValue.ace
        } else if let num = Int(self) {
            return PlayingCard.CardValue.pip(num)
        } else {
            return PlayingCard.CardValue.courtCard(self)
        }
    }
    var card : PlayingCard
    {

     let v = self.dropLast()
     let s = self.suffix(1)
     return PlayingCard(suite: String(s).suite, value: String(v).cardvalue)
    }
}
    
extension Int
{
    public func of(_ suite :PlayingCard.Suite) -> PlayingCard
    {
        return PlayingCard(suite: suite,value: cardValue)
    }
    
    public var cardValue : PlayingCard.CardValue
    {
        return PlayingCard.CardValue.pip(self)
    }
    public var letterDescription :String
    {
        switch self
        {
        case 3 : return "Three".localize
        case 4 : return "Four".localize
        case 5 : return "Five".localize
        case 6 : return "Six".localize
        case 7 : return "Seven".localize
        case 8 : return "Eight".localize
        case 9 : return "Nine".localize
        case 10 : return "Ten".localize
        case 11 : return "Eleven".localize
        default : return self.description
        }
    }
    public var random : Int
    {
             return Int(arc4random_uniform(UInt32(self)))
    }
}
public enum CardName
{
    case ace
    case king
    case queen
    case prince
    case princess
    case archer
    case knight
    case jack
    
    public var letter : String
        {
            switch(self)
            {
            case .ace :
                return "A"
            case .king :
                return "K"
            case .queen :
                return "Q"
            case .prince :
                return "PR"
            case .princess :
                return "PS"
            case .archer :
                return "AR"
            case .knight :
                return "KN"
            case .jack :
                return "J"
            } 
    }
    public var cardValue : PlayingCard.CardValue
        {
            switch(self)
            {
            case .ace :
                return PlayingCard.CardValue.ace
            default :
                 return PlayingCard.CardValue.courtCard(letter)
            }
    }

    public func of(_ suite :PlayingCard.Suite) -> PlayingCard?
    {
        return PlayingCard(suite: suite,value: cardValue)

    }
}




