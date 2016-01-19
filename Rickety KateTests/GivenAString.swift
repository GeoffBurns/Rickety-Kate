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
        return "%@ won %d %@"
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
        XCTAssert(you_won_a_jack=="You won a Jack",you_won_a_jack)
        
        let you_won_2_jacks = getStringForWinning("You",n: 2, pluralizable: "Jack")
        XCTAssert(you_won_2_jacks=="You won 2 Jacks",you_won_2_jacks)
        
        let you_score_10 = "%@ score is %d".with.sayTo("You").using(10).localize
        
 //       let you_score_10 = "%@ score is %d".with.sayTo("You",10).localize
       XCTAssert(you_score_10=="Your score is 10",you_score_10)
        
        let molly_score_12 = "%@ score is %d".with.sayTo("Molly").using(12).localize
        XCTAssert(molly_score_12=="Molly's score is 12",molly_score_12)
        
       let molly_score_22_1 = "%@ Score %d n %d Wins".with.sayTo("Molly").using(22, 1).localize
       XCTAssert(molly_score_22_1=="Molly's Score : 22 & 1 Wins",molly_score_22_1)
        
        let you_score_22_1 = "%@ Score %d n %d Wins".with.sayTo("You").using(22, 1).localize
        XCTAssert(you_score_22_1=="Your Score : 22 & 1 Wins",you_score_22_1)
        
        
        let molly_score_24_2 = "%@ Score %d n %d %@".with.sayTo("Molly").using(24).pluralizeUnit(2, unit: "Win").localize
        XCTAssert(molly_score_24_2=="Molly's Score : 24 & 2 Wins",molly_score_24_2)
        
        let molly_score_23_1 = "%@ Score %d n %d %@".with.sayTo("Molly").using(23).pluralizeUnit(1, unit: "Win").localize
        XCTAssert(molly_score_23_1=="Molly's Score : 23 & 1 Win",molly_score_23_1)
        
        let you_score_24_2 = "%@ Score %d n %d %@".with.sayTo("You").using(24).pluralizeUnit(2, unit: "Win").localize
        XCTAssert(you_score_24_2=="Your Score : 24 & 2 Wins",you_score_24_2)
        
        let you_score_23_1 = "%@ Score %d n %d %@".with.sayTo("You").using(23).pluralizeUnit(1, unit: "Win").localize
        XCTAssert(you_score_23_1=="Your Score : 23 & 1 Win",you_score_23_1)
    }

    public func testLocalizedStrings() {
        
        let molly_won_a_trick = "%@ just Won the Trick".sayTo("Molly")
        XCTAssert(molly_won_a_trick=="Molly just Won the Trick",molly_won_a_trick)
        
  
        let you_need_to_play = "You Need to Play %@ First".localizeWith("test")
        XCTAssert(you_need_to_play=="You Need to Play\ntest First",you_need_to_play)
        
        let molly_was_kissed = "%@ was kissed by Rickety Kate Poor %@".sayTwiceTo("Molly")
        XCTAssert(molly_was_kissed=="Molly was kissed by\nRickety Kate. Poor Molly.",molly_was_kissed)
        
        let you_was_kissed = "%@ was kissed by Rickety Kate Poor %@".sayTwiceTo("You")
        XCTAssert(you_was_kissed=="You were kissed by Rickety Kate.\nPoor you.",you_was_kissed)
        
        let molly_was_bashed = "%@ was bashed by the Hooligan Poor %@".sayTwiceTo("Molly")
        XCTAssert(molly_was_bashed=="Molly was bashed by the\nHooligan. Poor Molly.",molly_was_bashed)
        
        let you_was_bashed = "%@ was bashed by the Hooligan Poor %@".sayTwiceTo("You")
        XCTAssert(you_was_bashed=="You were bashed by the\nHooligan. Poor you.",you_was_bashed)
        let you_exit = "you want to exit".localize
        XCTAssert(you_exit=="you want to exit?",you_exit)
        
        
        let molly_won = "%@ just Won the Game".sayCongratsTo("Molly")
        XCTAssert(molly_won=="Wow!!! Molly\njust Won the Game",molly_won)
      
        let you_won = "%@ just Won the Game".sayCongratsTo("You")
        XCTAssert(you_won=="Congratulatons!!!\nYou just Won the Game",you_won)
    }
    
}

