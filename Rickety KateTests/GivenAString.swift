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

open class GivenAString : XCTestCase {
    

    
    override open func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func getStringForWinning(_ name:String,n:Int,pluralizable:String) -> String
    {
        return "%@ won %d %@"
            .with
            .sayTo(name)
            .pluralize(n,arguements: pluralizable)
            .localize

    }
    func staggeredPos(_ i:Int, _ j:Int, _ noCol:Int) -> Int {
       return noCol*i+j-noCol-1 - (i>2 ? 1 : 0)
       }
    
    func staggeredPos2(_ i:Int, _ j:Int, _ noCol:Int) -> Int {
         return  noCol*j+i-noCol-1 - (((i>1 && j>1) || j>2) ? 1 : 0) + (i==2 && j>1 ? noCol : 0)
            
         
         }
    
        
    func staggeredPos3(_ i:Int, _ j:Int, _ noCol:Int) -> Int {
                           return  noCol*j-i - (((i<3 && j>1) || j>2) ? 1 : 0) + (i==2 && j>1 ? noCol : 0)
               
               }
            open func testExample() {
                 
                 XCTAssert(staggeredPos(1,1,3) == 0, "Pass")
                 
                 XCTAssert(staggeredPos(1,2,3) == 1, "Pass")
                 XCTAssert(staggeredPos(1,3,3) == 2, "Pass")
                 XCTAssert(staggeredPos(2,1,3) == 3, "Expected 3 gave \(staggeredPos(2,1,3))")
                 XCTAssert(staggeredPos(2,2,3) == 4, "Expected 4 gave \(staggeredPos(2,2,3))")
                 XCTAssert(staggeredPos(3,1,3) == 5, "Pass")
                 XCTAssert(staggeredPos(3,2,3) == 6, "Pass")
                 XCTAssert(staggeredPos(3,3,3) == 7, "Pass")
              

              XCTAssert(staggeredPos2(1,1,3) == 0, "Pass")
              XCTAssert(staggeredPos2(2,1,3) == 1, "Pass")
                        XCTAssert(staggeredPos2(3,1,3) == 2, "Pass")
                        XCTAssert(staggeredPos2(1,2,3) == 3, "Expected 3 gave \(staggeredPos2(1,2,3))")
                        XCTAssert(staggeredPos2(2,2,3) == 6, "Expected 4 gave \(staggeredPos2(2,2,3))")
                        XCTAssert(staggeredPos2(3,2,3) == 4, "Pass")
                        XCTAssert(staggeredPos2(1,3,3) == 5, "Pass")
                        XCTAssert(staggeredPos2(3,3,3) == 7, "Pass")
              
              
              XCTAssert(staggeredPos(1,1,5) == 0, "Pass")
               
               XCTAssert(staggeredPos(1,2,5) == 1, "Pass")
               XCTAssert(staggeredPos(1,3,5) == 2, "Pass")
               XCTAssert(staggeredPos(1,4,5) == 3, "Pass")
               XCTAssert(staggeredPos(1,5,5) == 4, "Pass")
               XCTAssert(staggeredPos(2,1,5) == 5, "Expected 5 gave \(staggeredPos(2,1,3))")
               XCTAssert(staggeredPos(2,2,5) == 6, "Expected 6 gave \(staggeredPos(2,2,3))")
               XCTAssert(staggeredPos(2,3,5) == 7, "Expected 7 gave \(staggeredPos(2,3,3))")
               XCTAssert(staggeredPos(2,4,5) == 8, "Expected 8 gave \(staggeredPos(2,4,3)))")
               XCTAssert(staggeredPos(3,1,5) == 9, "Pass")
               XCTAssert(staggeredPos(3,2,5) == 10, "Pass")
               XCTAssert(staggeredPos(3,3,5) == 11, "Pass")
               XCTAssert(staggeredPos(3,4,5) == 12, "Pass")
               XCTAssert(staggeredPos(3,5,5) == 13, "Pass")
              
              
              XCTAssert(staggeredPos2(1,1,5) == 0, "Pass")
               
               XCTAssert(staggeredPos2(2,1,5) == 1, "Pass")
               XCTAssert(staggeredPos2(3,1,5) == 2, "Pass")
               XCTAssert(staggeredPos2(4,1,5) == 3, "Expected 3 gave \(staggeredPos2(4,1,5))")
               XCTAssert(staggeredPos2(5,1,5) == 4, "Expected 6 gave \(staggeredPos2(5,1,5))")
               XCTAssert(staggeredPos2(1,2,5) == 5, "Expected 4 gave \(staggeredPos2(1,2,5))")
               XCTAssert(staggeredPos2(2,2,5) == 10, "Expected 5 gave \(staggeredPos2(1,3,3))")
               XCTAssert(staggeredPos2(3,2,5) == 6, "Expected 9 gave \(staggeredPos2(1,4,3))")
               XCTAssert(staggeredPos2(4,2,5) == 7, "Expected 7 gave \(staggeredPos2(3,3,3))")
               XCTAssert(staggeredPos2(5,2,5) == 8, "Pass")
               XCTAssert(staggeredPos2(1,3,5) == 9, "Pass")
               XCTAssert(staggeredPos2(3,3,5) == 11, "Pass")
               XCTAssert(staggeredPos2(4,3,5) == 12, "Pass")
               XCTAssert(staggeredPos2(5,3,5) == 13, "Pass")
             
             
             
                      XCTAssert(staggeredPos3(1,1,3) == 2, "Pass")
                       XCTAssert(staggeredPos3(2,1,3) == 1, "Pass")
                                 XCTAssert(staggeredPos3(3,1,3) == 0, "Pass")
                                 XCTAssert(staggeredPos3(1,2,3) == 4, "Expected 4 gave \(staggeredPos3(1,2,3))")
                                 XCTAssert(staggeredPos3(2,2,3) == 6, "Expected 6 gave \(staggeredPos3(2,2,3))")
                                 XCTAssert(staggeredPos3(3,2,3) == 3, "Expected 3 gave \(staggeredPos3(3,2,3))")
                                 XCTAssert(staggeredPos3(1,3,3) == 7, "Pass")
                                 XCTAssert(staggeredPos3(3,3,3) == 5, "Pass")
             
             
             
                 XCTAssert(staggeredPos3(1,1,5) == 4, "Pass")
             
                  XCTAssert(staggeredPos3(2,1,5) == 3, "Pass")
                  XCTAssert(staggeredPos3(3,1,5) == 2, "Pass")
                  XCTAssert(staggeredPos3(4,1,5) == 1, "Expected 3 gave \(staggeredPos3(4,1,5))")
                  XCTAssert(staggeredPos3(5,1,5) == 0, "Expected 6 gave \(staggeredPos3(5,1,5))")
                  XCTAssert(staggeredPos3(1,2,5) == 8, "Expected 8 gave \(staggeredPos3(1,2,5))")
                  XCTAssert(staggeredPos3(2,2,5) == 12, "Expected 5 gave \(staggeredPos3(2,2,5))")
                  XCTAssert(staggeredPos3(3,2,5) == 7, "Expected 7 gave \(staggeredPos3(3,2,5))")
                  XCTAssert(staggeredPos3(4,2,5) == 6, "Expected 6 gave \(staggeredPos3(4,2,5))")
                  XCTAssert(staggeredPos3(5,2,5) == 5, "Expected 5 gave \(staggeredPos3(5,2,5))")
                  XCTAssert(staggeredPos3(1,3,5) == 13, "Pass")
                  XCTAssert(staggeredPos3(3,3,5) == 11, "Pass")
                  XCTAssert(staggeredPos3(4,3,5) == 10, "Pass")
                  XCTAssert(staggeredPos3(5,3,5) == 9, "Pass")
                    
                 // This is an example of a functional test case.
                 // Use XCTAssert and related functions to verify your tests produce the correct results.
             }
    open func testParameterizedStrings() {
        
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

    open func testLocalizedStrings() {
        
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

