//
//  MenuViewController.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 5/28/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation
import UIKit

final class MenuViewController: UITableViewController {
    
    // MARK: - Properties
    
    let label = UILabel(frame: CGRect.null)
    private var records = RecordManager.shared.getRecords()
    
    var onReplayTapped: Optional<() -> Void>
    
    
    // MARK: - LifeCycle
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        setupFooter()
        tableView.backgroundColor = .clear
        view.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.separatorColor = .clear
    }
    
    
    // MARK: - Table DataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseId = "record_cell"
        let record = records.first!
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId)
            ?? UITableViewCell(style: .value1, reuseIdentifier: reuseId)
        cell.textLabel?.text = "Highest Score"  // record.name ?? "---"
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        cell.detailTextLabel?.text = clockDisplayText(seconds: record.score)
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        return cell
    }
    
    func clockDisplayText(seconds: Double) -> String {
        let numberOfMinutes = Int(trunc(seconds/60))
        let numberOfSeconds = Int(trunc(seconds - Double(numberOfMinutes * 60)))
        return String(format: "%02d:%02d", numberOfMinutes, numberOfSeconds)
    }
    
    @objc func replayTapped(_ sender: UIButton) {
        onReplayTapped?()
    }
}


// MARK: - Helpers

private extension MenuViewController {
    
    func setupHeader() {
        label.frame = CGRect(x: tableView.frame.minX, y: tableView.frame.minY,
                           width: tableView.frame.size.width, height: 88)
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        tableView.tableHeaderView = label
    }
    
    func setupFooter() {
        let button = UIButton(frame: UIScreen.main.bounds)
        let buttonImage = UIImage(named: "baseline_replay_black")
        button.setImage(buttonImage, for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(replayTapped(_:)), for: .touchUpInside)
        tableView.tableFooterView = button
    }
}
