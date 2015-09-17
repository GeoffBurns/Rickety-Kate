//
//  CardSource.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 17/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import Foundation

// Used for testing
public class CardSource
{
    var deck: Deck = PlayingCard.Standard52CardDeck.sharedInstance;
    var data : Dictionary<String,PlayingCard> = [:]
    
    subscript(index: String) -> PlayingCard {
        return data[index]!
    }
    public static let sharedInstance = CardSource()
    private init()
    {
        for card  in deck.cards
        {
            data.updateValue(card, forKey: card.imageName)
        }
    }
    
}