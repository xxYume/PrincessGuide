//
//  CDPropertyViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class CDPropertyViewController: CDTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleSettingsChange(_:)), name: .cardDetailSettingsDidChange, object: nil)
    }
    
    @objc private func handleSettingsChange(_ notification: Notification) {
        reloadAll()
    }
    
    override func prepareRows(for card: Card) {
        
        rows.removeAll()
        let settings = CDSettingsViewController.Setting.default
    
        let property: Property
        let combatEffectiveness: Int
        
        if settings.statusComparison {
            let fromProperty = card.property(unitLevel: settings.unitLevel, unitRank: settings.rankFrom, bondRank: settings.bondRank, unitRarity: settings.unitRarity, addsEx: settings.addsEx)
            let toProperty = card.property(unitLevel: settings.unitLevel, unitRank: settings.rankTo, bondRank: settings.bondRank, unitRarity: settings.unitRarity, addsEx: settings.addsEx)
            property = toProperty - fromProperty
            
            let fromCombatEffectiveness = card.combatEffectiveness(unitLevel: settings.unitLevel, unitRank: settings.rankFrom, bondRank: settings.bondRank, unitRarity: settings.unitRarity, skillLevel: settings.skillLevel)
            let toCombatEffectiveness = card.combatEffectiveness(unitLevel: settings.unitLevel, unitRank: settings.rankTo, bondRank: settings.bondRank, unitRarity: settings.unitRarity, skillLevel: settings.skillLevel)
            combatEffectiveness = toCombatEffectiveness - fromCombatEffectiveness
        } else {
            property = card.property(unitLevel: settings.unitLevel, unitRank: settings.unitRank, bondRank: settings.bondRank, unitRarity: settings.unitRarity, addsEx: settings.addsEx)
            combatEffectiveness = card.combatEffectiveness(unitLevel: settings.unitLevel, unitRank: settings.unitRank, bondRank: settings.bondRank, unitRarity: settings.unitRarity, skillLevel: settings.skillLevel)
        }
        
        let unitLevel = settings.unitLevel
        let targetLevel = settings.targetLevel
        
        rows += [
            Row(type: CDProfileTextTableViewCell.self, data: .text(NSLocalizedString("Combat Effectiveness", comment: ""), String(combatEffectiveness), settings.statusComparison)),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                property.item(for: .atk),
                property.item(for: .magicStr)
                ], unitLevel, targetLevel, settings.statusComparison)),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                property.item(for: .def),
                property.item(for: .magicDef)
                ], unitLevel, targetLevel, settings.statusComparison)),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                property.item(for: .hp),
                property.item(for: .physicalCritical)
                ], unitLevel, targetLevel, settings.statusComparison)),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                property.item(for: .dodge),
                property.item(for: .magicCritical)
                ], unitLevel, targetLevel, settings.statusComparison)),
            Row(type: CDProfileTextTableViewCell.self, data: .textArray(
                [
                    (NSLocalizedString("Swing Time", comment: ""), String(card.base.normalAtkCastTime) + "s", false),
                    (NSLocalizedString("Attack Range", comment: ""), String(card.base.searchAreaWidth), false)
                ]
            )),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([property.item(for: .accuracy)], unitLevel, targetLevel, settings.statusComparison)),
            Row(type: CDProfileTextTableViewCell.self, data: .text(NSLocalizedString("Effective Physical HP", comment: ""), String(Int(property.effectivePhysicalHP.rounded())), settings.statusComparison)),
            Row(type: CDProfileTextTableViewCell.self, data: .text(NSLocalizedString("Effective Magical HP", comment: ""), String(Int(property.effectiveMagicalHP.rounded())), settings.statusComparison)),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                property.item(for: .waveHpRecovery)
                ], unitLevel, targetLevel, settings.statusComparison)),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                property.item(for: .waveEnergyRecovery)
                ], unitLevel, targetLevel, settings.statusComparison)),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                property.item(for: .lifeSteal)
                ], unitLevel, targetLevel, settings.statusComparison)),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                property.item(for: .hpRecoveryRate)
                ], unitLevel, targetLevel, settings.statusComparison)),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                property.item(for: .energyRecoveryRate)
                ], unitLevel, targetLevel, settings.statusComparison)),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                property.item(for: .energyReduceRate)
                ], unitLevel, targetLevel, settings.statusComparison))
        ]
        
    }

}
