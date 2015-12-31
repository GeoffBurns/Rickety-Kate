//
//  GameKitHelper.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 20/12/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import GameKit
import Foundation

let singleton = GameKitHelper()
let PresentAuthenticationViewController =
"PresentAuthenticationViewController"


protocol GameKitHelperDelegate {
    func matchStarted()
    func matchEnded()
    func matchReceivedData(match: GKMatch, data: NSData,
        fromPlayer player: String)
}


public class GameKitHelper: NSObject, GKGameCenterControllerDelegate, GKTurnBasedMatchmakerViewControllerDelegate {
    var authenticationViewController: UIViewController?
    var lastError: NSError?
    var gameCenterEnabled: Bool
    var delegate: GameKitHelperDelegate?
    var multiplayerMatch: GKMatch?
    var presentingViewController: UIViewController?
    var multiplayerMatchStarted: Bool

    
    
    var onDismiss : () -> () = {}
    
    class var sharedInstance: GameKitHelper {
        return singleton
    }
    
    override init() {
        gameCenterEnabled = true
        multiplayerMatchStarted = false
        super.init()
    }
    
    
    var displayName : String
        {
        let localPlayer = GKLocalPlayer.localPlayer()
    
            
        return localPlayer.alias ?? "You".localize
        }
    
    var gameCenterName : String?
        {
            let localPlayer = GKLocalPlayer.localPlayer()
            
            return localPlayer.alias
    }
    func authenticateLocalPlayer () {
        
        //1
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController, error) in
            
            
            //2
            self.lastError = error
            
            if viewController != nil {
                //3
                self.authenticationViewController = viewController
                
                NSNotificationCenter.defaultCenter().postNotificationName(
                    PresentAuthenticationViewController,
                    object: self)
            } else if localPlayer.authenticated {
                //4
                self.gameCenterEnabled = true
            } else {
                //5
                self.gameCenterEnabled = false
            }
        }
    }
    func findMatch(minPlayers: Int, maxPlayers: Int,
        presentingViewController viewController: UIViewController,
        delegate: GameKitHelperDelegate) {
            
            //1
            if !gameCenterEnabled {
                print("Local player is not authenticated")
                return
            }
            
            //2
            multiplayerMatchStarted = false
            multiplayerMatch = nil
            self.delegate = delegate
            presentingViewController = viewController
            
            
            //3
            let matchRequest = GKMatchRequest()
            matchRequest.minPlayers = minPlayers
            matchRequest.maxPlayers = maxPlayers
            
            //4
            let matchMakerViewController =
            GKTurnBasedMatchmakerViewController(matchRequest: matchRequest)
            
            matchMakerViewController.turnBasedMatchmakerDelegate = self
           
            matchMakerViewController.showExistingMatches = true;
            
            presentingViewController? .
                presentViewController(matchMakerViewController,
                    animated: false, completion: nil)
                
        
    }
    
   /// GKTurnBasedMatchmakerViewControllerDelegate functions START
        
        // The user has cancelled
        public func turnBasedMatchmakerViewControllerWasCancelled(viewController: GKTurnBasedMatchmakerViewController)
        {
             presentingViewController? .dismissViewControllerAnimated(true, completion: nil)
              print("Matchmaker cancelled")
        }
        
        // Matchmaking has failed with an error
        public func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController, didFailWithError error: NSError)
        {
             presentingViewController? .dismissViewControllerAnimated(true, completion: nil)
            print("Error finding match: %@", error.localizedDescription)
        }
    
    /*
        // Deprecated
        @available(iOS, introduced=5.0, deprecated=9.0, message="use GKTurnBasedEventListener player:receivedTurnEventForMatch:didBecomeActive:")
        optional public func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController, didFindMatch match: GKTurnBasedMatch)
    {
    }
        
        // Deprectated
        @available(iOS, introduced=5.0, deprecated=9.0, message="use GKTurnBasedEventListener player:wantsToQuitMatch:")
        optional public func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController, playerQuitForMatch match: GKTurnBasedMatch)
    {
    }

    */
    
    /// GKTurnBasedMatchmakerViewControllerDelegate functions END
    
    
    func reportAchievement(achievement: Achievement)
      {
        reportAchievements([achievement])
    }
    func reportAchievements(achievements: [Achievement]) {
  
        let gkAchievements : [GKAchievement] = achievements.map {
            ricketyKateAchievement in
            let gkAchievement = GKAchievement(identifier: ricketyKateAchievement.rawValue)
            gkAchievement.percentComplete = 100
            gkAchievement.showsCompletionBanner = true
            
            return gkAchievement as GKAchievement
        }
   
        
        if !gameCenterEnabled {
            print("Local player is not authenticated")
            return
        }
        GKAchievement.reportAchievements(gkAchievements) {(error) in
            self.lastError = error
        }
    }
    func reportScore(score: Int64,
        forLeaderBoard leaderBoard: LearderBoard) {
            
            if !gameCenterEnabled {
                print("Local player is not authenticated")
                return
            }
            
            //1
            let scoreReporter =
            GKScore(leaderboardIdentifier: leaderBoard.rawValue)
            scoreReporter.value = score
            scoreReporter.context = 0
            
            let scores = [scoreReporter]
            
            //2
            GKScore.reportScores(scores) {(error) in
                self.lastError = error
            }
    }
    func showGKGameCenterViewController(viewController: UIViewController!, onDismiss : () -> ()) {
        
        
        self.onDismiss = onDismiss
        
        if !gameCenterEnabled {
            print("Local player is not authenticated")
            return
        }
        
        //1
        let gameCenterViewController = GKGameCenterViewController()
        
        //2
        gameCenterViewController.gameCenterDelegate = self
        
        //3
        gameCenterViewController.viewState = .Achievements
        
        //4
        viewController .
            presentViewController(gameCenterViewController,
                animated: true, completion: nil)
    }
    
    public func gameCenterViewControllerDidFinish(gameCenterViewController:
        GKGameCenterViewController) {
            
            self.onDismiss()
            gameCenterViewController .
                dismissViewControllerAnimated(true, completion: nil)
    }
   
}
