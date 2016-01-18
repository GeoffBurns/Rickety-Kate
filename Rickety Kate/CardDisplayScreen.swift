//
//  CardDisplayScreen.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 2/10/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

enum CardDisplayTab : Int
{
    case Rules
    case Deck
    case Scores
}

typealias ScorePairCollection = [(PlayingCard,Int)]

// Help Screen
class CardDisplayScreen: MultiPagePopup, HasDiscardArea{
    
    var discardPile = CardPile(name: CardPileType.Discard.description)
    var discardWhitePile = CardPile(name: CardPileType.Discard.description)
    
    var isSetup = false
    var slides = [CardSlide]()
    var orderedGroups : [(Int,ScorePairCollection)] {
        
        let pointsGroups = GameSettings.sharedInstance.rules.cardScores.categorise {$0.1}
        return pointsGroups.sort { $0.0 > $1.0 }
    }
    
    var tabNewPage = [ rules, displayCardsInDeck, displayScoringCards ]
    var cards = [PlayingCard]()
    var oldPositon = CGPointZero
    var noOfSlides =  2
    var separationOfSlides = 0.4
    var slideStart  =  CGFloat(0.7)
    var slideLabelStart  =  CGFloat(0.83)
    var draggedNode : CardSprite? = nil
    var originalTouch = CGPointZero
    var originalScale = CGFloat(0)
    var originalOrder = CGFloat(0)
    var layoutSize = CGSizeZero
    
    override func onEnter() {

    }
    
    override func onExit() {
        super.onExit()
    }
    
    func rules()
    {
    if let ruleScreen = parent as? MultiPagePopup
        {
        ruleScreen.pageNo = self.pageNo
        ruleScreen.tabNo = 0
        }
    removeFromParent()
    }
    
    override func exit()
    {
        if let ruleScreen = parent as? MultiPagePopup
        {
            removeFromParent()
            ruleScreen.removeFromParent()
        }
       
    }
     func presetup(scene:SKNode)
    {
        pageNo = 0
        tabNo = -1
        cards = GameSettings.sharedInstance.deck!.orderedDeck
        
        if !isSetup
        {
            self.gameScene = scene
            self.tabNames = ["Rules","Deck","Scores"]
            setupDiscardArea()
            discardPile.isUp = true
            discardPile.speed = GameSettings.sharedInstance.tossDuration*0.5
            color = UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9)
            size = scene.frame.size
            position = CGPointZero
            anchorPoint = CGPointZero
            userInteractionEnabled = true
            isSetup = true
        }
    }
    
    override func setup(scene:SKNode)
    {
        size = scene.frame.size
        var layoutSize = size
        pageNo = 0
        tabNo = -1
        cards = GameSettings.sharedInstance.deck!.orderedDeck
        
        if !isSetup
          {
          self.gameScene = scene
          self.tabNames = ["Rules","Deck","Scores"]
          setupDiscardArea()
          discardPile.isUp = true
          discardPile.speed = GameSettings.sharedInstance.tossDuration*0.5
          color = UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9)
          size = scene.frame.size
          position = CGPointZero
          anchorPoint = CGPointZero
          userInteractionEnabled = true
   
           isSetup = true
          }
        if let resize = scene as? Resizable
        {
            self.adHeight = resize.adHeight
            layoutSize = CGSizeMake(size.width, size.height - self.adHeight)
        }
        arrangeLayoutFor(layoutSize,bannerHeight: adHeight)
    }
    func displayTitle()
    {
        let fontsize : CGFloat = FontSize.Small.scale
        let title = SKLabelNode(fontNamed:"Verdana")
        title.fontSize = fontsize
        title.position = CGPointMake(size.width * 0.50, size.height * 0.92 )
        title.text = "Card Rankings".localize
        self.addChild(title)
 
    }
    
    func displayPage()
    {
       displayTitle()
       displayButtons()
    }
    
    override func arrangeLayoutFor(size:CGSize,bannerHeight:CGFloat)
    {
        layoutSize = size
        switch DeviceSettings.layout
        {
            case .Phone :
                    noOfSlides =   2
                    separationOfSlides =   0.4
                    slideStart =  0.7
                    slideLabelStart =  0.83
            case .Pad :
                  noOfSlides =   3
                  separationOfSlides =   0.25
                  slideStart =  0.72
                  slideLabelStart =  0.83
            case .Portrait :
                  noOfSlides =   4
                  separationOfSlides =   0.2
                  slideStart = 0.78
                  slideLabelStart =  0.865
        }

        super.arrangeLayoutFor(size,bannerHeight: bannerHeight)
        if pageNo > noPageFor(tabNo) - 1
        {
            pageNo = noPageFor(tabNo) - 1
        }
        clearLabels()
        switch tabNo
        {
        case CardDisplayTab.Deck.rawValue:
            displaySlideLabels(size,bannerHeight: bannerHeight)
        case CardDisplayTab.Scores.rawValue:
            displayScoringCardsLabels(size,bannerHeight: bannerHeight)
        default: break
        }

        createSlides(size,bannerHeight: bannerHeight)
        displayPage()
        newPage()
    }
    func createSlides(size:CGSize,bannerHeight:CGFloat)
    {
        for slide in slides { slide.discardAll() }
        slides = []
        for i in 0..<noOfSlides
        {
            let slide = CardSlide(name: "slide")
            slide.setup(self, slideWidth: size.width * 0.9)
            slide.position = CGPointMake(size.width * 0.10, bannerHeight + size.height * (slideStart - ( CGFloat(i) * CGFloat(separationOfSlides))))
            slides.append(slide)
        }
    }
    override func noPageFor(tab:Int) -> Int
    {
        switch tab
        {
        case 0 :
            if let ruleScreen = parent as? MultiPagePopup
            {
                return ruleScreen.noPageFor(0)
            }
             return 1
        case 1 :
           return GameSettings.sharedInstance.deck!.suitesInDeck.numOfPagesOf(noOfSlides)
        case 2 :
           return self.orderedGroups.numOfPagesOf(noOfSlides)
         
        default :
            return 1
        }
    }
    
    func displaySlideLabels(size:CGSize,bannerHeight:CGFloat)
    {
        let fontsize : CGFloat = FontSize.Smallest.scale
        for (i,(_, _)) in Zip2Sequence(
            self.slides,
            cardsInSuitesDisplayed).enumerate() {
                
                let l = SKLabelNode(fontNamed:"Verdana")
                l.fontSize = fontsize
                l.position = CGPointMake(size.width * 0.10, bannerHeight + size.height * (self.slideLabelStart - ( CGFloat(i) * CGFloat(self.separationOfSlides))))
                l.text = "High Cards".localize
                l.name = "label"
                //   l.userData = ["SlideNo":i]
                
                let m = SKLabelNode(fontNamed:"Verdana")
                m.fontSize = fontsize
                m.position = CGPointMake(size.width * 0.93, bannerHeight + size.height * (self.slideLabelStart - ( CGFloat(i) * CGFloat(self.separationOfSlides))))
                m.text = "Low Cards".localize
                m.name = "label"
                //   l.userData = ["SlideNo":i]
                
                self.addChild(l)
                self.addChild(m)
        }
    }
    
    var cardsInSuitesDisplayed : [[PlayingCard]]
    {
            return GameSettings.sharedInstance.deck!
                .suitesInDeck
                .from(self.noOfSlides*self.pageNo, forLength: self.noOfSlides)
                .map { suite in  self.cards.filter { $0.suite == suite} }
                .filter { cards in cards.count > 0 }
    }
    func refillSlides()
    {
        for (slide, cards) in Zip2Sequence(
            self.slides,
            cardsInSuitesDisplayed)
        {
            slide.replaceWithContentsOf(cards)
            slide.rearrange()
        }
    }


    func displayCardsInDeck()
    {
        for slide in slides { slide.discardAll() }
        self.clearLabels()
        self.schedule(delay: GameSettings.sharedInstance.tossDuration*0.3)
            {
                self.refillSlides()
                self.displaySlideLabels(self.layoutSize,bannerHeight: self.adHeight)
            }
    }
    
    func clearLabels()
    {
        
        let labels = self
            .children
            .filter { $0 is SKLabelNode }
            .map { $0 as! SKLabelNode }
        
        for label in labels
        {
            label.removeFromParent()
        }
        /*
        var l = self.childNodeWithName("label")
        while l != nil
        {
            l!.removeFromParent()
            l = self.childNodeWithName("label")
        }*/
    }
    var scoringCardsByScoreDisplayed : [(Int,[PlayingCard])]
    {
            return orderedGroups
                .from(self.noOfSlides*self.pageNo, forLength: self.noOfSlides)
                .map { group in  (group.0, group.1.map { $0.0 }) }
                .filter { (_,cards) in cards.count > 0 }
    }
    
    func displayScoringCardsLabels(size:CGSize,bannerHeight:CGFloat)
    {
        let fontsize : CGFloat = FontSize.Smallest.scale
        for (i,(_, (points, _))) in Zip2Sequence(
            self.slides,
            scoringCardsByScoreDisplayed)
            .enumerate() {
                let l = SKLabelNode(fontNamed:"Verdana")
                l.fontSize = fontsize
                l.horizontalAlignmentMode = .Left
                l.position = CGPointMake(size.width * 0.05, bannerHeight + size.height * (self.slideLabelStart - ( CGFloat(i) * CGFloat(separationOfSlides))))
                if cards.count > 1 { l.text = "_ Points Each".localizeWith(points) }
                else if points > 0 { l.text = "_ Points".localizeWith(points) }
                else  { l.text = "_ Points".localizeWith(points) +
                    " (" + "Total Points for Hand can not Fall Below Zero".localize + ")" }
                l.name = "label"
                self.addChild(l)
        }
    }
    func refillScoringCards()
    {
        for (slide, (_, cards)) in Zip2Sequence(
            self.slides,
            scoringCardsByScoreDisplayed)
        {
            slide.replaceWithContentsOf(cards)
        }
        
    }
    func displayScoringCards()
    {
        for slide in slides {
            slide.discardAll()
            slide.clear() }
        
        refillScoringCards()
        displayScoringCardsLabels(self.layoutSize,bannerHeight: self.adHeight)
    }
    
    override func newPage()
    {
        if self.tabNo < 0 { return }

        clearLabels()
        let renderPage = self.tabNewPage[self.tabNo](self)
        self.schedule(delay: 0.3)
        {
            renderPage()
        }
    }
    

    func storeDraggedNode(node:CardSprite)
    {
        draggedNode = node;
        originalScale = node.xScale
        originalOrder = node.zPosition
        node.setScale(CardSize.Huge.scale)
        
        originalOrder = node.zPosition
        
        node.zPosition = CardSize.Huge.zOrder
        
        node.addLabel()
 
    }
    override func cardTouched(positionInScene:CGPoint) -> Bool
    {
       // let width = self.frame.size.width
    
        if let node = self.nodeAtPoint(positionInScene) as? CardSprite
            {
                storeDraggedNode(node)
                return true
            }
          
        return false
    }

    func restoreDraggedNode()
    {
        if let cardsprite = draggedNode
        {
            cardsprite.setScale(originalScale)
            cardsprite.zPosition = originalOrder
   
            cardsprite.removeLabel()
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
       super.touchesEnded(touches, withEvent: event)
       restoreDraggedNode()
    }

}
