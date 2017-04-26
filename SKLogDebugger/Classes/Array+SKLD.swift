//
//  Array+SKLD.swift
//  SKLogDebuggerDemo
//
//  Created by yukithehero on 2017/04/25.
//  Copyright © 2017年 yukithehero. All rights reserved.
//

import Foundation

extension Array {
    
    var lastIndex: Int {
        get {
            return count == 0 ? 0 : count - 1
        }
    }

    func each(e closure: (_ element: Element) -> Void) {
        for element in self {
            closure(element)
        }
    }
    
    func each(ie closure: (_ i: Int, _ element: Element) -> Void) {
        let c = count
        for i in 0 ..< c {
            closure(i, self[i])
        }
    }
    
    func each(fle closure: (_ first: Bool, _ last: Bool, _ element: Element) -> Void) {
        let c = count
        let li = lastIndex
        for i in 0 ..< c {
            let first = i == 0
            let last = i == li
            closure(first, last, self[i])
        }
    }
    
    func unique() -> Array {
        return NSOrderedSet(array: self).array as! Array<Element>
    }
}
