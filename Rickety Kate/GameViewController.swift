//
//  GameViewController.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 10/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import UIKit
import SpriteKit
import iAd

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController , ADBannerViewDelegate {

    var adBannerView: ADBannerView = ADBannerView(frame: CGRect.zeroRect)
    
    func loadAds(){
        adBannerView.center = CGPoint(x: adBannerView.center.x, y: view.bounds.size.height - adBannerView.frame.size.height / 2)
        adBannerView.delegate = self
        adBannerView.hidden = true
        view.addSubview(adBannerView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
     
       if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene
       {
            // Configure the view.
            let skView = self.view as! SKView
            
     //     let scene  =  GameScene(size:skView.bounds.size)
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
     //   scene.scaleMode = .AspectFit
            scene.table = CardTable.sharedDemoInstance
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
    //    if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.LandscapeLeft.rawValue)
     //   } else {
      //      return Int(UIInterfaceOrientationMask.All.rawValue)
      //  }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //iAd
    

    func bannerViewWillLoadAd(banner: ADBannerView!) {
        
        
        println("sort of working1")
        
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        
        
        self.adBannerView.alpha = 1.0
        adBannerView.hidden = false
        println("sort of working2")
        
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        
        
        println("sort of working3")
        
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        
        
        
        println("sort of working4")
        return true 
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        
        
    
}
}
