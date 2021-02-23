//
//  PongMessage.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 23.02.2021.
//

import Foundation

struct PongMessage {
    let deviceId: String
    let isActive: Bool
}

extension PongMessage {
    var toDict: AnyObject {
        return ["deviceId": deviceId,
                "isActive": isActive] as AnyObject
    }
}
