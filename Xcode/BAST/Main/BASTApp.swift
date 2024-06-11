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
    @StateObject private var fileManager = FileManager()

    var body: some Scene {
        WindowGroup {
            ContentView(fileManager: fileManager)
                .navigationViewStyle(StackNavigationViewStyle())
                .environmentObject(logger)
                .onOpenURL { url in
                    handleFile(url: url)
                }
        }
    }
    
    
    func handleFile(url: URL) {
        print("Received URL: \(url)")
        print("Path: \(url.path)")

        Task {            
            // Check file access
            let canAccess = url.startAccessingSecurityScopedResource()
            guard canAccess else {
                print("Can't access file: \(url.path)")
                return
            }

            defer {
                url.stopAccessingSecurityScopedResource()
            }

            do {
                // load content
                let data = try Data(contentsOf: url)

                // set file manager
                await MainActor.run {
                    self.fileManager.file = data
                    print("File loaded successfully, size: \(data.count) bytes")
                }
            } catch {
                // reset file manager
                await MainActor.run {
                    self.fileManager.file = Data() // Reset on failure
                    print("Error loading file: \(error.localizedDescription)")
                }
            }
        }
    }
}
