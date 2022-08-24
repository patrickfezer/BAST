//
//  Extensions.swift
//  BAST
//
//  Created by Patrick Fezer on 23.08.22.
//

import Foundation

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
    
    // This function is used to create a simple supstring with stard and end index
    func substring(from startIndex: Int, to endIndex: Int) -> String
    {
        var ret = ""
        
        for i in startIndex...endIndex
        {
            ret += String(self[i])
        }
        
        return ret
    }
}
