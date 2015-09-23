//
//  GameScene.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 10/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

enum CardPileType : CustomStringConvertible
{
    case Hand
    case Passing
    case Won
    case Trick
    
    
    var description : String {
        switch self {
            
        case .Hand: return "Hand"
        case .Passing: return "Passing"
        case .Won: return "Won"
        case .Trick: return "Trick"
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
    
    var dealtPiles : [CardPile] = []


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
        dealtPiles = []
        
        for player in table.players
        {
            table.setupPassedCards(self)
        
            for card in player.hand
            {
                let sprite = CardSprite(card: card, player: player)
                
                sprite.setScale(cardScale * 0.5)
                self.addChild(sprite)
            }
            let dealtPile = CardPile(name: "dealt")
            dealtPile.setup(self, direction: Direction.Up, position: CGPoint(x: width * CGFloat(2 * i  + 1) / hSpacing,y: height*0.5), isUp: false, isBig: false)
            
             dealtPile.appendContentsOf(player._hand.cards)
             dealtPiles.append(dealtPile)
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
    
        let hSpacing = CGFloat(table.players.count) * 2
        dealtPiles = []
        for (i,player) in table.players.enumerate() 
           {
           let dealtPile = CardPile(name: "dealt")
            dealtPile.setup(self, direction: Direction.Up, position: CGPoint(x: width * CGFloat(2 * i  + 1) / hSpacing,y: height*0.5), isUp: false, isBig: false)
            dealtPile.appendContentsOf(player._hand.cards)
            dealtPiles.append(dealtPile)
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
                player.wonCards.clear()
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
    
    func buttonTouched() -> Bool
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
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
      let width = self.frame.size.width
      for touch in (touches )
      {
        let positionInScene = touch.locationInNode(self)


        if buttonTouched()
        {
                return
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
                let liftUp = SKAction.scaleTo(1.2, duration: 0.2)
                adjustedNode.runAction(liftUp, withKey: "pickup")
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
        isInPassingCardsPhase = false
        StatusDisplay.publish()
        startTrickPhase()
    }
    
    func restoreDraggedCard()
    {
        
        if let cardsprite = draggedNode as? CardSprite,
           let fan = cardsprite.fan
        {
          fan.rearrange()
        }
        else
        {
          draggedNode!.zRotation = originalCardRotation
          draggedNode!.position = originalCardPosition
          draggedNode!.anchorPoint = originalCardAnchor
          draggedNode!.xScale = cardScale
          draggedNode!.yScale = cardScale
        }
        draggedNode=nil
    }
    
    
    func setDownDraggedPassingCard(positionInScene:CGPoint)
    {
        let height = self.frame.size.height
        let touchedNode = draggedNode!;
        if let cardsprite = touchedNode as? CardSprite
            {
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
                    let touchedNode = draggedNode!;
                    
                    if let cardsprite = touchedNode as? CardSprite
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
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

