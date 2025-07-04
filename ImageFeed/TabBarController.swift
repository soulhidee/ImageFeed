import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imagesListVC = ImagesListViewController()
        let imagesNav = UINavigationController(rootViewController: imagesListVC)
        imagesNav.tabBarItem = UITabBarItem(title: nil, image: UIImage.tabEditorialActive, tag: 0)
        
        let profileVC = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(title: nil, image: UIImage.tabProfileActive, tag: 1)
        
        viewControllers = [imagesNav, profileNav]
        
        setupTabBarAppearance()
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "YPBlack") ?? .black

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}

