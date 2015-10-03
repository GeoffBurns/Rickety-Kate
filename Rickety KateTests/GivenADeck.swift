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
       
        let cards = deck.cards
       
        XCTAssert(deck.cards.count == 52, "Pass")
        
        let unique = Set<PlayingCard>(cards)
        
        XCTAssert(unique.count == 52, "Pass")
   
    }
    
    public func deckWithNoOfSuites(noOfSuitesInDeck:Int = 4,noOfPlayersAtTable:Int  = 4,noOfCardsInASuite:Int  = 13,  hasTrumps:Bool = false,  hasJokers:Bool = false) -> [PlayingCard]
        {
        let deck = PlayingCard.BuiltCardDeck( gameSettings: FakeGameSettings(noOfSuitesInDeck: noOfSuitesInDeck ,
            noOfPlayersAtTable: noOfPlayersAtTable,
            noOfCardsInASuite: noOfCardsInASuite,
            hasTrumps: hasTrumps,
            hasJokers: hasJokers))
            return deck.orderedDeck
    }
    public func testContainRightNumberOfCards() {

        // count 52 without removed cards
        XCTAssert(deckWithNoOfSuites( 4,noOfPlayersAtTable: 4).count == 52, "Pass")
        XCTAssert(deckWithNoOfSuites( 4,noOfPlayersAtTable: 5).count == 50, "Pass")
        XCTAssert(deckWithNoOfSuites( 4,noOfPlayersAtTable: 6).count == 48, "Pass")
        XCTAssert(deckWithNoOfSuites( 4,noOfPlayersAtTable: 7).count == 49, "Pass")
        
        // count 65 without removed cards
        XCTAssert(deckWithNoOfSuites( 5,noOfPlayersAtTable: 4).count == 64, "Pass")
        XCTAssert(deckWithNoOfSuites( 5,noOfPlayersAtTable: 5).count == 65, "Pass")
        XCTAssert(deckWithNoOfSuites( 5,noOfPlayersAtTable: 6).count == 60, "Pass")
        XCTAssert(deckWithNoOfSuites( 5,noOfPlayersAtTable: 7).count == 63, "Pass")
        
        // count 78 without removed cards
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 4).count == 76, "Pass")
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 5).count == 75, "Pass")
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 6).count == 78, "Pass")
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 7).count == 77, "Pass")
        
        
        // count 56 without removed cards
        XCTAssert(deckWithNoOfSuites( 4,noOfPlayersAtTable: 4, noOfCardsInASuite:14).count == 56, "Pass")
        XCTAssert(deckWithNoOfSuites( 4,noOfPlayersAtTable: 5, noOfCardsInASuite:14).count == 55, "Pass")
        XCTAssert(deckWithNoOfSuites( 4,noOfPlayersAtTable: 6, noOfCardsInASuite:14).count == 54, "Pass")
        XCTAssert(deckWithNoOfSuites( 4,noOfPlayersAtTable: 7, noOfCardsInASuite:14).count == 56, "Pass")
        
        /// count 70 without removed cards
        XCTAssert(deckWithNoOfSuites( 5,noOfPlayersAtTable: 4, noOfCardsInASuite:14).count == 68, "Pass")
        XCTAssert(deckWithNoOfSuites( 5,noOfPlayersAtTable: 5, noOfCardsInASuite:14).count == 70, "Pass")
        XCTAssert(deckWithNoOfSuites( 5,noOfPlayersAtTable: 6, noOfCardsInASuite:14).count == 66, "Pass")
        XCTAssert(deckWithNoOfSuites( 5,noOfPlayersAtTable: 7, noOfCardsInASuite:14).count == 70, "Pass")
        
        // count 84 without removed cards
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 4, noOfCardsInASuite:14).count == 84, "Pass")
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 5, noOfCardsInASuite:14).count == 80, "Pass")
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 6, noOfCardsInASuite:14).count == 84, "Pass")
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 7, noOfCardsInASuite:14).count == 84, "Pass")
        
        // count 60 without removed cards
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 4, noOfCardsInASuite:10).count == 60, "Pass")
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 5, noOfCardsInASuite:10).count == 60, "Pass")
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 6, noOfCardsInASuite:10).count == 60, "Pass")
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 7, noOfCardsInASuite:10).count == 56, "Pass")
        
        // count 105 without removed cards
        XCTAssert(deckWithNoOfSuites( 7,noOfPlayersAtTable: 4, noOfCardsInASuite:15).count == 104, "Pass")
        XCTAssert(deckWithNoOfSuites( 7,noOfPlayersAtTable: 5, noOfCardsInASuite:15).count == 105, "Pass")
        XCTAssert(deckWithNoOfSuites( 7,noOfPlayersAtTable: 6, noOfCardsInASuite:15).count == 102, "Pass")
        XCTAssert(deckWithNoOfSuites( 7,noOfPlayersAtTable: 7, noOfCardsInASuite:15).count == 105, "Pass")
        
        
        // count 90 without removed cards
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 4, noOfCardsInASuite:15).count == 88, "Pass")
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 5, noOfCardsInASuite:15).count == 90, "Pass")
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 6, noOfCardsInASuite:15).count == 90, "Pass")
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 7, noOfCardsInASuite:15).count == 84, "Pass")
        
        // 112
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 4, noOfCardsInASuite:15, hasTrumps: true).count == 112, "Pass")
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 5, noOfCardsInASuite:15, hasTrumps: true).count == 110, "Pass")
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 6, noOfCardsInASuite:15, hasTrumps: true).count == 108, "Pass")
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 7, noOfCardsInASuite:15, hasTrumps: true).count == 112, "Pass")
        
        // 54
        XCTAssert(deckWithNoOfSuites( 4,noOfPlayersAtTable: 4,  hasJokers:true).count == 52, "Pass")
        XCTAssert(deckWithNoOfSuites( 4,noOfPlayersAtTable: 5,  hasJokers:true).count == 50, "Pass")
        XCTAssert(deckWithNoOfSuites( 4,noOfPlayersAtTable: 6,  hasJokers:true).count == 54, "Pass")
        XCTAssert(deckWithNoOfSuites( 4,noOfPlayersAtTable: 7,  hasJokers:true).count == 49, "Pass")
        
        
        // 114
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 4, noOfCardsInASuite:15, hasTrumps: true,  hasJokers:true).count == 112, "Pass")
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 5, noOfCardsInASuite:15, hasTrumps: true,  hasJokers:true).count == 110, "Pass")
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 6, noOfCardsInASuite:15, hasTrumps: true,  hasJokers:true).count == 114, "Pass")
        XCTAssert(deckWithNoOfSuites( 6,noOfPlayersAtTable: 7, noOfCardsInASuite:15, hasTrumps: true,  hasJokers:true).count == 112, "Pass")
        
        // 129
        XCTAssert(deckWithNoOfSuites( 7,noOfPlayersAtTable: 4, noOfCardsInASuite:15, hasTrumps: true,  hasJokers:true).count == 128, "Pass")
        XCTAssert(deckWithNoOfSuites( 7,noOfPlayersAtTable: 5, noOfCardsInASuite:15, hasTrumps: true,  hasJokers:true).count == 125, "Pass")
        XCTAssert(deckWithNoOfSuites( 7,noOfPlayersAtTable: 6, noOfCardsInASuite:15, hasTrumps: true,  hasJokers:true).count == 126, "Pass")
        XCTAssert(deckWithNoOfSuites( 7,noOfPlayersAtTable: 7, noOfCardsInASuite:15, hasTrumps: true,  hasJokers:true).count == 126, "Pass")
        
        // 136
        XCTAssert(deckWithNoOfSuites( 7,noOfPlayersAtTable: 4, noOfCardsInASuite:16, hasTrumps: true,  hasJokers:true).count == 136, "Pass")
        XCTAssert(deckWithNoOfSuites( 7,noOfPlayersAtTable: 5, noOfCardsInASuite:16, hasTrumps: true,  hasJokers:true).count == 135, "Pass")
        XCTAssert(deckWithNoOfSuites( 7,noOfPlayersAtTable: 6, noOfCardsInASuite:16, hasTrumps: true,  hasJokers:true).count == 132, "Pass")
        XCTAssert(deckWithNoOfSuites( 7,noOfPlayersAtTable: 7, noOfCardsInASuite:16, hasTrumps: true,  hasJokers:true).count == 133, "Pass")
        
        // 143
        XCTAssert(deckWithNoOfSuites( 7,noOfPlayersAtTable: 4, noOfCardsInASuite:17, hasTrumps: true,  hasJokers:true).count == 140, "Pass")
        XCTAssert(deckWithNoOfSuites( 7,noOfPlayersAtTable: 5, noOfCardsInASuite:17, hasTrumps: true,  hasJokers:true).count == 140, "Pass")
        XCTAssert(deckWithNoOfSuites( 7,noOfPlayersAtTable: 6, noOfCardsInASuite:17, hasTrumps: true,  hasJokers:true).count == 138, "Pass")
        XCTAssert(deckWithNoOfSuites( 7,noOfPlayersAtTable: 7, noOfCardsInASuite:17, hasTrumps: true,  hasJokers:true).count == 140, "Pass")
        
    }
 

}
