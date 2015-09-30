//
//  GivenACardTable.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 11/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import UIKit
import XCTest
import Rickety_Kate
import SpriteKit

class GivenACardTable: XCTestCase {
   var table : CardTable = CardTable.makeTable(SKNode(), gameSettings:FakeGameSettings(noOfSuitesInDeck: 4 ,
        noOfPlayersAtTable: 4) )
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPlayersLeadby() {
        // This is an example of a functional test case.
        
        let players = table.trickPlayersLeadBy(table.players[1])
        XCTAssert(players[0] == table.players[1] , "Pass")
        XCTAssert(players[1] == table.players[2] , "Pass")
        XCTAssert(players[2] == table.players[3] , "Pass")
        XCTAssert(players[3] == table.players[0] , "Pass")
    }



}
