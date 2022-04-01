//
//  SortTableViewCell.swift
//  FileManager
//
//  Created by Natali Malich
//

import UIKit

class SortTableViewCell: UITableViewCell {
    
    private var sortingLabel: UILabel = {
        let label = UILabel()
        label.text = "Show content ascending (A to Z)"
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var sortingSwitch: UISwitch = {
        let sorting = UISwitch()
        let value = UserDefaults.standard.bool(forKey: "A-Z") == true ||
        UserDefaults.standard.object(forKey: "A-Z") == nil
        sorting.setOn(value, animated: false)
        sorting.addTarget(self, action: #selector(switchStateDidChange), for: .valueChanged)
        sorting.translatesAutoresizingMaskIntoConstraints = false
        return sorting
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    @objc func switchStateDidChange(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "A-Z")
            print("Sorting on A-Z")
        } else {
            UserDefaults.standard.set(false, forKey: "A-Z")
            print("Sorting off A-Z")
        }
    }
}

extension SortTableViewCell {
    private func setupViews() {
        
        [sortingLabel, sortingSwitch].forEach {contentView.addSubview ($0)}
    }
}

extension SortTableViewCell {
    private func setupConstraints() {
        [
            sortingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            sortingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            sortingLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4),
            sortingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            sortingSwitch.centerYAnchor.constraint(equalTo: sortingLabel.centerYAnchor),
            sortingSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ]
        .forEach {$0.isActive = true}
    }
}
