//
//  GivenAString.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 5/12/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//


import UIKit
import XCTest
import Rickety_Kate

public class GivenAString : XCTestCase {
    

    
    override public func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    public func testContainAllUniqueCards() {
        
        let molly_won_a_jack = "_ won * _"
            .with
            .sayTo("Molly")
            .pluralize(1,arguements: "Jack")
            .localize
        
        XCTAssert(molly_won_a_jack=="Molly won a Jack",molly_won_a_jack)
        
    }
    
}

