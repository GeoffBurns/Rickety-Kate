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
  
    public class TestCardDeck : DeckBase
    {
    var deck: [PlayingCard] = [];
        
    public init(cards:[PlayingCard])
        {
            deck.extend(cards)
        }
    override public var orderedDeck:[PlayingCard]
    {

    return deck

    }
    }
 
}







