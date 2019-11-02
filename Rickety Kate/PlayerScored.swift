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
    case shotTheMoon(CardPlayer)
    case winRicketyKate(CardPlayer)
    case winHooligan(CardPlayer)
    case winOmnibus(CardPlayer)
    case winSpades(CardPlayer,Int)
    
    
    public var sound : [String]
    {
        switch self
          {
          case .shotTheMoon( let player ) :
            return player.isYou ? ["YouShot"] :[player.sound,"Shot"]
          case .winRicketyKate( let player ) :
            return player.isYou ? ["YouKissed"] :[player.sound,"Kissed"]
          case .winHooligan( let player ) :
            return  player.isYou ? ["YouBashed"] :[player.sound,"Bashed"]
          case .winOmnibus( let player ) :
            return player.isYou ? ["YouBus"] :[player.sound,"Bus"]
          case .winSpades( let player,  let noOfSpades ) :
            var talk = player.isYou ? "YouWon" : "Won"
            talk += Game.moreSettings.rules.shortDescription
            if noOfSpades > 1 { talk += "s"}
            return player.isYou ?  [talk] : [player.sound,talk]
         /*    case .winSpades( let player, _ ) :
                     return player.isYou ?
                            [ "YouWon",Game.moreSettings.rules.shortDescription] : [player.sound,"Won",Game.moreSettings.rules.shortDescription]
           */
          }
    }
    public var description : String?
    {
        switch self
        {
        case .shotTheMoon( let player ) :
            return "%@ just Shot the Moon".sayCongratsTo(player.name)
        case .winRicketyKate( let player ) :
            return  "%@ was kissed by Rickety Kate Poor %@".sayTwiceTo(player.name)
        case .winHooligan( let player ) :
            return  "%@ was bashed by the Hooligan Poor %@".sayTwiceTo(player.name)
        case .winOmnibus( let player ) :
            return "%@ just Caught the Bus".sayCongratsTo(player.name)
        case .winSpades( let player, let noOfSpades ) :
            let spades = Game.moreSettings.rules.shortDescription
            let start = "%@ won %d %@"
                .with
                .sayTo(player.name)
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



