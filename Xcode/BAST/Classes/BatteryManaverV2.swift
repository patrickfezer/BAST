//
//  BatteryManaverV2.swift
//  BAST
//
//  Created by Patrick Fezer on 05.11.22.
//
// New Version used for iOS 16

import Foundation
import SwiftUI

class BatteryMangerV2
{
    private let logger: TextLogger
    
    public enum keys: String
    {
        case capacity = "last_value_MaximumCapacityPercent"
        case cycleCount = "last_value_CycleCount"
        case nominalCapacity = "last_value_NominalChargeCapacity"
        case minFCC = "last_value_MinimumFCC"
        case maxFCC = "last_value_MaximumFCC"
    }
    
    private func batteryKey(key: keys, item: Data) -> Int
    {
        var ret = 0
        var indexCounter = 0
        let lengthKey = key.rawValue.count // length of the key
        let keyAsData = key.rawValue.data(using: .utf8)!
        
        // read file
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

                // calculate start index
                for p in i..<item.count
                {
                    if item[p] == 58 // 58 = : as ASCII
                    {
                        startIndex = p + 1 // set startIndex
                        break // break p loop
                    }
                }

                // calculate end index
                for z in startIndex..<item.count
                {
                    // break z loop
                    if item[z] == 44 // 44 = , as ASCII
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

                // log value if 0
                if ret == 0
                {
                    logger.log("Value not found: \(key.rawValue) = \(ret)")
                }
                break // break i loop
            }
        }
        // return Value
        return ret
    }
    
    
    // Create Text View
    public func batteryKeyAsText(data: Data, label: String, key: keys) -> some View
    {
        let batteryKey = batteryKey(key: key, item: data)
        
        // Convert Value to string
        var value: String
        {
            var ret = ""
            switch key
            {
            case .capacity:
                ret = String(batteryKey) + "%"
                break
            case .cycleCount:
                ret = String(batteryKey)
                break
            default:
                ret = String(batteryKey) + " mAh"
                break
            }
            
            return ret
        }
        
        // Return View
        return HStack
        {
            Text(label)
            Spacer()
            Text(value)
        }
    }
    
    // Initializer+
    init(_ logger: TextLogger)
    {
        self.logger = logger
    }
}
