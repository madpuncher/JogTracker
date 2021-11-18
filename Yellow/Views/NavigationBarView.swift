import UIKit

final class NavigationBarView: UIView {
    
    private let tabBarLogoImage: UIImageView = {
        let barImage = UIImageView()
        barImage.image = .tabBarLogo()
        barImage.translatesAutoresizingMaskIntoConstraints = false
        return barImage
    }()
    
    private let tabBarDetailsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.detailsButtonIcon(), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGreen
        
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        self.addSubview(tabBarLogoImage)
        self.addSubview(tabBarDetailsButton)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            tabBarLogoImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            tabBarLogoImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 15),
            
            tabBarDetailsButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            tabBarDetailsButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 15),
        ])
    }
    
}
