//
//  Bundle+SKLD.swift
//  Pods
//
//  Created by yukithehero on 2017/04/27.
//
//

import Foundation

extension Bundle {
    static func skld() -> Bundle {
        return Bundle(path: Bundle(for: SKLogDebugger.self).path(forResource: "SKLogDebugger", ofType: "bundle")!)!
    }
}
