
import UIKit
import Firebase
import SDWebImage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let imageCache = SDImageCache.shared
                imageCache.config.maxMemoryCost = 30 * 1024 * 1024 // 30 MB
                imageCache.config.maxDiskSize = 100 * 1024 * 1024 // 200 MB
                imageCache.config.shouldCacheImagesInMemory = true
                imageCache.config.shouldUseWeakMemoryCache = true
        return true
    }

}

