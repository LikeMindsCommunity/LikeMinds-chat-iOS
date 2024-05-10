//
//  Array+Extension.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 01/05/24.
//

import Foundation

extension Array where Element: Equatable {
    func unique() -> [Element] {
        var arr = [Element]()
        self.forEach {
            if !arr.contains($0) {
                arr.append($0)
            }
        }
        return arr
    }
    
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        
        return arrayOrdered
    }
}
