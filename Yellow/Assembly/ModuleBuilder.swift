import UIKit

//Не создавал плажку с пустым списком, так как нет возможности получить пустой масив со своим токеном (optional)

protocol Builder {
    
    func createAuthModule(router: RouterProtocol) -> UIViewController
    func createHomeModule(response: AuthResponseTokens, router: RouterProtocol) -> UIViewController
}

final class ModuleBuilder: Builder {
    
    public func createAuthModule(router: RouterProtocol) -> UIViewController {
        let view = AuthViewController()
        let networkService = NetworkService()
        let presenter = AuthPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }

    public func createHomeModule(response: AuthResponseTokens, router: RouterProtocol) -> UIViewController {
        let view = HomeViewController()
        let networkService = NetworkService()
        let presenter = HomePresenter(view: view, networkService: networkService, tokens: response, router: router)
        view.presenter = presenter
        return view
    }
}
