//
//  GameScene.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 10/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

/// How game play is displayed
class GameScene: SKScene {
    
    lazy var table = CardTable.makeTable()
    var originalTouch = CGPoint()
    var draggedNode: CardSprite? = nil;
    var cardScale = CGFloat(0.9)
    var cardScaleForSelected = CGFloat(1.05)
    
    var dealtPiles = [CardPile]()


    var playButton1 =  SKSpriteNode(imageNamed:"Play1")
    var playButton2 =  SKSpriteNode(imageNamed:"Play1")

    var rulesScreen = RuleScreen()
    var exitScreen = ExitScreen()
    var optionScreen = OptionScreen()
    
    var arePassingCards = true

    var isInPassingCardsPhase = true
    var cardTossDuration = 0.4
    let cardAnchorPoint = CGPoint(x: 0.5, y: GameSettings.isPad ? -0.7 :  -1.0)
    
    func createCardPilesToProvideStartPointForCardAnimation(width: CGFloat , height: CGFloat )
    {
        dealtPiles = []
        let hSpacing = CGFloat(table.players.count) * 2
        for (i,player) in table.players.enumerate()
        {
            let dealtPile = CardPile(name: "dealt")
            dealtPile.setup(self, direction: Direction.Up, position: CGPoint(x: width * CGFloat(2 * i  - 3) / hSpacing,y: height*1.2), isUp: false)
            
            dealtPile.appendContentsOf(player._hand.cards)
            dealtPiles.append(dealtPile)
        }
    }
    
    func createCardSpritesForCardsInPlayersHand()
    {
        for player in table.players
        {
            for card in player.hand
            {
                CardSprite.add(card, player: player, scene: self)
            }
        }
    }
    func seatPlayers()
    {
        
        let seats = Seater.seatsFor(table.players.count)
        for (player,seat) in Zip2Sequence(table.players,seats)
        {
            player.setup(self, sideOfTable: seat)
        }
    }

    
    func rearrangeCardImagesInHandsWithAnimation(width: CGFloat , height: CGFloat )
    {
        for player in table.players
        {
            player._hand.update()
            
        }
    }
    /// at end of game return sprites to start
    func reverseDeal(width: CGFloat , height: CGFloat )
    {
        for (i,player) in table.players.enumerate() 
           {
            dealtPiles[i].replaceWithContentsOf(player._hand.cards)
            }
        dealtPiles[0].appendContentsOf(table.tricksPile.map{ return $0.playedCard })
    }
    
    func StatusAreaFirstMessage()
    {

        if arePassingCards && !table.isInDemoMode
        {
            StatusDisplay.publish("Discard Your",message2: " Three Worst Cards")
        }
        else
        {
            StatusDisplay.publish("Game On",message2: "")
        }
    }
    

    
    func startTrickPhase()
    {
        let doneAction2 =  (SKAction.sequence([SKAction.waitForDuration(self.cardTossDuration*1.3),
            SKAction.runBlock({ [unowned self] in
                self.table.playTrickLeadBy(self.table.players[self.table.startPlayerNo])
                
            })]))
        self.runAction(doneAction2)
    }
    
    func setupNewGameArrangement()
    {
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        
        table.resetGame.subscribe {
   
            for player in self.table.players
            {
                player.wonCards.clear()
                    for card in player.hand
                    {
                        let sprite = CardSprite.sprite(card)!
                        sprite.flipDown()
                        sprite .player = player
                     }
            }
            
            self.table.newGame.publish()
        }
        table.newGame.subscribe {
            let doneAction =  (SKAction.sequence([SKAction.waitForDuration(self.cardTossDuration*0.1),
                SKAction.runBlock({ [unowned self] in
                    self.rearrangeCardImagesInHandsWithAnimation(width,  height: height)
                })]))
            self.runAction(doneAction)
           
            self.isInPassingCardsPhase = self.arePassingCards && !self.table.isInDemoMode
            if self.isInPassingCardsPhase
            {
              StatusDisplay.publish("Discard Your",message2: "Three Worst Cards")
            }
            else
            {
              self.startTrickPhase()
            }
        }
    }
    

    func setupExitScreen()
    {
        if table.isInDemoMode
        {
            return
        }
       exitScreen.setup(self)
    }
    func setupOptionScreen()
    {
        if !table.isInDemoMode
        {
            return
        }
        optionScreen.noOfSuites.current = GameSettings.sharedInstance.noOfSuitesInDeck
        optionScreen.noOfPlayers.current = GameSettings.sharedInstance.noOfPlayersAtTable
        optionScreen.noOfCardsInASuite.current = GameSettings.sharedInstance.noOfCardsInASuite
        optionScreen.hasTrumps.current = GameSettings.sharedInstance.hasTrumps
        
        optionScreen.hasJokers.current = GameSettings.sharedInstance.hasJokers
        optionScreen.setup(self)
    }
    func setupPlayButton()
    {
        if table.isInDemoMode
        {
        playButton1.position = CGPoint(x:self.frame.size.width*0.25,y:self.frame.size.height*0.5)
  
        playButton1.name = "Play"
        
        playButton1.zPosition = 200
        playButton1.userInteractionEnabled = false
        self.addChild(playButton1)
            playButton2.position = CGPoint(x:self.frame.size.width*0.75,y:self.frame.size.height*0.5)
            
            playButton2.name = "Play"
            
            playButton2.zPosition = 200
            playButton2.userInteractionEnabled = false
            self.addChild(playButton2)
        }
    }
    func setupPopupScreensAndButtons()
    {
        rulesScreen.setup(self)
        setupExitScreen()
        setupOptionScreen()
        setupPlayButton()
    }
    func setupStatusArea()
    {
        StatusDisplay.register(self)
        StatusAreaFirstMessage()
    }
    override func didMoveToView(view: SKView) {
                /* Setup your scene here */
     
        self.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 0.2, alpha: 1.0)

        setupStatusArea()
        setupPopupScreensAndButtons()
        seatPlayers()
        table.setupCardPilesSoPlayersCanPassTheir3WorstCards(self)
        createCardPilesToProvideStartPointForCardAnimation(self.frame.size.width,  height: self.frame.size.height)
        table.dealNewCardsToPlayers()
        
        createCardSpritesForCardsInPlayersHand()
        ScoreDisplay.sharedInstance.setupScoreArea(self, players: table.players)
        setupNewGameArrangement()
        
        table.newGame.publish()
    }
    
    func isNodeAPlayerOneCardSpite(cardsprite:CardSprite) -> Bool
    {
    // does the sprite belong to a player
    if let player = cardsprite.player
        {
           return player.name == "You"
        }

    return false
    }

    
    func resetWith(table:CardTable)
    {
        let width = self.frame.size.width
        let height = self.frame.size.height
        reverseDeal(width , height: height )
        
        let doneAction2 =  (SKAction.sequence([SKAction.waitForDuration(self.cardTossDuration),
            SKAction.runBlock({ [unowned self] in
                let transition = SKTransition.crossFadeWithDuration(0.5)
                let scene = GameScene(size: self.scene!.size)
                scene.scaleMode = SKSceneScaleMode.AspectFill
                scene.table = table
                self.scene!.view!.presentScene(scene, transition: transition)
                
            })]))
        self.runAction(doneAction2)
    }
    
    func buttonTouched(positionInScene:CGPoint) -> Bool
    {
        if let touchedNode : SKSpriteNode = self.nodeAtPoint(positionInScene) as? SKSpriteNode
        {
            switch touchedNode.name!
            {
                /// play button
            case "Play" :
                touchedNode.texture = SKTexture(imageNamed: "Play2")
                resetWith(CardTable.makeTable())
                return true
                /// exit button
            case  "Exit" :
                touchedNode.texture = SKTexture(imageNamed: "Exit2")
                exitScreen.alpha = 1.0
                exitScreen.zPosition = 500
                return  true
                /// rules button
            case "Rules" :
                rulesScreen.flipButton()
                return  true
                
                /// Option button
            case "Option" :
                optionScreen.flipButton()
                return  true
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
        {
            if isNodeAPlayerOneCardSpite(adjustedNode)        {
                
                draggedNode = adjustedNode;
                originalTouch = positionInScene
                adjustedNode.liftUp(positionInScene)
                
                
                return true
            }
            
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
    if deltaX > (2.2 * deltaY) && deltaX > 22
        {
           let touchedNodes = self.nodesAtPoint(positionInScene)
    
           for node in touchedNodes
                {
                 if let touchedNode  = node as? CardSprite
                      where isNodeAPlayerOneCardSpite(touchedNode)
                        && draggedNode != touchedNode
                        && ( goingRight && draggedNode!.positionInSpread < touchedNode.positionInSpread
                            || !goingRight && draggedNode!.positionInSpread > touchedNode.positionInSpread)
                    {
                        
                        draggedNode?.setdownQuick()
                        touchedNode.liftUpQuick(positionInScene)
                        draggedNode = touchedNode;
                        originalTouch = positionInScene
                        return
                    }
               }
            }
        
     if( draggedNode != nil)
      {
        let touchedNode = draggedNode!;
        
      touchedNode.position = positionInScene
      }
    }

    func endCardPassingPhase()
    {
        table.passOtherCards()
        table.takePassedCards()
        isInPassingCardsPhase = false
        StatusDisplay.publish()
        startTrickPhase()
    }
    
    func restoreDraggedCard()
    {
        
        if let cardsprite = draggedNode
    
        {
          cardsprite.setdown()
         draggedNode=nil
        }
        
    
    }
    
    
    func setDownDraggedPassingCard(positionInScene:CGPoint)
    {
        let height = self.frame.size.height
        let cardsprite = draggedNode!;
 
             if let sourceFanName = cardsprite.fan?.name
                 {
                 if sourceFanName == CardPileType.Hand.description  && positionInScene.y > height * 0.3
                        {
                            if let _ = table.passCard(0, passedCard: cardsprite.card)
                            {
                            return
                            }
                        }
                  if sourceFanName == CardPileType.Passing.description  && positionInScene.y <= height * 0.3
                    {
                        if let _ = table.unpassCard(0, passedCard: cardsprite.card)
                        {
                            return
                        }
                    }
                }
              
  
        restoreDraggedCard()
                    

    }
    
    func checkPassingPhaseProgess()
    {
        let count = table.cardsPassed[0].cards.count
        if  count < 3
        {
            
            if count == 2
            {
                StatusDisplay.publish("Discard one more card", message2: "Your worst card")
            }
            else
            {
                StatusDisplay.publish("Discard \(3 - count) more cards", message2: "Your worst cards")
            }
        }
        else
        {
            endCardPassingPhase()
        }
    }
    
    func doesNotFollowSuite(cardsprite:CardSprite)
    {
    cardsprite.color = UIColor.redColor()
    cardsprite.colorBlendFactor = 0.2
    
    StatusDisplay.publish("Card Does Not",message2: "Follow Suite")
    }
    
    func transferCardToTrickPile(cardsprite:CardSprite)
    {
        _ = self.table.playerOne._hand.remove(cardsprite.card)
        table.playTrickCard(self.table.playerOne, trickcard:cardsprite.card,state:table.currentStateOfPlay!,willAnimate:false)
        table.currentStateOfPlay=nil
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
    if let touch = touches.first
        {
        let height = self.frame.size.height
        let positionInScene = touch.locationInNode(self)
        
        if( draggedNode != nil)
           {
            
                if isInPassingCardsPhase
                    {
                    setDownDraggedPassingCard(positionInScene)
                    checkPassingPhaseProgess()
                    return;
                    }
                else if let state = self.table.currentStateOfPlay,
                    currentPlayer = state.remainingPlayers.first
                    where currentPlayer.name == "You"
                {
                    if let cardsprite = draggedNode
                        where positionInScene.y > height * 0.3
                        {
                        
                       if table.isMoveValid(self.table.playerOne,cardName: cardsprite.name!)
                          {
                          transferCardToTrickPile(cardsprite)
                          return;
                          }
                       else
                          {
                          doesNotFollowSuite(cardsprite)
                          }
                         }
                } else {
                        StatusDisplay.publish("Wait your turn",message2: "")
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

