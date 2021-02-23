//
//  ContactStatus.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 23.02.2021.
//

import Foundation

struct ContactStatus {
    let destinationDeviceId: String
    let numberMessage: Int
    let status: Bool
    
}

extension ContactStatus {
    var toDict: AnyObject {
        return ["destinationDeviceId": destinationDeviceId,
                "numberMessage": numberMessage,
                "status": status] as AnyObject
    }
    
    init?(data: AnyObject) {
        guard let data = data as? [String: AnyObject] else { return nil }
        if let destinationDeviceId = data["destinationDeviceId"] as? String,
           let numberMessage = data["numberMessage"] as? Int,
           let status = data["status"] as? Bool {
            self.destinationDeviceId = destinationDeviceId
            self.numberMessage = numberMessage
            self.status = status
        } else {
            return nil
        }
    }
}
