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
    @IBOutlet weak var realtimeButton: UIButton!
    @IBOutlet weak var logListButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
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
        Bundle.skld().loadNibNamed("SKLDMenuTrackView", owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor, constant: 0.0).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0).isActive = true
        clipsToBounds = true
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
