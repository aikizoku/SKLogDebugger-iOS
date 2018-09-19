//
//  SKLDListViewController.swift
//  SKLogDebuggerDemo
//
//  Created by yukithehero on 2017/04/20.
//  Copyright © 2017年 yukithehero. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SKLDListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var logs: [SKLDLog] = []
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "ログリスト"
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop,
                                          target: self,
                                          action: #selector(onPushCloseButton(sender:)))
        navigationItem.rightBarButtonItem = closeButton
        
        searchBar.text = SKLDDefaults.filterText.getString()
        searchBar.rx.searchButtonClicked.subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.searchBar.resignFirstResponder()
        }).disposed(by: disposeBag)
        
        tableView.register(UINib(nibName: kSKLDListCellName, bundle: Bundle.skld()), forCellReuseIdentifier: kSKLDListCellName)
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        SKLogDebugger.shared.logsObserver.subscribe(onNext: { [weak self] (logs, omitActions) in
            guard let `self` = self else { return }
            var showLogs: [SKLDLog] = logs
            if let filterText = self.searchBar.text {
                SKLDDefaults.filterText.set(filterText)
                if filterText.count > 0 {
                    showLogs = showLogs.filter({ $0.index.contains(filterText) })
                }
            }
            if omitActions.count > 0 {
                showLogs = showLogs.filter({ !omitActions.contains($0.action) })
            }
            self.logs = showLogs
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        searchBar.rx.text.subscribe(onNext: { text in
            SKLogDebugger.shared.logsObserver.onNext((logs: SKLogDebugger.shared.logs, omitActions: SKLogDebugger.shared.validOmitActions))
        }).disposed(by: disposeBag)
    }
    
    @objc func onPushCloseButton(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        SKLogDebugger.shared.showTrackView()
    }
}

extension SKLDListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kSKLDListCellName, for: indexPath) as! SKLDListCell
        cell.set(themeColor: .white, log: logs[indexPath.row], filter: searchBar.text)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let log = logs[indexPath.row]
        let alert = UIAlertController(title: log.action, message: "ログをコピーしました", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { alert in
            UIPasteboard.general.string = "action = \(log.action)\ndata =\n\(log.rawString)"
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}
