//
//  SKLDListTrackView.swift
//  SKLogDebuggerDemo
//
//  Created by yukithehero on 2017/04/20.
//  Copyright © 2017年 yukithehero. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SKLDListTrackView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var logs: [SKLDLog] = []
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    func initViews() {
        Bundle.skld().loadNibNamed("SKLDListTrackView", owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor, constant: 0.0).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0).isActive = true
        clipsToBounds = true
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        tableView.register(UINib(nibName: kSKLDListCellName, bundle: Bundle.skld()), forCellReuseIdentifier: kSKLDListCellName)
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        Observable.combineLatest(
            SKLogDebugger.shared.logs.asObservable(),
            SKLogDebugger.shared.validOmitActions.asObservable()
            ).subscribe(onNext: { [weak self] (logs, validOmitActions) in
                guard let `self` = self else { return }
                var showLogs: [SKLDLog] = logs
                if validOmitActions.count > 0 {
                    showLogs = showLogs.filter({ !validOmitActions.contains($0.action) })
                }
                self.logs = showLogs
                // self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                self.tableView.reloadData()
            }).addDisposableTo(disposeBag)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension SKLDListTrackView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kSKLDListCellName, for: indexPath) as! SKLDListCell
        cell.set(themeColor: .black, log: logs[indexPath.row], filter: nil)
        return cell
    }
}
