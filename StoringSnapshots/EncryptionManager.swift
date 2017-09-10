//
//  EncryptionManager.swift
//  StoringSnapshots
//
//  Created by Geoff Glaeser on 9/9/17.
//  Copyright © 2017 Workoutaholic. All rights reserved.
//

import Foundation
import Security
import RNCryptor

struct KeychainConfiguration {
    static let serviceName = "StoringSnapshots"
    static let accessGroup: String? = nil
}

enum EncryptionError: Error {
    case noPasswordSet
    case unableToSetPwd
    case failedToEncrypt
}

class EncryptionManager {
    
    static let sharedInstance = EncryptionManager()
    
    private let IMG_ENCRYPTION_KEY = "frefwefewefqweewf44t4398"
    private let IMG_ENCRYPTION_PWD = "3j25h2k34jh5235"
    
    init() {
        do {
            let _ = try getSecret()
        } catch {
            do {
                try setEncryptionSecret()
            } catch {
                print("unable to set")
            }
        }
    }
    
    private func getSecret() throws -> String {
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: IMG_ENCRYPTION_KEY,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            return keychainPassword
        }
        catch {
            throw EncryptionError.noPasswordSet
        }
    }
    
    private func setEncryptionSecret() throws {
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: IMG_ENCRYPTION_KEY,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            try passwordItem.savePassword(IMG_ENCRYPTION_PWD)
        } catch {
            throw EncryptionError.unableToSetPwd
        }
    }
    
    func encryptPhoto(imgData: Data) throws -> NSData {
        do {
            let pwd = try getSecret()
            return RNCryptor.encrypt(data: imgData, withPassword: pwd) as NSData
        }
        catch {
            throw EncryptionError.failedToEncrypt
        }
    }
}
