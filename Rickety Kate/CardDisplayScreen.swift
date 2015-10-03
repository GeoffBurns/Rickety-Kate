//
//  CardDisplayScreen.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 2/10/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

// Help Screen
class CardDisplayScreen: Popup {
    

    var isSetup = false
    var slides = [CardSlide]()
    
    var discard = CardSlide(name: "slide")
    lazy var deck = PlayingCard.BuiltCardDeck()
    var moreButton = SKSpriteNode(imageNamed: "More1")
    var backButton = SKSpriteNode(imageNamed: "Back")
    var suiteStart = 0
    var cards = [PlayingCard]()
    var oldPositon = CGPointZero
    
    override func onEnter() {

    }
    override func onExit() {
        super.onExit()
   
    }
    override func setup(scene:SKNode)
    {
        let numOfSlides = GameSettings.isPad ? 3 : 2
        
        let separationOfSlides = GameSettings.isPad ? 0.25 : 0.5
        
        if !isSetup
        {
        self.gameScene = scene
        color = UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9)
        size = scene.frame.size
        position = CGPointZero
        anchorPoint = CGPointZero
        userInteractionEnabled = true
        cards = deck.orderedDeck
   

        for i in 0..<numOfSlides
        {
            let slide = CardSlide(name: "slide")
            slide.setup(self, slideWidth: size.width * 0.9)
            slide.position = CGPointMake(size.width * 0.10, size.height * (0.5 - ( CGFloat(i) * CGFloat(separationOfSlides))))
            slides.append(slide)
        }
        discard.setup(self, slideWidth: size.width * 0.9)

        }
        isSetup = true
        for (i,slide) in slides.enumerate()
        {
                slide.position = CGPointMake(size.width * 0.10, size.height * (0.5 - ( CGFloat(i) * CGFloat(separationOfSlides))))
        }
        discard.position = CGPointMake(size.width * 0.10, size.height * -0.5 )
        for card in cards {
            let cs = CardSprite.create(card, player: nil, scene: self)
            cs.anchorPoint = CGPointMake(0.5,05)
        }
        suiteStart = 0
       displayPage()
        
    }
    
    func displayPage()
    {
        let title = SKLabelNode(fontNamed:"Verdana")
        title.fontSize = 30
        title.position = CGPointMake(size.width * 0.50, size.height * 0.92 )
        title.text = "Card Rankings"
        self.addChild(title)
        displayCards()
        
        moreButton.setScale(0.5)
        moreButton.anchorPoint = CGPoint(x: 2.0, y: 0.0)
        moreButton.position = CGPoint(x:self.frame.size.width,y:0.0)
        
        moreButton.name = "More"
        
        moreButton.zPosition = 300
        moreButton.userInteractionEnabled = false
        
        self.addChild(moreButton)
        
        backButton.setScale(0.5)
        backButton.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        backButton.position = CGPoint(x:0.0,y:0.0)
        
        backButton.name = "Back"
        
        backButton.zPosition = 300
        backButton.userInteractionEnabled = false
        backButton.alpha = 0.0
        self.addChild(backButton)
    }
    func displayCards()
    {
       
        let separationOfSlides = GameSettings.isPad ? 0.25 : 0.5
        
        
       
        for (i,slide) in slides.enumerate()
        {
            if  i+suiteStart < deck.suitesInDeck.count
            {
            let suite = cards.filter { $0.suite == deck.suitesInDeck[i+suiteStart]}
            
            if suite.count > 0
            {
            let l = SKLabelNode(fontNamed:"Verdana")
            l.fontSize = 20
            l.position = CGPointMake(size.width * 0.10, size.height * (0.83 - ( CGFloat(i) * CGFloat(separationOfSlides))))
            l.text = "High Cards"
            l.name = "label"
            
            let m = SKLabelNode(fontNamed:"Verdana")
            m.fontSize = 20
            m.position = CGPointMake(size.width * 0.93, size.height * (0.83 - ( CGFloat(i) * CGFloat(separationOfSlides))))
            m.text = "Low Cards"
            
            m.name = "label"
            
            self.addChild(l)
            self.addChild(m)
            
            discard.replaceWithContentsOf(slide.cards)
            slide.replaceWithContentsOf(suite)
            slide.update()
            }
                continue
            }
           
            discard.replaceWithContentsOf(slide.cards)
            slide.clear()
            slide.update()
           
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
        
        displayCards()
        
        let nextStart = suiteStart +  (GameSettings.isPad ? 3 : 2)
        
        moreButton.alpha = nextStart >= PlayingCard.Suite.None.rawValue
            ? 0.0 : 1.0
        backButton.alpha = suiteStart == 0
            ? 0.0 : 1.0
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in (touches )
        {
            let touchPoint = touch.locationInNode(self)
            if let touchedNode : SKSpriteNode = self.nodeAtPoint(touchPoint) as? SKSpriteNode
                
            {
                switch  touchedNode.name!
                {
                case "More" :
                    self.suiteStart += GameSettings.isPad ? 3 : 2
                    newPage()
                  
                case "Back" :
            
                    self.suiteStart -= GameSettings.isPad ? 3 : 2
                
                    if self.suiteStart < 0
                    {
                      self.suiteStart = 0
                    }
                    newPage()
                default:
                    continue
               
                }
            }
        }
    }
}
