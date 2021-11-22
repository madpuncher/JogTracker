import UIKit

final class HomeTableViewCell: UITableViewCell {
    
    private let jogIcon: UIImageView = {
        let jogIconImage = UIImageView()
        jogIconImage.image = UIImage(named: .jogRunnerIcon())
        jogIconImage.translatesAutoresizingMaskIntoConstraints = false
        return jogIconImage
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let speedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        return label
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        addViews()
        setupConstraints()
    }
    
    private func addViews() {
        contentView.addSubview(jogIcon)
        contentView.addSubview(dateLabel)
        contentView.addSubview(speedLabel)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(timeLabel)

    }
    
    private func setupConstraints() {
        
        let stackView = UIStackView(arrangedSubviews: [dateLabel,
                                                       speedLabel,
                                                       distanceLabel,
                                                       timeLabel])
        
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            jogIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.frame.size.width / 5),
            jogIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: jogIcon.trailingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: self.frame.self.height / 1.5),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            
        ])
    }
    
  
    public func configure(model: someJog) {
        
        if model.distance != 0 && model.time != 0 {
            dateLabel.text = .returnFormattedDate(value: model.date)
            speedLabel.text = "Speed: \(String(describing: (model.distance ?? 1) / (model.time ?? 1)))"
            distanceLabel.text = "Distance: \(String(describing: model.distance ?? 0))"
            timeLabel.text = "Time: " + .secondsToMinutes(seconds: model.time ?? 0) + " min"
        } else {
            dateLabel.text = .returnFormattedDate(value: model.date)
            speedLabel.text = "Speed: Неизвестно"
            distanceLabel.text = "Distance: \(String(describing: model.distance ?? 0))"
            timeLabel.text = "Time: " + .secondsToMinutes(seconds: model.time ?? 0) + "min"
        }
    }
}
