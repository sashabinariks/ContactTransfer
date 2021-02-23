//
//  ContactTransferVC.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 02.02.2021.
//

import UIKit

final class ContactTransferVC: UIViewController {

    // MARK: - Properties
    
    private let presenter: ContactTransferPresenterInterface?
    
    // MARK: Views
    
    private lazy var progressView: UIProgressView = .init()
    
    // Navigation
    private lazy var userBarItem: UIBarButtonItem = .init(
        title: "Cancle",
        style: .plain,
        target: self,
        action: #selector(didTapOnCancel(_:)))
    
    private lazy var progressBarItem: UIBarButtonItem = .init(
        title: "-/-",
        style: .plain,
        target: self,
        action: #selector(didTapOnSelectItem(_:)))
    
    private let collectionView: UICollectionView = .make()
    
    // MARK: - Contructor
    
    init(presenter: ContactTransferPresenterInterface) {
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

}

// MARK: - Configuration
extension ContactTransferVC {
    private func configure() {
        setupViews()
        configureNavigationBar()
        configureNavBarItems()
        configureCollectionView()
    }
    
    private func configureNavigationBar() {
        title = "Phonebook"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func configureNavBarItems() {
        navigationItem.setLeftBarButton(userBarItem, animated: true)
        navigationItem.setRightBarButton(progressBarItem, animated: true)
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ContactCell.self, forCellWithReuseIdentifier: "Cell")
    }
}

// MARK: - UserSessionPresenterDelegate
extension ContactTransferVC: ContactTransferPresenterDelegate {
    func shouldUpdateContactList() {
        collectionView.reloadData()
        progressBarItem.title = presenter?.progressMessage
        progressView.setProgress(presenter?.progress ?? 0, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension ContactTransferVC: UICollectionViewDataSource {
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
extension ContactTransferVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 20, height: 84)
    }
}

// MARK: - Setup Layout
extension ContactTransferVC {
    private func setupViews() {
        setupCollectionView()
        setupProgressView()
    }
    
    func setupProgressView() {
        collectionView.addSubview(progressView)
//        progressView.setProgress(0.7, animated: true)
        progressView.layout {
            $0.bottom.constraint(to: view.safeAreaLayoutGuide, by: .bottom(-20))
            $0.leading.constraint(to: view.safeAreaLayoutGuide, by: .leading(40))
            $0.trailing.constraint(to: view.safeAreaLayoutGuide, by: .trailing(-40))
        }
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.contentInset = .init(top: 10, left: 0, bottom: 0, right: 0)
        collectionView.layout {
            $0.constraint(to: view.safeAreaLayoutGuide)
        }
    }
}
