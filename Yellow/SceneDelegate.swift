import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowsScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(frame: windowsScene.coordinateSpace.bounds)
        self.window?.windowScene = windowsScene
        
        let navigationController = UINavigationController()
        let assemblyBuilder = ModuleBuilder()
        let router = Router(navigationController: navigationController, assemblyBuilder: assemblyBuilder)
        router.initialViewController()

        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }

}

