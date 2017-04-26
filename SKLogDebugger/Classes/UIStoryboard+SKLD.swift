//
//  UIStoryboard+SKLD.swift
//  Pods
//
//  Created by yukithehero on 2017/04/26.
//
//

import Foundation
import UIKit

extension UIStoryboard {
    
    static func instantiate(_ identifier: String) -> UIViewController {
        let path = Bundle(for: SKLogDebugger.self).path(forResource: "SKLogDebugger", ofType: "bundle")!
        let sb = UIStoryboard(name: "SKLD", bundle: Bundle(path: path))
        return sb.instantiateViewController(withIdentifier: identifier)
    }
}
