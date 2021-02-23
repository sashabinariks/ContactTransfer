//
//  Contact.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 22.02.2021.
//

import Foundation
import Contacts
import PhotosUI

struct Contact {
    let name: String?
    let surname: String?
    let phoneNumber: String
    let email: String?
    let image: Data?
}

extension Contact {
    init(contact: CNContact) {
        self.name = contact.givenName
        self.surname = contact.familyName
        self.phoneNumber = (contact.phoneNumbers.first?.value)?.stringValue ?? ""
        self.email = (contact.emailAddresses.first?.value as? String) ?? ""
        self.image = contact.thumbnailImageData
    }
    
    init(contact: ContactTransfer) {
        self.name = contact.name
        self.surname = contact.surname
        self.phoneNumber = contact.phoneNumber
        self.email = contact.email
        
        if let image = contact.image {
            self.image = Data(base64Encoded: image)
        } else {
            self.image = nil
        }
    }
    
    var fullName: String {
        return (name ?? "") + " " + (surname ?? "")
    }
    
    func makeTransfer(toUser id: String, size: Int, current: Int) -> ContactTransfer {
        ContactTransfer(recipient: id, name: name, surname: surname, phoneNumber: phoneNumber, email: email, image: lowResolutionImageBase64, currentNumber: current, size: size)
    }
    
    private var lowResolutionImageBase64: String? {
//        StaticImage.image.base64
        guard let data = image else { return nil }
        return UIImage(data: data)?.jpegData(compressionQuality: 0.35)?.base64EncodedString()
    }
}


struct ContactTransfer {
    let recipient: String
    let name: String?
    let surname: String?
    let phoneNumber: String
    let email: String?
    let image: String?
    let currentNumber: Int
    let size: Int
}

extension ContactTransfer {
    var toDict: AnyObject {
        return ["recipient": recipient,
                "name": name,
                "surname": surname,
                "phoneNumber": phoneNumber,
                
                "email": email,
                "image": image,
                "currentNumber": currentNumber,
                "size": size] as AnyObject
    }
    
    init?(data: AnyObject) {
        guard let data = data as? [String: AnyObject] else { return nil }
        if let recipient = data["recipient"] as? String,
           let phoneNumber = data["phoneNumber"] as? String,
           let currentNumber = data["currentNumber"] as? Int,
           let size = data["size"] as? Int {
            
            self.recipient = recipient
            self.name = data["name"] as? String
            self.surname = data["surname"] as? String
            self.phoneNumber = phoneNumber
            self.email = data["email"] as? String
            self.image = data["image"] as? String
            self.currentNumber = currentNumber
            self.size = size
        } else {
            return nil
        }
    }
    
    var toContact: Contact {
        Contact(contact: self)
    }
    
    var progressMessage: String {
        return String(currentNumber) + "/" + String(size)
    }
    
    var progress: Float {
        return Float(currentNumber) / Float(size)
    }
    
    func sendStatusFor(userId: String) -> ContactStatus {
        ContactStatus(destinationDeviceId: userId, numberMessage: currentNumber, status: true)
    }
}

extension Data {
    var toBase64: String? {
        base64EncodedString(options: .lineLength64Characters)
    }
}


