//
//  GameScene.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 10/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

class Seater
{
    static let seatsFor3 = [SideOfTable.Bottom, SideOfTable.Right, SideOfTable.Left]
    static let seatsFor4 = [SideOfTable.Bottom, SideOfTable.Right, SideOfTable.Top, SideOfTable.Left]
    static let seatsFor5 = [SideOfTable.Bottom, SideOfTable.Right, SideOfTable.TopMidRight, SideOfTable.TopMidLeft,
        SideOfTable.Left]
    
    static let seatsFor6 = [SideOfTable.Bottom, SideOfTable.Right, SideOfTable.TopMidRight, SideOfTable.Top, SideOfTable.TopMidLeft,
        SideOfTable.Left]
    
    static func seatsFor(noOfPlayers:Int) -> [SideOfTable]
    {
    switch noOfPlayers
    {
    case 3 : return seatsFor3
    case 4 : return seatsFor4
    case 5 : return seatsFor5
    case 6 : return seatsFor6
    default : return []
    }
    }
    
}
class GameScene: SKScene {
    
    lazy var table = CardTable.makeTable()
    var originalTouch = CGPoint()
    var originalCardPosition = CGPoint()
    var originalCardRotation = CGFloat()
    var originalCardAnchor = CGPoint()
    var draggedNode: SKSpriteNode? = nil;
    var cardScale = CGFloat(0.9)
    var cardScaleForSelected = CGFloat(1.05)
 

    var playButton1 =  SKSpriteNode(imageNamed:"Play1")
    var playButton2 =  SKSpriteNode(imageNamed:"Play1")

    var rulesScreen = RuleScreen()
    var exitScreen = ExitScreen()
    var optionScreen = OptionScreen()
    
    var arePassingCards = true

    var isInPassingCardsPhase = true
    var cardTossDuration = 0.4
    let cardAnchorPoint = CGPoint(x: 0.5, y: UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad ?
        -0.7 :
        -1.0)
    
    func createAndDisplayCardImages(width: CGFloat , height: CGFloat )
    {
        let seats = Seater.seatsFor(table.players.count)
        var i = 0
        let hSpacing = CGFloat(table.players.count) * 2
        for player in table.players
        {
            table.setupPassedCards(self)

            for card in player.hand
            {
                let sprite = CardSprite(card: card, player: player)
                
                sprite.setScale(cardScale)
                sprite.position = CGPoint(x: width * CGFloat(2 * i  + 1) / hSpacing,y: height*0.5)
                
                self.addChild(sprite)
            }
         
           i++
        }
        
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

    func reverseDeal(width: CGFloat , height: CGFloat )
    {
        let fullHand = CGFloat(13)
        
        var i = 0;
        let hSpacing = CGFloat(table.players.count) * 2
        for player in table.players
        {
            let noCards = CGFloat(player.hand.count)
            let playerSeat = player.sideOfTable
            let isPlayerOne = playerSeat==SideOfTable.Bottom
            var positionInSpread = (fullHand - noCards) * 0.5
            
            for trick in table.tricksPile
            {
                let moveAction = (SKAction.moveTo(CGPoint(x: -300,y:height*0.5), duration:(cardTossDuration*0.8)))
         
                CardSprite.sprite(trick.playedCard).runAction(moveAction)
            
            }
  
                for card in player.hand
                {
                    let sprite = CardSprite.sprite(card)
                  
                
                        sprite.anchorPoint = cardAnchorPoint
                    
                        sprite.flipDown()
                
                        sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                        let newPosition = CGPoint(x: width * CGFloat(2 * i  + 1) / hSpacing,y: height*0.5)
                        let moveAction = (SKAction.moveTo(newPosition, duration:(cardTossDuration*0.8)))
                  
                        let rotateAction = (SKAction.rotateToAngle(0.0, duration:(cardTossDuration*0.8)))
                        let scaleAction =  (SKAction.scaleTo(cardScale, duration:cardTossDuration*0.8))
                        let groupAction = (SKAction.group([moveAction,rotateAction,scaleAction]))
                        sprite.runAction(groupAction)
                        
                        sprite.zPosition = (isPlayerOne ? 100: 10) + positionInSpread
                        sprite.color = UIColor.whiteColor()
                        sprite.colorBlendFactor = 0
                        positionInSpread++
                }
         
            i++
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
        optionScreen.noOfSuites.current = GameSettings.sharedInstance.noOfSuitesInDeck
                optionScreen.noOfPlayers.current = GameSettings.sharedInstance.noOfPlayersAtTable
        optionScreen.noOfCardsInASuite.current = GameSettings.sharedInstance.noOfCardsInASuite
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
        createAndDisplayCardImages(self.frame.size.width,  height: self.frame.size.height)
        ScoreDisplay.sharedInstance.setupScoreArea(self, players: table.players)

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
                self.scene!.view!.presentScene(scene, transition: transition)
                
            })]))
        self.runAction(doneAction2)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
      let width = self.frame.size.width
      for touch in (touches )
      {
        let positionInScene = touch.locationInNode(self)


        if let touchedNode : SKSpriteNode = self.nodeAtPoint(positionInScene) as? SKSpriteNode
        {
            switch touchedNode.name!
            {
            /// play button
            case "Play" :
                touchedNode.texture = SKTexture(imageNamed: "Play2")
                resetWith(CardTable.makeTable())
                return
            /// exit button
            case  "Exit" :
                touchedNode.texture = SKTexture(imageNamed: "Exit2")
                exitScreen.alpha = 1.0
                exitScreen.zPosition = 500
                return
            /// rules button
            case "Rules" :
                rulesScreen.flipButton()
                return
  
            /// Option button
            case "Option" :
                optionScreen.flipButton()
                return
            default : break
      
             }
        }
        var newX = positionInScene.x
        if newX > width * 0.5
                {
                   newX = ((newX - width * 0.5) * 0.6) + width * 0.5
                }
        /// correct for rotation of card
        let adjustedPosition = CGPoint(x: newX,y: positionInScene.y)
        if let adjustedNode : SKSpriteNode = self.nodeAtPoint(adjustedPosition) as? SKSpriteNode
        {
            if isNodeAPlayerOneCardSpite(adjustedNode)        {
                        draggedNode = adjustedNode;
                        originalTouch = positionInScene
                        originalCardPosition  = adjustedNode.position
                        originalCardRotation  = adjustedNode.zRotation
                        originalCardAnchor  = adjustedNode.anchorPoint
                        
                        adjustedNode.zRotation = 0
                        adjustedNode.position = positionInScene
                        adjustedNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                        adjustedNode.xScale = 1.15
                        adjustedNode.yScale = 1.15
                        return
                    }
            
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    let touch = (touches ).first!
    let positionInScene = touch.locationInNode(self)
   
    let deltaX = abs(originalTouch.x - positionInScene.x)
    let deltaY = abs(originalTouch.y - positionInScene.y)
    /// track position in hand
    if deltaX > (2.2 * deltaY) && deltaX > 22
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
    //   rearrangeCardImagesInHandsWithAnimation(width, height: height)
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
                            //rearrangeCardImagesInPassPile(width, height: height)
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

