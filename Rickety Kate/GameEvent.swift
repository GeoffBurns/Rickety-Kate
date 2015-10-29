//
//  GameEvent.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 7/10/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

public enum GameEvent : Equatable
{
    case WinTrick(String)
    case WinGame(String)
    case ShotTheMoon(String)
    case WinRicketyKate(String)
    case WinHooligan(String)
    case WinOmnibus(String)
    case WinSpades(String,Int)
    case NewHand
    case CardDoesNotFollowSuite
    case TrumpsHaveNotBeenBroken
    case WaitYourTurn
    case CardPlayed(CardPlayer,PlayingCard)
    case PlayerKnocked(CardPlayer)
    case YourTurn
    case NewGame
    case StartHand
    case NotYourTurn
    case DiscardWorstCards(Int)
    
    var description : String?
        {
        switch self
            {
            case WinTrick( let name ) :
                return  name + " just Won the Trick"
            case PlayerKnocked( let player ) :
                return player.name=="You"
                    ? "You can not Play\nYou have to Knock"
                    : player.name + " Knocked"
            case ShotTheMoon( let name ) :
                return name=="You"
                    ? "Congratulatons!!!\nYou just Shot the Moon"
                    : "Wow!!!\n\(name) just Shot the Moon"
            case WinGame( let name ) :
                return name=="You"
                    ? "Congratulatons!!!\nYou just Won the Game"
                    : "Wow!!!\n\(name) just Won the Game"
            case WinRicketyKate( let name ) :
                return name=="You"
                    ? name + " were kissed by\nRickety Kate. Poor " + name
                    : name + " was kissed by\nRickety Kate. Poor " + name
            case WinHooligan( let name ) :
                return name=="You"
                    ? name + " were bashed by\nthe Hooligan. Poor " + name
                    : name + " was bashed by\nthe Hooligan. Poor " + name
            case WinOmnibus( let name ) :
                return name=="You"
                   ? "Congratulatons!\nYou just Caught the Bus"
                   : "Wow!\n\(name) just Caught the Bus"
            case WinSpades( let name, let noOfSpades ) :
                return  noOfSpades == 1
                    ? name + " won a \(GameSettings.sharedInstance.rules.trumpSuiteSingular)\nBad Luck"
                    : name + " won \(noOfSpades) \(GameSettings.sharedInstance.rules.trumpSuite.description)\nBad Luck"
            case NewHand :
                return nil
            case YourTurn :
                return "Your Turn"
            case NewGame :
                return "Game On"
            case StartHand :
                return nil
            case CardPlayed :
                return nil
            case NotYourTurn :
                return ""
            case TrumpsHaveNotBeenBroken :
                return "Can not Lead with a " + GameSettings.sharedInstance.rules.trumpSuiteSingular +
                "\nAs " + GameSettings.sharedInstance.rules.trumpSuitePlural + " Have Not Been Broken"
            case CardDoesNotFollowSuite :
                return "Card Does Not\nFollow Suite"
            case WaitYourTurn :
                return "Wait your turn"
            case DiscardWorstCards(let noOfCardsLeft) :
                switch noOfCardsLeft
                {
                case 3 :
                    return "Discard Your\nThree Worst Cards"
                case 1 :
                    return "Discard one more card\nYour worst card"
                default :
                    return "Discard \(noOfCardsLeft) more cards\nYour worst cards"
                }
            }
    }
}

public func ==(lhs: GameEvent, rhs: GameEvent) -> Bool {
    switch (lhs, rhs) {
        
    case let (.WinTrick(la), .WinTrick(ra)): return la == ra
    case let (.WinGame(la), .WinGame(ra)): return la == ra
    case let (.WinRicketyKate(la), .WinRicketyKate(ra)): return la == ra
    case let (.WinSpades(la,li), .WinSpades(ra,ri)): return la == ra && li == ri
    case let (.DiscardWorstCards(la), .DiscardWorstCards(ra)): return la == ra
    case (.NewHand, .NewHand): return true
    case (.CardDoesNotFollowSuite, .CardDoesNotFollowSuite): return true
    case (.WaitYourTurn, .WaitYourTurn): return true
    case (.YourTurn, .YourTurn): return true
    case (.NewGame, .NewGame): return true
    case (.StartHand, .StartHand): return true
    case (.NotYourTurn, .NotYourTurn): return true
        
    default: return false
    }
}
