import Foundation

protocol HomeViewProtocol: AnyObject {
    
    func showAlert(title: String, message: String)
    
    func reloadData()
}

protocol HomePresenterProtocol: AnyObject {
    
    var jogs: [SomeJog] { get set }
            
    var tokenResponse: AuthResponseTokens { get set }
    
    func requestNewJog(distance: String,
                       time: String,
                       date: String)
    
    func changeJogRequest(id: String,
                          userId: String,
                          distance: String,
                          time: String,
                          date: String)
    
    init(view: HomeViewProtocol,
         networkService: NetworkServiceProtocol,
         tokens: AuthResponseTokens,
         router: RouterProtocol)
    
}

final class HomePresenter: HomePresenterProtocol {
    
    public var jogs: [SomeJog] = [] {
        didSet {
            view?.reloadData()
        }
    }
    
    public var tokenResponse: AuthResponseTokens
    
    private let networkService: NetworkServiceProtocol
    
    private weak var view: HomeViewProtocol?
    
    var router: RouterProtocol?
    
    required init(view: HomeViewProtocol, networkService: NetworkServiceProtocol, tokens: AuthResponseTokens, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.tokenResponse = tokens
        
        jogsRequest()
    }
    
    // MARK: NETWORKING
    public func jogsRequest() {
        networkService.getRequestForJogs(accessToken: tokenResponse.accessToken,
                                         tokenType: tokenResponse.tokenType) { [weak self] response in
            switch response {
            case .success(let response):
                
                DispatchQueue.main.async {
                    self?.jogs = response
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
    
    func requestNewJog(distance: String,
                       time: String,
                       date: String) {
        networkService.postNewJogRequest(accessToken: tokenResponse.accessToken,
                                         tokenType: tokenResponse.tokenType,
                                         distance: distance,
                                         time: time,
                                         date: date) { [weak self] succefull in
            
            DispatchQueue.main.async {
                if succefull {
                    self?.showAlert(title: .succefull, message: .succefullJog)
                } else {
                    self?.showAlert(title: .errorTitle, message: .fetchJogError)
                }
            }
        }
    }
    
    func changeJogRequest(id: String,
                          userId: String,
                          distance: String,
                          time: String,
                          date: String) {
        
        networkService.putChangeJogRequest(accessToken: tokenResponse.accessToken,
                                           id: id,
                                           userId: userId,
                                           tokenType: tokenResponse.tokenType,
                                           distance: distance,
                                           time: time,
                                           date: date) { [weak self] result in
            
            DispatchQueue.main.async {
                if result {
                    self?.showAlert(title: .succefull, message: .succefullChangeJog)
                    self?.view?.reloadData()
                } else {
                    self?.showAlert(title: .errorTitle, message: .changeJogError)
                }
            }
        }
    }
    
}
