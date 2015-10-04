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
    
    var table : CardTable! {  didSet { setupTPassYourThreeWorstCardsPhase() } }
    var originalTouch = CGPoint()
    var draggedNode: CardSprite? = nil;
    var cardScale = CGFloat(0.9)
    var cardScaleForSelected = CGFloat(1.05)
    
    var dealtPiles = [CardPile]()

    var playButton1 =  SKSpriteNode(imageNamed:"Play1")
    var playButton2 =  SKSpriteNode(imageNamed:"Play1")

    
    var arePassingCards = true


   
    var cardPassingPhase : PassYourThreeWorstCardsPhase! = nil
    func setupTPassYourThreeWorstCardsPhase()
    {
        cardPassingPhase =  PassYourThreeWorstCardsPhase(scene: self,players: table.players);
    }
    
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
        let doneAction2 =  (SKAction.sequence([SKAction.waitForDuration(CardSprite.tossDuration*1.3),
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
                        let sprite = self.cardSprite(card)!
                        sprite.flipDown()
                        sprite .player = player
                     }
            }
            
            self.table.newGame.publish()
        }
        table.newGame.subscribe {
            let doneAction =  (SKAction.sequence([SKAction.waitForDuration(CardSprite.tossDuration*0.1),
                SKAction.runBlock({ [unowned self] in
                    self.rearrangeCardImagesInHandsWithAnimation(width,  height: height)
                })]))
            self.runAction(doneAction)
           
            self.cardPassingPhase.isCurrentlyActive = self.arePassingCards && !self.table.isInDemoMode
            if self.cardPassingPhase.isCurrentlyActive
            {
              StatusDisplay.publish("Discard Your",message2: "Three Worst Cards")
            }
            else
            {
              self.startTrickPhase()
            }
        }
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

        Navigate.setupRulesButton(self)
        if table.isInDemoMode
        {
            Navigate.setupOptionButton(self)
        }
        else
        {
           Navigate.setupExitButton(self)
        }
        
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
        cardPassingPhase.setupCardPilesSoPlayersCanPassTheir3WorstCards()
        table.setupCardPilesSoPlayersCanPlayTricks()
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

    func resetSceneWithNewTableThatIsInteractive(isInteractive:Bool)
    {
        let width = self.frame.size.width
        let height = self.frame.size.height
        reverseDeal(width , height: height )
        
    
        self.runAction((SKAction.sequence([SKAction.waitForDuration(CardSprite.tossDuration),
            SKAction.runBlock({ [unowned self] in
                let transition = SKTransition.crossFadeWithDuration(0.5)
                let scene = GameScene(size: self.scene!.size)
                
                scene.scaleMode = SKSceneScaleMode.AspectFill
             
                scene.table = isInteractive ?
                    CardTable.makeTable(scene) :
                    CardTable.makeDemo(scene)
                    
                self.scene!.view!.presentScene(scene, transition: transition)
                
                })])))
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
        if let touchedNode : SKSpriteNode = self.nodeAtPoint(positionInScene) as? SKSpriteNode
        {
            switch touchedNode.name!
            {
                /// play button
            case "Play" :
                touchedNode.texture = SKTexture(imageNamed: "Play2")
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
    
    func isCardInTheRightDirection(touchedCardSprite:CardSprite, goingRight:Bool) -> Bool
    {
        let touchedCardIsToRight = draggedNode!.positionInSpread < touchedCardSprite.positionInSpread
        return goingRight && touchedCardIsToRight
            || !goingRight && !touchedCardIsToRight
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
           let touchedNodes = self.nodesAtPoint(positionInScene)
    
           for node in touchedNodes
                {
                 if let touchedNode  = node as? CardSprite
                    
                      where isNodeAPlayerOneCardSpite(touchedNode)
                        && draggedNode != touchedNode
                        && isCardInTheRightDirection(touchedNode, goingRight:goingRight)
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
 
        let isTargetHand = positionInScene.y > height * 0.3
        if cardPassingPhase.transferCardSprite(cardsprite, isTargetHand:isTargetHand)
            {
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
    cardsprite.color = UIColor.redColor()
    cardsprite.colorBlendFactor = 0.2
    
    StatusDisplay.publish("Card Does Not",message2: "Follow Suite")
    }
    
    func transferCardToTrickPile(cardsprite:CardSprite)
    {
        _ = self.table.playerOne._hand.remove(cardsprite.card)
        table.playTrickCard(self.table.playerOne, trickcard:cardsprite.card,state:table.currentStateOfPlay!,willAnimate:false)
        table.currentStateOfPlay=nil
        StatusDisplay.publish()
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

