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
    var gameState = FakeGameState(noPlayers: 4)
    var strategy = PerfectKnowledgeStrategy.sharedInstance
    var settings = FakeGameSettings()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        player.addCardsToHand(["QS","QD","JD","5D","2C","KC","10C"])
     
        self.gameState = FakeGameState(noPlayers: 4, gameSettings:settings)
        GameSettings.sharedInstance = settings
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCardChoiceIfNoSpades() {
        // This is an example of a functional test case.
        
        
        gameState.addCardsToTrickPile(["QC","JC","9C"])
        
        let card =  strategy.chooseCard(player as CardHolder,gameState:gameState as GameState)
        XCTAssert(card?.imageName=="KC", "IfNoSpades")
        
        
        
    }
    func testCardChoiceIfSpades() {
        // This is an example of a functional test case.
        
        gameState.addCardsToTrickPile(["QC","QS","JC",])
        let card =  strategy.chooseCard(player as CardHolder,gameState:gameState as GameState)
        XCTAssert(card?.imageName=="10C", "IfSpades")
        
        
    }
    func testCardChoiceIfOmnibus() {
        // This is an example of a functional test case.
        
        
        gameState.addCardsToTrickPile(["4D","9D","KC"])
        
        var card =  strategy.chooseCard(player as CardHolder,gameState:gameState as GameState)
        XCTAssert(card?.imageName=="QD", "IfNotOmnibus")
        
        settings.includeOmnibus=true
        gameState.reset()
        
        var bonusCount = gameState.bonusCards.count
        XCTAssert(bonusCount==1, "1 bonusCards")
        
        let bonusCards =  gameState.bonusCardFor(PlayingCard.Suite.diamonds)
        bonusCount = bonusCards.count
        XCTAssert(bonusCount==1, "1 bonusCards that are Daimonds")
        
        card =  strategy.chooseCard(player as CardHolder,gameState:gameState)
        XCTAssert(card?.imageName=="JD", "IfOmnibus choose " + (card?.imageName ?? "NA"))
        
        
        gameState.setTrickPile(["4D","KND","KC"])
        
        card =  strategy.chooseCard(player as CardHolder,gameState:gameState as GameState)
        XCTAssert(card?.imageName=="QD", "Pass")
        
    }
  }
