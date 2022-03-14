//
//  DetailsFileViewController.swift
//  FileManager
//
//  Created by Natali Malich
//

import UIKit
import PhotosUI

class DetailsFileViewController: UIViewController {
    
    weak var imageView: UIImageView!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .systemGray6
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let cellID: String
    
    init (cellID: String) {
        self.cellID = cellID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
        self.tableView.register(FileTableViewCell.self, forCellReuseIdentifier: cellID)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.setupViews()
        self.setupConstraints()
    }
}

extension DetailsFileViewController {
    private func setupViews() {
        view.addSubview(tableView)
    }
}

extension DetailsFileViewController {
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

extension DetailsFileViewController {
    @objc func actionOnAddFile() {
        var textField = UITextField()
        let alert = UIAlertController(title: nil, message: "Enter folder name", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Enter text"
            textField = alertTextField
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            if let text = textField.text, !text.isEmpty {
                FileManagerApp.shared.createFile(fileName: text)
                FileManagerApp.filesArray.append(text)
                self.tableView.reloadData()
            } else {
                FileManagerApp.shared.createFile(fileName: "Default name")
                FileManagerApp.filesArray.append("Default name")
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func actionOnAddImage() {
        showImagePickerOptions()
    }
    
    private func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }
    
    private func showImagePickerOptions() {
        let alertVC = UIAlertController(title: "Pick a photo", message: "Choose a picture from library or camera", preferredStyle: .actionSheet)
        
        //Image picker for camera
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (action) in
            guard let self = self else { return }
            
            let cameraImagePicker = self.imagePicker(sourceType: .camera)
            cameraImagePicker.delegate = self
            cameraImagePicker.allowsEditing = true
            self.present(cameraImagePicker, animated: true, completion: nil)
        }
        
        //Image picker for library
        let libraryAction = UIAlertAction(title: "Library", style: .default) { [weak self] (action) in
            guard let self = self else { return }
            let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
            libraryImagePicker.delegate = self
            libraryImagePicker.allowsEditing = true
            self.present(libraryImagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertVC.addAction(cameraAction)
        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension DetailsFileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FileManagerApp.filesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FileTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! FileTableViewCell
        cell.folderName.text = FileManagerApp.filesArray[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        print("\(FileManagerApp.filesArray.description)")
        print("\(indexPath.row)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailFileVC = UIViewController()
        detailFileVC.title = FileManagerApp.filesArray[indexPath.row]
        detailFileVC.view.backgroundColor = .white
        navigationController?.pushViewController(detailFileVC, animated: true)
        tableView.reloadData()
    }
}

extension DetailsFileViewController: UITableViewDelegate {}

extension DetailsFileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        self.imageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
