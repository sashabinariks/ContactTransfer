//
//  StartVC.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 02.02.2021.
//

import UIKit

final class StartVC: UIViewController {

    // MARK: - Properties
    
    private let presenter: StartPresenterInterface?
    
    // MARK: - Views
    
    private let nameTextField: UITextField = .makeHeavyWith(fontSize: 18, placeholder: "Name")
    private let startButton: UIButton = .make(title: "Start")
    
    // MARK: - Contructor
    
    init(presenter: StartPresenterInterface) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter?.delegate = self
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Methods
    
    @objc private func didTapOnStart(_ sender: UIButton) {
        presenter?.shouldStart()
    }

}

// MARK: - Configuration
extension StartVC {
    private func configure() {
        setupViews()
        configureNavigationBar()
        configureStartButton()
        configureTextField()
    }
    
    private func configureNavigationBar() {
        title = "Share contact"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func configureTextField() {
        nameTextField.delegate = self
    }
    
    private func configureStartButton() {
        startButton.addTarget(self, action: #selector(didTapOnStart(_:)), for: .touchUpInside)
    }
}

// MARK: - StartPresenterDelegate
extension StartVC: StartPresenterDelegate {
    func didHappenErrorWithName() {
        nameTextField.layer.setBorder(width: 1, color: .red)
    }
    func shouldOpenUserListWith(presenter: UserListPresenterInterface) {
        let controller = UserListVC(presenter: presenter)
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.prefersLargeTitles = true
        navigation.modalPresentationStyle = .fullScreen
        navigationController?.present(navigation, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension StartVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nameTextField.layer.setBorder(width: 1, color: .black)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        presenter?.didTypeName = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Setup Layout
extension StartVC {
    private func setupViews() {
        setupNameTextView()
        setupStartButton()
    }
    
    private func setupNameTextView() {
        nameTextField.layer.setBorder(width: 1, color: .darkGray)
        view.addSubview(nameTextField)
        nameTextField.layout {
            $0.constraint(to: view, by: .leading(40), .trailing(-40))
            $0.centerY.constraint(to: view, by: .centerY(0))
            $0.size(.height(50))
        }
    }
    
    private func setupStartButton() {
        startButton.backgroundColor = .green
        startButton.layer.setCornerRadius(width: 25)
        view.addSubview(startButton)
        startButton.layout {
            $0.top.constraint(to: nameTextField, by: .bottom(100))
            $0.centerX.constraint(to: view, by: .centerX(0))
            $0.size(.height(50), .width(120))
        }
    }
}
