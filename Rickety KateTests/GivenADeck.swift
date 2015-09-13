//
//  GivenADeck.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 11/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import UIKit
import XCTest
import Rickety_Kate

public class GivenADeck: XCTestCase {

    var deck: Deck = PlayingCard.Standard52CardDeck.sharedInstance;
    var cards : Dictionary<String,PlayingCard> = [:]
    override public func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    
       
    }
    
    override public func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    public func testContainAllUniqueCards() {
        // This is an example of a functional test case.
        let cards = deck.cards
       
        XCTAssert(deck.cards.count == 52, "Pass")
        
        let unique = Set<PlayingCard>(cards)
        
        XCTAssert(unique.count == 52, "Pass")
    }

 

}
