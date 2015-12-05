//
//  GivenAPerfectKnowledgeStrategy.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 5/12/2015.
//  Copyright © 2015 Nereids Gold. All rights reserved.
//

import UIKit
import XCTest
import Rickety_Kate


class GivenAPerfectKnowledgeStrategy: XCTestCase {
    var player = FakeCardHolder()
    var deck: Deck = PlayingCard.Standard52CardDeck.sharedInstance;
    var gameState = FakeGameState(noPlayers: 4)
    var strategy = PerfectKnowledgeStrategy.sharedInstance
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        player.addCardsToHand(["QS","QD","5D","2C","KC","10C"])
        GameSettings.sharedInstance = FakeGameSettings()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCardChoiceIfNoSpades() {
        // This is an example of a functional test case.
        
        gameState.addCardsToTrickPile(["QC","JC","9C",])
        let card =  strategy.chooseCard(player as CardHolder,gameState:gameState as GameState)
        XCTAssert(card?.imageName=="KC", "Pass")
        

        
    }
    func testCardChoiceIfSpades() {
        // This is an example of a functional test case.
        
        gameState.addCardsToTrickPile(["QC","QS","JC",])
        let card =  strategy.chooseCard(player as CardHolder,gameState:gameState as GameState)
        XCTAssert(card?.imageName=="10C", "Pass")
        
    
    }
}
