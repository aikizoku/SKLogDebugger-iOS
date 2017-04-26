//
//  ViewController.swift
//  SKLogDebugger
//
//  Created by yuki@thehero.jp on 04/26/2017.
//  Copyright (c) 2017 yuki@thehero.jp. All rights reserved.
//

import UIKit
import SKLogDebugger

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        SKLogDebugger.shared.setOmitActions(["action_omit_1", "action_omit_2"])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ログデバッガの設定画面を開きます
    @IBAction func onPushOpenSetting(_ sender: UIButton) {
        SKLogDebugger.shared.openSettingView()
    }
    
    // ログを追加する
    @IBAction func onPushAddLog1(_ sender: UIButton) {
        SKLogDebugger.shared.addLog(
            action: "action_1",
            data: [:]
        )
    }
    
    // ログを追加する
    @IBAction func onPushAddLog2(_ sender: UIButton) {
        SKLogDebugger.shared.addLog(
            action: "action_2",
            data: ["data1": 123,
                   "data2": "aaa",
                   "data3": true]
        )
    }
    
    // ログを追加する
    @IBAction func onPushAddLog3(_ sender: UIButton) {
        SKLogDebugger.shared.addLog(
            action: "action_3",
            data: ["data1": [1, 2, 3, "a", "b", "c"],
                   "data2": ["data21": -123,
                             "data22": "bbb",
                             "data23": false],
                   "data3": ["data31": ["data311": "321"]]]
        )
    }
    
    // ログ（除外対象）を追加する
    @IBAction func onPushAddOmitLog1(_ sender: UIButton) {
        SKLogDebugger.shared.addLog(
            action: "action_omit_1",
            data: [:]
        )
    }
    
    // ログ（除外対象）を追加する
    @IBAction func onPushAddOmitLog2(_ sender: UIButton) {
        SKLogDebugger.shared.addLog(
            action: "action_omit_2",
            data: ["data1": 123,
                   "data2": "aaa",
                   "data3": true]
        )
    }

}

