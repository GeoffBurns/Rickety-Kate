//
//  Popup.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 24/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

public extension CGPoint {

    public func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    

    public func lengthSquared() -> CGFloat {
        return x*x + y*y
    }
}
    public func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }



// Popup screen for user input
class Popup: SKSpriteNode {
    
    weak var gameScene : SKNode? = nil
    weak var button :  PopupButton? = nil
    var startTouchPosition = CGPointZero

    

    func setup(gameScene : SKNode)
    {
        self.gameScene = gameScene
 
    }
    
    init()
    {
        super.init(texture: nil, color: UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9), size:  CGSize(width: 1, height: 1))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func onEnter()
    {
        
    }
    
    func onExit()
    {
        self.removeAllChildren()
    }
    
}

class MultiPagePopup : Popup {
    var moreButton = SKSpriteNode(imageNamed: "More1".symbol)
    var backButton = SKSpriteNode(imageNamed: "Back".symbol)
    var exitButton = SKSpriteNode(imageNamed: "Exit".symbol)
    
    var tabButtons : [SKSpriteNode] = []
    var tabNo = 0 { didSet { updateTab()   }}
    var pageNo = 0
    var tabNames : [String] = []
    
    func updateTab()
    {
        let tabButton = tabButtons[self.tabNo]
        
        let textureName = (tabButton.name! + "2").symbol
        tabButton.texture = SKTexture(imageNamed: textureName)
        let otherTabs = tabButtons
            .filter { $0.name  != tabButton.name }
        
        for otherTab in otherTabs
        {
            otherTab.texture = SKTexture(imageNamed: (otherTab.name! + "1").symbol)
        }
    }
    
    func displayButtons()
    {
        moreButton.setScale(ButtonSize.Small.scale)
        moreButton.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        moreButton.position = CGPoint(x:self.size.width,y:0.0)
        
        moreButton.name = "More"
        
        moreButton.zPosition = 100
        moreButton.userInteractionEnabled = false
        
        moreButton.addSafelyTo(self)
        
        backButton.setScale(ButtonSize.Small.scale)
        backButton.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        backButton.position = CGPoint(x:0.0,y:0.0)
        backButton.name = "Back"
        backButton.zPosition = 100
        backButton.userInteractionEnabled = false
        
        backButton.addSafelyTo(self)
        
        exitButton.setScale(ButtonSize.Small.scale)
        exitButton.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        exitButton.position = CGPoint(x:self.frame.size.width,y:self.size.height)
        
        exitButton.name = "Exit"
        
        exitButton.zPosition = 100
        exitButton.userInteractionEnabled = false
        
       
        exitButton.addSafelyTo(self)
        
        
        if tabButtons.count == 0
        {
        for (i,tabName) in tabNames.enumerate()
        {
            let imageName = tabName + (i == tabNo ? "2" : "1")
            let tabButton = SKSpriteNode(imageNamed: imageName.symbol)
            tabButton.setScale(ButtonSize.Small.scale)
            tabButton.anchorPoint = CGPoint(x: CGFloat(-i), y: 1.0)
            tabButton.position = CGPoint(x:0.0,y:self.frame.size.height)
            
            tabButton.name = tabName
            
            tabButton.zPosition = 300
            tabButton.userInteractionEnabled = false
            
            tabButtons.append(tabButton)
            self.addChild(tabButton)
        }
        }
    }
    
    // overriden in derived class
    func newPage()
    {
    }
    func exit()
    {
        removeFromParent()
    }
    // overriden in derived class
    func noPageFor(tab:Int) -> Int
    {
        return 1
    }
    func nextPage()
    {
        self.pageNo++
     
       if self.pageNo >= noPageFor(self.tabNo)
        {
            if  tabNames.count == 0
            {
                self.pageNo = 0
            }
            else
            {
            self.pageNo = 0
            self.tabNo = self.tabNo+1 >= tabNames.count ? 0 : self.tabNo+1
            }
        }
        newPage()
    }
    func prevPage()
    {
        self.pageNo--
        
        if self.pageNo < 0
        {
            
            if  tabNames.count > 0
            {
            self.tabNo = self.tabNo <= 0 ?  tabNames.count-1 : self.tabNo-1
            self.pageNo = noPageFor(self.tabNo) - 1
            }
            else
            {
                self.pageNo = noPageFor(0) - 1
            }
        }
        newPage()
    }
    func buttonTouched(positionInScene:CGPoint) -> Bool
    {
        if let touchedNode : SKSpriteNode = self.nodeAtPoint(positionInScene) as? SKSpriteNode,
            nodeName =  touchedNode.name
        {
            
            let buttons = tabButtons
                .enumerate()
                .filter { (i,tabButton) in return i != self.tabNo && tabButton.name == nodeName }
            
            for (i,_) in buttons
            {
                self.pageNo = 0
                self.tabNo = i
                newPage()
                return true
                
                
            }
            switch nodeName
            {
            case "More" :
                nextPage()
                return true
            case "Back" :
                prevPage()
                return true
            case "Exit" :
                exit()
                return true
            default:
                return false
                
            }
        }
        
        return false
    }
    
    func cardTouched(positionInScene:CGPoint) -> Bool
    {
        return false
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        
        if let t = touches.first
        {
            startTouchPosition = t.locationInNode(self)
        }
        for touch in (touches )
        {
            let positionInScene = touch.locationInNode(self)
            
            if buttonTouched(positionInScene) { return }
            if cardTouched(positionInScene) { return }
        }
    }


    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let t = touches.first
        {
          let  endTouchPosition = t.locationInNode(self)
          let  displacement = endTouchPosition - startTouchPosition
          if displacement.lengthSquared() > 4000 && 2*fabs(displacement.x) < fabs(displacement.y)
          {
            if displacement.y < 0
            {
                nextPage()
            }
            else
            {
                prevPage()
            }
          }
        }
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if let touches = touches {
            touchesEnded(touches, withEvent: event)
        }
    }
}