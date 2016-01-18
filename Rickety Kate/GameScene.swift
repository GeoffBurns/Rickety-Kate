//
//  GameScene.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 10/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit
import ReactiveCocoa

public protocol HasDiscardArea : class
{
    var discardPile : CardPile { get }
    var discardWhitePile : CardPile { get }
}

public class CardScene : SKScene, HasDiscardArea, PositionedOnTable  {
    
    public var discardPile = CardPile(name: CardPileType.Discard.description)
    public var discardWhitePile = CardPile(name: CardPileType.Discard.description)
    public var tableSize = CGSize()
}

extension HasDiscardArea
{
    func setupDiscardArea()
    {
        
        discardWhitePile.isBackground = true
        discardPile.setup(self, direction: Direction.Up, position: CGPoint(x: -300, y: -300),isUp: false)
        discardWhitePile.setup(self, direction: Direction.Up, position: CGPoint(x: -300, y: -300),isUp: false)
//        discardPile.isDiscard = true
//        discardWhitePile.isDiscard = true
        discardWhitePile.speed = 0.1
    }
}
protocol HasDealersArea : HasDiscardArea
{
    var dealtPiles : [CardPile] { get set }
    
}
protocol PositionedOnTable
{
     var tableSize : CGSize { get set }
    
}

extension CGSize
{
      var isPortrait : Bool { return self.width < self.height }
}

extension PositionedOnTable
{
    var isPortrait : Bool { return tableSize.isPortrait }
}

extension HasDealersArea
{
    func setupDealersAreaFor(noOfPlayers:Int,size:CGSize)
    {
        let width = size.width
        let height = size.height
        dealtPiles = []
        let hSpacing = CGFloat(noOfPlayers) * 2
        let directions = [Direction.Down,Direction.Right,Direction.Right,Direction.Up,Direction.Up,Direction.Left,Direction.Left,Direction.Left,Direction.Left,Direction.Left,Direction.Left]
        for i in 0..<noOfPlayers
        {
            let dealtPile = CardPile(name: CardPileType.Dealt.description)
            dealtPile.setup(self, direction: directions[i], position: CGPoint(x: width * CGFloat(2 * i  - 3) / hSpacing,y: height*1.2), isUp: false)
            dealtPile.speed = 0.1
            dealtPiles.append(dealtPile)
        }
        
    }
    
    func deal(hands:[[PlayingCard]])
    {
        for (dealtPile,hand) in Zip2Sequence(dealtPiles,hands)
        {
            dealtPile.replaceWithContentsOf(hand)
        }
    }
}

protocol HasBackgroundSpread : HasDiscardArea
{
    var backgroundFan : CardFan { get }
    
}
extension HasBackgroundSpread
{
    func setupBackgroundSpread( )
    {
        backgroundFan.isBackground = true
        backgroundFan.setup(self, sideOfTable: SideOfTable.Center, isUp: true, sizeOfCards: CardSize.Medium)
        backgroundFan.zPositon = 0.0
        backgroundFan.speed = 0.1
    }
    func fillBackgroundSpreadWith(cards:[PlayingCard])
    {
        backgroundFan.discardAll()
        backgroundFan.replaceWithContentsOf(cards)
    }
}


class CardGameScene : CardScene, HasDealersArea {
    
    var table : RicketyKateCardTable! 
    var dealtPiles = [CardPile]()

    func createCardPilesToProvideStartPointForCardAnimation(size:CGSize )
    {
        setupDealersAreaFor(table.players.count,size:size )
        deal(table.dealtHands)
    }

    /// at end of game return sprites to start
    func discard()
    {
        for player in table.players
        {
            player._hand.discardAll()
         }
        table.trickFan.discardAll()
    }

}

protocol HasDraggableCards : class
{

    var draggedNode: CardSprite? { get set }
}

extension HasDraggableCards
{
    func restoreDraggedCard()
    {
        if let cardsprite = draggedNode
            
        {
            cardsprite.setdown()
            draggedNode=nil
        }
    }
    func quickSwapDraggedCard(newCard:CardSprite,originalPosition:CGPoint)
    {
    draggedNode?.setdownQuick()
    newCard.liftUpQuick(originalPosition)
    draggedNode = newCard;
    }
    func startDraggingCard(newCard:CardSprite,originalPosition:CGPoint)
    {
    draggedNode = newCard
    newCard.liftUp(originalPosition)
    }
}

/// How game play is displayed
class RicketyKateGameScene: CardGameScene, HasBackgroundSpread, HasDraggableCards, Resizable{

    
    override var table : RicketyKateCardTable! {  didSet { setupPassYourThreeWorstCardsPhase() } }
    var originalTouch = CGPoint()
    var draggedNode: CardSprite? = nil;
    var cardScaleForSelected = CGFloat(1.05)

    var backgroundFan = CardFan(name: CardPileType.Background.description)
    var playButton1 =  SKSpriteNode(imageNamed:"Play1")
    var playButton2 =  SKSpriteNode(imageNamed:"Random1")
    var arePassingCards : Bool { return  GameSettings.sharedInstance.willPassCards && !table.isInDemoMode }
    var cardPassingPhase : PassYourThreeWorstCardsPhase! = nil

    var adHeight = CGFloat(0)
    var currentPlayer = MutableProperty<CardPlayer>(CardPlayer(name: "None"))
    
    func setupPassYourThreeWorstCardsPhase()
    {
        cardPassingPhase =  PassYourThreeWorstCardsPhase(scene: self,players: table.players);
    }
    
    func seatPlayers()
    {
    
        let seats = self.isPortrait ? Seater.portraitSeatsFor(table.players.count) : Seater.seatsFor(table.players.count)
        for (i,(player,seat)) in Zip2Sequence(table.players,seats).enumerate()
        {
            player.setup(self, sideOfTable: seat, playerNo: i,isPortrait: self.isPortrait)
        }
    }
    func arrangeLayoutFor(size:CGSize, bannerHeight:CGFloat)
    {
    let width = size.width
    let height = size.height -  bannerHeight
      
    let newSize = CGSizeMake(width, height)
 
    if let rulesButton = self.childNodeWithName("Rules1")
          {
          rulesButton.position = CGPoint(x:0.0,y:size.height )
          }
    if table.isInDemoMode
        {
            
            playButton1.position = CGPoint(x:width*0.25,y:height*0.5+bannerHeight)
            playButton2.position = CGPoint(x:width*0.75,y:height*0.5+bannerHeight)
            
        if let optionsButton = self.childNodeWithName("Options1")
          {
            optionsButton.position = CGPoint(x:size.width,y:size.height)
          }
        } else {
            if  let exitButton = self.childNodeWithName("Exit")
            {
                exitButton.position = CGPoint(x:size.width,y:size.height )
            }
        }
   
        backgroundFan.bannerHeight = bannerHeight
        backgroundFan.tableSize = newSize
        backgroundFan.rearrangeFast()
        
        
        table.trickFan.bannerHeight = bannerHeight
        table.trickFan.tableSize = newSize
        table.trickFan.rearrangeFast()
        
        
        self.cardPassingPhase.arrangeLayoutFor(newSize,bannerHeight: bannerHeight)
        StatusDisplay.sharedInstance.arrangeLayoutFor(newSize,bannerHeight: bannerHeight)
        
        let seats = size.isPortrait ? Seater.portraitSeatsFor(table.players.count) : Seater.seatsFor(table.players.count)
        for (player,seat) in Zip2Sequence(table.players,seats)
        {
            player.setPosition(newSize,sideOfTable: seat)
        }
        
        for (player,score) in Zip2Sequence(table.players,ScoreDisplay.sharedInstance.scoreLabel)
        {
          score.position = ScoreDisplay.scorePosition(player.sideOfTable, size: newSize, bannerHeight:adHeight )
          score.zRotation = ScoreDisplay.scoreRotation(player.sideOfTable)
        }
        
        let nodeNeedingLayoutRearrangement = self
            .children
            .filter { $0 is Resizable }
            .map { $0 as! Resizable }
   
        
        for resizing in nodeNeedingLayoutRearrangement
        {
        resizing.arrangeLayoutFor(newSize,bannerHeight: bannerHeight)
        }
        for (i,player) in table.players.enumerate()
        {
         self.schedule(delay: 0.4 * Double(i) )
         {
            player._hand.bannerHeight = bannerHeight
            player._hand.tableSize = newSize
            player._hand.rearrangeFast()
            player.wonCards.bannerHeight = bannerHeight
            player.wonCards.tableSize = newSize
            player.wonCards.rearrange()
         }
        }
    }

    
    func rearrangeCardImagesInHandsWithAnimation()
    {
        for player in table.players
        {
            player._hand.update()
        }
    }

    
    func StatusAreaFirstMessage()
    {
        if arePassingCards
        {
            Bus.sharedInstance.send(GameEvent.DiscardWorstCards(3))
        }
        else
        {
            Bus.sharedInstance.send(GameEvent.NewGame)
        }
    }
    
 
    func startTrickPhase()
    {
        fillBackgroundSpreadWith(trickBackgroundCards)

        self.schedule(delay: GameSettings.sharedInstance.tossDuration*1.3) { [weak self]  in
            if let s = self
            {
                s.table.playTrick(s.table.players[s.table.startPlayerNo])
            }
        }
    }
    
    func setupNewGameArrangement()
    {
        Bus.sharedInstance.gameSignal
            .observeOn(UIScheduler())
            .filter { $0 == GameEvent.NewHand }
            .observeNext { [weak self] _ in
                if let s = self
                {
                    for player in s.table.players
                    {
                        player.wonCards.clear()
                        for card in player.hand
                        {
                          if let sprite = s.cardSprite(card)
                            {
                                sprite .player = player
                            }
                        }
                    }
            
                    s.startHand()
                }
        }

      
   /*     let signal : Signal<CardPlayer,NoError> =  Bus.sharedInstance.gameSignal
            . filter { switch $0 {case .TurnFor: return true; default: return false } }
                . map { switch $0 {
                case GameEvent.TurnFor(let player) : return player
                default : return CardPlayer(name: "None")
                    }
                }
                
        self.currentPlayer <~ signal
 
 */
        self.currentPlayer <~  Bus.sharedInstance.gameSignal
                                    . filter { switch $0 {case .TurnFor: return true; default: return false } }
                                    . map { switch $0 {
                                                case GameEvent.TurnFor(let player) : return player
                                                default : return CardPlayer(name: "None")
                                                }
                                           }
    }

    func startHand()
    {
        self.schedule(delay: GameSettings.sharedInstance.tossDuration*0.5) { [weak self]  in
          if let s = self
          {
            s.rearrangeCardImagesInHandsWithAnimation()
            s.cardPassingPhase.isCurrentlyActive = s.arePassingCards
            if s.cardPassingPhase.isCurrentlyActive
               {
                s.fillBackgroundSpreadWith(s.threeWorstBackgroundCards)
                Bus.sharedInstance.send(GameEvent.NewGame)
               }
            }
        }
        self.schedule(delay: GameSettings.sharedInstance.tossDuration*2.2) { [weak self]  in
          if let s = self
            {
            s.cardPassingPhase.isCurrentlyActive = s.arePassingCards
            if s.cardPassingPhase.isCurrentlyActive
              {
                Bus.sharedInstance.send(GameEvent.DiscardWorstCards(3))
              } else {
                s.startTrickPhase()
              }
            }
        }
  
    }
 
    func setupPlayButton()
    {
        if table.isInDemoMode
        {
   
        playButton1.name = "Play"
        playButton1.setScale(ButtonSize.Big.scale)
        playButton1.zPosition = 200
        playButton1.userInteractionEnabled = false
        self.addChild(playButton1)
            
        playButton2.name = "Random"
        playButton2.setScale(ButtonSize.Big.scale)
        playButton2.zPosition = 200
        playButton2.userInteractionEnabled = false
        self.addChild(playButton2)
        }
    }
    func setupPopupScreensAndButtons()
    {
        Navigate.setupRulesButton(self)
        if table.isInDemoMode
        {
            Navigate.setupOptionButton(self)
            StatusDisplay.sharedInstance.setDemoMode()
        }
        else
        {
           Navigate.setupExitButton(self)
           StatusDisplay.sharedInstance.setGameMode()
        }
        
        setupPlayButton()
    }
    func setupStatusArea()
    {
        StatusDisplay.register(self)
        StatusAreaFirstMessage()
    }
    
    var trickBackgroundCards : [PlayingCard]
        {
            return GameSettings.sharedInstance.rules.backgroundCards
        }
    var threeWorstBackgroundCards : [PlayingCard]
        {
            return [
                CardName.Ace.of(PlayingCard.Suite.Spades)!,
                CardName.Ace.of(PlayingCard.Suite.Hearts)!,
                CardName.Ace.of(PlayingCard.Suite.Diamonds)!]
    }
    
    func setupBackground()
    {
        self.backgroundColor = GameSettings.backgroundColor
        
        self.setupBackgroundSpread( )
        self.cardPassingPhase.isCurrentlyActive = self.arePassingCards
        if self.cardPassingPhase.isCurrentlyActive
        {
            self.fillBackgroundSpreadWith(self.threeWorstBackgroundCards)
        }
        else
        {
        self.fillBackgroundSpreadWith(self.trickBackgroundCards)
        }
    }
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        setupDiscardArea()
        setupBackground()
        setupStatusArea()
        setupPopupScreensAndButtons()
        seatPlayers()
        cardPassingPhase.setupCardPilesSoPlayersCanPassTheir3WorstCards()
        table.setupCardPilesSoPlayersCanPlayTricks()
        
        let s = UIScreen.mainScreen().bounds.size
        createCardPilesToProvideStartPointForCardAnimation(s)
        ScoreDisplay.sharedInstance.setupScoreArea(self, players: table.players)
        arrangeLayoutFor(s,bannerHeight: self.adHeight)
        table.dealNewCardsToPlayersThen {
            self.setupNewGameArrangement()
            self.startHand()
        }
    
 
  
    }
    
    func isNodeAPlayerOneCardSpite(cardsprite:CardSprite) -> Bool
    {
        
        // does the sprite belong to a player
        if let fan = cardsprite.fan,
            player = cardsprite.player
            where (fan.name == CardPileType.Passing.description ||
                fan.name == CardPileType.Hand.description) &&
                player is HumanPlayer
        {
            return true
        }
        return false
        
    }
 

    func resetSceneWithNewTableThatIsInteractive(isInteractive:Bool)
    {
        discard()
        
        self.schedule(delay: GameSettings.sharedInstance.tossDuration) { [weak self] in
             if let s = self,
                    oldScene = s.scene,
                    view = oldScene.view
                {
                let transition = SKTransition.crossFadeWithDuration(0.5)
                let scene = RicketyKateGameScene(size: oldScene.size)
                
                scene.scaleMode = SKSceneScaleMode.ResizeFill
             
                scene.table = isInteractive ?
                    RicketyKateCardTable.makeTable(scene) :
                    RicketyKateCardTable.makeDemo(scene)
                scene.adHeight = s.adHeight
                view.presentScene(scene, transition: transition)
                }
        }
    }
    func resetSceneWithInteractiveTable()
    {
       resetSceneWithNewTableThatIsInteractive(true)
    }
    func resetSceneAsDemo()
    {
        resetSceneWithNewTableThatIsInteractive(false)
    }
    func buttonTouched(positionInScene:CGPoint) -> Bool
    {
        if let touchedNode : SKSpriteNode = self.nodeAtPoint(positionInScene) as? SKSpriteNode,
            touchName = touchedNode.name
        {
            switch touchName
            {
            /// play button
            case "Play" :
                touchedNode.texture = SKTexture(imageNamed: "Play2")
                resetSceneWithInteractiveTable()
                return true
                /// play button
            case "Random" :
                touchedNode.texture = SKTexture(imageNamed: "Random2")
                GameSettings.sharedInstance.random()
                resetSceneWithInteractiveTable()
                return true
            default : break
            }
        }
         return false
    }
    
    func cardTouched(positionInScene:CGPoint) -> Bool
    {
        let width = self.frame.size.width
        var newX = positionInScene.x
        if newX > width * 0.5
        {
            newX = ((newX - width * 0.5) * 0.6) + width * 0.5
        }
        /// correct for rotation of card
        let adjustedPosition = CGPoint(x: newX,y: positionInScene.y)
        if let adjustedNode = self.nodeAtPoint(adjustedPosition) as? CardSprite
            where isNodeAPlayerOneCardSpite(adjustedNode)
               {
                startDraggingCard(adjustedNode,originalPosition:positionInScene)
                originalTouch = positionInScene
                return true
                }
           return false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
 
      for touch in (touches )
      {
        let positionInScene = touch.locationInNode(self)

        if buttonTouched(positionInScene)
           {
                return
           }
        if cardTouched(positionInScene)
           {
            return
           }
   
        }
    }
    

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    let touch = (touches ).first!
    let positionInScene = touch.locationInNode(self)
   
    let goingRight = originalTouch.x < positionInScene.x
    let deltaX = abs(originalTouch.x - positionInScene.x)
    let deltaY = abs(originalTouch.y - positionInScene.y)
        
    /// if swiping horizonatally then riffle through the card fan
    /// displaying each card in turn
    if deltaX > (2.2 * deltaY) && deltaX > 15
        {
            if let oldCard = draggedNode,
                    fan = oldCard.fan,
                    indexInFan = fan.cards.indexOf(oldCard.card)
                where isNodeAPlayerOneCardSpite(oldCard)
            {
                let newIndex = goingRight ? indexInFan+1 : indexInFan-1
                    
                if newIndex >= 0 && fan.cards.count > newIndex
                {
                  let newCard = fan.cards[newIndex]
                  if let cardSprite = self.cardSprite(newCard)
                    {
                    quickSwapDraggedCard(cardSprite,originalPosition:positionInScene)
                    originalTouch = positionInScene
                    }
                        
                }
                 return
            }
        }
     if let touchedNode = draggedNode
      {
      touchedNode.position = positionInScene
      }
    }

 
    
    func setDownDraggedPassingCard(positionInScene:CGPoint)
    {
        let height = self.frame.size.height
        let cardsprite = draggedNode!;
 
        let isTargetHand = positionInScene.y > height * 0.3
        if cardPassingPhase.transferCardSprite(cardsprite, isTargetHand:isTargetHand)
            {
            draggedNode = nil
            return
            }
  
        restoreDraggedCard()
    }
    
    func checkPassingPhaseProgess()
    {
        if  cardPassingPhase.isPassingPhaseContinuing()
        {
            // continue
        }
        else
        {
            // stop
            startTrickPhase()
        }
    }
    
    func doesNotFollowSuite(cardsprite:CardSprite)
    {
    cardsprite.tintRed()
    
    Bus.sharedInstance.send(GameEvent.CardDoesNotFollowSuite)
    }
    
    func transferCardToTrickPile(cardsprite:CardSprite)
    {
        table.playTrickCard(self.table.playerOne, trickcard:cardsprite.card)
  
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
    if let touch = touches.first
        {
        let height = self.frame.size.height
        let positionInScene = touch.locationInNode(self)
        
        if( draggedNode != nil)
           {
            
                if self.cardPassingPhase.isCurrentlyActive
                    {
                    setDownDraggedPassingCard(positionInScene)
                    checkPassingPhaseProgess()
                    return;
                    }
                else if self.currentPlayer.value is HumanPlayer
                {
                    if let cardsprite = draggedNode
                        where positionInScene.y > height * 0.3
                        {
                        
                       let gameEvent = table.isMoveValid(self.table.playerOne,card: cardsprite.card)
                        switch gameEvent
                          {
                          case .CardPlayed(_, _) :
                               transferCardToTrickPile(cardsprite)
                               draggedNode = nil
                               return
                          case .CardDoesNotFollowSuite :
                               doesNotFollowSuite(cardsprite)
                        
                          default:
                               cardsprite.tintRed()

                               Bus.sharedInstance.send(gameEvent)
                          
                          }
                    
                         }
                } else {
                    Bus.sharedInstance.send(GameEvent.WaitYourTurn)
                }
            
             restoreDraggedCard()
            }
            
        }

    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if let touches = touches {
            touchesEnded(touches, withEvent: event)
        }
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

