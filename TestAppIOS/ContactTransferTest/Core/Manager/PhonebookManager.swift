//
//  PhonebookManager.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 04.02.2021.
//

import Foundation
import Contacts

protocol PhonebookFetchable {
    func fetchContacts(_ contactsHandler: @escaping ([Contact])->Void)
}

class PhonebookManager {
    
    // MARK: - Properties
    
    private let store: CNContactStore
    
    //data
    private var contacts: [Contact] = []
    
    private let keysToFetch = [
        CNContactGivenNameKey, CNContactFamilyNameKey,
        CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactThumbnailImageDataKey] as [CNKeyDescriptor]
    
    // MARK: - Contructor
    
    init() {
        self.store = CNContactStore()
    }
    
    // MARK: - Methods
    
    
}

extension PhonebookManager: PhonebookFetchable {
    func fetchContacts(_ contactsHandler: @escaping ([Contact]) -> Void) {
        do {
            store.requestAccess(for: .contacts) { [weak self] isAuthorize, error in
                guard isAuthorize, let keys = self?.keysToFetch else { return }
                try? self?.store.enumerateContacts(
                    with: CNContactFetchRequest(keysToFetch: keys),
                    usingBlock: { (cncontact, point) in
                        let contact = Contact(contact: cncontact)
                        self?.contacts.append(contact)
                        if let contacts = self?.contacts {
                            contactsHandler(contacts)
                        }
                })
            }
        } catch {
            print("Failed to fetch contact, error: \(error)")
        }
    }
}

