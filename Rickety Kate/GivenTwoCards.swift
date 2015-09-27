//
//  GivenTwoCards.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 11/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//
/*
import UIKit
import XCTest
import Rickety_Kate

public class GivenTwoCards: XCTestCase {
 
    var deck: Deck = PlayingCard.Standard52CardDeck.sharedInstance;
    var cards : Dictionary<String,PlayingCard> = [:]
    override public func setUp() {
        super.setUp()
        for card  in deck.cards
        {
            cards.updateValue(card, forKey: card.imageName)
        }
    }
    
    override public func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    public func testBeCompable() {
        // This is an example of a functional test case.        
        let QueenOfSpades = cards["QS"]!
        let AceOfSpades = cards["AS"]!
        let KingOfSpades = cards["KS"]!
        let TenOfSpades = cards["10S"]!
        let FiveOfSpades = cards["5S"]!
        
        XCTAssert(!(AceOfSpades.value <  AceOfSpades.value), "Less Than")
        XCTAssert(QueenOfSpades.value <  AceOfSpades.value, "Less Than")
        XCTAssert(KingOfSpades.value <  AceOfSpades.value, "Less Than")
        XCTAssert(TenOfSpades.value <  AceOfSpades.value, "Less Than")
        XCTAssert(QueenOfSpades.value <  KingOfSpades.value, "Less Than")
        XCTAssert(TenOfSpades.value <  KingOfSpades.value, "Less Than")
        XCTAssert(FiveOfSpades.value <  TenOfSpades.value, "Less Than")
        
        
        XCTAssert(AceOfSpades.value <=  AceOfSpades.value, "Less Than Equal")
        XCTAssert(QueenOfSpades.value <=  AceOfSpades.value, "Less Than Equal")
        XCTAssert(KingOfSpades.value <=  AceOfSpades.value, "Less Than Equal")
        XCTAssert(TenOfSpades.value <=  AceOfSpades.value, "Less Than Equal")
        XCTAssert(QueenOfSpades.value <=  KingOfSpades.value, "Less Than Equal")
        XCTAssert(TenOfSpades.value <=  KingOfSpades.value, "Less Than Equal")
        XCTAssert(FiveOfSpades.value <=  TenOfSpades.value, "Less Than Equal")
        
        XCTAssert(!(AceOfSpades.value !=  AceOfSpades.value), "Not Equal")
        XCTAssert(QueenOfSpades.value !=  AceOfSpades.value, "Not Equal")
        XCTAssert(KingOfSpades.value !=  AceOfSpades.value, "Not Equal")
        XCTAssert(TenOfSpades.value !=  AceOfSpades.value, "Not Equal")
        XCTAssert(QueenOfSpades.value !=  KingOfSpades.value, "Not Equal")
        XCTAssert(TenOfSpades.value !=  KingOfSpades.value, "Not Equal")
        XCTAssert(FiveOfSpades.value !=  TenOfSpades.value, "Not Equal")
        
        XCTAssert(AceOfSpades.value ==  AceOfSpades.value, "Equal")
        XCTAssert(!(QueenOfSpades.value ==  AceOfSpades.value), "Equal")
        XCTAssert(!(KingOfSpades.value ==  AceOfSpades.value), "Equal")
        XCTAssert(!(TenOfSpades.value ==  AceOfSpades.value), "Equal")
        XCTAssert(!(QueenOfSpades.value ==  KingOfSpades.value), "Equal")
        XCTAssert(!(TenOfSpades.value ==  KingOfSpades.value), "Equal")
        XCTAssert(!(FiveOfSpades.value ==  TenOfSpades.value), "Equal")
        
        XCTAssert(!(AceOfSpades.value >  AceOfSpades.value), "Greater Than")
        XCTAssert(AceOfSpades.value > QueenOfSpades.value , "Greater Than")
        XCTAssert(AceOfSpades.value > KingOfSpades.value, "Greater Than")
        XCTAssert(AceOfSpades.value > TenOfSpades.value, "Greater Than")
        XCTAssert(KingOfSpades.value > QueenOfSpades.value, "Greater Than")
        XCTAssert(KingOfSpades.value > TenOfSpades.value, "Greater Than")
        XCTAssert(TenOfSpades.value > FiveOfSpades.value, "Greater Than")
        
        
        XCTAssert(AceOfSpades.value >=  AceOfSpades.value, "Greater Than Equal")
        XCTAssert(AceOfSpades.value >= QueenOfSpades.value , "Greater Than Equal")
        XCTAssert(AceOfSpades.value >= KingOfSpades.value, "Greater Than Equal")
        XCTAssert(AceOfSpades.value >= TenOfSpades.value, "Greater Than Equal")
        XCTAssert(KingOfSpades.value >= QueenOfSpades.value, "Greater Than Equal")
        XCTAssert(KingOfSpades.value >= TenOfSpades.value, "Greater Than Equal")
        XCTAssert(TenOfSpades.value >= FiveOfSpades.value, "Greater Than Equal")
        
        XCTAssert(QueenOfSpades <  AceOfSpades, "Less Than")
        XCTAssert(!(AceOfSpades <  AceOfSpades), "Less Than")
        XCTAssert(KingOfSpades <  AceOfSpades, "Less Than")
        XCTAssert(TenOfSpades <  AceOfSpades, "Less Than")
        XCTAssert(QueenOfSpades <  KingOfSpades, "Less Than")
        XCTAssert(TenOfSpades <  KingOfSpades, "Less Than")
        XCTAssert(FiveOfSpades <  TenOfSpades, "Less Than")
        
        XCTAssert(QueenOfSpades <=  AceOfSpades, "Less Than Equal")
        XCTAssert(AceOfSpades <=  AceOfSpades, "Less Than Equal")
        XCTAssert(KingOfSpades <=  AceOfSpades, "Less Than Equal")
        XCTAssert(TenOfSpades <=  AceOfSpades, "Less Than Equal")
        XCTAssert(QueenOfSpades <=  KingOfSpades, "Less Than Equal")
        XCTAssert(TenOfSpades <=  KingOfSpades, "Less Than Equal")
        XCTAssert(FiveOfSpades <=  TenOfSpades, "Less Than Equal")
        
        XCTAssert(!(AceOfSpades !=  AceOfSpades), "Not Equal")
        XCTAssert(QueenOfSpades !=  AceOfSpades, "Not Equal")
        XCTAssert(KingOfSpades !=  AceOfSpades, "Not Equal")
        XCTAssert(TenOfSpades !=  AceOfSpades, "Not Equal")
        XCTAssert(QueenOfSpades !=  KingOfSpades, "Not Equal")
        XCTAssert(TenOfSpades !=  KingOfSpades, "Not Equal")
        XCTAssert(FiveOfSpades !=  TenOfSpades, "Not Equal")
        XCTAssert(!(QueenOfSpades !=  QueenOfSpades), "Not Equal")
        XCTAssert(!(KingOfSpades !=  KingOfSpades), "Not Equal")
        XCTAssert(!(TenOfSpades !=  TenOfSpades), "Not Equal")
        XCTAssert(!(FiveOfSpades !=  FiveOfSpades), "Not Equal")
        
        
        XCTAssert(AceOfSpades ==  AceOfSpades, "Equal")
        XCTAssert(!(QueenOfSpades ==  AceOfSpades), "Equal")
        XCTAssert(!(KingOfSpades ==  AceOfSpades), "Equal")
        XCTAssert(!(TenOfSpades ==  AceOfSpades), "Equal")
        XCTAssert(!(QueenOfSpades ==  KingOfSpades), "Equal")
        XCTAssert(!(TenOfSpades ==  KingOfSpades), "Equal")
        XCTAssert(QueenOfSpades ==  QueenOfSpades, "Equal")
        XCTAssert(KingOfSpades ==  KingOfSpades, "Equal")
        XCTAssert(TenOfSpades ==  TenOfSpades, "Equal")
        XCTAssert(FiveOfSpades ==  FiveOfSpades, "Equal")
        
        
        XCTAssert(!(AceOfSpades >  AceOfSpades), "Greater Than")
        XCTAssert(AceOfSpades > QueenOfSpades , "Greater Than")
        XCTAssert(AceOfSpades > KingOfSpades, "Greater Than")
        XCTAssert(AceOfSpades > TenOfSpades, "Greater Than")
        XCTAssert(KingOfSpades > QueenOfSpades, "Greater Than")
        XCTAssert(KingOfSpades > TenOfSpades, "Greater Than")
        XCTAssert(TenOfSpades >= FiveOfSpades , "Greater Than")
        
        XCTAssert(AceOfSpades >=  AceOfSpades, "Greater Than Equal")
        XCTAssert(AceOfSpades >= QueenOfSpades , "Greater Than Equal")
        XCTAssert(AceOfSpades >= KingOfSpades, "Greater Than Equal")
        XCTAssert(AceOfSpades >= TenOfSpades, "Greater Than Equal")
        XCTAssert(KingOfSpades >= QueenOfSpades, "Greater Than Equal")
        XCTAssert(KingOfSpades >= TenOfSpades, "Greater Than Equal")
        XCTAssert(TenOfSpades >= FiveOfSpades, "Greater Than Equal")
        
        XCTAssert(KingOfSpades >= TenOfSpades , "Pass")
        XCTAssert(AceOfSpades ==  AceOfSpades, "Pass")
        
      
    }


  

}*/
