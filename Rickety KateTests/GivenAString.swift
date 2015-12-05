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
    
    
    func getStringForWinning(name:String,n:Int,pluralizable:String) -> String
    {
        return "_ won * _"
            .with
            .sayTo(name)
            .pluralize(n,arguements: pluralizable)
            .localize

    }
    
    public func testParameterizedStrings() {
        
        let molly_won_a_jack = getStringForWinning("Molly",n: 1, pluralizable: "Jack")
        XCTAssert(molly_won_a_jack=="Molly won a Jack",molly_won_a_jack)
        
        let molly_won_2_jacks = getStringForWinning("Molly",n: 2, pluralizable: "Jack")
        XCTAssert(molly_won_2_jacks=="Molly won 2 Jacks",molly_won_2_jacks)
        
        let you_won_a_jack = getStringForWinning("You",n: 1, pluralizable: "Jack")
        XCTAssert(you_won_a_jack=="You won a Jack",molly_won_2_jacks)
        
        let you_won_2_jacks = getStringForWinning("You",n: 2, pluralizable: "Jack")
        XCTAssert(you_won_2_jacks=="You won 2 Jacks",you_won_2_jacks)
        
    }
    
    public func testLocalizedStrings() {
        
        let molly_won_a_trick = "_ just Won the Trick".sayTo("Molly")
        XCTAssert(molly_won_a_trick=="Molly just Won the Trick",molly_won_a_trick)
        
  
        let you_need_to_play = "You Need to Play _ First".localizeWith("test")
        XCTAssert(you_need_to_play=="You Need to Play\ntest First",you_need_to_play)
        
        let molly_was_kissed = "_ was kissed by Rickety Kate Poor _".sayTwiceTo("Molly")
        XCTAssert(molly_was_kissed=="Molly was kissed by\nRickety Kate. Poor Molly.",molly_was_kissed)
        
        let you_was_kissed = "_ was kissed by Rickety Kate Poor _".sayTwiceTo("You")
        XCTAssert(you_was_kissed=="You were kissed by Rickety Kate.\nPoor you.",you_was_kissed)
        
        let molly_was_bashed = "_ was bashed by the Hooligan Poor _".sayTwiceTo("Molly")
        XCTAssert(molly_was_bashed=="Molly was bashed by the\nHooligan. Poor Molly.",molly_was_bashed)
        
        let you_was_bashed = "_ was bashed by the Hooligan Poor _".sayTwiceTo("You")
        XCTAssert(you_was_bashed=="You were bashed by the\nHooligan. Poor you.",you_was_bashed)
        let you_exit = "you want to exit".localize
        XCTAssert(you_exit=="you want to exit?",you_exit)
        
        
        let molly_won = "_ just Won the Game".sayCongratsTo("Molly")
        XCTAssert(molly_won=="Wow!!! Molly\njust Won the Game",molly_won)
      
        let you_won = "_ just Won the Game".sayCongratsTo("You")
        XCTAssert(you_won=="Congratulatons!!!\nYou just Won the Game",you_won)
    }
    
}

