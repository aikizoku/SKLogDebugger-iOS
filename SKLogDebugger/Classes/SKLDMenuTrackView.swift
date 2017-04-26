//
//  SKLDMenuTrackView.swift
//  SKLogDebuggerDemo
//
//  Created by yukithehero on 2017/04/20.
//  Copyright © 2017年 yukithehero. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SKLDMenuTrackView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var liveButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    
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
        Bundle(for: SKLDMenuTrackView.self).loadNibNamed("SKLDMenuTrackView", owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor, constant: 0.0).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0).isActive = true
        clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
