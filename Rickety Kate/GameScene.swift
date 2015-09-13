//
//  GameScene.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 10/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * CGFloat(M_PI) / 180.0
    }
}


extension Double {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * CGFloat(M_PI) / 180.0
    }
}

public enum SideOfTable:Int
{
   case Bottom
   case Right
   case Top
   case Left
   case Center
    
    func positionOfCard(positionInSpread: CGFloat, spriteHeight: CGFloat, width: CGFloat, height: CGFloat) -> CGPoint
    {
        var startheight = CGFloat(0.0)
        var startWidth = width * 0.35
        var fullHand = CGFloat(13)
        var hortizonalSpacing = width * 0.3 / fullHand
        var verticalSpacing = height * 0.2 / fullHand
        switch self
        {
        // Player One
        case .Bottom:
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight-spriteHeight*0.9)
        // Computer Player
        case .Right:
            startWidth = width
            startheight = height * 0.4
            return CGPoint(x: startWidth+spriteHeight*1.1 ,y: startheight+verticalSpacing*positionInSpread )
        // Computer Player
        case .Top:
            hortizonalSpacing = -width * 0.2 / fullHand
            startWidth = width * 0.6
            startheight = height
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight+spriteHeight*0.5)
        // Computer Player
        case .Left:
            verticalSpacing = -verticalSpacing
            startWidth = width
            startheight = height * 0.6
            return CGPoint(x: -spriteHeight*1.1 ,y: startheight+verticalSpacing*positionInSpread )

        // the trick pile
        case .Center:
            var startheight = height * 0.5
            var startWidth = width * 0.35
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight-spriteHeight*0.9)
        }
    }
    func rotationOfCard(positionInSpread: CGFloat) -> CGFloat
    {
        
    var fullHand = CGFloat(13)
        
        var startRotate = CGFloat(0)
        switch self
        {
        // Computer Player
        case .Right:
            startRotate = 120.degreesToRadians
         // Computer Player
        case .Top:
            startRotate = 210.degreesToRadians
        // Computer Player
        case .Left:
            startRotate = -60.degreesToRadians
        // PlayerOne of the trick pile
        default:
            startRotate = 30.degreesToRadians
        }
   
        
    var rotateDelta = 60.degreesToRadians / fullHand
    
    return   startRotate - rotateDelta * positionInSpread
    }
    
    func positionOfWonCards( width: CGFloat, height: CGFloat) -> CGPoint
    {
    
        switch self
        {
            // Player One
        case .Bottom:
            return CGPoint(x: width*0.5,y: -200.0)
            // Computer Player
        case .Right:
 
            return CGPoint(x: width*1.2,y: height * 0.5)
            // Computer Player
        case .Top:
            return CGPoint(x: width*0.5,y: height * 1.2)
            // Computer Player
        case .Left:
            return CGPoint(x: -200,y: height * 0.5)
            
            // the trick pile
        case .Center:

            return CGPoint(x: width*0.5,y:  height * 0.5)
            
            
        }
    }
}

class GameScene: SKScene {
    
    var table = CardTable.sharedInstance
    
    var originalCardPosition = CGPoint()
    var originalCardRotation = CGFloat()
    var originalCardAnchor = CGPoint()
    var draggedNode: SKSpriteNode? = nil;
    var cardScale = CGFloat(0.9)
    var cardScaleForSelected = CGFloat(1.05)
    var noticeLabel = SKLabelNode(fontNamed:"Chalkduster")
    var noticeLabel2 = SKLabelNode(fontNamed:"Chalkduster")
    var scoreLabel = [SKLabelNode](count: 4, repeatedValue: SKLabelNode())
    var scoreLabel2 = [SKLabelNode](count: 4, repeatedValue: SKLabelNode())
    var scoreLabel3 = [SKLabelNode](count: 4, repeatedValue: SKLabelNode())
    var cardTossDuration = 0.9
    
    func createAndDisplayCardImages(width: CGFloat , height: CGFloat )
    {
        var i = 0
        for player in table.players
        {
            player.sideOfTable = SideOfTable(rawValue: i)!
            for card in player.hand
            {
                let sprite = SKSpriteNode(imageNamed:"Back1")
                
                var pos = CGFloat(i)
                sprite.setScale(cardScale)
                sprite.position = CGPoint(x: width * CGFloat(2 * i  + 1) / 8.0,y: height*0.5)
                
                sprite.name = card.imageName
                sprite.userData = NSMutableDictionary?(["player":player.name] as NSMutableDictionary)
                sprite.userInteractionEnabled = false
                table.displayedCards.updateValue((sprite: sprite, card: card), forKey: card.imageName)
                
                table.displayedCardsIsFaceUp.updateValue(false, forKey: card.imageName)
                self.addChild(sprite)
            }
            i++
        }
    }
    
    func rearrangeCardImagesInTrickPile(width: CGFloat , height: CGFloat )
    {
        var fullHand = CGFloat(13)
        var positionInSpread = (fullHand - 4 ) * 0.5
        var z = CGFloat(1)
        var count = table.tricksPile.count
        for trick in table.tricksPile
        {
            let playerSeat = SideOfTable.Center
   
            if let sprite = table.displayedCards[trick.playedCard.imageName]?.sprite
                    {
                        sprite.setScale(cardScale*0.5)
                        sprite.anchorPoint = CGPoint(x: 0.5, y: -1)
                        
                        sprite.position = playerSeat.positionOfCard(positionInSpread, spriteHeight: sprite.size.height, width: width, height: height)
                        sprite.zRotation =  playerSeat.rotationOfCard(positionInSpread)
                        sprite.zPosition = z
                        sprite.color = UIColor.whiteColor()
                        sprite.colorBlendFactor = 0
                        positionInSpread++
                        z++
                    }
            }
    }

    func rearrangeCardImagesInHands(width: CGFloat , height: CGFloat )
    {

        var fullHand = CGFloat(13)
        
        var i = 0;
        for player in table.players
        {
            var noCards = CGFloat(player.hand.count)
            
            var positionInSpread = (fullHand - noCards) * 0.5
            if let playerSeat = SideOfTable(rawValue: i)
            {
            for card in player.hand
              {
                if let sprite = table.displayedCards[card.imageName]?.sprite
                {
                    // PlayerOne's cards are larger
                    sprite.setScale(i==0 ? cardScale: cardScale*0.5)
                    
                    if(i==0)
                    {
                        if let isUp = table.displayedCardsIsFaceUp[card.imageName] where isUp
                        {
                         // don't need to do anything
                        }
                        else
                        {
                            table.displayedCardsIsFaceUp.updateValue(true, forKey: card.imageName)
                            sprite.texture = SKTexture(imageNamed:card.imageName)
                        }

                    }
                    sprite.anchorPoint = CGPoint(x: 0.5, y: -1)
                    sprite.position = playerSeat.positionOfCard(positionInSpread, spriteHeight: sprite.size.height, width: width, height: height)
                    sprite.zRotation =  playerSeat.rotationOfCard(positionInSpread)
                     sprite.zPosition = (i==0 ? 100: 10) + positionInSpread
                    sprite.color = UIColor.whiteColor()
                    sprite.colorBlendFactor = 0
                    positionInSpread++
                }
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
            var noCards = CGFloat(player.hand.count)
       
            var positionInSpread = (fullHand - noCards) * 0.5
            if let playerSeat = SideOfTable(rawValue: i)
            {
                for card in player.hand
                {
                    if let sprite = table.displayedCards[card.imageName]?.sprite
                    {
                        // PlayerOne's cards are larger
                        sprite.setScale(i==0 ? cardScale: cardScale*0.5)
                        sprite.anchorPoint = CGPoint(x: 0.5, y: -1)
                        if(i==0)
                        {
                            if let isUp = table.displayedCardsIsFaceUp[card.imageName] where isUp
                            {
                                // don't need to do anything
                            }
                            else
                            {
                                table.displayedCardsIsFaceUp.updateValue(true, forKey: card.imageName)
                                sprite.texture = SKTexture(imageNamed:card.imageName)
                            }
                        }
                        
                        let newPosition =  playerSeat.positionOfCard(positionInSpread, spriteHeight: sprite.size.height, width: width, height: height)
                        let moveAction = (SKAction.moveTo(newPosition, duration:(cardTossDuration)))
                        let rotationAngle = playerSeat.rotationOfCard(positionInSpread)
                        let rotateAction = (SKAction.rotateToAngle(rotationAngle, duration:(cardTossDuration)))
                        
                        let groupAction = (SKAction.group([moveAction,rotateAction]))
                        sprite.runAction(groupAction)
                   
                        sprite.zPosition = (i==0 ? 100: 10) + positionInSpread
                        sprite.color = UIColor.whiteColor()
                        sprite.colorBlendFactor = 0
                        positionInSpread++
                    }
                }
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
    func setupStatusArea()
    {
        noticeLabel.text = ""
        noticeLabel.fontSize = 65;
        noticeLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.size.height * 0.4);
        
        noticeLabel2.fontSize = 65;
        noticeLabel2.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.size.height * 0.68);
        self.addChild(noticeLabel)
        self.addChild(noticeLabel2)
        
        table.statusInfo.subscribe() { (message1: String,message2: String) in
            
            self.noticeLabel.removeAllActions()
            self.noticeLabel2.removeAllActions()
            
            self.noticeLabel.alpha = 1.0
            self.noticeLabel2.alpha = 1.0

            switch (message1,message2)
            {
            case ("","") :
                self.noticeLabel.text = "";
                self.noticeLabel2.text = "";
            case (_,"") :
                self.noticeLabel.text = message1;
                self.noticeLabel2.text = "";
                self.noticeLabel.runAction(SKAction.fadeOutWithDuration(4))
                
            default :
                self.noticeLabel2.text = message1;
                self.noticeLabel.text = message2;
                self.noticeLabel.runAction(SKAction.fadeOutWithDuration(4))
                self.noticeLabel2.runAction(SKAction.fadeOutWithDuration(4))
            }
        }
       self.table.statusInfo.publish("Game On","")
        
    }
    
    func setupScoreFor(i:Int)
    {
        scoreLabel[i] = SKLabelNode(fontNamed:"Verdana")
        scoreLabel2[i] = SKLabelNode(fontNamed:"Verdana")
        scoreLabel3[i] = SKLabelNode(fontNamed:"Verdana")
        let l = scoreLabel[i]
        let m = scoreLabel2[i]
        let n = scoreLabel3[i]
        
        table.scoreUpdates[i] = Publink<Int>()
        
        l.text = ""
        l.fontSize = 30;
        m.text = ""
        m.fontSize = 30;
        
        n.text = ""
        n.fontSize = 30;
        m.color = UIColor.grayColor()
        m.colorBlendFactor = 1.0
        n.color = UIColor.grayColor()
        n.colorBlendFactor = 0.5
        
        if let side = SideOfTable(rawValue: i)
        {
            var position = CGPoint()
            var rotate = CGFloat()
            switch side
            {
            case .Right:
                position = CGPoint(x:self.frame.size.width * 0.90, y:CGRectGetMidY(self.frame))
                rotate = 90.degreesToRadians
            case .Top:
                position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.size.height * 0.75)
                rotate = 0.degreesToRadians
            case .Left:
                position = CGPoint(x:self.frame.size.width * 0.10, y:CGRectGetMidY(self.frame))
                rotate = -90.degreesToRadians
            default:
                position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.size.height * 0.35)
                rotate = 0.degreesToRadians
            }
            
            l.position = position
            l.zPosition = 301
            l.zRotation = rotate
            
            m.position = CGPoint(x:position.x+3,y:position.y-3)
            m.zPosition = 299
            m.zRotation = rotate
            
            
            n.position = CGPoint(x:position.x-2,y:position.y+2)
            n.zPosition = 300
            n.zRotation = rotate
            
            self.addChild(l)
            self.addChild(m)
            self.addChild(n)
        }
      
     
        table.scoreUpdates[i].subscribe() { (update:Int) in
            
            let name = self.table.players[i].name
            
            let l = self.scoreLabel[i]
            let m = self.scoreLabel2[i]
            let n = self.scoreLabel3[i]
            
            let message = (name == "You") ? "Your Score is \(update)" : "\(name)'s Score is \(update)"
            l.text = message
            m.text = message
            n.text = message
            }
      
        self.table.scoreUpdates[i].publish(0)
        
    }
    func setupScores()
    {
        for i in 0...3
        {
            setupScoreFor(i)
        }
    }
    func setupNewGameArrangement()
    {
        var width = self.frame.size.width
        var height = self.frame.size.height
        
        
        table.resetGame.subscribe {
            self.table.statusInfo.publish("New Hand","" )
            
            for player in self.table.players
            {
                    for card in player.hand
                    {
                        self.table.displayedCardsIsFaceUp.updateValue(false, forKey: card.imageName)
                        if let sprite  = self.table.displayedCards[card.imageName]?.sprite
                        {
                          sprite.texture = SKTexture(imageNamed:"Back1")
                          if let data = sprite.userData
                            {
                               data.setValue(player.name, forKey: "player")
                            }
                           
                        }
                }
            }
            
            self.table.newGame.publish()
        }
        table.newGame.subscribe {
            let doneAction =  (SKAction.sequence([SKAction.waitForDuration(self.cardTossDuration*0.6),
                SKAction.runBlock({
                    self.rearrangeCardImagesInHandsWithAnimation(width,  height: height)
                    
                })]))
            self.runAction(doneAction)
            
            
            let doneAction2 =  (SKAction.sequence([SKAction.waitForDuration(self.cardTossDuration*2),
                SKAction.runBlock({
                    self.table.playTrickLeadBy(self.table.players[self.table.startPlayerNo])
                    
                })]))
            self.runAction(doneAction2)
            // rearrangeCardImagesInHands(width,  height: height)
            
        }

     table.newGame.publish()
    }

    override func didMoveToView(view: SKView) {
                /* Setup your scene here */
     

        setupStatusArea()
        
        table.dealNewCardsToPlayers()
        setupScores()
        setupTidyup()
        var width = self.frame.size.width
        var height = self.frame.size.height
    
        createAndDisplayCardImages(width,  height: height)
        setupNewGameArrangement()
    }
    
    func PlayerOneCardSpiteAtLocation(positionInScene: CGPoint) -> SKSpriteNode?
    {
      // is there a node there and is it a sprite
        if let touchedNode : SKSpriteNode = self.nodeAtPoint(positionInScene) as? SKSpriteNode
        {
             // does the sprite belong to a player
            if let cardData: NSMutableDictionary  =  touchedNode.userData
            {
                if let player: String = cardData.valueForKey("player") as? String
                {
                    // does the sprite belong to player one
                    if player == "You"
                    {
                        return touchedNode
                    }
                }
            }
         
        }
         return nil
    }
  
  
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
 
      for touch in (touches as! Set<UITouch>)
      {
        
        let positionInScene = touch.locationInNode(self)
        if let touchedNode : SKSpriteNode = PlayerOneCardSpiteAtLocation(positionInScene)
        {
     
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
    
   override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
    let touch = (touches as! Set<UITouch>).first!
    let positionInScene = touch.locationInNode(self)
    

       // let touchedNode = self.nodeAtPoint(positionInScene)
     if( draggedNode != nil)
     {
        let touchedNode = draggedNode!;
        
    touchedNode.position = positionInScene
    }
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchCount = touches.count
        let touch = touches.first as! UITouch

        let height = self.frame.size.height
        let positionInScene = touch.locationInNode(self)
        
        if( draggedNode != nil)
        {
            let touchedNode = draggedNode!;
            if positionInScene.y > height * 0.3
            {
                
                if let nodeName = touchedNode.name,
                    displayedCard = table.displayedCards[nodeName]
                {
                    if let state = self.table.currentStateOfPlay,
                    currentPlayer = state.remainingPlayers.first
                    where currentPlayer.name == "You"
                {
                       if table.isMoveValid(self.table.playerOne,cardName: nodeName)
                       {
                    
                     if let displayedCard = table.displayedCards[nodeName],
                        index = find(self.table.playerOne.hand,displayedCard.card)
                        {
                        let trickcard = self.table.playerOne.hand.removeAtIndex(index)
                        table.playTrickCard(self.table.playerOne, trickcard:displayedCard.card,state:table.currentStateOfPlay!,willAnimate:false)
                            table.currentStateOfPlay=nil

                        return;
                     }
                    
                    }
                       else
                       {
                        
                        displayedCard.sprite.color = UIColor.redColor()
                        displayedCard.sprite.colorBlendFactor = 0.2
                        
                        
                        table.statusInfo.publish("Card Does Not","Follow Suite")
                        
                    }
                    } else {
                        table.statusInfo.publish("Wait your turn","")
                    }
                
       
                }
                
        
            touchedNode.zRotation = originalCardRotation
            touchedNode.position = originalCardPosition
            touchedNode.anchorPoint = originalCardAnchor
        
            touchedNode.xScale = cardScale
            touchedNode.yScale = cardScale
            draggedNode=nil
            }
        }

        
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
