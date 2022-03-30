//
//  FileTableViewCell.swift
//  FileManager
//
//  Created by Natali Malich
//

import UIKit

class FileTableViewCell: UITableViewCell {
    
    var iconFile: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var nameFile: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var sizeFile:  UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
}

extension FileTableViewCell {
    private func setupViews() {
        
        [iconFile, nameFile, sizeFile].forEach {contentView.addSubview ($0)}
    }
}

extension FileTableViewCell {
    private func setupConstraints() {
        [
            iconFile.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            iconFile.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            iconFile.widthAnchor.constraint(equalToConstant: 25),
            iconFile.heightAnchor.constraint(equalToConstant: 25),
            iconFile.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            nameFile.leadingAnchor.constraint(equalTo: iconFile.trailingAnchor, constant: 10),
            nameFile.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 4/6),
            nameFile.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            sizeFile.leadingAnchor.constraint(equalTo: nameFile.trailingAnchor, constant: 10),
            sizeFile.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            sizeFile.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        .forEach {$0.isActive = true}
    }
}
