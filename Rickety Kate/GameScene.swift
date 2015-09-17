//
//  GameScene.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 10/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    
    lazy var table = CardTable.makeTable()
    
    var originalCardPosition = CGPoint()
    var originalCardRotation = CGFloat()
    var originalCardAnchor = CGPoint()
    var draggedNode: SKSpriteNode? = nil;
    var cardScale = CGFloat(0.9)
    var cardScaleForSelected = CGFloat(1.05)
    var exitLabel = SKLabelNode(fontNamed:"Chalkduster")
    var exitLabel2 = SKLabelNode(fontNamed:"Chalkduster")

    var rulesButton =  SKSpriteNode(imageNamed:"Rules1")
    var playButton1 =  SKSpriteNode(imageNamed:"Play1")
    var playButton2 =  SKSpriteNode(imageNamed:"Play1")
    var exitButton =  SKSpriteNode(imageNamed:"Exit")
    var rulesText : SKMultilineLabel? = nil
    lazy var exitScreen = SKSpriteNode(color: UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9), size: CGSize(width: 1, height: 1))
    var isRulesTextShowing = false
    var isExitScreenShowing = false
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
            sprite.zRotation =  playerSeat.rotationOfCard(positionInSpread)
            sprite.zPosition = z
            sprite.color = UIColor.whiteColor()
            sprite.colorBlendFactor = 0
            positionInSpread++
            z++
        }
    }
    
    func rearrangeCardImagesInHands(width: CGFloat , height: CGFloat )
    {
        let fullHand = CGFloat(13)
        
        var i = 0;
        for player in table.players
        {
            let noCards = CGFloat(player.hand.count)
            
            var positionInSpread = (fullHand - noCards) * 0.5
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
                    sprite.position = playerSeat.positionOfCard(positionInSpread, spriteHeight: sprite.size.height, width: width, height: height)
                    sprite.zRotation =  playerSeat.rotationOfCard(positionInSpread)
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
        let fullHand = CGFloat(13)
        
        var i = 0;
        for player in table.players
        {
            let noCards = CGFloat(player.hand.count)
       
            var positionInSpread = (fullHand - noCards) * 0.5
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
                       
                        
                        let newPosition =  playerSeat.positionOfCard(positionInSpread, spriteHeight: sprite.size.height, width: width, height: height)
                        let moveAction = (SKAction.moveTo(newPosition, duration:(cardTossDuration*0.8)))
                        let rotationAngle = playerSeat.rotationOfCard(positionInSpread)
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
        rulesText  = SKMultilineLabel(text: "Rickety Kate is a trick taking card game. This means every player tosses in a card and the player with the highest card in the same suite as the first card wins the trick and the cards. But wait! the person with the lowest running score wins. So winning a trick is not necessarially good.  The Queen of Spades (Rickety Kate) is worth 10 points against you and the other spades are worth 1 point against you. When you run out of cards you are dealt another hand. If you obtain all the spades in a hand it is called 'Shooting the Moon' and your score drops to zero. At the beginning of each hand the player pass their three worst cards to their neighbour. Aces and King are the worst cards.", labelWidth: Int(self.frame.width * 0.88), pos: CGPoint(x:CGRectGetMidX(self.frame),y:self.frame.size.height*0.8),fontSize:30,fontColor:UIColor.whiteColor(),leading:40)
        let sprite = SKSpriteNode(color: UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9), size: self.frame.size)
        sprite.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame))
        
        sprite.name = "Rules Background"
        sprite.userInteractionEnabled = false
        rulesText!.addChild(sprite)
        rulesText!.zPosition = -10
        
        rulesText!.name = "Rules text"
        rulesText!.userInteractionEnabled = false
        
        rulesText!.alpha = 0.0
        
        rulesButton.setScale(0.5)
        rulesButton.anchorPoint = CGPoint(x: 0.0,
            y:
            UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad ?
                1.6 :
            2.2)
        rulesButton.position = CGPoint(x:0.0,y:self.frame.size.height)
 
        rulesButton.name = "Rules"
        
        rulesButton.zPosition = 450
        rulesButton.userInteractionEnabled = false
        self.addChild(rulesButton)
        self.addChild(rulesText!)
        
    }

    func setupExitScreen()
    {
        if table.isInDemoMode
        {
            return
        }
        exitScreen = SKSpriteNode(color: UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9), size: self.frame.size)
        
        exitScreen.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame))
        exitScreen.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        exitScreen.name = "ExitBackground"
        exitScreen.userInteractionEnabled = false
        exitScreen.zPosition = -10
        exitScreen.alpha = 0.0
        
        exitLabel.text = "Are you sure"
        exitLabel.fontSize = 65;
        exitLabel.position = CGPoint(x:self.frame.width * 0.0, y:self.frame.size.height * 0.2);
        
        exitScreen.addChild(exitLabel)
        
        
        exitLabel2.text = "you want to exit?"
        exitLabel2.fontSize = 65;
        exitLabel2.position = CGPoint(x:self.frame.width * 0.0, y:self.frame.size.height * 0.07);
        
        exitScreen.addChild(exitLabel2)
        
        let yesButton =  SKSpriteNode(imageNamed:"Yes")
        yesButton.position = CGPoint(x:self.frame.width * -0.25,y:self.frame.height * -0.1)
        yesButton.setScale(0.5)
        yesButton.zPosition = 100
        yesButton.name = "Yes"
        yesButton.userInteractionEnabled = false
    
        
        
        let noButton =  SKSpriteNode(imageNamed:"No")
        noButton.position = CGPoint(x:self.frame.width*0.25,y:self.frame.height * -0.1)
        noButton.setScale(0.5)
        noButton.zPosition = 100
        noButton.name = "No"
        noButton.userInteractionEnabled = false
        
        exitScreen.addChild(yesButton)
        exitScreen.addChild(noButton)
        
        self.addChild(exitScreen)
    
        exitButton.setScale(0.5)
        exitButton.anchorPoint = CGPoint(x: 1.0,
            y:
            UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad ?
                1.6 :
            2.2)
        exitButton.position = CGPoint(x:self.frame.size.width,y:self.frame.size.height)
    
        exitButton.name = "Exit"
        
        exitButton.zPosition = 450
        exitButton.userInteractionEnabled = false
        self.addChild(exitButton)
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
    func isNodeRulesButton(node:SKSpriteNode) -> Bool
    {
        return node.name == "Rules"
    }
    func isNodeAExitButton(node:SKSpriteNode) -> Bool
    {
        return node.name == "Exit"
    }
    func isNodeAYesButton(node:SKSpriteNode) -> Bool
    {
        return node.name == "Yes"
    }
    func isNodeANoButton(node:SKSpriteNode) -> Bool
    {
        return node.name == "No"
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        let width = self.frame.size.width
        let height = self.frame.size.height
      for touch in (touches )
      {
        let positionInScene = touch.locationInNode(self)
        if let touchedNode : SKSpriteNode = self.nodeAtPoint(positionInScene) as? SKSpriteNode
        {
        if isNodeAPlayButton(touchedNode)
        {
            
            touchedNode.texture = SKTexture(imageNamed: "Play2")
        
            
            reverseDeal(width , height: height )
            
            let doneAction2 =  (SKAction.sequence([SKAction.waitForDuration(self.cardTossDuration),
                SKAction.runBlock({
                    let transition = SKTransition.crossFadeWithDuration(0.5)
                    let scene = GameScene(size: self.scene!.size)
                    scene.scaleMode = SKSceneScaleMode.AspectFill
                    
                    self.scene!.view!.presentScene(scene, transition: transition)
                    
                })]))
            self.runAction(doneAction2)
            
        return
        }
        if isNodeAExitButton(touchedNode)
            {
                touchedNode.texture = SKTexture(imageNamed: "Exit2")
                exitScreen.alpha = 1.0
                exitScreen.zPosition = 500
            }
        if isNodeANoButton(touchedNode)
            {
                exitButton.texture = SKTexture(imageNamed: "Exit")
                exitScreen.alpha = 0.0
                exitScreen.zPosition = -10
            }
        if isNodeAYesButton(touchedNode)
            {
                touchedNode.texture = SKTexture(imageNamed: "Yes2")
                reverseDeal(width , height: height )
                
                let doneAction2 =  (SKAction.sequence([SKAction.waitForDuration(self.cardTossDuration),
                    SKAction.runBlock({
                        let transition = SKTransition.crossFadeWithDuration(0.5)
                        let scene = GameScene(size: self.scene!.size)
                        scene.scaleMode = SKSceneScaleMode.AspectFill
                        scene.table = CardTable.makeDemo()
                        self.scene!.view!.presentScene(scene, transition: transition)
                        
                    })]))
                self.runAction(doneAction2)
            }
        /// rules button
        if isNodeRulesButton(touchedNode)
        {
            if(isRulesTextShowing)
            {
            rulesButton.texture = SKTexture(imageNamed: "Rules1")
            rulesText!.alpha = 0.0
            rulesText!.zPosition = -10
            isRulesTextShowing = false
            }
            else
            {
                rulesButton.texture = SKTexture(imageNamed: "Rules2")
                rulesText!.alpha = 1.0
                 rulesText!.zPosition = 400
                isRulesTextShowing = true
            }
          return
            
        }
        if isNodeAPlayerOneCardSpite(touchedNode)        {
        draggedNode = touchedNode;
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

