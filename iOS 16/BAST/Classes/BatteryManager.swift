//
//  BatteryManager.swift
//  BAST
//
//  Created by Patrick Fezer on 23.08.22.
//

import Foundation
import SwiftUI

class BatteryManager
{
    public enum keys: String
    {
        case maxFCC = "BatteryMaxFCC"
        case minFCC = "BatteryMinFCC"
        case nominalChargeCapacity = "NominalChargeCapacity"
        case designCapacity = "design_capacity"
        case cycleCount = "cycle_count"
    }


    private func batteryKey(item: Data, key: keys) -> Int
    {
        var ret = 0 // return value
        let offset = "</key><integer>".data(using: .utf8)!.count
        var indexCounter = 0 // will be increased at character match
        let lengthKey = key.rawValue.count // length of the key
        let keyAsData = key.rawValue.data(using: .utf8)!
        
        
        
        for i in 0..<item.count
        {

            // indexCounter handling
            if item[i] == keyAsData[indexCounter]
            {
                indexCounter += 1 // increase indexCounter
            } else
            {
                indexCounter = 0 // reset indexCoounter
            }

            // Match
            if indexCounter == lengthKey
            {
                var startIndex = 0
                var endIndex = 0
                
                for p in (i+offset)..<item.count
                {
                    if item[p] == 62 // 62 = > as ASCII
                    {
                        startIndex = p + 1 // set startIndex
                        break // break p loop
                    }
                }
                
                // calculate endIndex
                for z in startIndex..<item.count
                {
                    // break z loop
                    if item[z] == 60 // 60 = < as ASCII
                    {
                        break
                    } else
                    {
                        endIndex = z + 1 // set endIndex
                    }
                }
                
                let range = startIndex..<endIndex // set range for subdata
                let data = item.subdata(in: range) // create subdata
                let DataAsString = String(decoding: data, as: UTF8.self) // convert to String
                ret = Int(DataAsString) ?? 0 // convert to Int
                break // break i loop
            }
        }

        // Return result
        return ret
    }
    
    // Create Text View
    public func batteryKeyAsText(data: Data, label: String, key1: keys, key2: keys?) -> some View
    {
        
        // Unit for capactiy
        var unit: String
        {
            var ret = ""
            
            if key1 != .cycleCount
            {
                ret = " mAh"
            }
            
            return ret
        }
        
        if key2 != nil
        {
            return HStack
            {
                Text(label)
                Spacer()
                Text(calculatePercentage(in1: batteryKey(item: data, key: key1), in2: batteryKey(item: data, key: key2!))+"%")
            }
            
        } else
        {
            return HStack
            {
                Text(label)
                Spacer()
                Text(String(batteryKey(item: data, key: key1)) + unit)
            }
        }
        
    }
    
    
    // Calculate normalised percentage
    private func calculatePercentage(in1: Int, in2: Int) -> String
    {
        var result = Double(in1)/Double(in2) * 100
        
        if result.isNaN
        {
            // Set result to 0 if no value is set
            result = 0
            return String(format: "%.0f", (result))
        } else
        {
            // return result as String with to digits
            return String(format: "%.2f", (result))
        }
    }
}
