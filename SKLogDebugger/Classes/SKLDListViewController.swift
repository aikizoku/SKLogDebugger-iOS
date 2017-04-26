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
        
        navigationItem.title = "Log List"
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop,
                                          target: self,
                                          action: #selector(onPushCloseButton(sender:)))
        navigationItem.rightBarButtonItem = closeButton
        
        searchBar.text = SKLDDefaults.filterText.getString()
        searchBar.rx.searchButtonClicked.subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.searchBar.resignFirstResponder()
        }).addDisposableTo(disposeBag)
        
        tableView.register(UINib(nibName: kSKLDListCellName, bundle: Bundle.skld()), forCellReuseIdentifier: kSKLDListCellName)
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        Observable.combineLatest(
            searchBar.rx.text,
            SKLogDebugger.shared.logs.asObservable(),
            SKLogDebugger.shared.validOmitActions.asObservable()
            ).subscribe(onNext: { [weak self] (filterText, logs, validOmitActions) in
                guard let `self` = self else { return }
                var showLogs: [SKLDLog] = logs
                if let filterText = self.searchBar.text {
                    SKLDDefaults.filterText.set(filterText)
                    if filterText.characters.count > 0 {
                        showLogs = showLogs.filter({ $0.index.contains(filterText) })
                    }
                }
                if validOmitActions.count > 0 {
                    showLogs = showLogs.filter({ !validOmitActions.contains($0.action) })
                }
                self.logs = showLogs
                self.tableView.reloadData()
            }).addDisposableTo(disposeBag)
    }
    
    func onPushCloseButton(sender: UIBarButtonItem) {
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
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}
