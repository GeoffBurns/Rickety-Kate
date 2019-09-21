//
//  GameViewController.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 10/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import UIKit
import SpriteKit
//import iAd
import Cards


class GameViewController: UIViewController //, ADBannerViewDelegate
{

    //var adBannerView: ADBannerView = ADBannerView(frame: CGRect.zero)

    // iAds Depreciated
    /*
     
    func loadAds(){
  
        adBannerView.center = CGPoint(x: adBannerView.center.x, y: view.bounds.size.height - adBannerView.frame.size.height / 2)
        adBannerView.delegate = self
        adBannerView.isHidden = true
        

        view.addSubview(adBannerView)
        
        // set self.canDisplayBannerAds to true
        // or use ADBannerView and ADBannerViewDelegate
        // don't do both
        // self.canDisplayBannerAds = true
        
    }
   */

    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        // Detect the screensize
        let sizeRect = UIScreen.main.applicationFrame
        let scale = UIScreen.main.scale
        let width = sizeRect.size.width * scale
        let height = sizeRect.size.height * scale
        let size = CGSize(width: width, height: height)
        
        NotificationCenter.default .
            addObserver(self, selector:
                #selector(GameViewController.showAuthenticationViewController), name:
                NSNotification.Name(rawValue: PresentAuthenticationViewController), object: nil)
        
        GameKitHelper.sharedInstance.authenticateLocalPlayer()
        GameKitHelper.sharedInstance.gameView = self.view as? SKView
        Game.settings.isFoolATrump = false
        Game.settings.isAceHigh =  true
        Game.settings.noOfSuitesDefault = 5
        Game.settings.options = [
            Options.noOfSuites,
            Options.noOfCards,
            Options.noOfPlayers,
            Options.jokers,
            Options.trumps,
            Options.passCard,
            MoreOptions.winningScore,
            Options.speed,
            MoreOptions.ruleSet,
            MoreOptions.hooligan,
            MoreOptions.omnibus,
            Options.showTips,
            MoreOptions.allowBreaking,
            Options.useNumbers
        ]
        Options.speed.valueWasSetTo = Game.settings.cacheSpeed
        MoreOptions.ruleSet.valueWasSetTo = Game.settings.clearData
        Tip.setup()
        ScoreDisplay.scoreToString = {(name,wins,score) in
            if wins==0
            {
                return  "%@ score is %d".with.sayTo(name).using(score).localize
            }
            return "%@ Score %d n %d %@".with.sayTo(name).using(score).pluralizeUnit(wins, unit: "Win").localize
        }
     /*   ScoreDisplay.bottom =  DeviceSettings.isPortrait ? 0.12 :
            (DeviceSettings.isPhone
                ? (DeviceSettings.isPhoneX || DeviceSettings.isPhone55inch ? 0.25 : 0.19)
                : 0.22)
 
        ScoreDisplay._bottom  = { return DeviceSettings.isPortrait ? 0.115 :
            (DeviceSettings.isPhone
                ? 0.19 //(DeviceSettings.isPhoneX ? 0.19 : 0.19)
                : 0.23) }
        */
        ScoreDisplay._bottom  = {
            let isBig = DeviceSettings.isBigPro
            let bottom : CGFloat = DeviceSettings.isPortrait ? ( isBig ? 0.09 : 0.115) :
                (DeviceSettings.isPhone
                    ? (DeviceSettings.isPhoneX || DeviceSettings.isPhone55inch ? 0.235 : 0.19)
                    : ( isBig ? 0.16 : 0.23))
            return bottom
            
        }
    
        /* ScoreDisplay.bottom =  DeviceSettings.isPortrait ? 0.12 :
         (DeviceSettings.isPhone
         ? (DeviceSettings.isPhoneX || DeviceSettings.isPhone55inch ? 0.25 : 0.19)
         : 0.22) */
        // Scene should be shown in fullscreen mode
        let scene = RicketyKateGameScene(size: size)
        scene.tableSize = size

        // Configure the view.
        let skView = self.view as! SKView
            

        skView.showsFPS = false
        skView.showsNodeCount = false
            
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
            
        /* Set the scale mode to manually resize */
        scene.scaleMode = .resizeFill
        
        scene.table = RicketyKateCardTable.makeDemo(scene)
            
        skView.presentScene(scene)
        
        
        // iAds Depreciated
        //loadAds()
     
    }
    
    
    @objc func showAuthenticationViewController() {
        let gameKitHelper = GameKitHelper.sharedInstance
        
        if let authenticationViewController =
            gameKitHelper.authenticationViewController {
                
              self  .
                    present(authenticationViewController,
                        animated: true,
                        completion: nil)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
  
            return UIInterfaceOrientationMask.landscapeLeft

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        Game.settings.memoryWarning = true
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
   
    override  func viewWillTransition( to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator)
    
    {
     resize(
        //adBannerView,
        size: size);
  
    }


   func resize(
  //  _ banner: ADBannerView?,
    size:CGSize = UIScreen.main.applicationFrame.size) {
        
        let adHeight = CGFloat()
    
   /*    if let b = banner, b.isHidden == false
        {
            adHeight = b.frame.size.height
       }*/
    if let uiView = self.view,
        let skView = uiView as? SKView,
        let scene = skView.scene as? RicketyKateGameScene
    {
        scene.adHeight = adHeight
        scene.arrangeLayoutFor(size,bannerHeight: adHeight)
        return
    }
    let   skViews = self.view.subviews.filter { $0 is SKView }
    if let uiView = skViews.first,
        let skView = uiView as? SKView,
        let scene = skView.scene as? RicketyKateGameScene
        {
            scene.adHeight = adHeight
            
            scene.arrangeLayoutFor(size,bannerHeight: adHeight)
        }
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {

     //   resize(adBannerView);
    }
 //iAd
    /*
    func bannerViewWillLoadAd(_ banner: ADBannerView) {
         NSLog("banner will load");
    }
    
    func bannerViewDidLoadAd(_ banner: ADBannerView) {
       adBannerView.isHidden = false
       resize(banner);
         NSLog("banner loaded");
    }
    
    func bannerViewActionDidFinish(_ banner: ADBannerView) {
        
      //   resize(banner);
         NSLog("banner Action Did Finish");
    }
    
    func bannerViewActionShouldBegin(_ banner: ADBannerView, willLeaveApplication willLeave: Bool) -> Bool {
        
        return true 
    }
    
    func bannerView(_ banner: ADBannerView, didFailToReceiveAdWithError error: Error) {
       adBannerView.isHidden = true

        let status = banner.isBannerLoaded ? "error but banner loaded" :"banner unloaded"
        NSLog(status);
        
         resize(banner);
        
        if let oldError = error as NSError?
        {
         let errorString = oldError.debugDescription
         NSLog(errorString);
        }
 
}
 */
}
