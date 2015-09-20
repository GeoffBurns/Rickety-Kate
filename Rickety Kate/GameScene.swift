//
//  GameScene.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 10/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    lazy var table = CardTable.makeTable(4)
    var originalTouch = CGPoint()
    var originalCardPosition = CGPoint()
    var originalCardRotation = CGFloat()
    var originalCardAnchor = CGPoint()
    var draggedNode: SKSpriteNode? = nil;
    var cardScale = CGFloat(0.9)
    var cardScaleForSelected = CGFloat(1.05)
    var noOfSuitesInDeck = 4

    var playButton1 =  SKSpriteNode(imageNamed:"Play1")
    var playButton2 =  SKSpriteNode(imageNamed:"Play1")

    var rulesScreen = RuleScreen()
    var exitScreen = ExitScreen()
    var optionScreen = OptionScreen(noOfSuites: 4)
    var arePassingCards = true
    var isInPassingCardsPhase = true
    var cardTossDuration = 0.4
    let cardAnchorPoint = CGPoint(x: 0.5, y: UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad ?
        -0.7 :
        -1.0)
    
    func createAndDisplayCardImages(width: CGFloat , height: CGFloat )
    {
        var i = 0
        for player in table.players
        {
            player.sideOfTable = SideOfTable(rawValue: i)!
            for card in player.hand
            {
                let sprite = CardSprite(card: card, player: player)
                
                          sprite.setScale(cardScale)
                sprite.position = CGPoint(x: width * CGFloat(2 * i  + 1) / 8.0,y: height*0.5)
                
    
                self.addChild(sprite)
            }
            i++
        }
    }

    func rearrangeCardImagesInTrickPile(width: CGFloat , height: CGFloat )
    {
        let fullHand = CGFloat(13)
        var positionInSpread = (fullHand - CGFloat(table.noOfPlayers) ) * 0.5
        var z = CGFloat(1)
        for trick in table.tricksPile
        {
            let playerSeat = SideOfTable.Center
            let sprite = CardSprite.sprite(trick.playedCard)
            sprite.setScale(cardScale*0.5)
            sprite.anchorPoint = cardAnchorPoint
            sprite.position = playerSeat.positionOfCard(positionInSpread, spriteHeight: sprite.size.height, width: width, height: height)
            sprite.zRotation =  playerSeat.rotationOfCard(positionInSpread)
            sprite.zPosition = z
            sprite.color = UIColor.whiteColor()
            sprite.colorBlendFactor = 0
            positionInSpread++
            z++
        }
    }
    
    func rearrangeCardImagesInPassPile(width: CGFloat , height: CGFloat )
    {
        let fullHand = CGFloat(13)
        var positionInSpread = (fullHand - 3 ) * 0.5
        var z = CGFloat(1)
        for card in table.cardsPassed[0]
        {
            let playerSeat = SideOfTable.Center
            
            let sprite = CardSprite.sprite(card)
          
            sprite.setScale(cardScale*0.5)
            sprite.anchorPoint = cardAnchorPoint
                
            sprite.position = playerSeat.positionOfCard(positionInSpread, spriteHeight: sprite.size.height, width: width, height: height)
            sprite.zRotation =  playerSeat.rotationOfCard(positionInSpread, fullHand:fullHand)
            sprite.zPosition = z
            sprite.color = UIColor.whiteColor()
            sprite.colorBlendFactor = 0
            positionInSpread++
            z++
        }
    }
    
    func rearrangeCardImagesInHands(width: CGFloat , height: CGFloat )
    {
        var fullHand = CGFloat(13)
        
        var i = 0;
        for player in table.players
        {
            let noCards = CGFloat(player.hand.count)
            
            var positionInSpread = (fullHand - noCards) * 0.5
            if fullHand < noCards
            {
                fullHand = noCards
                positionInSpread = CGFloat(0)
            }
            if let playerSeat = SideOfTable(rawValue: i)
            {
         
            for card in player.hand
              {
                let sprite = CardSprite.sprite(card)
                
                // PlayerOne's cards are larger
                sprite.setScale(i==0 ? cardScale: cardScale*0.5)
                    
                if(i==0)
                    {
                        sprite.flipUp()
                    
                    }
                    sprite.anchorPoint = cardAnchorPoint
                sprite.position = playerSeat.positionOfCard(positionInSpread, spriteHeight: sprite.size.height, width: width, height: height, fullHand:fullHand)
                    sprite.zRotation =  playerSeat.rotationOfCard(positionInSpread, fullHand:fullHand)
                     sprite.zPosition = (i==0 ? 100: 10) + positionInSpread
                    sprite.color = UIColor.whiteColor()
                    sprite.colorBlendFactor = 0
                    positionInSpread++
                }
            
            }
            i++
        }
       }
    func rearrangeCardImagesInHandsWithAnimation(width: CGFloat , height: CGFloat )
    {
        var fullHand = CGFloat(13)
        
        var i = 0;
        for player in table.players
        {
            let noCards = CGFloat(player.hand.count)
       
            var positionInSpread = (fullHand - noCards) * 0.5
            if fullHand < noCards
            {
                fullHand = noCards
                positionInSpread = CGFloat(0)
            }
            if let playerSeat = SideOfTable(rawValue: i)
            {
                for card in player.hand
                {
                    let sprite = CardSprite.sprite(card)
                   
                        // PlayerOne's cards are larger
                        sprite.setScale(i==0 ? cardScale: cardScale*0.5)
                        sprite.anchorPoint = cardAnchorPoint

                        
                        if(i==0)
                        {
                         sprite.flipUp()
                                        
                        }
                        else
                        {
                         sprite.flipDown()
                            
                        }
                       
                        
                    let newPosition =  playerSeat.positionOfCard(positionInSpread, spriteHeight: sprite.size.height, width: width, height: height, fullHand:fullHand)
                        let moveAction = (SKAction.moveTo(newPosition, duration:(cardTossDuration*0.8)))
                        let rotationAngle = playerSeat.rotationOfCard(positionInSpread, fullHand:fullHand)
                        let rotateAction = (SKAction.rotateToAngle(rotationAngle, duration:(cardTossDuration*0.8)))
                        
                        let groupAction = (SKAction.group([moveAction,rotateAction]))
                        sprite.runAction(groupAction)
                   
                        sprite.zPosition = (i==0 ? 100: 10) + positionInSpread
                        sprite.color = UIColor.whiteColor()
                        sprite.colorBlendFactor = 0
                        positionInSpread++
                   
                }
            }
            i++
        }
    }
    func reverseDeal(width: CGFloat , height: CGFloat )
    {
        let fullHand = CGFloat(13)
        
        var i = 0;
        for player in table.players
        {
            let noCards = CGFloat(player.hand.count)
            
            var positionInSpread = (fullHand - noCards) * 0.5
            
            for trick in table.tricksPile
            {
                let moveAction = (SKAction.moveTo(CGPoint(x: -300,y:height*0.5), duration:(cardTossDuration*0.8)))
         
                CardSprite.sprite(trick.playedCard).runAction(moveAction)
            
            }
  
                for card in player.hand
                {
                    let sprite = CardSprite.sprite(card)
                  
                        // PlayerOne's cards are larger
                
                        sprite.anchorPoint = cardAnchorPoint
                    
                        sprite.flipDown()
                
                        sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                        let newPosition = CGPoint(x: width * CGFloat(2 * i  + 1) / 8.0,y: height*0.5)
                        let moveAction = (SKAction.moveTo(newPosition, duration:(cardTossDuration*0.8)))
                  
                        let rotateAction = (SKAction.rotateToAngle(0.0, duration:(cardTossDuration*0.8)))
                        let scaleAction =  (SKAction.scaleTo(cardScale, duration:cardTossDuration*0.8))
                        let groupAction = (SKAction.group([moveAction,rotateAction,scaleAction]))
                        sprite.runAction(groupAction)
                        
                        sprite.zPosition = (i==0 ? 100: 10) + positionInSpread
                        sprite.color = UIColor.whiteColor()
                        sprite.colorBlendFactor = 0
                        positionInSpread++
                  
                }
         
            i++
        }
    }
    
    func rearrange()
    {
        let width = self.frame.size.width
        let height = self.frame.size.height
        rearrangeCardImagesInTrickPile(width,  height: height)
        rearrangeCardImagesInHands(width,  height: height)
    }
    func setupTidyup()
    {
        table.tidyup.subscribe {
            self.rearrange()
        }
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
            SKAction.runBlock({
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
                    for card in player.hand
                    {
                        let sprite = CardSprite.sprite(card)
                        sprite.flipDown()
                        sprite.player = player
                     }
            }
            
            self.table.newGame.publish()
        }
        table.newGame.subscribe {
            let doneAction =  (SKAction.sequence([SKAction.waitForDuration(self.cardTossDuration*0.1),
                SKAction.runBlock({
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
     table.newGame.publish()
    }
    
    func ruletext()
    {
        rulesScreen.setup(self)
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
        optionScreen.noOfSuites.current = noOfSuitesInDeck
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
    override func didMoveToView(view: SKView) {
                /* Setup your scene here */
     
        self.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 0.2, alpha: 1.0)

        StatusDisplay.register(self)
        StatusAreaFirstMessage()
        ruletext()
        setupExitScreen()
        setupOptionScreen()
        setupPlayButton()
        table.dealNewCardsToPlayers()
        ScoreDisplay.sharedInstance.setupScoreArea(self, players: table.players)
        setupTidyup()
        let width = self.frame.size.width
        let height = self.frame.size.height
    
        createAndDisplayCardImages(width,  height: height)
        setupNewGameArrangement()
    }
    
    func isNodeAPlayerOneCardSpite(node:SKSpriteNode) -> Bool
    {
    // does the sprite belong to a player
    if let cardsprite = node as? CardSprite,
        player = cardsprite.player
        {
           return player.name == "You"
        }

    return false
    }
    func isNodeAPlayButton(node:SKSpriteNode) -> Bool
    {
        return node.name == "Play"
    }

    func isNodeAExitButton(node:SKSpriteNode) -> Bool
    {
        return node.name == "Exit"
    }
    
    func resetWith(table:CardTable)
    {
        let width = self.frame.size.width
        let height = self.frame.size.height
        reverseDeal(width , height: height )
        
        let doneAction2 =  (SKAction.sequence([SKAction.waitForDuration(self.cardTossDuration),
            SKAction.runBlock({
                let transition = SKTransition.crossFadeWithDuration(0.5)
                let scene = GameScene(size: self.scene!.size)
                scene.scaleMode = SKSceneScaleMode.AspectFill
                scene.table = table
                scene.noOfSuitesInDeck  = self.noOfSuitesInDeck
                self.scene!.view!.presentScene(scene, transition: transition)
                
            })]))
        self.runAction(doneAction2)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
    
      for touch in (touches )
      {
        let positionInScene = touch.locationInNode(self)
        
     //   var a = self.nodesAtPoint(positionInScene)
        if let touchedNode : SKSpriteNode = self.nodeAtPoint(positionInScene) as? SKSpriteNode
        {
        if isNodeAPlayButton(touchedNode)
        {
            
            touchedNode.texture = SKTexture(imageNamed: "Play2")
        
            resetWith(CardTable.makeTable(self.noOfSuitesInDeck))
            
        return
        }
        if isNodeAExitButton(touchedNode)
            {
                touchedNode.texture = SKTexture(imageNamed: "Exit2")
                exitScreen.alpha = 1.0
                exitScreen.zPosition = 500
            }
        /// rules button
        if touchedNode.name == "Rules"
        {
        rulesScreen.flipButton()
        return
        }
        /// Option button
        if touchedNode.name == "Option"
            {
                optionScreen.flipButton()
                return
            }
        if isNodeAPlayerOneCardSpite(touchedNode)        {
        draggedNode = touchedNode;
        originalTouch = positionInScene
        originalCardPosition  = touchedNode.position
        originalCardRotation  = touchedNode.zRotation
        originalCardAnchor  = touchedNode.anchorPoint
            
        touchedNode.zRotation = 0
        touchedNode.position = positionInScene
        touchedNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        touchedNode.xScale = 1.15
        touchedNode.yScale = 1.15
        }
        break
        }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    let touch = (touches ).first!
    let positionInScene = touch.locationInNode(self)
   
    let deltaX = abs(originalTouch.x - positionInScene.x)
    let deltaY = abs(originalTouch.y - positionInScene.y)
        
    if deltaX > (2.2 * deltaY)
        {
          
           let touchedNodes = self.nodesAtPoint(positionInScene)
    
            for node in touchedNodes
                {
                    if let touchedNode : SKSpriteNode = node as? SKSpriteNode
                      where isNodeAPlayerOneCardSpite(touchedNode)
                        && draggedNode != touchedNode
                    {
                        
                        restoreDraggedCard()
                        
                        draggedNode = touchedNode;
                        originalTouch = positionInScene
                        originalCardPosition  = touchedNode.position
                        originalCardRotation  = touchedNode.zRotation
                        originalCardAnchor  = touchedNode.anchorPoint
                        
                        touchedNode.zRotation = 0
                        touchedNode.position = positionInScene
                        touchedNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                        touchedNode.xScale = 1.15
                        touchedNode.yScale = 1.15
                        return
                    }
               }
            }
        
    
       // let touchedNode = self.nodeAtPoint(positionInScene)
     if( draggedNode != nil)
      {
        let touchedNode = draggedNode!;
        
      touchedNode.position = positionInScene
      }
    }

    func endCardPassingPhase()
    {
        let width = self.frame.size.width
        let height = self.frame.size.height
        table.passOtherCards()
        table.takePassedCards()
        rearrangeCardImagesInHandsWithAnimation(width, height: height)
        isInPassingCardsPhase = false
        StatusDisplay.publish()
        startTrickPhase()
    }
    
    func restoreDraggedCard()
    {
        draggedNode!.zRotation = originalCardRotation
        draggedNode!.position = originalCardPosition
        draggedNode!.anchorPoint = originalCardAnchor
        draggedNode!.xScale = cardScale
        draggedNode!.yScale = cardScale
        draggedNode=nil
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
        if let touch = touches.first
        {
        let width = self.frame.size.width
        let height = self.frame.size.height
        let positionInScene = touch.locationInNode(self)
        
        if( draggedNode != nil)
        {
            let touchedNode = draggedNode!;
            if positionInScene.y > height * 0.3
            {
                
                if let cardsprite = touchedNode as? CardSprite
                {
                    
                    if isInPassingCardsPhase
                    {
                    
                            if let _ = table.passCard(0, passedCard: cardsprite.card)
                            {
                                
                            }
                            else
                            {
                                restoreDraggedCard()
                            }
                            rearrangeCardImagesInPassPile(width, height: height)
                            let count = table.cardsPassed[0].count
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
                            return;
                        
                    }
                    else if let state = self.table.currentStateOfPlay,
                    currentPlayer = state.remainingPlayers.first
                    where currentPlayer.name == "You"
                {
                       if table.isMoveValid(self.table.playerOne,cardName: cardsprite.name!)
                       {
                    
                     if let  index = self.table.playerOne.hand.indexOf(cardsprite.card)
                        {
                        _ = self.table.playerOne.hand.removeAtIndex(index)
                        table.playTrickCard(self.table.playerOne, trickcard:cardsprite.card,state:table.currentStateOfPlay!,willAnimate:false)
                            table.currentStateOfPlay=nil
                        return;
                     }
                    
                    }
                       else
                       {
                        cardsprite.color = UIColor.redColor()
                        cardsprite.colorBlendFactor = 0.2
                        
                        StatusDisplay.publish("Card Does Not",message2: "Follow Suite")
                        
                    }
                    } else {
                        StatusDisplay.publish("Wait your turn",message2: "")
                    }
                }
   
     
            }
                   restoreDraggedCard()
        }

        }
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

