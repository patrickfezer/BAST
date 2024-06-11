//
//  BatteryManaverV2.swift
//  BAST
//
//  Created by Patrick Fezer on 05.11.22.
//
// Description: New Version of the BatteryManager used for iOS 16.0 and earlier

import Foundation
import SwiftUI

class BatteryMangerV2
{
    private let logger: TextLogger
    private let expertMode: Bool
    
    public enum keys: String
    {
        case capacity = "last_value_MaximumCapacityPercent"
        case cycleCount = "last_value_CycleCount"
        case NCC = "last_value_NominalChargeCapacity"
        case minNCC = "last_value_NCCMin"
        case maxNCC = "last_value_NCCMax"
    }
    
    
    public func getBatteryValues(file: Data) -> [keys : Int]
    {
        let allKeys: [keys] = [.capacity, .cycleCount, .NCC, .minNCC, .maxNCC]
        
        var ret = [keys : Int]()
        
        allKeys.forEach { key in
            ret[key] = batteryKey(key: key, item: file)
        }
        return ret
    }
    
    
    // Returns an Int appending to the enum's key
    public func batteryKey(key: keys, item: Data) -> Int
    {
        var ret = 0
        var indexCounter = 0
        let lengthKey = key.rawValue.count // length of the key
        let keyAsData = key.rawValue.data(using: .utf8)!
        
        // read file
        for i in 0..<item.count
        {

            // indexCounter handling
            item[i] == keyAsData[indexCounter] ? (indexCounter += 1) : (indexCounter = 0)

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
                ret == 0 ? logger.log("Value not found: \(key.rawValue)") : () // log value is result is 0
                
                break // break i loop
            }
        }
        
        // check if battery health is over 100% and return value
        return (key == keys.capacity && !expertMode && ret > 100) ? 100 : ret
    }
    
    // Create View for List Entry
    public func batteryKeyView(label: String, value: [keys:Int], key: keys) -> some View
    {
        
        let batteryValue = value[key] ?? 0
    
        // Convert Value to string
        var value: String
        {
            var ret = ""
            switch key
            {
            case .capacity:
                ret = String(batteryValue) + "%"
                break
            case .cycleCount:
                ret = String(batteryValue)
                break
            default:
                ret = String(batteryValue) + " mAh"
                break
            }
            
            // Value is unvalid if zero, cycle count exceptet.
            return (batteryValue == 0 && key != keys.cycleCount) ? "n/A" : ret
        }
        
        // Return View
        return HStack
        {
            Text(label)
            Spacer()
            Text(value)
        }
    }
    
    // Initializer
    init(_ logger: TextLogger)
    {
        self.logger = logger
        self.expertMode = UserDefaults.standard.bool(forKey: AppInformation.expertModeKey)
    }
}
