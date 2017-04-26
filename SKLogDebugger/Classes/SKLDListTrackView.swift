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
        Bundle(for: SKLDListTrackView.self).loadNibNamed("SKLDListTrackView", owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor, constant: 0.0).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0).isActive = true
        clipsToBounds = true
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        tableView.register(UINib(nibName: kSKLDListCellName, bundle: Bundle(for: SKLDListCell.self)), forCellReuseIdentifier: kSKLDListCellName)
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        SKLogDebugger.shared.logs.asObservable().subscribe(onNext: { [weak self] logs in
            guard let `self` = self else { return }
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
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
        return SKLogDebugger.shared.logs.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kSKLDListCellName, for: indexPath) as! SKLDListCell
        cell.set(themeColor: .black, log: SKLogDebugger.shared.logs.value[indexPath.row], filter: nil)
        return cell
    }
}
