//
//  UserListVC.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 02.02.2021.
//

import UIKit

final class UserListVC: UIViewController {

    // MARK: - Properties
    
    private let presenter: UserListPresenterInterface?
    
    // MARK: - Views
    
    private let collectionView: UICollectionView = .make()
    
    // MARK: - Contructor
    
    init(presenter: UserListPresenterInterface) {
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
    }
    
    // MARK: - Methods
    
    
}

// MARK: - Configuration
extension UserListVC {
    private func configure() {
        setupViews()
        configureNavigationBar()
        configureCollectionView()
    }
    
    private func configureNavigationBar() {
        title = "User list"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
}

// MARK: - UserListPresenterDelegate
extension UserListVC: UserListPresenterDelegate {
    func shouldTransferContacts(presenter: PhonebookListPresenterInterface) {
        let controller = PhonebookListVC(presenter: presenter)
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.prefersLargeTitles = true
        navigationController?.present(navigation, animated: true)
    }
    
    func shouldGetContactsFromUser(presenter: ContactTransferPresenter) {
//        let presenter = ContactTransferPresenter(networkManager: mana)
        let controller = ContactTransferVC(presenter: presenter)
        controller.view.backgroundColor = .white
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.prefersLargeTitles = true
        navigationController?.present(navigation, animated: true)
    }
    
    func didReceiveInvite(_ invite: Invite) {
        let alert = UIAlertController(title: "Reveived invite", message: "User \(invite.displayName) want to share contacts with you", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Accept", style: .default) { [weak self] _ in
            self?.presenter?.acceptInvite(invite)
        })
        
        alert.addAction(UIAlertAction(title: "Decline", style: .cancel) { [weak self] _ in
            self?.presenter?.declineInvite(invite)
        })

        self.present(alert, animated: true)
    }
    
    func shouldReloadUserList() {
        collectionView.reloadData()
    }
}

// MARK: - UserCellDelegate
extension UserListVC: UserCellDelegate {
    func shouldStartPairWithUser(_ user: User) {
        presenter?.sendInviteForUser(user)
    }
}

// MARK: - UICollectionViewDataSource
extension UserListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberOfUsers ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        if let cell = cell as? UserCell {
            cell.user = presenter?.userAtIndex(indexPath.item)
            cell.delegate = self
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UserListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 60, height: 80)
    }
}

// MARK: Setup layout
extension UserListVC {
    private func setupViews() {
        view.addSubview(collectionView)
        collectionView.layout {
            $0.constraint(to: view.safeAreaLayoutGuide)
        }
    }
    
}
