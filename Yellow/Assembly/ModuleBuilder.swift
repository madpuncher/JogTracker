import UIKit

//Можно было добавить Coordinator или Router, но в силу отсутствия большого флоy - решил не добавлять (optional)

//Не создавал плажку с пустым списком, так как нет возможности получить пустой масив со своим токеном (optional)

protocol Builder {
    
    static func createAuthModule() -> UIViewController
    static func createHomeModule(response: AuthResponseTokens) -> UIViewController
}

final class ModuleBuilder: Builder {
    
    static func createAuthModule () -> UIViewController {
        let view = AuthViewController()
        let networkService = NetworkService()
        let presenter = AuthPresenter(view: view, networkService: networkService)
        view.presenter = presenter
        return view
    }

    static func createHomeModule(response: AuthResponseTokens) -> UIViewController {
        let view = HomeViewController()
        let networkService = NetworkService()
        let presenter = HomePresenter(view: view, networkService: networkService, tokens: response)
        view.presenter = presenter
        return view
    }
}
