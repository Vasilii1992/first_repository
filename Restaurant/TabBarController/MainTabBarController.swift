
import UIKit
 
final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setTabBarAppearance()
    }
    
    private func generateTabBar() {
        viewControllers = [
        generateVC(viewController: ViewController(),
                   title: Resources.Strings.TabBarTitle.food,
                   image: UIImage(systemName: "frying.pan")),
        generateVC(viewController: MenuViewController(),
                   title: Resources.Strings.TabBarTitle.drink,
                   image: UIImage(named: "barIcon")),
        generateVC(viewController: AboutUsViewController(),
                   title: Resources.Strings.TabBarTitle.aboutUS,
                   image: UIImage(systemName: "house.circle.fill"))

        ]
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }

    private func setTabBarAppearance() {
        tabBar.tintColor = .tabBarItemAccent
        tabBar.unselectedItemTintColor = .tabBarItemLight
    }
}
