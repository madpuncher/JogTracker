import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowsScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(frame: windowsScene.coordinateSpace.bounds)
        self.window?.windowScene = windowsScene

        self.window?.rootViewController = ModuleBuilder.createAuthModule()
        self.window?.makeKeyAndVisible()
    }

}

