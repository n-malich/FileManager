//
//  SizeTableViewCell.swift
//  FileManager
//
//  Created by Natali Malich
//

import UIKit

class SizeTableViewCell: UITableViewCell {
    
    private var sizeLabel: UILabel = {
        let label = UILabel()
        label.text = "Show photo size"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var sizeSwitch: UISwitch = {
        let size = UISwitch()
        let value = UserDefaults.standard.bool(forKey: "Show size") == true ||
        UserDefaults.standard.object(forKey: "Show size") == nil
        size.setOn(value, animated: false)
        size.addTarget(self, action: #selector(switchStateDidChange), for: .valueChanged)
        size.translatesAutoresizingMaskIntoConstraints = false
        return size
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
            UserDefaults.standard.set(true, forKey: "Show size")
            print("Показываю размер картинки")
        } else {
            UserDefaults.standard.set(false, forKey: "Show size")
            print("Размер картинки скрыт")
        }
    }
}

extension SizeTableViewCell {
    private func setupViews() {
        
        [sizeLabel, sizeSwitch].forEach {contentView.addSubview ($0)}
    }
}

extension SizeTableViewCell {
    private func setupConstraints() {
        [
            sizeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            sizeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            sizeLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4),
            sizeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            sizeSwitch.centerYAnchor.constraint(equalTo: sizeLabel.centerYAnchor),
            sizeSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ]
        .forEach {$0.isActive = true}
    }
}
