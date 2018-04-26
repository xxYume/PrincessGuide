//
//  IconImageView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Kingfisher

class IconImageView: UIImageView {

    var skillIconID: Int? {
        didSet {
            if let id = skillIconID {
                kf.setImage(with: URL.image.appendingPathComponent("/icon/skill/\(id).webp"))
            }
        }
    }
    
    var itemID: Int? {
        didSet {
            if let id = itemID {
                kf.setImage(with: URL.image.appendingPathComponent("/icon/item/\(id).webp"))
            }
        }
    }
    
    var equipmentID: Int? {
        didSet {
            if let id = equipmentID {
                kf.setImage(with: URL.image.appendingPathComponent("/icon/equipment/\(id).webp"))
            }
        }
    }
    
    var cardID: Int? {
        didSet {
            if let id = cardID {
                kf.setImage(with: URL.image.appendingPathComponent("/icon/unit/\(id + 10).webp"))
            }
        }
    }
    
    func showPlaceholder() {
        kf.setImage(with: URL.image.appendingPathComponent("/icon/unit/000000.webp"))
    }
}