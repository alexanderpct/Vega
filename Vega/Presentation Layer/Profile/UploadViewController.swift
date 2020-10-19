//
//  UploadViewController.swift
//  Vega
//
//  Created by Alexander on 13.06.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController {
    
    let noFileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "folder.fill")
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Ничего не выбрано"
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        title = "Загрузить"
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(noFileImage)
        noFileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noFileImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -96).isActive = true
        noFileImage.heightAnchor.constraint(equalToConstant: 96).isActive = true
        noFileImage.widthAnchor.constraint(equalToConstant: 128).isActive = true
        
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: noFileImage.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 64).isActive = true
    }
    
    @objc private func handleTap() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.text"], in: .import)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
}


extension UploadViewController: UIDocumentPickerDelegate {
    
}
