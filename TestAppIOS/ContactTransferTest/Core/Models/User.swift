//
//  User.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 19.02.2021.
//

import Foundation

struct User: Codable {
    let deviceId: String
    let displayName: String
}

extension User {
    var toDict: AnyObject {
        return ["deviceId": deviceId, "displayName": displayName] as AnyObject
    }
    
    init?(data: AnyObject) {
        guard let data = data as? [String: String] else { return nil }
        if let deviceId = data["deviceId"], let displayName = data["displayName"] {
            self.deviceId = deviceId
            self.displayName = displayName
        } else {
            return nil
        }
    }
    
    static func parseUsers(_ data: AnyObject) -> [User] {
        guard let datas = data as? [AnyObject] else { return [] }
        return datas.compactMap {
            User(data: $0)
        }
    }
}
