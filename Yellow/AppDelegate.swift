import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    static var shared: AppDelegate {
        let delegate = UIApplication.shared.delegate

        guard let appDelegate = delegate as? AppDelegate else {
            fatalError("Cannot cast \(type(of: delegate)) to AppDelegate")
        }

        return appDelegate
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let navigationController = UINavigationController()
        let moduleBuilder = ModuleBuilder()
        let router = Router(navigationController: navigationController, assemblyBuilder: moduleBuilder)
        router.initialViewController()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

