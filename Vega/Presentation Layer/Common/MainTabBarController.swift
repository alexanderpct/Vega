//
//  MainTabBarController.swift
//  Vega
//
//  Created by Alexander on 01.11.2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var login: Login = .denied
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let networkService: VegaNetworkProtocol = NetworkService()
                
        viewControllers = [
            createNewViewController(viewController: DocumentsListViewController(networkService: networkService), title: "Документы", imageName: "doc.fill"),
            createNewViewController(viewController: UpdatesViewController(), title: "Уведомления", imageName: "envelope"),
            createNewViewController(viewController: ProfileViewController(), title: "Профиль", imageName: "person.fill")

        ]
    }
    

    private func createNewViewController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        navController.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: imageName), selectedImage: nil)
        navController.view.backgroundColor = .white
        viewController.navigationItem.title = title
        return navController
        
    }

}
