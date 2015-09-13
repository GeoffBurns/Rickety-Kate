//
//  GivenTwoCards.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 11/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import UIKit
import XCTest
import Rickety_Kate

public class GivenTwoCards: XCTestCase {
 
    var deck: Deck = PlayingCard.Standard52CardDeck.sharedInstance;
    var cards : Dictionary<String,PlayingCard> = [:]
    override public func setUp() {
        super.setUp()
        for card  in deck.cards
        {
            cards.updateValue(card, forKey: card.imageName)
        }
    }
    
    override public func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    public func testBeCompable() {
        // This is an example of a functional test case.        
        let QueenOfSpades = cards["QS"]
        let AceOfSpades = cards["AS"]
        let KingOfSpades = cards["KS"]
        let TenOfSpades = cards["10S"]
        
        XCTAssert(QueenOfSpades >  AceOfSpades, "Pass")
        XCTAssert(KingOfSpades >  AceOfSpades, "Pass")
        XCTAssert(TenOfSpades >  AceOfSpades, "Pass")
        XCTAssert(QueenOfSpades >  KingOfSpades, "Pass")
        XCTAssert(TenOfSpades >  KingOfSpades, "Pass")
        XCTAssert(KingOfSpades <= TenOfSpades , "Pass")
        XCTAssert(AceOfSpades ==  AceOfSpades, "Pass")
    }


  

}
