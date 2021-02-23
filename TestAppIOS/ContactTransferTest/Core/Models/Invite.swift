//
//  Invite.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 19.02.2021.
//

import Foundation

struct Invite: Codable {
    let destinationDeviceId: String
    let deviceId: String
    let displayName: String
    let accepted: Bool?
}

extension Invite {
    func accept(myName: String) -> Invite {
        return Invite(
            destinationDeviceId: deviceId,
            deviceId: destinationDeviceId,
            displayName: myName,
            accepted: true)
    }
    
    func decline(myName: String) -> Invite {
        return Invite(
            destinationDeviceId: deviceId,
            deviceId: destinationDeviceId,
            displayName: myName,
            accepted: false)
    }
}

extension Invite {
    var toDict: AnyObject {
        return ["destinationDeviceId": destinationDeviceId,
                "deviceId": deviceId,
                "displayName": displayName,
                "accepted": accepted] as AnyObject
    }
    
    init?(data: AnyObject) {
        guard let data = data as? [String: AnyObject] else { return nil }
        if let destinationDeviceId = data["destinationDeviceId"] as? String,
           let deviceId = data["deviceId"] as? String,
           let displayName = data["displayName"] as? String {
            self.destinationDeviceId = destinationDeviceId
            self.deviceId = deviceId
            self.displayName = displayName
            
            self.accepted = data["accepted"]  as? Bool
        } else {
            return nil
        }
    }
}
