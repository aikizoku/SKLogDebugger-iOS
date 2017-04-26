//
//  SKLDDefaults.swift
//  SKLogDebuggerDemo
//
//  Created by yukithehero on 2017/04/20.
//  Copyright © 2017年 yukithehero. All rights reserved.
//

import Foundation

enum SKLDDefaults: String {
    case
    isDebugMode,
    isShowRealtimeTrackView,
    validOmitActions,
    filterText
}

extension SKLDDefaults {
    
    func getStrings() -> [String] {
        return UserDefaults.standard.array(forKey: key()) as? [String] ?? []
    }
    
    func getString() -> String {
        return UserDefaults.standard.string(forKey: key()) ?? ""
    }
    
    func getInt() -> Int {
        return UserDefaults.standard.integer(forKey: key())
    }
    
    func getBool() -> Bool {
        return UserDefaults.standard.bool(forKey: key())
    }
}

extension SKLDDefaults {
    
    func set(_ value: [String]) {
        setValue(value)
    }
    
    func set(_ value: String) {
        setValue(value)
    }
    
    func set(_ value: Int) {
        setValue(value)
    }
    
    func set(_ value: Bool) {
        setValue(value)
    }
}

extension SKLDDefaults {
    
    fileprivate func setValue(_ value: Any?) {
        let d = UserDefaults.standard
        d.setValue(value, forKey: key())
        d.synchronize()
    }
    
    fileprivate func key() -> String {
        return "sk_log_debugger::\(rawValue)"
    }
}
