//
//  UIColor+SKLD.swift
//  Pods
//
//  Created by yukithehero on 2017/04/26.
//
//

import Foundation
import UIKit

extension UIColor {
    
    static func color(r: Int, g: Int, b: Int, a: Float) -> UIColor {
        return UIColor(colorLiteralRed: Float(r)/255.0, green: Float(g)/255.0, blue: Float(b)/255.0, alpha: a)
    }
}
