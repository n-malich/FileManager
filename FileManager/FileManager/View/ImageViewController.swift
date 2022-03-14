//
//  ImageViewController.swift
//  FileManager
//
//  Created by Natali Malich
//

import UIKit

class ImageViewController: UIViewController {
        
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(imageView: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.imageView.image = imageView
//        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.setupViews()
        self.setupConstraints()
    }
}

extension ImageViewController {
    private func setupViews() {
        view.addSubview(imageView)
    }
}

extension ImageViewController {
    private func setupConstraints() {
        [
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
            .forEach {$0.isActive = true}
    }
}
