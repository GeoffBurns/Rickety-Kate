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
    case TurnOverYourCards
    case SuiteFinished(PlayingCard.Suite)
    case CardPlayed(CardHolderBase,PlayingCard)
    case PlayerKnocked(CardPlayer)
    case YouNeedToPlayThisFirst(PlayingCard)
    case TurnFor(CardPlayer)
    case ShowTip(Tip)
    case NewGame
    case StartHand
    case SomethingHasGoneWrong
    case DiscardWorstCards(Int)

    var congrats : String  { return "Congratulatons".localize }
    var wow : String  { return "Wow".localize   }
    
    var description : String?
        {
            switch self
            {
            case WinTrick( let name ) :
                return  "_ just Won the Trick".sayTo(name)
            case PlayerKnocked( let player ) :
                return player.isYou
                    ? "You can not Play You have to Knock".localize
                    : "_ Knocked".localizeWith(player.name )
            case YouNeedToPlayThisFirst(let card) :
                return "You Need to Play _ First".localizeWith(card.description)
            case SuiteFinished(let suite) :
                return suite.description + " " + "Finished".localize
            case ShotTheMoon( let name ) :
                return "_ just Shot the Moon".sayCongratsTo(name)
            case WinGame( let name ) :
                return "_ just Won the Game".sayCongratsTo(name)
            case WinRicketyKate( let name ) :
                return  "_ was kissed by Rickety Kate Poor _".sayTwiceTo(name)
            
            case WinHooligan( let name ) :
                return  "_ was bashed by the Hooligan Poor _".sayTwiceTo(name)
            case WinOmnibus( let name ) :
                return "_ just Caught the Bus".sayCongratsTo(name)
            case WinSpades( let name, let noOfSpades ) : 
                let start = "_ won * _"
                    .with
                    .sayTo(name)
                    .pluralize(noOfSpades,arguements: GameSettings.sharedInstance.rules.shortDescription)
                    .localize
                return  start + "\n" + "Bad Luck".localize + "."
            case TurnOverYourCards :
                return "Swipe to turn over your cards".localize
            case TurnFor( let player ) :
                if player is HumanPlayer
                {
                    return player.isYou
                        ? "Your Turn".localize
                        : "_ Turn".localizeWith(player.name )
                } else { return nil }
            case ShowTip( let tip ) :
                return tip.description
            case NewHand :
                    return nil
            case SomethingHasGoneWrong :
                return nil
            case NewGame :
                return "_ Game On".localizeWith(GameSettings.sharedInstance.gameType)
            case StartHand :
                return nil
            case CardPlayed :
                return nil
            case TrumpsHaveNotBeenBroken :
                return "Can not Lead with a _".localizeWith(GameSettings.sharedInstance.rules.trumpSuiteSingular)
            case CardDoesNotFollowSuite :
                return "Card Does Not Follow Suite".localize
            case WaitYourTurn :
                return "Wait your turn".localize
            case DiscardWorstCards(let noOfCardsLeft) :
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
                let messageLines = message.componentsSeparatedByString("\n")
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
                let messageLines = message.componentsSeparatedByString("\n")
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
        
    case let (.WinTrick(la), .WinTrick(ra)): return la == ra
    case let (.PlayerKnocked(la), .PlayerKnocked(ra)): return la == ra
    case let (.YouNeedToPlayThisFirst(la), .YouNeedToPlayThisFirst(ra)): return la == ra
    case let (.SuiteFinished(la), .SuiteFinished(ra)): return la == ra
    case let (.ShotTheMoon(la), .ShotTheMoon(ra)): return la == ra
    case let (.WinGame(la), .WinGame(ra)): return la == ra
    case let (.WinRicketyKate(la), .WinRicketyKate(ra)): return la == ra
    case let (.WinHooligan(la), .WinHooligan(ra)): return la == ra
    case let (.WinOmnibus(la), .WinOmnibus(ra)): return la == ra
    case let (.WinSpades(la,li), .WinSpades(ra,ri)): return la == ra && li == ri
    case let (.TurnFor(la), .TurnFor(ra)): return la == ra
    case let (.ShowTip(la), .ShowTip(ra)): return la == ra
    case let (.DiscardWorstCards(la), .DiscardWorstCards(ra)): return la == ra
    case (.NewHand, .NewHand): return true
    case (.CardDoesNotFollowSuite, .CardDoesNotFollowSuite): return true
    case (.WaitYourTurn, .WaitYourTurn): return true
    case (.NewGame, .NewGame): return true
    case (.StartHand, .StartHand): return true
        
    default: return false
    }
}
