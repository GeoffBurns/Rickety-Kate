//
//  GivenAPlayer.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 11/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import UIKit
import XCTest
import Rickety_Kate

class GivenAPlayer: XCTestCase {
    var player : CardPlayer = ComputerPlayer(name:"Ken",margin:2)
   var deck: Deck = PlayingCard.Standard52CardDeck.sharedInstance;
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        player.hand = deck.cards
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testName() {
        // This is an example of a functional test case.
        
   
        XCTAssert(player.name=="Ken", "Pass")
    }


 

}
