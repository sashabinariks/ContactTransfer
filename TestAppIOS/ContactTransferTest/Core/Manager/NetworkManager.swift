//
//  NetworkManager.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 04.02.2021.
//

import Foundation
import StompClientLib

enum UrlPath {
    case base
    case pong
    
    case users
    case register
    
    case invite(String)
    case sendInvite
    
    case receiveMessage(String)
    case sendMessages
    case messageStatus(String)
    case status
    
    var url: String {
        switch self {
        case .base:
            return "ws://test-env-2.eba-3e7rpc8d.us-east-1.elasticbeanstalk.com/ws"
        case .pong:
            return "/app/active"
        case .users:
            return "/topic/public"
        case .register:
            return "/app/register"
        case let .invite(uuid):
            return "/user/\(uuid)/invite"
        case .sendInvite:
            return "/app/invite"
        case let .receiveMessage(uuid):
            return "/user/\(uuid)/messages"
        case .sendMessages:
            return "/app/chat"
        case let .messageStatus(uuid):
            return "/user/\(uuid)/status"
        case .status:
            return "/app/status"
        }
    }
}

protocol NetworkUserManagable {
    func registerNewUser(_ user: User)
    func fetchUsers(_ usersHandler: @escaping ([User])->Void)
}

protocol NetworkInvitable {
    func didReceiveInvite(_ handler: @escaping (Invite)->Void)
    func didReceiveInviteAnswer(_ handler: @escaping (Invite)->Void)
    func sendInviteAnswer(_ invite: Invite)
    func requestInviteFor(_ user: User)
}

protocol NetworkContactTransfarable {
    func sendContact(_ contact: ContactTransfer)
    func didReveiveContact(_ handler: @escaping (ContactTransfer) -> Void)
    func sendContactStatus(_ status: ContactStatus)
    func didReveiveContactStatus(_ handler: @escaping (ContactStatus) -> Void)
}

class NetworkManager {
    
    // MARK: - Properties
    
    private let socketClient: StompClientLib
    private let url = URL(string: UrlPath.base.url)!
    private (set) var currentUser: User?
    
    private var fetchUserHandlerStorage: [([User])->Void] = []
    private var inviteHandlerStorage: [(Invite)->Void] = []
    private var inviteAnswerHandlerStorage: [(Invite)->Void] = []
    private var receiveMessagesHandler: ((ContactTransfer)->Void)?
    private var receiveMessageStatusHandler: ((ContactStatus)->Void)?
    
    //data
    private var users: [User] = [] {
        didSet {
            fetchUserHandlerStorage.forEach {
                $0(users)
            }
        }
    }
    
    // MARK:  - Constructor
    
    init() {
        self.socketClient = StompClientLib()
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url) , delegate: self)
        sendPong()
    }
    
    private func sendPong() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            print("Send pong")
            self.socketClient.sendJSONForDict(dict: self.pongMessage.toDict, toDestination: UrlPath.pong.url)
            self.sendPong()
        }
    }
    
    private var pongMessage: PongMessage {
        guard let currentDevice = currentUser?.deviceId else {
            return PongMessage(deviceId: "", isActive: true)
        }
        return PongMessage(deviceId: currentDevice, isActive: true)
    }
    
}

// MARK: - NetworkUserManagable
extension NetworkManager: NetworkUserManagable {
    func registerNewUser(_ user: User) {
        socketClient.sendJSONForDict(dict: user.toDict, toDestination: UrlPath.register.url)
        currentUser = user
        subscribeOnReceiveInvite()
    }
    
    func fetchUsers(_ usersHandler: @escaping ([User]) -> Void) {
        fetchUserHandlerStorage.append(usersHandler)
        usersHandler(users)
    }
    
    private func handleReceiveUpdateUser(_ data: AnyObject) {
        let users = User.parseUsers(data)
        guard !users.isEmpty else { return }
        if let currentUser = currentUser?.deviceId {
            self.users = users.filter { $0.deviceId != currentUser }
        } else {
            self.users = users
        }
        
    }
}

// MARK: - NetworkInvitable
extension NetworkManager: NetworkInvitable {
    func didReceiveInvite(_ handler: @escaping (Invite)->Void) {
        inviteHandlerStorage.append(handler)
    }
    
    func didReceiveInviteAnswer(_ handler: @escaping (Invite) -> Void) {
        inviteAnswerHandlerStorage.append(handler)
    }
    
    func sendInviteAnswer(_ invite: Invite) {
        socketClient.sendJSONForDict(dict: invite.toDict, toDestination: UrlPath.sendInvite.url)
        if invite.accepted == true {
            socketClient.subscribe(destination: UrlPath.receiveMessage(invite.deviceId).url)
        }
    }
    
    func requestInviteFor(_ user: User) {
        guard let currentUser = currentUser else { return }
        let invite = Invite(
            destinationDeviceId: user.deviceId,
            deviceId: currentUser.deviceId,
            displayName: currentUser.displayName,
            accepted: nil)
        socketClient.sendJSONForDict(dict: invite.toDict, toDestination: UrlPath.sendInvite.url)
    }
    
    private var currentUserReceiveInvite: String? {
        guard let uuid = currentUser?.deviceId else { return nil }
        return UrlPath.invite(uuid).url
    }
    
    private func subscribeOnReceiveInvite() {
        guard let url = currentUserReceiveInvite,
              let status = currentUserReceiveMessageStatus else { return }
        socketClient.subscribe(destination: url)
        socketClient.subscribe(destination: UrlPath.sendInvite.url)
        socketClient.subscribe(destination: status)
    }
    
    private func handleReceiveInvite(_ data: AnyObject) {
        guard let invite = Invite(data: data) else { return }
        
        if invite.accepted == nil {
            inviteHandlerStorage.forEach {
                $0(invite)
            }
        } else {
            inviteAnswerHandlerStorage.forEach {
                $0(invite)
            }
        }
    }
    
    private func handleGetAnswerForInviteFromUsers(_ data: AnyObject) {
        guard let invite = Invite(data: data) else { return }
        guard let currentUser = currentUser,
              invite.deviceId == currentUser.deviceId, invite.accepted != nil else { return }
        
        inviteAnswerHandlerStorage.forEach {
            $0(invite)
        }
    }
}

// MARK: - NetworkContactTransfarable
extension NetworkManager: NetworkContactTransfarable {
    func sendContactStatus(_ status: ContactStatus) {
        socketClient.sendJSONForDict(dict: status.toDict, toDestination: UrlPath.status.url)
    }
    
    func didReveiveContactStatus(_ handler: @escaping (ContactStatus) -> Void) {
        receiveMessageStatusHandler = handler
    }
    
    func sendContact(_ contact: ContactTransfer) {
        socketClient.sendJSONForDict(dict: contact.toDict, toDestination: UrlPath.sendMessages.url)
    }
    
    func didReveiveContact(_ handler: @escaping (ContactTransfer) -> Void) {
        receiveMessagesHandler = handler
    }
    
    private var currentUserReceiveMessage: String? {
        guard let uuid = currentUser?.deviceId else { return nil }
        return UrlPath.receiveMessage(uuid).url
    }
    
    private var currentUserReceiveMessageStatus: String? {
        guard let uuid = currentUser?.deviceId else { return nil }
        return UrlPath.messageStatus(uuid).url
    }
    
    private func handleReceiveMessage(_ data: AnyObject) {
        guard let message = ContactTransfer(data: data) else { return }
        receiveMessagesHandler?(message)
    }
    
    private func handleReceiveMessageStatus(_ data: AnyObject) {
        guard let message = ContactStatus(data: data) else { return }
        receiveMessageStatusHandler?(message)
    }
}

// MARK: - StompClientLibDelegate
extension NetworkManager: StompClientLibDelegate {
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?,
                     akaStringBody stringBody: String?, withHeader header: [String : String]?,
                     withDestination destination: String) {
        print("OnReceive", destination)
        guard let response = jsonBody else { return }
        
        switch destination {
        case UrlPath.users.url:
            handleReceiveUpdateUser(response)
        case currentUserReceiveInvite ?? "":
            handleReceiveInvite(response)
        case UrlPath.sendInvite.url:
            handleGetAnswerForInviteFromUsers(response)
        case currentUserReceiveMessage ?? "":
            handleReceiveMessage(response)
        case currentUserReceiveMessageStatus ?? "":
            handleReceiveMessageStatus(response)
        default:
            break
        }
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("stompClientDidDisconnect")
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        socketClient.subscribe(destination: UrlPath.users.url)
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("serverDidSendReceipt")
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("serverDidSendError")
    }
    
    func serverDidSendPing() {
        print("serverDidSendPing")
        
        socketClient.sendJSONForDict(dict: pongMessage.toDict, toDestination: UrlPath.pong.url)
    }
}


