//
//  Bundle+SKLD.swift
//  Pods
//
//  Created by yukithehero on 2017/04/26.
//
//

import Foundation
import UIKit

extension Bundle {
    
    static func skld() -> Bundle {
        return Bundle(for: SKLogDebugger.self)
    }
}
