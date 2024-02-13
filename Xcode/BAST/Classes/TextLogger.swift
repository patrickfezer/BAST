//
//  TextLogger.swift
//  BAST
//
//  Created by Patrick Fezer on 13.09.22.
//

import Foundation
import SwiftUI

class TextLogger: ObservableObject
{
    private var logLimit = 1000 // Limit of the log entries
    private var saveKey = "saveKeyTextLogger" // Save key for UserDefaults
    private var logs: [String] // array of logs as string
    
    // Save logs to UserDefaults
    private func save()
    {
        UserDefaults.standard.set(logs, forKey: saveKey)
        print("Saved Logfile")
    }
    
    // Write a string to logs
    public func log(_ entry: String)
    {
        
        // add current date to entry
        let logEntry = "\(Date.now): \(entry)"
        
        // append to array
        logs.append(logEntry)
        
        // delete old entries
        while logs.count > logLimit
        {
            logs.remove(at: 0)
        }
        
        // save logs
        save()
        
        print(entry)
    }
    
    public func clearLogfile()
    {
        logs.removeAll()
        save()
    }
    
    public func printAllEntries()
    {
        logs.forEach { entry in
            print(entry)
        }
    }
    
    public func convertToString() -> String
    {
        var ret = String()
        
        logs.forEach { entry in
            ret += entry + "\n"
        }

        return ret
    }
    
    // Initializer
    public init()
    {
        // Read stored values from UserDefauts
        logs = UserDefaults.standard.array(forKey: saveKey) as? [String] ?? [""]
        print("Logger initialized")
    }
}
