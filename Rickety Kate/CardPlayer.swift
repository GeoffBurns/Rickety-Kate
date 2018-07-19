//
//  CardPlayer.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 11/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit
import ReactiveSwift


// Cut down version of a CardPlayer that is visible to tests
public protocol CardHolder
{
    func cardsIn(_ suite:PlayingCard.Suite) -> [PlayingCard]
    
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
extension Sequence where Iterator.Element == PlayingCard
{
public func cardsIn(_ suite:PlayingCard.Suite) -> [PlayingCard]
{
    return self.filter {suite == $0.suite}
}
    
    public func cardsNotIn(_ suite:PlayingCard.Suite) -> [PlayingCard]
    {
        return self.filter {suite != $0.suite}
    }
}


open class NoPlayer:  CardHolderBase
{
    init() {
        super.init(name: "Played")
    }
}
open class CardHolderBase :  CardHolder
{
    open var name : String = "Base"
    open var isYou : Bool { return name=="You".localize }
    lazy var _hand : CardFan = CardFan(name: CardPileType.hand.description, player:self)
    open var hand : [PlayingCard] { get { return _hand.cards } set { _hand.cards = newValue }}
    open func cardsIn(_ suite:PlayingCard.Suite) -> [PlayingCard]
    {
        return _hand.cards.filter {$0.suite == suite}
    }
    
    init(name s: String) {
        self.name = s
    }
    open func removeFromHand(_ card:PlayingCard) -> PlayingCard?
    {
        return _hand.remove(card)
    }
}



// Models the state and behaviour of each of the players in the game
open class CardPlayer :CardHolderBase , Equatable, Hashable
{
    //////////////////////////////////////
    /// Variables
    //////////////////////////////////////
    // public var score : Int = 0
    var currentTotalScore  = MutableProperty<Int>(0)
    var isSetup = false
    var noOfWins = MutableProperty<Int>(0)
    var scoreForCurrentHand = 0
    open var sideOfTable = SideOfTable.bottom
    var playerNo = 0
    var wonCards : CardPile = CardPile(name: CardPileType.won.description)
 
    ///////////////////////////////////////////
    /// Static Functions
    ///////////////////////////////////////////
    static func demoPlayers(_ noOfPlayers:Int) -> [CardPlayer]
    {
        return Usher.players(noOfPlayers,noOfHumans: 0)
    }
    
    static func gamePlayers(_ noOfPlayers:Int) -> [CardPlayer]
    {
        var noOfHumanPlayers = Game.settings.noOfHumanPlayers
        noOfHumanPlayers = noOfHumanPlayers < 1 ? 1 : noOfHumanPlayers
        noOfHumanPlayers = noOfHumanPlayers > noOfPlayers ? noOfPlayers : noOfHumanPlayers
        
        return Usher.players(noOfPlayers,noOfHumans: noOfHumanPlayers)
    }
    
    ///////////////////////////////////////
    /// Hashable Protocol
    ///////////////////////////////////////
    open var hashValue: Int {
        return self.name.hashValue
    }
    
    /////////////////////////////////
    /// Constructors and setup
    /////////////////////////////////
    func setup(_ scene: CardScene, sideOfTable: SideOfTable, playerNo: Int, isPortrait: Bool)
    {
        
        self.isSetup = true
        self.sideOfTable = sideOfTable
        self.playerNo = playerNo
        let isUp = sideOfTable == SideOfTable.bottom
        let cardSize = isUp ? (isPortrait ? CardSize.medium :CardSize.big) : CardSize.small
        _hand.setup(scene, sideOfTable: sideOfTable, isUp: isUp, sizeOfCards: cardSize)
        wonCards.setup(scene, direction: sideOfTable.direction, position: sideOfTable.positionOfWonCards(scene.frame.width, height: scene.frame.height))
    }
    
    func setPosition(_ size:CGSize, sideOfTable: SideOfTable)
    {
        if self.isSetup
        {
            _hand.tableSize = size
            
            self.sideOfTable = sideOfTable
            _hand.sideOfTable = sideOfTable
            _hand.direction = sideOfTable.direction
            
            let isPortrait = size.width < size.height
            let isUp = sideOfTable == SideOfTable.bottom
            _hand.sizeOfCards = isUp ? (isPortrait ? CardSize.medium :CardSize.big) : CardSize.small
            wonCards.position = sideOfTable.positionOfWonCards(size.width, height: size.height)
            wonCards.tableSize = size
      //      wonCards.update()
      //      _hand.update()
        }
    }
    ///////////////////////////////////
    /// Instance Methods
    ///////////////////////////////////
    
    open func newHand(_ cards: [PlayingCard]  )
    {
        _hand.replaceWithContentsOf(cards)
    }
    
    open func appendContentsToHand(_ cards: [PlayingCard]  )
    {
        _hand.appendContentsOf(cards);
    }
    
}

open class HumanPlayer :CardPlayer
{
    public init() {
        super.init(name: GameKitHelper.sharedInstance.displayName)
    }
    
    public override init(name:String) {
        super.init(name: name )
    }
}



open class FakeCardHolder : CardHolderBase
{

    
    //////////
    // internal functions
    //////////
    open func addCardsToHand(_ cardCodes:[String])
    {
        hand.append(contentsOf: cardCodes.map { $0.card } )
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
