//
//  PlayingCardComparable.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 16/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import Foundation

public func < <T: RawRepresentable>(a: T, b: T) -> Bool where T.RawValue: Comparable {
    return a.rawValue < b.rawValue
}
public func <= <T: RawRepresentable>(a: T, b: T) -> Bool where T.RawValue: Comparable {
    return a.rawValue <= b.rawValue
}
public func >= <T: RawRepresentable>(a: T, b: T) -> Bool where T.RawValue: Comparable {
    return a.rawValue >= b.rawValue
}

public func > <T: RawRepresentable>(a: T, b: T) -> Bool where T.RawValue: Comparable {
    return a.rawValue > b.rawValue
}

public func ==(lhs: PlayingCard.CardValue, rhs: PlayingCard.CardValue) -> Bool {
    switch (lhs, rhs) {
    case let (.courtCard(la), .courtCard(ra)): return la == ra
    case let (.pip(la), .pip(ra)): return la == ra
    case (.ace, .ace): return true
        
    default: return false
    }
}

public func <=(lhs: PlayingCard.Suite, rhs: PlayingCard.Suite) -> Bool
{
    return lhs.rawValue <= rhs.rawValue
}
public func >=(lhs: PlayingCard.Suite, rhs: PlayingCard.Suite) -> Bool
{
    return lhs.rawValue >= rhs.rawValue
}
public func >(lhs: PlayingCard.Suite, rhs: PlayingCard.Suite) -> Bool
{
    return lhs.rawValue > rhs.rawValue
}



func pictureLetterToRank(_ letter:String) -> Int
{
    switch letter
    {
    case "K" : return 18
    case "Q" : return 17
    case "PR" : return 16
    case "PS" : return 15
    case "AR" : return 14
    case "KN" : return 13
    case "J" : return 12
    default: return 0
    }
}

public func <=(lhs: PlayingCard.CardValue, rhs: PlayingCard.CardValue) -> Bool
{
    switch (lhs, rhs) {
    case (.ace, .ace): return true
    case (.ace, _): return !GameSettings.sharedInstance.isAceHigh
    case (_, .ace): return GameSettings.sharedInstance.isAceHigh
    case let (.courtCard(la), .courtCard(ra)): return pictureLetterToRank(la) <= pictureLetterToRank(ra)
    case (.courtCard, _): return false
    case let (.pip(la), .pip(ra)): return la <= ra
    default: return true
    }
}

public func >=(lhs: PlayingCard.CardValue, rhs: PlayingCard.CardValue) -> Bool
{
    switch (lhs, rhs) {
    case (.ace, .ace): return true
    case (.ace, _): return GameSettings.sharedInstance.isAceHigh
    case (_, .ace): return !GameSettings.sharedInstance.isAceHigh
    case let (.courtCard(la), .courtCard(ra)): return pictureLetterToRank(la) >= pictureLetterToRank(ra)
    case (.courtCard, _): return true
    case let (.pip(la), .pip(ra)): return la >= ra
    default: return false
    }
}
public func >(lhs: PlayingCard.CardValue, rhs: PlayingCard.CardValue) -> Bool
{
    switch (lhs, rhs) {
    case (.ace, .ace): return false
    case (.ace, _): return GameSettings.sharedInstance.isAceHigh
    case (_, .ace): return !GameSettings.sharedInstance.isAceHigh
    case let (.courtCard(la), .courtCard(ra)): return pictureLetterToRank(la) > pictureLetterToRank(ra)
    case (.courtCard, _): return true
    case let (.pip(la), .pip(ra)): return la > ra
    default: return false
    }
}
public func < (lhs: PlayingCard.CardValue, rhs: PlayingCard.CardValue) -> Bool
{
    switch (lhs, rhs) {
    case (.ace, .ace): return false
    case (.ace, _): return !GameSettings.sharedInstance.isAceHigh
    case (_, .ace): return GameSettings.sharedInstance.isAceHigh
    case let (.courtCard(la), .courtCard(ra)): return pictureLetterToRank(la) < pictureLetterToRank(ra)
    case (.courtCard, _): return false
    case let (.pip(la), .pip(ra)): return la < ra
    default: return true
    }
}

public func ==(lhs: PlayingCard, rhs: PlayingCard) -> Bool
{
    let areEqual = lhs.suite == rhs.suite &&
        lhs.value == rhs.value
    
    return areEqual
}
public func <=(lhs: PlayingCard, rhs: PlayingCard) -> Bool
{
    if(lhs.suite < rhs.suite)
    {
        return true
    }
    
    if(lhs.suite > rhs.suite)
    {
        return false
    }
    
    return lhs.value <= rhs.value
    
}
public func >=(lhs: PlayingCard, rhs: PlayingCard) -> Bool
{
    if(lhs.suite.rawValue < rhs.suite.rawValue)
    {
        return false
    }
    
    if(lhs.suite > rhs.suite)
    {
        return true
    }
    
    return lhs.value >= rhs.value
}
public func >(lhs: PlayingCard, rhs: PlayingCard) -> Bool
{
    if(lhs.suite.rawValue < rhs.suite.rawValue)
    {
        return false
    }
    
    if(lhs.suite > rhs.suite)
    {
        return true
    }
    
    return lhs.value  > rhs.value
}
public func <(lhs: PlayingCard, rhs: PlayingCard) -> Bool
{
    if(lhs.suite.rawValue < rhs.suite.rawValue)
    {
        return true
    }
    
    if(lhs.suite > rhs.suite)
    {
        return false
    }
    
    return lhs.value  < rhs.value
}
