//
//  AppDelegate.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 10/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.


import SwiftUI

@main
struct Rickety_Kate: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


struct ContentView: View {
  
    var body: some View {
        
        GameViewControllerWrapper()
            .ignoresSafeArea()
      //  SpriteView(scene: scene)
    }
}

