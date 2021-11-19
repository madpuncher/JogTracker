import Foundation
import UIKit

protocol AuthViewProtocol: AnyObject {
        
    func showAlert(title: String, message: String)

}

protocol AuthPresenterProtocol: AnyObject {
            
    init(view: AuthViewProtocol,
         networkService: NetworkServiceProtocol,
         router: RouterProtocol)
    
    func authRequest()
            
}

final class AuthPresenter: AuthPresenterProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    private weak var view: AuthViewProtocol?
    
    var router: RouterProtocol?
    
    required init(view: AuthViewProtocol,
                  networkService: NetworkServiceProtocol,
                  router: RouterProtocol) {
        
        self.view = view
        self.networkService = networkService
        self.router = router
    }
    
    // MARK: NETWORKING
    public func authRequest() {
        networkService.postRequestToLogin(uuid: "hello") { [weak self] response in
            switch response {
                
            case .success(let response):
                
                DispatchQueue.main.async {
                    self?.router?.showHomeView(response: response)
                }
                
            case .failure(let error):
                self?.showAlert(title: .errorTitle, message: error.localizedDescription)
            }
        }
    }
    
    // MARK: VIEW DELEGATE METHODS
    public func showAlert(title: String, message: String) {
        view?.showAlert(title: title, message: message)
    }
    
}
