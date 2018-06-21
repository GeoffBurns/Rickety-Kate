//
//  GivenAEarlyLeadingStrategy.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 16/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import UIKit
import XCTest
import Rickety_Kate

class GivenAEarlyLeadingStrategy: XCTestCase {
    var player = FakeCardHolder()
    var gameState = FakeGameState(noPlayers: 4)
    var strategy = EarlyGameLeadingStrategy(margin:4)
    
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
    
    func testCardChoice() {
        // This is an example of a functional test case.
        
        var card =  strategy.chooseCard(player as CardHolder,gameState:gameState as GameState)
        XCTAssert(card?.imageName=="QD", (card?.imageName ?? "nil") + " chosen instead of QD")
        
        gameState.addNotFollowed(PlayingCard.Suite.diamonds)
        
        card =  strategy.chooseCard(player as CardHolder,gameState:gameState as GameState)
        
        if let cardname = card?.imageName
        {
        XCTAssert(cardname=="KC", (card?.imageName ?? "nil") + " chosen instead of KC")
        }
        else
        {
            XCTAssert(false, "No Card")
        }
        
        gameState.addNotFollowed(PlayingCard.Suite.clubs)
        
        card =  strategy.chooseCard(player as CardHolder,gameState:gameState as GameState)
        XCTAssert(card == nil, "Pass")

    }
    
}
