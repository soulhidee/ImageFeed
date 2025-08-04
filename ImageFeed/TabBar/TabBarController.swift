import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imagesListVC = ImagesListViewController()
        let imagesNav = UINavigationController(rootViewController: imagesListVC)
        imagesNav.tabBarItem = UITabBarItem(title: nil, image: UIImage.tabEditorialActive, tag: 0)
        
        let profileVC = ProfileViewController()
        profileVC.presenter = ProfilePresenter()
        profileVC.presenter?.view = profileVC
        profileVC.tabBarItem = UITabBarItem(title: nil, image: UIImage.tabProfileActive, tag: 1)
        
        viewControllers = [imagesNav, profileVC]
        
        setupTabBarAppearance()
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.ypBlack
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.ypWhite
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.ypWhite]
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
