//
//  CardCollectionViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class CardCollectionViewCell: UICollectionViewCell {
    
    var isEnable = true {
        didSet {
            if isEnable {
                foregroundView.alpha = 0
            } else {
                foregroundView.alpha = 0.55
            }
        }
    }
    
    let icon = IconImageView()
    
    let foregroundView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.backgroundColor = theme.color.tableViewCell.background
            themeable.foregroundView.backgroundColor = theme.color.foregroundColor
        }
        
        contentView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(foregroundView)
        foregroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        foregroundView.alpha = 0
        foregroundView.isUserInteractionEnabled = false
    }
    
    func configure(for card: Card, isEnable: Bool) {
        icon.cardID = card.iconID()
        self.isEnable = isEnable
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
