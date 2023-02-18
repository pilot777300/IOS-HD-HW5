

import UIKit

class TabBar: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setUpVC()
    }
    
    func setUpVC() {
        viewControllers = [
            createNavController(for: PicturesViewController(), title: NSLocalizedString("Файлы", comment: ""), image: UIImage(systemName: "f.circle")!),
            createNavController(for: SettingsViewController(), title: NSLocalizedString("Настройки", comment: ""), image: UIImage(systemName: "gearshape")!)
        ]
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                                     title: String,
                                                     image: UIImage) -> UIViewController {
        
           let navController = UINavigationController(rootViewController: rootViewController)
           navController.tabBarItem.title = title
           navController.tabBarItem.image = image
           navController.navigationBar.prefersLargeTitles = true
           rootViewController.navigationItem.title = title
           return navController
       }
    }
