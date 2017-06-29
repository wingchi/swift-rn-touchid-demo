//
//  NativeKeychain.swift
//  IdentityForce
//
//  Created by Stephen Wong on 1/23/17.
//  Copyright © 2017 IdentityForce. All rights reserved.
//

import UIKit
import KeychainAccess
import LocalAuthentication

protocol Keychainable {
  func authenticationPrompt(_ authenticationPrompt: String) -> Keychainable
  func accessibility(_ accessibility: Accessibility, authenticationPolicy: AuthenticationPolicy) -> Keychainable
  func set(_ value: String, key: String) throws
  func get(_ key: String) throws -> String?
  func remove(_ key: String) throws
}

@objc(NativeKeychain)
final class NativeKeychain: NSObject {
  var keychain: Keychainable? = nil
  
  override init() {
    guard let bundleId = Bundle.main.bundleIdentifier else {
      super.init()
      return
    }
    self.keychain = Keychain(service: bundleId)
    super.init()
  }
  
  init(keychain: Keychainable?) {
    if let keychain = keychain {
      self.keychain = keychain
    } else {
      guard let bundleId = Bundle.main.bundleIdentifier else {
        super.init()
        return
      }
      self.keychain = Keychain(service: bundleId)
    }
    super.init()
  }
  
  @objc func checkTouchIdAvailability(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    let context = LAContext()
    var error: NSError?
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
      resolve(true)
    } else {
      guard let error = error else {
        resolve(false)
        return
      }
      reject("no_touchid", error.localizedDescription, error)
    }
  }
  
  @objc func addTouchIdItem(userid: String,
                            password: String,
                            resolve: @escaping RCTPromiseResolveBlock,
                            reject: @escaping RCTPromiseRejectBlock) {
    guard !RCTRunningInAppExtension()
      else {
        reject("in_app_extension_running", "In app extension is currently running", nil)
        return
      }
    
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
      do {
        try self.keychain?
          .authenticationPrompt("Verify your fingerprint to enable Touch ID")
          .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
          .set(password, key: userid)
        resolve(true)
      } catch let e {
        reject("add_failed", e.localizedDescription, e)
      }
    }
  }
  
  @objc func getTouchIdItem(userid: String,
                            resolve: @escaping RCTPromiseResolveBlock,
                            reject: @escaping RCTPromiseRejectBlock) {
    guard !RCTRunningInAppExtension()
      else {
        reject("in_app_extension_running", "In app extension is currently running", nil)
        return
      }
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
      do {
        guard let password = try self.keychain?
          .authenticationPrompt("Authentication required to proceed")
          .get(userid)
          else {
            reject("password_undefined", "The password for \(userid) is undefined", nil)
            return
        }
        resolve(password)
      } catch let e {
        guard let error = e as? Status else {
          reject("get_failed", e.localizedDescription, e)
          return
        }
        switch error {
        case .userCanceled:
          reject("op_cancelled", e.localizedDescription, e)
        default:
          reject("get_failed", e.localizedDescription, e)
        }
      }
    }
  }
  
  @objc func removeTouchIdItem(userid: String,
                               resolve: @escaping RCTPromiseResolveBlock,
                               reject: @escaping RCTPromiseRejectBlock) {
    do {
      try keychain?.remove(userid)
      resolve(true)
    } catch let e {
      reject("delete_failed", e.localizedDescription, e)
    }
  }
}

extension Keychain: Keychainable {
  func accessibility(_ accessibility: Accessibility, authenticationPolicy: AuthenticationPolicy) -> Keychainable {
    let keychain: Keychain = self.accessibility(accessibility, authenticationPolicy: authenticationPolicy)
    return keychain
  }
  func authenticationPrompt(_ authenticationPrompt: String) -> Keychainable {
    let keychain: Keychain = self.authenticationPrompt(authenticationPrompt)
    return keychain
  }
  
}
