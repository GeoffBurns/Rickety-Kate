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


class GameViewController: UIViewController , ADBannerViewDelegate {

    var adBannerView: ADBannerView = ADBannerView(frame: CGRect.zero)
    
    func loadAds(){
        adBannerView.center = CGPoint(x: adBannerView.center.x, y: view.bounds.size.height - adBannerView.frame.size.height / 2)
        adBannerView.delegate = self
        adBannerView.hidden = true
        self.canDisplayBannerAds = true
        view.addSubview(adBannerView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        // Detect the screensize
        let sizeRect = UIScreen.mainScreen().applicationFrame
        var width = sizeRect.size.width * UIScreen.mainScreen().scale
        var height = sizeRect.size.height * UIScreen.mainScreen().scale
        
        if width < height  // not needed on simulator but needed on real device
        {
            let temp = height
            height = width
            width = temp
        }
        // Scene should be shown in fullscreen mode
        let scene = RicketyKateGameScene(size: CGSizeMake(width, height))
    

        // Configure the view.
        let skView = self.view as! SKView
            

        skView.showsFPS = false
        skView.showsNodeCount = false
            
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
            
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
     
        scene.table = RicketyKateCardTable.makeDemo(scene)
            
        skView.presentScene(scene)
      // loadAds()
     
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
  
            return UIInterfaceOrientationMask.LandscapeLeft

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
        

        
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        
        
     //   self.adBannerView.alpha = 1.0
     //   adBannerView.hidden = false

        
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        
        

        
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        
        
        
  
        return true 
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        
        
    
}
}
