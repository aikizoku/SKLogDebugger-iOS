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
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a))
    }
}
