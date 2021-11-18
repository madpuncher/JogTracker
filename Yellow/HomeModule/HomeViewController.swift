
import UIKit

final class HomeViewController: UIViewController, HomeViewProtocol, CreateNewJogViewOutput {
    
    private let navBarView: NavigationBarView = {
        let view = NavigationBarView()
        view.backgroundColor = .systemGreen
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.zPosition = 1
        return view
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .white
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(HomeTableViewCell.self, forCellReuseIdentifier: .homeCellID)
        return table
    }()
    
    private let addJogButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.addJogButtonIcon(), for: .normal)
        return button
    }()
    
    private let form: CreateNewJog = {
        let view = CreateNewJog()
        view.layer.cornerRadius = 15
        view.isHidden = true 
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: CONSTANTS
    
    public var presenter: HomePresenterProtocol!
    
    // MARK: LIFE CYCLE METHODS

    override func viewDidLoad() {
        super.viewDidLoad()

        form.delegate = self
        
        addViews()
        setupConstraints()
        addDelegate()
        addGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    //MARK: Setup UI
    
    private func addViews() {
        
        view.addSubview(navBarView)
        view.addSubview(tableView)
        view.addSubview(addJogButton)
        view.addSubview(form)
        
        view.backgroundColor = .white
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            navBarView.topAnchor.constraint(equalTo: view.topAnchor),
            navBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBarView.heightAnchor.constraint(equalToConstant: view.bounds.height / 7.5),
            
            tableView.topAnchor.constraint(equalTo: navBarView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addJogButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addJogButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            form.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            form.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            form.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            form.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            form.heightAnchor.constraint(equalToConstant: view.frame.size.height / 1.6)
        ])
    }
    
    // MARK: ANOTHER
    
    public func addDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func addGesture() {
        addJogButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
                
        view.addGestureRecognizer(tap)
    }
    
    // MARK: PROTOCOL FUNCTIONS
    
    func closedForm() {
        form.isHidden = true
        tableView.isHidden = false
        addJogButton.isHidden = false
        tableView.reloadData()
    }
    
    func saveFormAndPostRequest(distance: String, time: String, date: String) {
        presenter.requestNewJog(distance: distance, time: time, date: date)
    }
    
    func showAlert() {
        showAlert(title: "Ошибка", message: "Вы ввели не все данные")
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    public func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func buttonTapped() {
        form.isHidden = false
        tableView.isHidden = true
        addJogButton.isHidden = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

// MARK: TABLE VIEW DATA SOURCE / DELEGATE

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.jogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: .homeCellID, for: indexPath) as! HomeTableViewCell
        
        let currentJog = presenter.jogs[indexPath.row]

        cell.configure(model: currentJog)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(view.frame.size.height / 5)
    }
    
}
