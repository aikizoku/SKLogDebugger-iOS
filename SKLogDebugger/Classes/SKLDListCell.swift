//
//  SKLDListCell.swift
//  SKLogDebuggerDemo
//
//  Created by yukithehero on 2017/04/20.
//  Copyright © 2017年 yukithehero. All rights reserved.
//

import Foundation
import UIKit
import SwiftyAttributes

let kSKLDListCellName = "SKLDListCell"

enum SKLDThemeColor {
    case black
    case white
}

class SKLDListCell: UITableViewCell {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initViews()
    }
    
    fileprivate func initViews() {
    }
    
    func set(themeColor: SKLDThemeColor, log: SKLDLog, filter: String?) {
        var textColor: UIColor
        switch themeColor {
        case .black:
            headerView.backgroundColor = UIColor.color(r: 0, g: 0, b: 0, a: 0.3)
            textColor = UIColor.white
        case .white:
            headerView.backgroundColor = UIColor.color(r: 0, g: 0, b: 0, a: 0.1)
            textColor = UIColor.black
        }
        if let filter = filter {
            var actionText = NSAttributedString()
            let actions = log.action.components(separatedBy: filter)
            actions.each(fle: { (first, last, action) in
                actionText = actionText + action.withTextColor(textColor)
                if !last {
                    actionText = actionText + filter.withTextColor(textColor).withBackgroundColor(UIColor.color(r: 0, g: 0, b: 0, a: 0.3))
                }
            })
            actionLabel.attributedText = actionText
            
            var dataText = NSAttributedString()
            let datas = log.rawString.components(separatedBy: filter)
            datas.each(fle: { (first, last, data) in
                dataText = dataText + data.withTextColor(textColor)
                if !last {
                    dataText = dataText + filter.withTextColor(textColor).withBackgroundColor(UIColor.color(r: 0, g: 0, b: 0, a: 0.3))
                }
            })
            dataLabel.attributedText = dataText
        } else {
            actionLabel.attributedText = log.action.withTextColor(textColor)
            dataLabel.attributedText = log.rawString.withTextColor(textColor)
        }
        createdAtLabel.attributedText = log.createdAt.withTextColor(textColor)
    }
}
