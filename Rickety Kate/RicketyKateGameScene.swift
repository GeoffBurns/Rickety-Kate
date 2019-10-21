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
class RicketyKateGameScene: CardGameScene, HasBackgroundSpread, HasDraggableCards, HasDemoMode, Resizable{
    
    
    override var table : RicketyKateCardTable! {  didSet { setupPassYourThreeWorstCardsPhase() } }
    var originalTouch = CGPoint()
    var draggedNode: CardSprite? = nil;
    var cardScaleForSelected = CGFloat(1.05)
    
    var backgroundFan = CardFan(name: CardPileType.background.description)
    var playButton1 =  SKSpriteNode(imageNamed:"Play1")
    var playButton2 =  SKSpriteNode(imageNamed:"Random1")
    var arePassingCards : Bool { return  Game.settings.willPassCards && !table.isInDemoMode }
    var cardPassingPhase : PassYourThreeWorstCardsPhase! = nil
    var isInDemoMode : Bool { return table.isInDemoMode }
    var adHeight = CGFloat(0)

    
    func setupPassYourThreeWorstCardsPhase()
    {
        cardPassingPhase =  PassYourThreeWorstCardsPhase(scene: self,players: table.players);
    }
    
    func seatPlayers(_ isPortrait:Bool)
    {
   
        table.seatPlayers(isPortrait)
    }
    func seatPlayers()
    {
        seatPlayers(self.isPortrait)
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
        if isInDemoMode
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
        
        table.adjustPlayerPosition(bannerHeight, newSize, size.isPortrait)
    
        let nodeNeedingLayoutRearrangement = self
            .children
            .filter { $0 is Resizable }
            .map { $0 as! Resizable }
        
        
        for resizing in nodeNeedingLayoutRearrangement
        {
            resizing.arrangeLayoutFor(newSize,bannerHeight: bannerHeight)
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
            Bus.send(GameNotice.discardWorstCards2(Game.moreSettings.gameType,3))
        }
        else
        {
            Bus.send(GameNotice.newGame2(Game.moreSettings.gameType))
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
        
        
        setupCurrentPlayer()
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

                         s.cardPassingPhase.showPassPile(0)
                         s.fillBackgroundSpreadWith(s.threeWorstBackgroundCards)
                         Bus.send(GameNotice.newGame)
                         if Game.currentOperator != 0 {
                                             if let t = s.table {

                                                 Bus.send(GameNotice.turnFor(t.playerOne))
                                                 t.reseatPlayers(0,isPortrait:s.isPortrait)
                                             }
                                             
                                         }
                     }
                 }
             }
             if Game.currentOperator != 0 && arePassingCards
             {
                table.reseatPlayers(0)
                self.schedule(delay: Game.settings.tossDuration) { [weak self]  in
                             if let s = self,
                                let t = s.table {
                                        Bus.send(GameNotice.turnFor(t.playerOne))
                                    }
                         }
             }
             self.schedule(delay: Game.settings.tossDuration*2.2) { [weak self]  in
                 if let s = self
                 {
                     s.cardPassingPhase.isCurrentlyActive = s.arePassingCards
                     if s.cardPassingPhase.isCurrentlyActive
                     {
                         Bus.send(GameNotice.discardWorstCards(3))
                     } else {
                         s.startTrickPhase()
                     }
                 }
             }
             
         
  
      
    }
    
    func setupPlayButton()
    {
        if isInDemoMode
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
        if isInDemoMode
        {
            Navigate.setupOptionButton(self)
            StatusDisplay.sharedInstance.setDemoMode()
        }
        else
        {
            Navigate.setupExitButton(self)
            if Game.moreSettings.noOfHumanPlayers > 1
                { StatusDisplay.sharedInstance.setMultiplayerMode() }
            else
                { StatusDisplay.sharedInstance.setGameMode() }
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
        
        if let selectedNode = self.atPoint(positionInScene) as? CardSprite, isNodeAPlayerOneCardSpite(selectedNode)
        {
            startDraggingCard(selectedNode,originalPosition:positionInScene)
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
            if table.areCardsShowing && cardTouched(positionInScene)
            {
                return
            }
            
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        if isInDemoMode { return }
        let touch = (touches ).first!
        let positionInScene = touch.location(in: self)
        
        let goingRight = originalTouch.x < positionInScene.x
        let deltaX = abs(originalTouch.x - positionInScene.x)
        let deltaY = abs(originalTouch.y - positionInScene.y)
        
        
        /// if swiping horizonatally then riffle through the card fan
        /// displaying each card in turn
        if deltaX > (2.2 * deltaY) && deltaX > 15
        {
            
        if (Game.settings.noOfHumanPlayers > 1 && !table.areCardsShowing)
                {
                    table.turnOverCards()
                }
        else if table.areCardsShowing
          {
            if let oldCard = draggedNode,
                let fan = oldCard.fan,
                let indexInFan = fan.cards.firstIndex(of: oldCard.card), isNodeAPlayerOneCardSpite(oldCard)
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
        }
        if let touchedNode = draggedNode
        {
            if table.areCardsShowing { touchedNode.position = positionInScene }
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
    public func isPassingPhaseContinuing() -> Bool
     {
      if  !cardPassingPhase.isPlayerPassing()
         {
             if Game.settings.noOfHumanPlayers < 2
             {
                 cardPassingPhase.endCardPassingPhase()
                 return false
             } else
             {
               let newPlayer = table.nextPlayerAfter(table.players[Game.currentOperator])

                cardPassingPhase.hidePassPile(Game.currentOperator)
                if newPlayer.playerNo != 0 && newPlayer is HumanPlayer
                 {
                    cardPassingPhase.showPassPile(newPlayer.playerNo)
                     Bus.send(GameEvent.turnFor(newPlayer))
                     table.reseatPlayers(newPlayer.playerNo)
                 }
                 else{
                       cardPassingPhase.endCardPassingPhase()
                      return false
                 }
             }
     }

        return true
    }
    func checkPassingPhaseProgess()
    {
        if  isPassingPhaseContinuing()
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
        table.playTrickCard(self.currentPlayer, trickcard:cardsprite.card)
        
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
                else if self.currentPlayer is HumanPlayer
                {
                    if let cardsprite = draggedNode, positionInScene.y > height * 0.3
                    {
                        
                        let move = table.isMoveValid(self.currentPlayer,card: cardsprite.card)
                        switch move
                        {
                        case .cardPlayed(_, _) :
                            transferCardToTrickPile(cardsprite)
                            draggedNode = nil
                            return
                        default :
                            cardsprite.tintRed()
                            Bus.send(GameNotice.invalidMove(move))
                        }
                    }
                } else {
                    Bus.send(GameNotice.waitYourTurn)
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
