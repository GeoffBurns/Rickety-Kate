//
//  RicketyKateGameScene.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 14/7/18.
//  Copyright © 2018 Nereids Gold. All rights reserved.
//

import SpriteKit
import ReactiveSwift
import Cards

/// How game play is displayed
class RicketyKateGameScene: CardGameScene, HasBackgroundSpread, HasDraggableCards, Resizable{
    
    
    override var table : RicketyKateCardTable! {  didSet { setupPassYourThreeWorstCardsPhase() } }
    var originalTouch = CGPoint()
    var draggedNode: CardSprite? = nil;
    var cardScaleForSelected = CGFloat(1.05)
    
    var backgroundFan = CardFan(name: CardPileType.background.description)
    var playButton1 =  SKSpriteNode(imageNamed:"Play1")
    var playButton2 =  SKSpriteNode(imageNamed:"Random1")
    var arePassingCards : Bool { return  Game.settings.willPassCards && !table.isInDemoMode }
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
        for (i,(player,seat)) in zip(table.players,seats).enumerated()
        {
            player.setup(self, sideOfTable: seat, playerNo: i,isPortrait: self.isPortrait)
        }
    }
    func arrangeLayoutFor(_ size:CGSize, bannerHeight:CGFloat)
    {
        let width = size.width
        let height = size.height -  bannerHeight
        
        let newSize = CGSize(width: width, height: height)
        let topLeft = DeviceSettings.isPhoneX  ? CGPoint(x:20.0,y:size.height-20.0 ) : CGPoint(x:0.0,y:size.height )
        let topRight = DeviceSettings.isPhoneX  ? CGPoint(x:size.width-20.0,y:size.height-20.0 ) : CGPoint(x:size.width,y:size.height)
        if let rulesButton = self.childNode(withName: "Rules1")
        {
            rulesButton.position = topLeft
        }
        if table.isInDemoMode
        {
            
            playButton1.position = CGPoint(x:width*0.25,y:height*0.5+bannerHeight)
            playButton2.position = CGPoint(x:width*0.75,y:height*0.5+bannerHeight)
            
            if let optionsButton = self.childNode(withName: "Options1")
            {
                optionsButton.position = topRight
            }
        } else {
            if  let exitButton = self.childNode(withName: "Exit")
            {
                exitButton.position = topRight
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
        for (player,seat) in zip(table.players,seats)
        {
            player.setPosition(newSize,sideOfTable: seat)
        }
        
        for (player,score) in zip(table.players,ScoreDisplay.sharedInstance.scoreLabel)
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
        for (i,player) in table.players.enumerated()
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
            Bus.sharedInstance.send(GameEvent.discardWorstCards(3))
        }
        else
        {
            Bus.sharedInstance.send(GameEvent.newGame)
        }
    }
    
    
    func startTrickPhase()
    {
        fillBackgroundSpreadWith(trickBackgroundCards)
        
        self.schedule(delay: Game.settings.tossDuration*1.3) { [weak self]  in
            if let s = self
            {
                s.table.playTrick(s.table.players[s.table.startPlayerNo])
            }
        }
    }
    
    func setupNewGameArrangement()
    {
        Bus.sharedInstance.gameSignal
            .observe(on: UIScheduler())
            .filter { $0 == GameEvent.newHand }
            .observeValues { [weak self] _ in
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
            . filter { switch $0 {case .turnFor: return true; default: return false } }
            . map { switch $0 {
            case GameEvent.turnFor(let player) : return player
            default : return CardPlayer(name: "None")
                }
        }
    }
    
    func startHand()
    {
        self.schedule(delay: Game.settings.tossDuration*0.5) { [weak self]  in
            if let s = self
            {
                s.rearrangeCardImagesInHandsWithAnimation()
                s.cardPassingPhase.isCurrentlyActive = s.arePassingCards
                if s.cardPassingPhase.isCurrentlyActive
                {
                    s.fillBackgroundSpreadWith(s.threeWorstBackgroundCards)
                    Bus.sharedInstance.send(GameEvent.newGame)
                }
            }
        }
        self.schedule(delay: Game.settings.tossDuration*2.2) { [weak self]  in
            if let s = self
            {
                s.cardPassingPhase.isCurrentlyActive = s.arePassingCards
                if s.cardPassingPhase.isCurrentlyActive
                {
                    Bus.sharedInstance.send(GameEvent.discardWorstCards(3))
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
            playButton1.setScale(ButtonSize.big.scale)
            playButton1.zPosition = 200
            playButton1.isUserInteractionEnabled = false
            self.addChild(playButton1)
            
            playButton2.name = "Random"
            playButton2.setScale(ButtonSize.big.scale)
            playButton2.zPosition = 200
            playButton2.isUserInteractionEnabled = false
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
        return Game.rules.backgroundCards
    }
    var threeWorstBackgroundCards : [PlayingCard]
    {
        return [
            CardName.ace.of(PlayingCard.Suite.spades)!,
            CardName.ace.of(PlayingCard.Suite.hearts)!,
            CardName.ace.of(PlayingCard.Suite.diamonds)!]
    }
    
    func setupBackground()
    {
        self.backgroundColor = Game.backgroundColor
        
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
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        setupDiscardArea()
        setupBackground()
        setupStatusArea()
        setupPopupScreensAndButtons()
        seatPlayers()
        cardPassingPhase.setupCardPilesSoPlayersCanPassTheir3WorstCards()
        table.setupCardPilesSoPlayersCanPlayTricks()
        
        let s = UIScreen.main.bounds.size
        createCardPilesToProvideStartPointForCardAnimation(s)
        ScoreDisplay.sharedInstance.setupScoreArea(self, players: table.players)
        arrangeLayoutFor(s,bannerHeight: self.adHeight)
        table.dealNewCardsToPlayersThen(self.dealtPiles) {
            self.setupNewGameArrangement()
            self.startHand()
        }
        
        
        
    }
    
    func isNodeAPlayerOneCardSpite(_ cardsprite:CardSprite) -> Bool
    {
        
        // does the sprite belong to a player
        if let fan = cardsprite.fan,
            let player = cardsprite.player, (fan.name == CardPileType.passing.description ||
            fan.name == CardPileType.hand.description) &&
            player is HumanPlayer
        {
            return true
        }
        return false
        
    }
    
    
    func resetSceneWithNewTableThatIsInteractive(_ isInteractive:Bool)
    {
        discard()
        
        self.schedule(delay: Game.settings.tossDuration) { [weak self] in
            if let s = self,
                let oldScene = s.scene,
                let view = oldScene.view
            {
                let transition = SKTransition.crossFade(withDuration: 0.5)
                let scene = RicketyKateGameScene(size: oldScene.size)
                
                scene.scaleMode = SKSceneScaleMode.resizeFill
                
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
    func buttonTouched(_ positionInScene:CGPoint) -> Bool
    {
        if let touchedNode : SKSpriteNode = self.atPoint(positionInScene) as? SKSpriteNode,
            let touchName = touchedNode.name
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
                Game.moreSettings.random()
                resetSceneWithInteractiveTable()
                return true
            default : break
            }
        }
        return false
    }
    
    func cardTouched(_ positionInScene:CGPoint) -> Bool
    {
        let width = self.frame.size.width
        var newX = positionInScene.x
        if newX > width * 0.5
        {
            newX = ((newX - width * 0.5) * 0.6) + width * 0.5
        }
        /// correct for rotation of card
        let adjustedPosition = CGPoint(x: newX,y: positionInScene.y)
        if let adjustedNode = self.atPoint(adjustedPosition) as? CardSprite, isNodeAPlayerOneCardSpite(adjustedNode)
        {
            startDraggingCard(adjustedNode,originalPosition:positionInScene)
            originalTouch = positionInScene
            return true
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        
        for touch in (touches )
        {
            let positionInScene = touch.location(in: self)
            
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
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = (touches ).first!
        let positionInScene = touch.location(in: self)
        
        let goingRight = originalTouch.x < positionInScene.x
        let deltaX = abs(originalTouch.x - positionInScene.x)
        let deltaY = abs(originalTouch.y - positionInScene.y)
        
        /// if swiping horizonatally then riffle through the card fan
        /// displaying each card in turn
        if deltaX > (2.2 * deltaY) && deltaX > 15
        {
            if let oldCard = draggedNode,
                let fan = oldCard.fan,
                let indexInFan = fan.cards.index(of: oldCard.card), isNodeAPlayerOneCardSpite(oldCard)
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
    
    
    
    func setDownDraggedPassingCard(_ positionInScene:CGPoint)
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
    
    
    func transferCardToTrickPile(_ cardsprite:CardSprite)
    {
        table.playTrickCard(self.table.playerOne, trickcard:cardsprite.card)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first
        {
            let height = self.frame.size.height
            let positionInScene = touch.location(in: self)
            
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
                    if let cardsprite = draggedNode, positionInScene.y > height * 0.3
                    {
                        
                        let gameEvent = table.isMoveValid(self.table.playerOne,card: cardsprite.card)
                        switch gameEvent
                        {
                        case .cardPlayed(_, _) :
                            transferCardToTrickPile(cardsprite)
                            draggedNode = nil
                            return
                            
                        default:
                            cardsprite.tintRed()
                            
                            Bus.sharedInstance.send(gameEvent)
                            
                        }
                    }
                } else {
                    Bus.sharedInstance.send(GameEvent.waitYourTurn)
                }
                
                restoreDraggedCard()
            }
            
        }
        
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //      if let touches = touches {
        touchesEnded(touches, with: event)
        //    }
    }
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
