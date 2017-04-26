//
//  SKLDSettingViewController.swift
//  SKLogDebuggerDemo
//
//  Created by yukithehero on 2017/04/20.
//  Copyright © 2017年 yukithehero. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

fileprivate enum Section: Int {
    case debug = 0
    case omitPattern = 1
    
    case count = 2
}

class SKLDSwitchCell: UITableViewCell {
    @IBOutlet weak var switchView: UISwitch!
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

class SKLDSettingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var omitPatterns = Variable<[String]>([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Log debugger 設定"
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop,
                                          target: self,
                                          action: #selector(onPushCloseButton(sender:)))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    func onPushCloseButton(sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension SKLDSettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count.rawValue
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int
        switch section {
        case Section.debug.rawValue:
            rows = 1
        case Section.omitPattern.rawValue:
            rows = omitPatterns.value.count
        default:
            rows = 0
        }
        return rows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SKLDSwitchCell") as! SKLDSwitchCell
        switch indexPath.section {
        case Section.debug.rawValue:
            cell.textLabel?.text = "デバッグモード"
            cell.switchView.isOn = SKLDDefaults.isDebugMode.getBool()
            cell.switchView.rx.isOn.subscribe(onNext: { isOn in
                SKLDDefaults.isDebugMode.set(isOn)
                if isOn {
                    SKLogDebugger.shared.showTrackView()
                } else {
                    SKLogDebugger.shared.hideTrackView()
                }
            }).addDisposableTo(cell.disposeBag)
        case Section.omitPattern.rawValue:
            let omitPattern = omitPatterns.value[indexPath.row]
            cell.textLabel?.text = "「\(omitPattern)」を表示"
            cell.switchView.isOn = SKLDDefaults.validOmitPatterns.getStrings().contains(omitPattern)
            cell.switchView.rx.isOn.subscribe(onNext: { isOn in
                var validOmitPatterns = SKLDDefaults.validOmitPatterns.getStrings()
                if isOn {
                    validOmitPatterns.append(omitPattern)
                } else {
                    validOmitPatterns = validOmitPatterns.filter({ $0 != omitPattern })
                }
                SKLDDefaults.validOmitPatterns.set(validOmitPatterns)
            }).addDisposableTo(cell.disposeBag)
        default:
            cell.textLabel?.text = nil
        }
        return cell
    }
}

