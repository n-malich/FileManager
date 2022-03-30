//
//  FileViewController.swift
//  FileManager
//
//  Created by Natali Malich
//

import UIKit
import PhotosUI

class FileViewController: UIViewController {
    
    var delegate: FileViewControllerDelegate?
    private var url: URL
    private var files: [URL]?
    private var alert : UIAlertController?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemGray6
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(url: URL) {
        self.url = url
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
        
        self.files = FileManagerApp.shared.showFile(directoryURL: self.url)
        print("\(String(describing: files))")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refresh()
    }
    
    @objc private func alertTextFieldDidChange(sender: UITextField) {
        alert?.actions[0].isEnabled = sender.text!.count > 0
    }
    
    func refresh() {
        self.files = FileManagerApp.shared.showFile(directoryURL: self.url)
        
        if UserDefaults.standard.bool(forKey: "A-Z") == true ||
            UserDefaults.standard.object(forKey: "A-Z") == nil {
            self.files?.sort(by: { $0.lastPathComponent < $1.lastPathComponent})
        } else {
            self.files?.sort(by: { $1.lastPathComponent < $0.lastPathComponent})
        }
        self.tableView.reloadData()
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
    @objc private func actionOnAddFile() {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        alert = UIAlertController(title: nil, message: "Enter folder name", preferredStyle: .alert)
        
        alert?.addTextField { alertTextField in
            alertTextField.addTarget(self, action: #selector(self.alertTextFieldDidChange), for: .editingChanged)
            textField = alertTextField
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            guard let text = textField.text else { return }
            FileManagerApp.shared.createFolder(nameFolder: text, directoryURL: self.url)
            self.refresh()
        }
        addAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert!.addAction(addAction)
        alert!.addAction(cancelAction)
        present(alert!, animated: true, completion: nil)
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
        guard let imageURL = info[.imageURL] as? URL else { return }
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        FileManagerApp.shared.createImage(nameImage: imageURL.lastPathComponent, directoryURL: self.url, data: data)
        self.refresh()
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension FileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "fileCellID", for: indexPath) as! FileTableViewCell
        let url = (files?[indexPath.row])!
        
        let data = FileManager.default.contents(atPath: url.path)
        cell.iconFile.image = UIImage(data: data ?? Data()) ?? UIImage(systemName: "folder.fill")!

        cell.nameFile.text = url.lastPathComponent
        
        if !url.isDirectory {
            cell.accessoryType = .none
            if UserDefaults.standard.bool(forKey: "Show size") == true ||
                UserDefaults.standard.object(forKey: "Show size") == nil {
                let imageSize = (Double(data?.count ?? 0) / 1024 / 1024)
                cell.sizeFile.text = String(format: "%.2f Mb", imageSize)
                cell.sizeFile.isHidden = false
            } else {
                cell.sizeFile.isHidden = true
            }
        } else {
            cell.accessoryType = .disclosureIndicator
            cell.sizeFile.isHidden = true
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUrl = (files?[indexPath.row])!
        if selectedUrl.isDirectory {
            self.delegate?.openFileViewController(directoryURL: selectedUrl, title: selectedUrl.lastPathComponent)
        } else {
            let data = FileManager.default.contents(atPath: selectedUrl.path)
            let image = UIImage(data: data ?? Data()) ?? UIImage(systemName: "photo.fill")!
            self.delegate?.navigateToImageVC(imageView: image)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        FileManagerApp.shared.deleteFile(directoryURL: url, fileURL: (files?[indexPath.row])!)
        self.refresh()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
