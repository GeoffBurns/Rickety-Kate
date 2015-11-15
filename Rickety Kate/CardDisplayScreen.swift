//
//  CardDisplayScreen.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 2/10/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

enum CardDisplayTab
{
    case DeckTab
    case ScoringTab
}

typealias ScorePairCollection = [(PlayingCard,Int)]

// Help Screen
class CardDisplayScreen: Popup, HasDiscardArea {
    
    
    var discardPile = CardPile(name: CardPileType.Discard.description)
    var discardWhitePile = CardPile(name: CardPileType.Discard.description)
    
    var isSetup = false
    var slides = [CardSlide]()
    var orderedGroups : [(Int,ScorePairCollection)] = []
    var activeTab = CardDisplayTab.DeckTab
    var moreButton = SKSpriteNode(imageNamed: "More1")
    var backButton = SKSpriteNode(imageNamed: "Back")
    var deckButton = SKSpriteNode(imageNamed: "Deck2")
    var scoreButton = SKSpriteNode(imageNamed: "Scores1")
    var suiteStart = 0
    var cards = [PlayingCard]()
    var oldPositon = CGPointZero
    let noOfSlides = GameSettings.isPad ? 3 : 2
    let separationOfSlides = GameSettings.isPad ? 0.25 : 0.4
    let slideStart : CGFloat = GameSettings.isPad ? 0.72 : 0.7
    var draggedNode : CardSprite? = nil
    var originalTouch = CGPointZero
    var originalScale = CGFloat(0)
    var originalOrder = CGFloat(0)
    
    override func onEnter() {

    }
    override func onExit() {
        super.onExit()
   
    }
    override func setup(scene:SKNode)
    {
        if !isSetup
          {
          self.gameScene = scene
            
          setupDiscardArea()
            
          color = UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9)
          size = scene.frame.size
          position = CGPointZero
          anchorPoint = CGPointZero
          userInteractionEnabled = true
          cards = GameSettings.sharedInstance.deck!.orderedDeck
   

          for i in 0..<noOfSlides
           {
            let slide = CardSlide(name: "slide")
            slide.setup(self, slideWidth: size.width * 0.9)
            slide.position = CGPointMake(size.width * 0.10, size.height * (slideStart - ( CGFloat(i) * CGFloat(separationOfSlides))))
            slides.append(slide)
           }
            
           isSetup = true
          }

        for card in cards {
            let cs = CardSprite.create(card, scene: self)
            cs.anchorPoint = CGPointMake(0.5,05)
        }
        suiteStart = 0
        displayPage() 
    }
    
    func displayPage()
    {
        let fontsize : CGFloat = FontSize.Small.scale
        let title = SKLabelNode(fontNamed:"Verdana")
        title.fontSize = fontsize
        title.position = CGPointMake(size.width * 0.50, size.height * 0.92 )
        title.text = "Card Rankings"
        self.addChild(title)
        
        switch activeTab
        {
        case .DeckTab : displayCardsInDeck()
        case .ScoringTab : displayScoringCards()
        }
      
        
        moreButton.setScale(ButtonSize.Small.scale)
        moreButton.anchorPoint = CGPoint(x: 2.0, y: 0.0)
        moreButton.position = CGPoint(x:self.frame.size.width,y:0.0)
        
        moreButton.name = "More"
        
        moreButton.zPosition = 300
        moreButton.userInteractionEnabled = false
        
        self.addChild(moreButton)
        
        backButton.setScale(ButtonSize.Small.scale)
        backButton.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        backButton.position = CGPoint(x:0.0,y:0.0)
        
        backButton.name = "Back"
        
        backButton.zPosition = 300
        backButton.userInteractionEnabled = false
        backButton.alpha = 0.0
        self.addChild(backButton)
        
        
        deckButton.setScale(ButtonSize.Small.scale)
        deckButton.anchorPoint = CGPoint(x: 2.0, y: 1.0)
        deckButton.position = CGPoint(x:self.frame.size.width,y:self.frame.size.height)
        
        deckButton.name = "Deck"
        
        deckButton.zPosition = 300
        deckButton.userInteractionEnabled = false
        
        self.addChild(deckButton)
        
        scoreButton.setScale(ButtonSize.Small.scale)
        scoreButton.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        scoreButton.position = CGPoint(x:self.frame.size.width,y:self.frame.size.height)
        
        scoreButton.name = "Score"
        
        scoreButton.zPosition = 300
        scoreButton.userInteractionEnabled = false
        
        self.addChild(scoreButton)
        
        let nextStart = noOfSlides
        switch activeTab
        {
        case .DeckTab :  moreButton.alpha = nextStart >= GameSettings.sharedInstance.deck!.suitesInDeck.count ? 0.0 : 1.0
        case .ScoringTab : moreButton.alpha = nextStart >=  self.orderedGroups.count ? 0.0 : 1.0
        }
    }
    func displayCardsInDeck()
    {
        
        let fontsize : CGFloat = FontSize.Smallest.scale
        for (i,slide) in slides.enumerate()
        {
            if  i+suiteStart < GameSettings.sharedInstance.deck!.suitesInDeck.count
            {
                let suite = cards.filter { $0.suite == GameSettings.sharedInstance.deck!.suitesInDeck[i+suiteStart]}
                
                if suite.count > 0
                {
                    let l = SKLabelNode(fontNamed:"Verdana")
                    l.fontSize = fontsize
                    l.position = CGPointMake(size.width * 0.10, size.height * (0.83 - ( CGFloat(i) * CGFloat(separationOfSlides))))
                    l.text = "High Cards"
                    l.name = "label"
                    
                    let m = SKLabelNode(fontNamed:"Verdana")
                    m.fontSize = fontsize
                    m.position = CGPointMake(size.width * 0.93, size.height * (0.83 - ( CGFloat(i) * CGFloat(separationOfSlides))))
                    m.text = "Low Cards"
                    
                    m.name = "label"
                    
                    self.addChild(l)
                    self.addChild(m)
                    
                    
           
                      slide.discardAll()
                      slide.replaceWithContentsOf(suite)
                    slide.rearrange()
     
                    
                    continue
                }
            }

              slide.discardAll()
           
              slide.clear()
              slide.rearrange()
 
            
        }
    }
    
    func displayScoringCards()
    {
        
        let fontsize : CGFloat = FontSize.Smallest.scale
        
        let pointsGroups = GameSettings.sharedInstance.rules.cardScores.categorise {$0.1}
        
        self.orderedGroups = pointsGroups.sort { $0.0 > $1.0 }
        
        
        for (i,slide) in slides.enumerate()
        {
         slide.discardAll()
         if  i+suiteStart < orderedGroups.count
            {
                
            let group = orderedGroups[i+suiteStart]
            let cards = group.1.map { $0.0 }
            
            if cards.count > 0
              {
              let l = SKLabelNode(fontNamed:"Verdana")
              l.fontSize = fontsize
              l.horizontalAlignmentMode = .Left
              l.position = CGPointMake(size.width * 0.05, size.height * (0.83 - ( CGFloat(i) * CGFloat(separationOfSlides))))
              if cards.count > 1 { l.text = "\(group.0) Points Each" }
              else if group.0 > 0 { l.text = "\(group.0) Points" }
              else  { l.text = "\(group.0) Points (Total Points for Hand can not Fall Below Zero)" }
              l.name = "label"
              self.addChild(l)
 
              slide.replaceWithContentsOf(cards)
                
              continue
              }
            }
        slide.clear()
        }
    }
    
    func newPage()
    {
        var l = self.childNodeWithName("label")
        while l != nil
        {
            l!.removeFromParent()
            l = self.childNodeWithName("label")
        }
        
        
        self.schedule(delay: 0.3)
        {
          switch self.activeTab
             {
             case .DeckTab : self.displayCardsInDeck()
             case .ScoringTab : self.displayScoringCards()
             }
            let nextStart = self.suiteStart +  self.noOfSlides
            
            switch self.activeTab
            {
            case .DeckTab :  self.moreButton.alpha = nextStart >= GameSettings.sharedInstance.deck!.suitesInDeck.count ? 0.0 : 1.0
            case .ScoringTab : self.moreButton.alpha = nextStart >=  self.orderedGroups.count ? 0.0 : 1.0
            }

        }
        
        backButton.alpha = suiteStart == 0 ? 0.0 : 1.0
    }
    func buttonTouched(positionInScene:CGPoint) -> Bool
    {
        if let touchedNode : SKSpriteNode = self.nodeAtPoint(positionInScene) as? SKSpriteNode,
        nodeName =  touchedNode.name
        {
            switch nodeName
            {
            case "Deck" :
                
                if activeTab != .DeckTab
                {
                    self.suiteStart = 0
                    deckButton.texture = SKTexture(imageNamed: "Deck2")
                    scoreButton.texture = SKTexture(imageNamed: "Scores1")
                    activeTab = .DeckTab
                    newPage()
                }
                return true
            case "Score" :
                
                if activeTab != .ScoringTab
                {
                    self.suiteStart = 0
                    deckButton.texture = SKTexture(imageNamed: "Deck1")
                    scoreButton.texture = SKTexture(imageNamed: "Scores2")
                    activeTab = .ScoringTab
                    newPage()
                }
                return true
            case "More" :
                self.suiteStart += noOfSlides
                newPage()
                
                return true
            case "Back" :
                
                self.suiteStart -= noOfSlides
                
                if self.suiteStart < 0
                {
                    self.suiteStart = 0
                }
                newPage()
                
                return true
            default:
                return false
                
            }
        }
        
        return false
    }
    func storeDraggedNode(node:CardSprite)
    {
        draggedNode = node;
        originalScale = node.xScale
        originalOrder = node.zPosition
        node.setScale(CardSize.Huge.scale)
        
        originalOrder = node.zPosition
        
        node.zPosition = CardSize.Huge.zOrder
        
        
        let label = SKLabelNode(text:node.card.description)
       
        
        label.position = CGPoint(x: 0.0, y: node.size.height*0.35) /// CGPoint(x: 0.5*node.size.width, y: node.size.height*0.98)
        label.fontColor = UIColor.blackColor()
        label.fontName = "Verdana"
        label.fontSize = 11
        node.addChild(label)
    }
    func cardTouched(positionInScene:CGPoint) -> Bool
    {
       // let width = self.frame.size.width
    
        if let node = self.nodeAtPoint(positionInScene) as? CardSprite
        {
       
                storeDraggedNode(node)
                return true
            }
          
        return false
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in (touches )
        {
            let positionInScene = touch.locationInNode(self)
            
            if buttonTouched(positionInScene) { return }
            if cardTouched(positionInScene) { return }
        }
    }
    func restoreDraggedNode()
    {
        if let cardsprite = draggedNode
        {
            cardsprite.setScale(originalScale)
            cardsprite.zPosition = originalOrder
            cardsprite.removeAllChildren()
            draggedNode=nil
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in (touches )
        {
            let positionInScene = touch.locationInNode(self)
            
            if let node = self.nodeAtPoint(positionInScene) as? CardSprite
                where draggedNode?.name != node.name
            {
                restoreDraggedNode()
                storeDraggedNode(node)
                return
            }
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
       restoreDraggedNode()
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if let touches = touches {
            touchesEnded(touches, withEvent: event)
        }
    }

}
