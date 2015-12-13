//
//  CardPlayer.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 11/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit
import ReactiveCocoa



// Cut down version of a CardPlayer that is visible to tests
public protocol CardHolder
{
    func cardsIn(suite:PlayingCard.Suite) -> [PlayingCard]
    
    var hand : [PlayingCard] { get }
}

extension CardHolder
{
    public var RicketyKate : PlayingCard?
        {
            let RicketyKate = hand.filter { $0.isRicketyKate}
            
            return RicketyKate.first
    }
}
public class NoPlayer:  CardHolderBase
{
    init() {
        super.init(name: "Played")
    }
}
public class CardHolderBase :  CardHolder
{
    public var name : String = "Base"
    public var isYou : Bool { return name=="You".localize }
    lazy var _hand : CardFan = CardFan(name: CardPileType.Hand.description, player:self)
    public var hand : [PlayingCard] { get { return _hand.cards } set { _hand.cards = newValue }}
    public func cardsIn(suite:PlayingCard.Suite) -> [PlayingCard]
    {
        return _hand.cards.filter {$0.suite == suite}
    }
    
    init(name s: String) {
        self.name = s
    }
    public func removeFromHand(card:PlayingCard) -> PlayingCard?
    {
        return _hand.remove(card)
    }
}



// Models the state and behaviour of each of the players in the game
public class CardPlayer :CardHolderBase , Equatable, Hashable
{
    //////////////////////////////////////
    /// Variables
    //////////////////////////////////////
    // public var score : Int = 0
    var currentTotalScore  = MutableProperty<Int>(0)
    var isSetup = false
    var noOfWins = MutableProperty<Int>(0)
    var scoreForCurrentHand = 0
    public var sideOfTable = SideOfTable.Bottom
    var playerNo = 0
    var wonCards : CardPile = CardPile(name: CardPileType.Won.description)
    static let computerPlayers = [ComputerPlayer(name:"Fred",margin: 2),ComputerPlayer(name:"Molly",margin: 3),ComputerPlayer(name:"Greg",margin: 1),ComputerPlayer(name:"Sarah",margin: 4),ComputerPlayer(name:"Warren",margin: 5),ComputerPlayer(name:"Linda",margin: 3),ComputerPlayer(name:"Rita",margin: 4)]
    
    ////////////////////////////////////////////
    /// Static Functions
    ///////////////////////////////////////////
    
    static func demoPlayers(noOfPlayers:Int) -> [CardPlayer]
    {
        return Array(computerPlayers[0..<noOfPlayers])
    }
    
    static func gamePlayers(noOfPlayers:Int) -> [CardPlayer]
    {
        let noOfComputerPlayers = noOfPlayers - 1
        return [HumanPlayer.sharedInstance] + Array(computerPlayers[0..<noOfComputerPlayers])
    }
    
    ///////////////////////////////////////
    /// Hashable Protocol
    ///////////////////////////////////////
    public var hashValue: Int {
        return self.name.hashValue
    }
    

    /////////////////////////////////
    /// Constructors and setup
    /////////////////////////////////
    func setup(scene: CardScene, sideOfTable: SideOfTable, playerNo: Int, isPortrait: Bool)
    {
        
        self.isSetup = true
        self.sideOfTable = sideOfTable
        self.playerNo = playerNo
        let isUp = sideOfTable == SideOfTable.Bottom
        let cardSize = isUp ? (isPortrait ? CardSize.Medium :CardSize.Big) : CardSize.Small
        _hand.setup(scene, sideOfTable: sideOfTable, isUp: isUp, sizeOfCards: cardSize)
        wonCards.setup(scene, direction: sideOfTable.direction, position: sideOfTable.positionOfWonCards(scene.frame.width, height: scene.frame.height))
    }
    
    func setPosition(size:CGSize, sideOfTable: SideOfTable)
    {
        if self.isSetup
        {
            _hand.tableSize = size
            
            self.sideOfTable = sideOfTable
            _hand.sideOfTable = sideOfTable
            let isPortrait = size.width < size.height
            let isUp = sideOfTable == SideOfTable.Bottom
            _hand.sizeOfCards = isUp ? (isPortrait ? CardSize.Medium :CardSize.Big) : CardSize.Small
            wonCards.position = sideOfTable.positionOfWonCards(size.width, height: size.height)
            wonCards.tableSize = size
            wonCards.update()
            _hand.update()
        }
    }
    ///////////////////////////////////
    /// Instance Methods
    ///////////////////////////////////
    
    public func newHand(cards: [PlayingCard]  )
    {
        _hand.replaceWithContentsOf(cards)
    }
    
    public func appendContentsToHand(cards: [PlayingCard]  )
    {
        _hand.appendContentsOf(cards);
    }
    
}

public class HumanPlayer :CardPlayer
{
    static let sharedInstance = HumanPlayer()
    private init() {

        super.init(name: "You".localize)
    }
}

public class ComputerPlayer :CardPlayer
{
    //////////////////////////////////////
    /// Variables
    //////////////////////////////////////
    var strategies = [TrickPlayingStrategy]()
    var passingStrategy = HighestCardsPassingStrategy.sharedInstance
    
    
    
    /////////////////////////////////
    /// Constructors and setup
    /////////////////////////////////
    public init(name s: String,margin:Int) {
        super.init(name: s)
        strategies  = [
            PerfectKnowledgeStrategy.sharedInstance,
            NonFollowingStrategy.sharedInstance,
            EarlyGameLeadingStrategy(margin:margin),
            EarlyGameFollowingStrategy(margin:margin),
            LateGameLeadingStrategy.sharedInstance,
            LateGameFollowingStrategy.sharedInstance]
    }
    
    ///////////////////////////////////
    /// Instance Methods
    ///////////////////////////////////
    public func playCard(gameState:GameState) -> PlayingCard?
    {
        for strategy in strategies
        {
            if let card : PlayingCard = strategy.chooseCard( self, gameState:gameState)
            {
                return card
            }
        }
        return RandomStrategy.sharedInstance.chooseCard(self,gameState:gameState)
    }
    
    public func passCards() -> [PlayingCard]
    {
        return passingStrategy.chooseWorstCards(self)
    }

    
}

public class FakeCardHolder : CardHolderBase
{

    
    //////////
    // internal functions
    //////////
    public func addCardsToHand(cardCodes:[String])
    {
        hand.appendContentsOf(cardCodes.map { $0.card } )
    }
    
    public init() {
        super.init(name: "Fake")
    }
    
}
////////////////////////////////////////////////////////////
/// Equatable Protocol
///////////////////////////////////////////////////////////

public func ==(lhs: CardPlayer, rhs: CardPlayer) -> Bool
{
    return lhs.name == rhs.name
}