//
//  StartPresenter.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 02.02.2021.
//

import Foundation
import UIKit

protocol StartPresenterInterface: class {
    var delegate: StartPresenterDelegate? { get set }
    var didTypeName: String? { get set }
    
    func shouldStart()
}

protocol StartPresenterDelegate: class {
    func didHappenErrorWithName()
    func shouldOpenUserListWith(presenter: UserListPresenterInterface)
}

final class StartPresenter: StartPresenterInterface {
    
    // MARK: - Properties
    
    weak var delegate: StartPresenterDelegate?
    
    var didTypeName: String? {
        get { name }
        set { self.name = newValue }
    }
    
    private var name: String?
    
    // services
    private let manager: NetworkManager
    
    // MARK: - Constructor
    
    init() {
        self.manager = NetworkManager()
        setup()
    }
    
    // MARK: - Interface
    
    func shouldStart() {
        if let name = name, !name.isEmpty,
           let deviceUUID = UIDevice.current.identifierForVendor?.uuidString {
            let user = User(deviceId: deviceUUID, displayName: name)
            print("New user ", user)
            manager.registerNewUser(user)
            let presenter = UserListPresenter(networkManager: manager)
            delegate?.shouldOpenUserListWith(presenter: presenter)
        } else {
            delegate?.didHappenErrorWithName()
        }
    }
    
    // MARN: - Methods
    
    private func setup() {
        
    }
    
}
