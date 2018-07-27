//
//  PlayerScored.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 27/7/18.
//  Copyright © 2018 Geoff Burns. All rights reserved.
//


import Cards



public enum Scored  : PlayerScored , Equatable
{
    case shotTheMoon(String)
    case winRicketyKate(String)
    case winHooligan(String)
    case winOmnibus(String)
    case winSpades(String,Int)
    
    public var description : String?
    {
        switch self
        {
        case .shotTheMoon( let name ) :
            return "%@ just Shot the Moon".sayCongratsTo(name)
        case .winRicketyKate( let name ) :
            return  "%@ was kissed by Rickety Kate Poor %@".sayTwiceTo(name)
        case .winHooligan( let name ) :
            return  "%@ was bashed by the Hooligan Poor %@".sayTwiceTo(name)
        case .winOmnibus( let name ) :
            return "%@ just Caught the Bus".sayCongratsTo(name)
        case .winSpades( let name, let noOfSpades ) :
            let spades = Game.moreSettings.rules.shortDescription
            let start = "%@ won %d %@"
                .with
                .sayTo(name)
                .pluralize(noOfSpades,arguements: spades)
            
            let local = start.localize
            return  local + "\n" + "Bad Luck".localize + "."
            
        }
    }
    
    
}


public func ==(lhs: Scored, rhs: Scored) -> Bool {
    switch (lhs, rhs) {
    case let (.shotTheMoon(la), .shotTheMoon(ra)): return la == ra

    case let (.winRicketyKate(la), .winRicketyKate(ra)): return la == ra
    case let (.winHooligan(la), .winHooligan(ra)): return la == ra
    case let (.winOmnibus(la), .winOmnibus(ra)): return la == ra
    default: return false
    }
}



