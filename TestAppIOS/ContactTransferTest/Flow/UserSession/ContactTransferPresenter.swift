//
//  ContactTransferPresenter.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 02.02.2021.
//

import Foundation

protocol ContactTransferPresenterInterface: class {
    var delegate: ContactTransferPresenterDelegate? { get set }
    
    var numberOfContacts: Int { get }
    func contactAtIndex(_ index: Int) -> Contact
    
    var progressMessage: String { get }
    var progress: Float { get }
}

protocol ContactTransferPresenterDelegate: class {
    func shouldUpdateContactList()
}

final class ContactTransferPresenter: ContactTransferPresenterInterface {
    
    // MARK: - Properties
    
    weak var delegate: ContactTransferPresenterDelegate?
    
    private let fromUserId: String
    private var contacts: [Contact] = []
    
    private let manager: NetworkContactTransfarable
    
    // MARK: - Constructor
    
    init(fromUserId: String, networkManager: NetworkContactTransfarable) {
        self.fromUserId = fromUserId
        self.manager = networkManager
        setup()
    }
    
    // MARK: - Interface
    
    var numberOfContacts: Int {
        contacts.count
    }
    
    func contactAtIndex(_ index: Int) -> Contact {
        contacts[index]
    }
    
    var progressMessage: String = "-/-"
    var progress: Float = 0
    
    // MARN: - Methods
    
    private func setup() {
        manager.didReveiveContact { [weak self] contact in
            self?.contacts.append(contact.toContact)
            self?.progressMessage = contact.progressMessage
            self?.progress = contact.progress
            self?.delegate?.shouldUpdateContactList()
            if let user = self?.fromUserId {
                self?.manager.sendContactStatus(contact.sendStatusFor(userId: user))
            }
            print(contact)
        }
    }
    
}
