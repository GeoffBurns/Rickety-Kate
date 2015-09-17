//
//  GivenALateGameFollowingStrategy.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 16/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import UIKit
import XCTest
import Rickety_Kate

class GivenALateGameFollowingStrategy: XCTestCase {
    var player = FakeCardHolder()
    var deck: Deck = PlayingCard.Standard52CardDeck.sharedInstance;
    var gameState = FakeGameState(noPlayers: 4)
    var strategy = LateGameFollowingStrategy.sharedInstance
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        player.addCardsToHand(["QS","QD","5D","2C","KC","10C"])
        gameState.addCardsToTrickPile(["QC"])
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCardChoice() {
        // This is an example of a functional test case.
        
        let card =  strategy.chooseCard(player as CardHolder,gameState:gameState as GameState)
        XCTAssert(card?.imageName=="10C", "Pass")
    }
    
}
