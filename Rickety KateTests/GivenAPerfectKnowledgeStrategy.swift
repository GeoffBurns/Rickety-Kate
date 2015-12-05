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
    var settings = FakeGameSettings()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        player.addCardsToHand(["QS","QD","5D","2C","KC","10C"])
        GameSettings.sharedInstance = settings
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testScoring() {
        // This is an example of a functional test case.
        
        let clubsTrick = gameState.createTrickPile(["QC","JC","7C","10C"])
        XCTAssert(clubsTrick.score==0, "clubsTrick")

        let ricketyTrick = gameState.createTrickPile(["QC","QS","7C","10C"])
        XCTAssert(ricketyTrick.score==10, "ricketyTrick")

        settings.includeHooligan=true
        
        let hooliganTrick = gameState.createTrickPile(["QC","JC","7C","10C"])
        XCTAssert(hooliganTrick.score==7, String(format: "hooliganTrick is scored %d instead of 7",  hooliganTrick.score))
    }
  }
