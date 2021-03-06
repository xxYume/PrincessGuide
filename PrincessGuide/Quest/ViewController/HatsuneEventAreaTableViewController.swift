//
//  HatsuneEventAreaTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/17.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class HatsuneEventAreaTableViewController: UITableViewController, DataChecking {
    
    private var areas = [HatsuneEventArea]()
    
    let refresher = RefreshHeader()
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = backgroundImageView
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            let navigationBar = themeable.navigationController?.navigationBar
            navigationBar?.tintColor = theme.color.tint
            navigationBar?.barStyle = theme.barStyle
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.refresher.arrowImage.tintColor = theme.color.indicator
            themeable.refresher.loadingView.color = theme.color.indicator
            themeable.tableView.indicatorStyle = theme.indicatorStyle
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateEnd(_:)), name: .preloadEnd, object: nil)
        
        tableView.mj_header = refresher
        refresher.refreshingBlock = { [weak self] in self?.check() }
        
        tableView.keyboardDismissMode = .onDrag
        tableView.register(HatsuneEventTableViewCell.self, forCellReuseIdentifier: HatsuneEventTableViewCell.description())
        tableView.rowHeight = 84
        tableView.tableFooterView = UIView()
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        loadData()
    }
    
    @objc private func handleUpdateEnd(_ notification: NSNotification) {
        loadData()
    }
    
    private func loadData() {
        LoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Master.shared.getHatsuneEventAreas { (areas) in
                // preload
                DispatchQueue.global(qos: .userInitiated).async {
                    areas.forEach { _ = $0.wave?.enemies.first?.enemy }
                    DispatchQueue.main.async {
                        LoadingHUDManager.default.hide()
                        self?.areas = areas.sorted { ($0.base.startTime, $0.base.areaId, $0.base.difficulty) > ($1.base.startTime, $1.base.areaId, $1.base.difficulty) }
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HatsuneEventTableViewCell.description(), for: indexPath) as! HatsuneEventTableViewCell
        let area = areas[indexPath.row]
        cell.configure(for: "\(area.base.questName)", subtitle: area.base.title, unitID: area.wave?.enemies.first?.enemy?.unit.prefabId)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let area = areas[indexPath.row]
        if let enemy = area.wave?.enemies.first?.enemy {
            let vc = EDTabViewController(enemy: enemy)
            vc.hidesBottomBarWhenPushed = true
            vc.navigationItem.title = enemy.unit.unitName
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
