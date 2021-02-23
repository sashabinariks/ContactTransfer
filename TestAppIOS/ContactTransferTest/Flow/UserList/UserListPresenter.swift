//
//  UserListPresenter.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 02.02.2021.
//

import Foundation

protocol UserListPresenterInterface: UserInvitePresenterInterface {
    var delegate: UserListPresenterDelegate? { get set }
    
    var numberOfUsers: Int { get }
    func userAtIndex(_ index: Int) -> User
    
    func sendInviteForUser(_ user: User)
}

protocol UserListPresenterDelegate: UserInvitePresenterDelegate {
    func shouldReloadUserList()
}

// Invite

protocol UserInvitePresenterInterface: class {
    func acceptInvite(_ invite: Invite)
    func declineInvite(_ invite: Invite)
}

protocol UserInvitePresenterDelegate: class {
    func didReceiveInvite(_ invite: Invite)
    
    func shouldTransferContacts(presenter: PhonebookListPresenterInterface)
    func shouldGetContactsFromUser(presenter: ContactTransferPresenter)
}

final class UserListPresenter: UserListPresenterInterface {
    
    // MARK: - Properties
    
    weak var delegate: UserListPresenterDelegate?
    
    private let networkManager: NetworkManager
    
    //data
    private var users: [User] = []
    
    
    // MARK: - Constructor
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        setup()
    }
    
    // MARK: - Interface
    
    var numberOfUsers: Int {
        users.count
    }
    
    func userAtIndex(_ index: Int) -> User {
        users[index]
    }
    
    // MARK: - Interface
    
    func sendInviteForUser(_ user: User) {
        networkManager.requestInviteFor(user)
    }
    
    func acceptInvite(_ invite: Invite) {
        guard let myName = networkManager.currentUser?.displayName else { return }
        networkManager.sendInviteAnswer(invite.accept(myName: myName))
        
        let presenter = ContactTransferPresenter(fromUserId: invite.deviceId, networkManager: networkManager)
        delegate?.shouldGetContactsFromUser(presenter: presenter)
    }
    
    func declineInvite(_ invite: Invite) {
        guard let myName = networkManager.currentUser?.displayName else { return }
        networkManager.sendInviteAnswer(invite.decline(myName: myName))
    }
    
    // MARK: - Methods
    
    private func setup() {
        subscribeUsersUpdate()
        subscribeOnReceiveInvite()
        subscribeOnReceiveAnswerForInvite()
    }
    
    private func subscribeOnReceiveInvite() {
        networkManager.didReceiveInvite { [weak self] invite in
            print(invite)
            self?.delegate?.didReceiveInvite(invite)
        }
    }
    
    private func subscribeOnReceiveAnswerForInvite() {
        networkManager.didReceiveInviteAnswer { [unowned self] invite in
            print("==== ANSWER ====")
            print(invite)
            
            guard invite.accepted == true else { return }
            let presenter = PhonebookListPresenter(userIdToSend: invite.deviceId, networkManager: networkManager)
            delegate?.shouldTransferContacts(presenter: presenter)
        }
    }
}

// MARK: - Fetching users
extension UserListPresenter {
    private func subscribeUsersUpdate() {
        networkManager.fetchUsers({ [weak self] users in
            self?.users = users
            self?.delegate?.shouldReloadUserList()
        })
    }
}
