//
//  CardHolder.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 17/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import Foundation

// Cut down version of a CardPlayer that is visible to tests
public protocol CardHolder
{
    func cardsIn(suite:PlayingCard.Suite) -> [PlayingCard]
    var RicketyKate : PlayingCard? {get}
    var hand : [PlayingCard] { get }
}

public class CardHolderBase
{
    var _hand : CardFan = CardFan(name: CardPileType.Hand.description)
    public var hand : [PlayingCard] { get { return _hand.cards } set { _hand.cards = newValue }}
    public func cardsIn(suite:PlayingCard.Suite) -> [PlayingCard]
    {
        return _hand.cards.filter {$0.suite == suite}
    }
    public var RicketyKate : PlayingCard?
        {
            let RicketyKate = _hand.cards.filter { $0.isRicketyKate}
            
            return RicketyKate.first
    }
}

public class FakeCardHolder : CardHolderBase, CardHolder
{
    let cardSource = CardSource.sharedInstance

    //////////
    // internal functions
    //////////
    public func addCardsToHand(cardCodes:[String])
    {
        for code in cardCodes
        {
            let card : PlayingCard = cardSource[code]
            
            hand.append(card)
        }
    }
    
    public override init() {}
    
}