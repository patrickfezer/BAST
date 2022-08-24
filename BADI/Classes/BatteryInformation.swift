//
//  BatteryInformation.swift
//  BAST
//
//  Created by Patrick Fezer on 23.08.22.
//

import Foundation

class BatteryInformation
{
    public enum keys: String
    {
        case maxFCC = "BatteryMaxFCC"
        case minFCC = "BatteryMinFCC"
        case nominalChargeCapacity = "NominalChargeCapacity"
        case designCapacity = "design_capacity"
        case cycleCount = "cycle_count"
    }


    public func batteryKey(item: String, key: keys) -> Int
    {
        var ret = 0 // return value
        let offset = String("</key><integer>").count
        let lengthKey = key.rawValue.count // length of the key
        var indexCounter = 0 // will be increased at character match

        for i in 0..<item.count
        {
            // indexCounter handling
            if item[i] == key.rawValue[indexCounter]
            {
                indexCounter += 1 // increase indexCounter
            } else
            {
                indexCounter = 0 // reset indexCoounter
            }

            // Match
            if indexCounter == lengthKey
            {
                let startIndex = i + offset + 1 // start index for substring
                var endIndex = startIndex // set endIndex to startIndex

                // calculate endIndex
                for z in startIndex..<item.count
                {
                    // Increase endIndex if current and next char is an valid integer
                    if Int(String(item[z])) != nil && Int(String(item[z + 1])) != nil
                    {
                        endIndex += 1
                    } else
                    {
                        break // break z loop
                    }
                }
                ret = Int(item.substring(from: startIndex, to: endIndex)) ?? 0 // create substring as int
                break // break i loop
            }
        }
        
        // Return result
        return ret
    }
}
