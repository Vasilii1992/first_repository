
import UIKit
 
final class MainTabBarController: UITabBarController {
    
    let foodIcon    = "frying.pan"
    let drincIcon   = "barIcon"
    let aboutUsIcon = "house.circle.fill"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setTabBarAppearance()
    }
    
    private func generateTabBar() {
        viewControllers = [
        generateVC(viewController: MainView(),
                   title: Resources.Strings.TabBarTitle.food,
                   image: UIImage(systemName: foodIcon)),
        generateVC(viewController: MenuView(),
                   title: Resources.Strings.TabBarTitle.drink,
                   image: UIImage(named: drincIcon)),
        generateVC(viewController: AboutUsViewController(),
                   title: Resources.Strings.TabBarTitle.aboutUS,
                   image: UIImage(systemName: aboutUsIcon))

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
