//
//  GivenATrickPile.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 6/12/2015.
//  Copyright © 2015 Nereids Gold. All rights reserved.
//

import UIKit
import XCTest
import Rickety_Kate


class GivenATrickPile: XCTestCase {
    var player = FakeCardHolder()
    var gameState = FakeGameState(noPlayers: 4)
    var settings =  FakeGameSettings()
    
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
    

    func testScoring() {
        // This is an example of a functional test case.
        
        let clubsTrick = gameState.createTrickPile(["QC","JC","7C","10C"])
        XCTAssert(clubsTrick.score==0, "clubsTrick")
        
        let ricketyTrick = gameState.createTrickPile(["QC","QS","7C","10C"])
        XCTAssert(ricketyTrick.score==10, "ricketyTrick")
        
        settings.includeHooligan=true
        
        let hooliganTrick = gameState.createTrickPile(["QC","JC","7C","10C"])
        XCTAssert(hooliganTrick.score==7, String(format: "hooliganTrick is scored %d instead of 7",  hooliganTrick.score))
        
        settings.includeOmnibus=true
        let busTrick = gameState.createTrickPile(["QD","JD","7D","10S"])
        XCTAssert(busTrick.score == -9, String(format: "busTrick is scored %d instead of -9",  busTrick.score))
    }
    
    func testWinningPlay() {
        // This is an example of a functional test case.
        
        let clubsTrick = gameState.createTrickPile(["QC","JC","7C","10C"])
        XCTAssert(clubsTrick.winningPlay?.playedCard.imageName=="QC", "clubsTrick")
        
        let ricketyTrick = gameState.createTrickPile(["JC","QS","7C","10C"])
        XCTAssert(ricketyTrick.winningPlay?.playedCard.imageName=="JC", "ricketyTrick")
        
        
        let hooliganTrick = gameState.createTrickPile(["2U","JC","7C","10C"])
        XCTAssert(hooliganTrick.winningPlay?.playedCard.imageName=="2U", "hooliganTrick")
        
        let busTrick = gameState.createTrickPile(["2U","JD","7D","11U"])
        XCTAssert(busTrick.winningPlay?.playedCard.imageName=="11U", "busTrick" )
        
        let sunTrick = gameState.createTrickPile(["11U","JD","ARU","PSU"])
        XCTAssert(sunTrick.winningPlay?.playedCard.imageName=="PSU", "sunTrick" )
    }
}
