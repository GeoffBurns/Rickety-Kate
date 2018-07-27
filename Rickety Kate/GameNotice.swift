//
//  GameNotice.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 27/7/18.
//  Copyright © 2018 Geoff Burns. All rights reserved.
//
import Cards

public enum GameNotice : Equatable
{
    case winTrick(String)
    case winGame(String)
    case shotTheMoon(String)
    case winRicketyKate(String)
    case winHooligan(String)
    case winOmnibus(String)
    case winSpades(String,Int)
    case invalidMove(Move)
    case validMove(Move)
    case waitYourTurn
    case turnOverYourCards
    case turnFor(CardPlayer)
    case showTip(Tip)
    case newGame
    case discardWorstCards(Int)
    
    var congrats : String  { return "Congratulatons".localize }
    var wow : String  { return "Wow".localize   }
    
    var description : String?
    {
        switch self
        {
        case .winTrick( let name ) :
            return  "%@ just Won the Trick".sayTo(name)
        case .shotTheMoon( let name ) :
            return "%@ just Shot the Moon".sayCongratsTo(name)
        case .winGame( let name ) :
            return "%@ just Won the Game".sayCongratsTo(name)
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
        case .turnOverYourCards :
            return "Swipe to turn over your cards".localize
        case .turnFor( let player ) :
            if player is HumanPlayer
            {
                return player.isYou
                    ? "Your Turn".localize
                    : "%@ Turn".localizeWith(player.name )
            } else { return nil }
        case .showTip( let tip ) :
            return tip.description
        case .newGame :
            return "%@ Game On".localizeWith(Game.moreSettings.gameType)
        case .invalidMove( let move )  :
            return move.description
        case .validMove( let move )  :
            return move.description
        case .waitYourTurn :
            return "Wait your turn".localize
        case .discardWorstCards(let noOfCardsLeft) :
            switch noOfCardsLeft
            {
            case 3 :
                //  return "Discard Your".localize + "\n" + "Three Worst Cards".localize
                return Game.moreSettings.gameType + "\n" + "Discard 3 cards".localize
            case 1 :
                return "Discard one more card".localize + "\n" + "Your worst card".localize
            default :
                return "Discard two more cards".localize + "\n" + "Your worst cards".localize
            }
        }
    }
    
    var line2 : String?
    {
        if let message = description {
            if message == "" {
                return ""
            }
            let messageLines = message.components(separatedBy: "\n")
            switch (messageLines.count) {
            case 1 :
                return message
            default :
                return messageLines[1]
            }
        }
        return nil
    }
    var line1 : String?
    {
        if let message = description {
            if message == "" {
                return ""
            }
            let messageLines = message.components(separatedBy: "\n")
            switch (messageLines.count) {
            case 1 :
                return ""
            default :
                return messageLines[0]
            }
        }
        return nil
    }
}

public func ==(lhs: GameNotice, rhs: GameNotice) -> Bool {
    switch (lhs, rhs) {
        
    case let (.winTrick(la), .winTrick(ra)): return la == ra
        
    case let (.shotTheMoon(la), .shotTheMoon(ra)): return la == ra
    case let (.winGame(la), .winGame(ra)): return la == ra
    case let (.winRicketyKate(la), .winRicketyKate(ra)): return la == ra
    case let (.winHooligan(la), .winHooligan(ra)): return la == ra
    case let (.winOmnibus(la), .winOmnibus(ra)): return la == ra
    case let (.winSpades(la,li), .winSpades(ra,ri)): return la == ra && li == ri
    case let (.turnFor(la), .turnFor(ra)): return la == ra
    case let (.showTip(la), .showTip(ra)): return la == ra
    case let (.discardWorstCards(la), .discardWorstCards(ra)): return la == ra
    case let (.invalidMove(la), .invalidMove(ra)): return la == ra
    case let (.validMove(la), .validMove(ra)): return la == ra
    case (.waitYourTurn, .waitYourTurn): return true
    case (.newGame, .newGame): return true
        
    default: return false
    }
}
