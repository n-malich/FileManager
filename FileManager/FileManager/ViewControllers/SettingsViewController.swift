//
//  SettingsViewController.swift
//  FileManager
//
//  Created by Natali Malich
//

import UIKit

class SettingsViewController: UIViewController {
    
    var delegate: SettingsViewControllerDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemGray6
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
        self.setupViews()
        self.setupConstraints()
        
        self.tableView.register(SortTableViewCell.self, forCellReuseIdentifier: "sortCellID")
        self.tableView.register(SizeTableViewCell.self, forCellReuseIdentifier: "sizeCellID")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

extension SettingsViewController {
    private func setupViews() {
        view.addSubview(tableView)
    }
}

extension SettingsViewController {
    private func setupConstraints() {
        [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
            .forEach {$0.isActive = true}
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell: SortTableViewCell = tableView.dequeueReusableCell(withIdentifier: "sortCellID", for: indexPath) as! SortTableViewCell
            cell.selectionStyle = .none
            return cell
        case (0, 1):
            let cell: SizeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "sizeCellID", for: indexPath) as! SizeTableViewCell
            cell.selectionStyle = .none
            return cell
        case (1, 0):
            let cell = UITableViewCell(frame: .zero)
            var content = cell.defaultContentConfiguration()
            content.text = "Change password"
            content.textProperties.font = .systemFont(ofSize: 16)
            content.textProperties.color = .systemBlue
            content.textProperties.alignment = .center
            cell.contentConfiguration = content
            cell.selectionStyle = .none
            return cell
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            UserDefaults.standard.removeObject(forKey: "Password")
            UserDefaults.standard.set(true, forKey: "ChangePass")
            LoginInspector.shared.removePassword()
            
            self.delegate?.navigateToLoginVC()
        }
    }
}
