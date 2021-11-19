import UIKit

protocol MainRouter {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: Builder? { get set }
}

protocol RouterProtocol: MainRouter {
    func initialViewController()
    func showHomeView(response: AuthResponseTokens)
    func popToRoot()
}

class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    
    var assemblyBuilder: Builder?
    
    init(navigationController: UINavigationController, assemblyBuilder: Builder) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        if let navigationController = navigationController {
            guard let mainViewController = assemblyBuilder?.createAuthModule(router: self) else { return }
            navigationController.viewControllers = [mainViewController]
        }
    }
    
    func showHomeView(response: AuthResponseTokens) {
        if let navigationController = navigationController {
            guard let homeViewController = assemblyBuilder?.createHomeModule(response: response, router: self) else { return }
            homeViewController.modalPresentationStyle = .fullScreen
            navigationController.present(homeViewController, animated: true, completion: nil)
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
        
}
