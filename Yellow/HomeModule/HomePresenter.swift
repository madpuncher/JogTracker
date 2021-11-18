import Foundation

protocol HomeViewProtocol: AnyObject {
    
    func showAlert(title: String, message: String)
    
    func reloadData()

}

protocol HomePresenterProtocol: AnyObject {
    
    var jogs: [someJog] { get set }
            
    var tokenResponse: AuthResponseTokens { get set }
    
    func requestNewJog(distance: String,
                       time: String,
                       date: String)
    
    init(view: HomeViewProtocol, networkService: NetworkServiceProtocol, tokens: AuthResponseTokens)
    
}

final class HomePresenter: HomePresenterProtocol {
    
    public var jogs: [someJog] = [] {
        didSet {
            view?.reloadData()
        }
    }
    
    public var tokenResponse: AuthResponseTokens
    
    private let networkService: NetworkServiceProtocol
    
    private weak var view: HomeViewProtocol?
    
    required init(view: HomeViewProtocol, networkService: NetworkServiceProtocol, tokens: AuthResponseTokens) {
        self.view = view
        self.networkService = networkService
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
                    self?.showAlert(title: "Успешно", message: "Забег успешно загружён")
                } else {
                    self?.showAlert(title: .errorTitle, message: "Произошла ошибка во время загрузки")
                }
            }
        }
    }
    
}
