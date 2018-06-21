import SpriteKit

public enum GameEvent : Equatable
{
    case winTrick(String)
    case winGame(String)
    case shotTheMoon(String)
    case winRicketyKate(String)
    case winHooligan(String)
    case winOmnibus(String)
    case winSpades(String,Int)
    case newHand
    case cardDoesNotFollowSuite(PlayingCard.Suite)
    case trumpsHaveNotBeenBroken
    case waitYourTurn
    case turnOverYourCards
    case suiteFinished(PlayingCard.Suite)
    case cardPlayed(CardHolderBase,PlayingCard)
    case playerKnocked(CardPlayer)
    case youNeedToPlayThisFirst(PlayingCard)
    case turnFor(CardPlayer)
    case showTip(Tip)
    case newGame
    case startHand
    case somethingHasGoneWrong
    case discardWorstCards(Int)

    var congrats : String  { return "Congratulatons".localize }
    var wow : String  { return "Wow".localize   }
    
    var description : String?
        {
            switch self
            {
            case .winTrick( let name ) :
                return  "%@ just Won the Trick".sayTo(name)
            case .playerKnocked( let player ) :
                return player.isYou
                    ? "You can not Play You have to Knock".localize
                    : "_ Knocked".localizeWith(player.name )
            case .youNeedToPlayThisFirst(let card) :
                return "You Need to Play %@ First".localizeWith(card.description)
            case .suiteFinished(let suite) :
                return suite.description + " " + "Finished".localize
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
                let start = "%@ won %d %@"
                    .with
                    .sayTo(name)
                    .pluralize(noOfSpades,arguements: GameSettings.sharedInstance.rules.shortDescription)
                    .localize
                return  start + "\n" + "Bad Luck".localize + "."
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
            case .newHand :
                    return nil
            case .somethingHasGoneWrong :
                return nil
            case .newGame :
                return "%@ Game On".localizeWith(GameSettings.sharedInstance.gameType)
            case .startHand :
                return nil
            case .cardPlayed :
                return nil
            case .trumpsHaveNotBeenBroken :
                return "Can not Lead with a %@".localizeWith(GameSettings.sharedInstance.rules.trumpSuiteSingular)
            case .cardDoesNotFollowSuite( let suite )  :
                return "Card Does Not Follow Suite".localize + "\n" + "Play a %@".localizeWith(suite.singular)
            case .waitYourTurn :
                return "Wait your turn".localize
            case .discardWorstCards(let noOfCardsLeft) :
                switch noOfCardsLeft
                {
                case 3 :
                  //  return "Discard Your".localize + "\n" + "Three Worst Cards".localize
                    return GameSettings.sharedInstance.gameType + "\n" + "Discard 3 cards".localize
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

public func ==(lhs: GameEvent, rhs: GameEvent) -> Bool {
    switch (lhs, rhs) {
        
    case let (.winTrick(la), .winTrick(ra)): return la == ra
    case let (.playerKnocked(la), .playerKnocked(ra)): return la == ra
    case let (.youNeedToPlayThisFirst(la), .youNeedToPlayThisFirst(ra)): return la == ra
    case let (.suiteFinished(la), .suiteFinished(ra)): return la == ra
    case let (.shotTheMoon(la), .shotTheMoon(ra)): return la == ra
    case let (.winGame(la), .winGame(ra)): return la == ra
    case let (.winRicketyKate(la), .winRicketyKate(ra)): return la == ra
    case let (.winHooligan(la), .winHooligan(ra)): return la == ra
    case let (.winOmnibus(la), .winOmnibus(ra)): return la == ra
    case let (.winSpades(la,li), .winSpades(ra,ri)): return la == ra && li == ri
    case let (.turnFor(la), .turnFor(ra)): return la == ra
    case let (.showTip(la), .showTip(ra)): return la == ra
    case let (.discardWorstCards(la), .discardWorstCards(ra)): return la == ra
    case (.newHand, .newHand): return true
    case (.cardDoesNotFollowSuite, .cardDoesNotFollowSuite): return true
    case (.waitYourTurn, .waitYourTurn): return true
    case (.newGame, .newGame): return true
    case (.startHand, .startHand): return true
        
    default: return false
    }
}
