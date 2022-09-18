//
//  BASTApp.swift
//  BAST
//
//  Created by Patrick Fezer on 23.08.22.
//

import SwiftUI

@main
struct BASTApp: App {
    
    // Logger
    @StateObject private var logger = TextLogger()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .navigationViewStyle(StackNavigationViewStyle())
                .environmentObject(logger)
        }
    }
}
