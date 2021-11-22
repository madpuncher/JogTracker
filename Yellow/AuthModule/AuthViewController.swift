import UIKit

final class AuthViewController: UIViewController, AuthViewProtocol {
    
    private let tabBarLogoImage: UIImageView = {
        let barImage = UIImageView()
        barImage.image = UIImage(named: .tabBarLogo())
        barImage.translatesAutoresizingMaskIntoConstraints = false
        return barImage
    }()
    
    private let authLogoImage: UIImageView = {
        let barImage = UIImageView()
        barImage.image = UIImage(named: .authLogo())
        barImage.translatesAutoresizingMaskIntoConstraints = false
        return barImage
    }()
    
    private let tabBarDetailsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: .detailsButtonIcon()), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Let me in", for: .normal)
        button.tintColor = #colorLiteral(red: 0.9161211848, green: 0.565367341, blue: 0.9756446481, alpha: 1)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 0.9161211848, green: 0.565367341, blue: 0.9756446481, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let containerView: UIView = {
        let container = UIView()
        container.backgroundColor = .systemGreen
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private let navBarView: NavigationBarView = {
        let view = NavigationBarView()
        view.backgroundColor = .systemGreen
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let activity: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = #colorLiteral(red: 0.9161211848, green: 0.565367341, blue: 0.9756446481, alpha: 1)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isHidden = true
        return indicator
    }()
    // MARK: CONSTANTS
    
    public var presenter: AuthPresenterProtocol!
    
    // MARK: VC LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //LAYOUT
        addViews()
        setupConstraints()
        setupNavBar()
        
        //Anotother
        addTargets()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        signInButton.layer.cornerRadius = signInButton.bounds.height / 2
    }
    
    // MARK: FUNCTIONALITY
    
    private func addTargets() {
        signInButton.addTarget(self, action: #selector(signInButtonWasPressed), for: .touchUpInside)
    }
    
    private func setupNavBar() {
        navigationController?.isNavigationBarHidden = true
    }
    //MARK: Setup UI
    
    private func addViews() {
        
        view.addSubview(navBarView)
        view.addSubview(authLogoImage)
        view.addSubview(signInButton)
        
        signInButton.addSubview(activity)
        
        view.backgroundColor = .white
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            navBarView.topAnchor.constraint(equalTo: view.topAnchor),
            navBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBarView.heightAnchor.constraint(equalToConstant: view.bounds.height / 8.5),
                        
            authLogoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authLogoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.topAnchor.constraint(equalTo: authLogoImage.bottomAnchor, constant: view.frame.width / 3),
            signInButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 2.5),
            signInButton.heightAnchor.constraint(equalToConstant: .defailtButtonHeight),
            
            activity.centerXAnchor.constraint(equalTo: signInButton.centerXAnchor),
            activity.centerYAnchor.constraint(equalTo: signInButton.centerYAnchor),
        ])
    }
    
    // MARK: PROTOCOL FUNCTIONS
       
    public func showAlert(title: String, message: String) {
        
        let alert = AlertFactory.createAlert(with: .init(title: title,
                                                         message: message,
                                                         style: .alert,
                                                         actions: [.init(title: "OK",
                                                                         style: .default,
                                                                         closure: nil)]))
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: TARGETS
    
    @objc private func signInButtonWasPressed() {
        
        signInButton.setTitle("", for: .normal)
        activity.isHidden = false
        activity.startAnimating()
        
        presenter.authRequest()
    }
}
