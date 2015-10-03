//
//  PlayingCardComparable.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 16/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import Foundation

public func < <T: RawRepresentable where T.RawValue: Comparable>(a: T, b: T) -> Bool {
    return a.rawValue < b.rawValue
}
public func <= <T: RawRepresentable where T.RawValue: Comparable>(a: T, b: T) -> Bool {
    return a.rawValue <= b.rawValue
}
public func >= <T: RawRepresentable where T.RawValue: Comparable>(a: T, b: T) -> Bool {
    return a.rawValue >= b.rawValue
}

public func > <T: RawRepresentable where T.RawValue: Comparable>(a: T, b: T) -> Bool {
    return a.rawValue > b.rawValue
}

public func ==(lhs: PlayingCard.CardValue, rhs: PlayingCard.CardValue) -> Bool {
    switch (lhs, rhs) {
    case let (.CourtCard(la), .CourtCard(ra)): return la == ra
    case let (.Pip(la), .Pip(ra)): return la == ra
    case (.Ace, .Ace): return true
        
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



func pictureLetterToRank(letter:String) -> Int
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
    case (.Ace, .Ace): return true
    case (.Ace, _): return false
    case (_, .Ace): return true
    case let (.CourtCard(la), .CourtCard(ra)): return pictureLetterToRank(la) <= pictureLetterToRank(ra)
    case (.CourtCard, _): return false
    case let (.Pip(la), .Pip(ra)): return la <= ra
    default: return true
    }
}

public func >=(lhs: PlayingCard.CardValue, rhs: PlayingCard.CardValue) -> Bool
{
    switch (lhs, rhs) {
    case (.Ace, .Ace): return true
    case (.Ace, _): return true
    case (_, .Ace): return false
    case let (.CourtCard(la), .CourtCard(ra)): return pictureLetterToRank(la) >= pictureLetterToRank(ra)
    case (.CourtCard, _): return true
    case let (.Pip(la), .Pip(ra)): return la >= ra
    default: return false
    }
}
public func >(lhs: PlayingCard.CardValue, rhs: PlayingCard.CardValue) -> Bool
{
    switch (lhs, rhs) {
    case (.Ace, .Ace): return false
    case (.Ace, _): return true
    case (_, .Ace): return false
    case let (.CourtCard(la), .CourtCard(ra)): return pictureLetterToRank(la) > pictureLetterToRank(ra)
    case (.CourtCard, _): return true
    case let (.Pip(la), .Pip(ra)): return la > ra
    default: return false
    }
}
public func < (lhs: PlayingCard.CardValue, rhs: PlayingCard.CardValue) -> Bool
{
    switch (lhs, rhs) {
    case (.Ace, .Ace): return false
    case (.Ace, _): return false
    case (_, .Ace): return true
    case let (.CourtCard(la), .CourtCard(ra)): return pictureLetterToRank(la) < pictureLetterToRank(ra)
    case (.CourtCard, _): return false
    case let (.Pip(la), .Pip(ra)): return la < ra
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
