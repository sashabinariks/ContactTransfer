//
//  PhonebookListVC.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 02.02.2021.
//

import UIKit

final class PhonebookListVC: UIViewController {

    // MARK: - Properties
    
    private let presenter: PhonebookListPresenterInterface?
    
    // MARK: Views
    
    // Navigation
    private lazy var userBarItem: UIBarButtonItem = .init(
        title: "Cancle",
        style: .plain,
        target: self,
        action: #selector(didTapOnCancel(_:)))
    
    private lazy var selectBarItem: UIBarButtonItem = .init(
        title: "Select",
        style: .plain,
        target: self,
        action: #selector(didTapOnSelectItem(_:)))
    
    // Main
    private let collectionView: UICollectionView = .make()
    private let sendButton: UIButton = .make(title: "Send all contacts")

    // MARK: - Contructor
    
    init(presenter: PhonebookListPresenterInterface) {
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
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods
    
    
    
    // MARK: - Actions
    
    @objc private func didTapOnCancel(_ sender: Any) {
        print("didTapOnCancel")
        dismiss(animated: true)
    }

    @objc private func didTapOnSelectItem(_ sender: UIBarButtonItem) {
        print("didTapOnSelectItem")
    }
    
    @objc private func didTapOnSendButton(_ sender: UIButton) {
        print("didTapOnSendButton")
        presenter?.sendContacts()
    }

}

// MARK: - Configuration
extension PhonebookListVC {
    private func configure() {
        setupViews()
        configureNavigationBar()
        configureNavBarItems()
        configureCollectionView()
        
        sendButton.addTarget(self, action: #selector(didTapOnSendButton(_:)), for: .touchUpInside)
    }
    
    private func configureNavigationBar() {
        title = "Phonebook"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func configureNavBarItems() {
        navigationItem.setLeftBarButton(userBarItem, animated: true)
//        navigationItem.setRightBarButton(selectBarItem, animated: true)
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ContactCell.self, forCellWithReuseIdentifier: "Cell")
    }
}

// MARK: - PhonebookListPresenterDelegate
extension PhonebookListVC: PhonebookListPresenterDelegate {
    func shouldUpdateContactList() {
        collectionView.reloadData()
    }
    
    func shouldOpenUserListWith(presenter: UserListPresenterInterface) {
        let controller = UserListVC(presenter: presenter)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showSuccesSendGreating(numberOfContacts: Int) {
        let alert = UIAlertController(title: "Success", message: "You have sent \(numberOfContacts) contacts", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension PhonebookListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberOfContacts ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        if let cell = cell as? ContactCell {
            cell.contact = presenter?.contactAtIndex(indexPath.item)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhonebookListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 20, height: 84)
    }
}

// MARK: - Setup Layout
extension PhonebookListVC {
    private func setupViews() {
        setupCollectionView()
        setupSendButton()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.layout {
            $0.constraint(to: view.safeAreaLayoutGuide)
        }
    }
    
    private func setupSendButton() {
        sendButton.backgroundColor = .green
        sendButton.layer.setCornerRadius(width: 25)
        view.addSubview(sendButton)
        sendButton.layout {
            $0.bottom.constraint(to: collectionView, by: .bottom(-20))
            $0.centerX.constraint(to: view, by: .centerX(0))
            $0.size(.height(50), .width(200))
        }
    }
}
