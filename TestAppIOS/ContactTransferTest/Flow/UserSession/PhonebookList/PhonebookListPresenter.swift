//
//  PhonebookListPresenter.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 02.02.2021.
//

import Foundation

protocol PhonebookListPresenterInterface: class {
    var delegate: PhonebookListPresenterDelegate? { get set }
    
    var numberOfContacts: Int { get }
    func contactAtIndex(_ index: Int) -> Contact
    
    func sendContacts()
}

protocol PhonebookListPresenterDelegate: class {
    func shouldUpdateContactList()
    func shouldOpenUserListWith(presenter: UserListPresenterInterface)
    func showSuccesSendGreating(numberOfContacts: Int)
}

final class PhonebookListPresenter: PhonebookListPresenterInterface {
    
    // MARK: - Properties
    
    weak var delegate: PhonebookListPresenterDelegate?
        
    private let userIdToSend: String
    
    private let phonebook = PhonebookManager()
    private let networkManager: NetworkManager
    
    //data
    private var contacts: [Contact] = []
    private var contactsToSend: [Int: Contact]?
    
    // MARK: - Constructor
    
    init(userIdToSend: String, networkManager: NetworkManager) {
        self.userIdToSend = userIdToSend
        self.networkManager = networkManager
        setup()
    }
    
    // MARK: - Interface
    
    var numberOfContacts: Int {
        contacts.count
    }
    
    func contactAtIndex(_ index: Int) -> Contact {
        contacts[index]
    }
    
    func didTapOnUserList() {
        let presenter = UserListPresenter(networkManager: networkManager)
        delegate?.shouldOpenUserListWith(presenter: presenter)
    }
    
    // MARN: - Methods
    
    func sendContacts() {
        contactsToSend = contacts
            .enumerated()
            .reduce([Int: Contact]()) { (result, contact) in
                var result = result
                result[contact.offset] = contact.element
                return result
        }
        sendContactToUser()
    }
    
    func acceptInvite(_ invite: Invite) {
        guard let myName = networkManager.currentUser?.displayName else { return }
        networkManager.sendInviteAnswer(invite.accept(myName: myName))
    }
    
    func declineInvite(_ invite: Invite) {
        guard let myName = networkManager.currentUser?.displayName else { return }
        networkManager.sendInviteAnswer(invite.decline(myName: myName))
    }
    
    private func setup() {
        phonebook.fetchContacts { [weak self] contacts in
            self?.contacts = contacts
            print(contacts)
            self?.delegate?.shouldUpdateContactList()
        }
        
        networkManager.didReveiveContactStatus { [weak self] status in
            print(status)
            self?.sendContactToUser()
        }
    }
    
    private func sendContactToUser() {
        guard let firstKey = contactsToSend?.keys.sorted().first else {
            delegate?.showSuccesSendGreating(numberOfContacts: contacts.count)
            return
        }
        guard let nextContact = contactsToSend?[firstKey] else { return }
        contactsToSend?[firstKey] = nil
        let transfer = nextContact.makeTransfer(toUser: userIdToSend, size: contacts.count, current: firstKey+1)
        networkManager.sendContact(transfer)
    }
}
