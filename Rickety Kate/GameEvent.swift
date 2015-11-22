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
    case SuiteFinished(PlayingCard.Suite)
    case CardPlayed(CardHolderBase,PlayingCard)
    case PlayerKnocked(CardHolderBase)
    case YouNeedToPlayThisFirst(PlayingCard)
    case YourTurn
    case NewGame
    case StartHand
    case NotYourTurn
    case SomethingHasGoneWrong
    case DiscardWorstCards(Int)
    
    
    var congrats : String  { return "Congratulatons".localize + "\n"}
    var wow : String  { return "Wow!".localize  + "\n" }
    
    var description : String?
        {
            switch self
            {
            case WinTrick( let name ) :
                return name.isYou
                    ? "You just Won the Trick".localize_
                    : "_ just Won the Trick".localizeWith(name)
            case PlayerKnocked( let player ) :
                return player.isYou
                    ? "You can not Play You have to Knock".localize_
                    : "_ Knocked".localizeWith(player.name )
            case YouNeedToPlayThisFirst(let card) :
                return "You Need to Play _ First".localizeWith(card.description)
            case SuiteFinished(let suite) :
                return suite.description + " " + "Finished".localize
            case ShotTheMoon( let name ) :
                return name.isYou
                    ? congrats + "You just Shot the Moon".localize_
                    : wow + name + " " + "just Shot the Moon".localize_
            case WinGame( let name ) :
                return name.isYou
                    ? congrats + "You just Won the Game".localize_
                    : wow + name + " " + "just Won the Game".localize_
            case WinRicketyKate( let name ) :
                return name.isYou
                    ? "you were kissed by".localize_ + "\nRickety Kate. " + "Poor you".localize_ + "."
                    : name + " " + "was kissed by".localize_ + "\nRickety Kate. " + "Poor".localize + " " + name + "."
            case WinHooligan( let name ) :
                return name.isYou
                    ? "you were bashed by".localize_ + "\n" + "the Hooligan".localize_ + ". " + "Poor you".localize_ + "."
                    : name + " " + "was kissed by".localize_ + "\n" + "the Hooligan".localize_ + ". " + "Poor".localize + " " + name + "."
            case WinOmnibus( let name ) :
                return name.isYou
                    ? congrats + "You just Caught the Bus".localize_
                    : wow + name + " " + "just Caught the Bus".localize_
            case WinSpades( let name, let noOfSpades ) :

                var start = ""
                if name.isYou
                {
                  start = (noOfSpades == 1)
                        ?  "You won a _".localizeWith(GameSettings.sharedInstance.rules.trumpSuiteSingular)
                        :  "You won _ _".localizeWith(noOfSpades,GameSettings.sharedInstance.rules.trumpSuiteSingular)
                }
                else
                {
                    start = (noOfSpades == 1)
                        ?  "_ won a _".localizeWith(name,GameSettings.sharedInstance.rules.trumpSuiteSingular)
                        :  "_ won _ _".localizeWith(name,noOfSpades,GameSettings.sharedInstance.rules.trumpSuiteSingular)
                }
                return  start + "\n" + "Bad Luck".localize_ + "."
                
                
            case NewHand :
                return nil
            case SomethingHasGoneWrong :
                return nil
            case YourTurn :
                return "Your Turn".localize_
            case NewGame :
                return "Game On".localize_
            case StartHand :
                return nil
            case CardPlayed :
                return nil
            case NotYourTurn :
                return ""
            case TrumpsHaveNotBeenBroken :
                return "Can not Lead with a _".localizeWith(GameSettings.sharedInstance.rules.trumpSuiteSingular)
            case CardDoesNotFollowSuite :
                return "Card Does Not Follow Suite".localize_
            case WaitYourTurn :
                return "Wait your turn".localize_
            case DiscardWorstCards(let noOfCardsLeft) :
                switch noOfCardsLeft
                {
                case 3 :
                    return "Discard Your".localize_ + "\n" + "Three Worst Cards".localize_
                case 1 :
                    return "Discard one more card".localize_ + "\n" + "Your worst card".localize_
                default :
                    return "Discard two more cards".localize_ + "\n" + "Your worst cards".localize_
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
