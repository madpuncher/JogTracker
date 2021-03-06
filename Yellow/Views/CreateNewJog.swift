import UIKit

protocol CreateNewJogViewOutput {
    
    func closedForm()
    func saveFormAndPostRequest(distance: String, time: String, date: String)
    
    func saveChangesAndPutRequest(id: Int,
                                  userId: String,
                                  distance: String,
                                  time: String,
                                  date: String)
    
    func showAlert()
    
}

class CreateNewJog: UIView {
    
    private let xmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: .xmarkgButtonIcon()), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.font = .boldSystemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Distance"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Time"
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let distanceTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.keyboardType = .numberPad
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let timeTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.keyboardType = .numberPad
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let dateTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let datePicker: UIDatePicker = {
        var picker = UIDatePicker()
        picker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            /// else ???????? ?????? ??????????????????????
            // ???? ?????????????? ?????????? ?????????????????????????????? ????????????
        }
        return picker
    }()
    
    var viewForChange: Bool!
    var currentJog: SomeJog!
    
    var delegate: CreateNewJogViewOutput!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        setupConstaints()
        addTargets()
        configureViews()
        setupToolBar()
        
        backgroundColor = .systemGreen
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        saveButton.layer.cornerRadius = saveButton.bounds.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        dateTextField.inputView = datePicker
    }
    
    private func addTargets() {
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        xmarkButton.addTarget(self, action: #selector(closedButtonPressed), for: .touchUpInside)
    }
    
    @objc private func closedButtonPressed() {
        delegate.closedForm()
    }
    
    @objc private func saveButtonPressed() {
        
        guard
            let distance = distanceTextField.text,
            let time = timeTextField.text,
            let date = dateTextField.text,
            distance.count > 0,
            time.count > 0,
            date.count > 0 else {
                delegate.showAlert()
                return
            }
        
        guard
            let id = currentJog.id,
            let userId = currentJog.userId else {
                return
            }
        
        if viewForChange {
            
            delegate.saveChangesAndPutRequest(id: id,
                                              userId: userId,
                                              distance: distance,
                                              time: time,
                                              date: date)
        } else {
            delegate.saveFormAndPostRequest(distance: distance, time: time, date: date)
        }
        
        distanceTextField.text = ""
        timeTextField.text = ""
        dateTextField.text = ""
        
        delegate.closedForm()
    }
    
    @objc private func doneButtonDateInBarPressed() {
        
        if dateTextField.isFirstResponder {
            dateFormatter()
            self.endEditing(true)
        } else {
            self.endEditing(true)
        }
        
    }
    
    private func setupConstaints() {
        
        NSLayoutConstraint.activate([
            xmarkButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            xmarkButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            
            distanceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 34),
            distanceLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 35),
            
            distanceTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 34),
            distanceTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -34),
            distanceTextField.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 10),
            
            timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 34),
            timeLabel.topAnchor.constraint(equalTo: distanceTextField.bottomAnchor, constant: 20),
            
            timeTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 34),
            timeTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -34),
            timeTextField.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10),
            
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 34),
            dateLabel.topAnchor.constraint(equalTo: timeTextField.bottomAnchor, constant: 20),
            
            dateTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 34),
            dateTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -34),
            dateTextField.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            
            saveButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 34),
            saveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -34),
            saveButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -34),
            saveButton.heightAnchor.constraint(equalToConstant: .defailtButtonHeight)
            
        ])
    }
    
    private func addViews() {
        self.addSubview(xmarkButton)
        self.addSubview(distanceLabel)
        self.addSubview(timeLabel)
        self.addSubview(dateLabel)
        self.addSubview(timeTextField)
        self.addSubview(dateTextField)
        self.addSubview(distanceTextField)
        self.addSubview(saveButton)
    }
    
    // MARK: CUSTOM / HELP FUNCTIONS
    
    private func dateFormatter() {
        let formatter = DateFormatter()
        formatter.dateFormat = .dateFormatter
        dateTextField.text = formatter.string(from: datePicker.date)
    }
    
    private func setupToolBar() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonDateInBarPressed))
        
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        dateTextField.inputAccessoryView = toolbar
        distanceTextField.inputAccessoryView = toolbar
        timeTextField.inputAccessoryView = toolbar
    }
    
}
