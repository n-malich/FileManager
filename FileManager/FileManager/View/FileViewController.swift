//
//  FileViewController.swift
//  FileManager
//
//  Created by Natali Malich
//

import UIKit
import PhotosUI

class FileViewController: UIViewController {
    
    private var file: File
    private var counterForImageName = 1
    private var counterForDefaultFolderName = 1
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .systemGray6
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(data: File) {
        self.file = data
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
        self.tableView.register(FileTableViewCell.self, forCellReuseIdentifier: "fileCellID")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.setupViews()
        self.setupConstraints()
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(actionOnAddFile)),
            UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(actionOnAddImage))
        ]
    }
}

extension FileViewController {
    private func setupViews() {
        view.addSubview(tableView)
    }
}

extension FileViewController {
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

extension FileViewController {
    @objc func actionOnAddFile() {
        var textField = UITextField()
        let alert = UIAlertController(title: nil, message: "Enter folder name", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Enter text"
            textField = alertTextField
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            if let text = textField.text, !text.isEmpty {
                let newFile = FileManagerApp.shared.createFolder(nameFolder: text, mode: .document)
                self.file.children.append(newFile)
            } else {
                let defaultName = "Default name\(self.counterForDefaultFolderName)"
                self.counterForDefaultFolderName += 1
                let newFile = FileManagerApp.shared.createFolder(nameFolder: defaultName, mode: .document)
                self.file.children.append(newFile)
            }
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func actionOnAddImage() {
        self.showImagePickerOptions()
    }
      
    private func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }

    private func showImagePickerOptions() {
        let alertVC = UIAlertController(title: "Pick a photo", message: "Choose a picture from library or camera", preferredStyle: .actionSheet)

        //Image picker for camera
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] action in
            guard let self = self else { return }
            let cameraImagePicker = self.imagePicker(sourceType: .camera)
            cameraImagePicker.delegate = self
            cameraImagePicker.allowsEditing = true
            self.present(cameraImagePicker, animated: true, completion: nil)
        }

        //Image picker for library
        let libraryAction = UIAlertAction(title: "Library", style: .default) { [weak self] action in
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

extension FileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let defaultName = "Image\(counterForImageName)"
        counterForImageName += 1
        let newFile = FileManagerApp.shared.createImage(nameImage: defaultName, mode: .image, image: image)
        self.file.children.append(newFile)
        self.dismiss(animated: true, completion: nil)
        self.tableView.reloadData()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension FileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return file.children.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "fileCellID", for: indexPath) as! FileTableViewCell
        cell.nameFile.text = file.children[indexPath.row].name
        cell.iconFile.image = file.children[indexPath.row].image
        if file.children[indexPath.row].mode == .image {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .disclosureIndicator
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if file.children[indexPath.row].mode == .image {
            guard let image = file.children[indexPath.row].image else { return }
            let detailImageVC = ImageViewController(imageView: image )
            self.navigationController?.present(detailImageVC, animated: true, completion: nil)
        } else {
            let detailFileVC = FileViewController(data: file.children[indexPath.row])
            detailFileVC.title = detailFileVC.file.name
            self.navigationController?.pushViewController(detailFileVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        FileManagerApp.shared.deleteFile(directoryPath: file.url, filePath: file.children[indexPath.row].url)
        
        for (index, _) in file.children.enumerated() {
            if indexPath.row == index {
                file.children.remove(at: index)
            }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
}

extension FileViewController: UITableViewDelegate {}
