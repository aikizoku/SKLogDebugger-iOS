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
    case omitAction = 1
    
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

    let omitActionsObserver = PublishSubject<[String]>()
    var omitActions: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "ログデバッガーの設定"
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop,
                                          target: self,
                                          action: #selector(onPushCloseButton(sender:)))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc func onPushCloseButton(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        SKLogDebugger.shared.showTrackView()
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
        case Section.omitAction.rawValue:
            rows = omitActions.count
        default:
            rows = 0
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Section.omitAction.rawValue:
            return "非表示にしたいログ"
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SKLDSwitchCell") as! SKLDSwitchCell
        switch indexPath.section {
        case Section.debug.rawValue:
            cell.textLabel?.text = "ログデバッグを有効にする"
            cell.switchView.isOn = SKLDDefaults.isDebugMode.getBool()
            cell.switchView.rx.isOn.subscribe(onNext: { isOn in
                SKLDDefaults.isDebugMode.set(isOn)
            }).disposed(by: cell.disposeBag)
        case Section.omitAction.rawValue:
            let omitAction = omitActions[indexPath.row]
            cell.textLabel?.text = omitAction
            cell.switchView.isOn = SKLDDefaults.validOmitActions.getStrings().contains(omitAction)
            cell.switchView.rx.isOn.subscribe(onNext: { isOn in
                var validOmitActions = SKLDDefaults.validOmitActions.getStrings()
                if isOn {
                    validOmitActions.append(omitAction)
                } else {
                    validOmitActions = validOmitActions.filter({ $0 != omitAction })
                }
                SKLDDefaults.validOmitActions.set(validOmitActions)
                SKLogDebugger.shared.validOmitActions = validOmitActions
                SKLogDebugger.shared.logsObserver.onNext((logs: [], omitActions: validOmitActions))
            }).disposed(by: cell.disposeBag)
        default:
            cell.textLabel?.text = nil
        }
        return cell
    }
}

