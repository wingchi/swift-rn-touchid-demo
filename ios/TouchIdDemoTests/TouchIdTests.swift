//
//  NativeKeychainTests.swift
//
//  Created by Stephen Wong on 1/26/17.
//

import XCTest
@testable import TouchIdDemo
import KeychainAccess

final class NativeKeychainTests: XCTestCase {
  
  func testAddGetSuccess() {
    let mockKeychain = MockKeychain()
    let nativeKeychain = NativeKeychain(keychain: mockKeychain)
    let testPassword = "password"
    
    // setting "testuser" should succeeed and resolve true
    let addExpectation = expectation(description: "Adding test user")
    nativeKeychain.addTouchIdItem(
      userid: "testuser",
      password: testPassword,
      resolve: { result in
        guard let success = result as? Bool else {
          XCTFail("Result was not a Bool")
          return
        }
        XCTAssert(success)
        addExpectation.fulfill()
    },
      reject: { _, _, _ in
        XCTFail("Could not add test user")
    }
    )
    
    // getting our test user's password should resolve the correct password
    let getExpectation = expectation(description: "Getting test user password")
    nativeKeychain.getTouchIdItem(
      userid: "testuser",
      resolve: { result in
        guard let password = result as? String else {
          XCTFail("Result was not a String")
          return
        }
        XCTAssertEqual(testPassword, password)
        getExpectation.fulfill()
    },
      reject: { _, _, _ in
        XCTFail("Could not retrieve test user password")
    }
    )
    
    waitForExpectations(timeout: 4) { error in
      XCTAssertNil(error, "Adding and getting a test id failed")
    }
  }
  
  func testAddFailure() {
    let mockKeychain = MockKeychain()
    let nativeKeychain = NativeKeychain(keychain: mockKeychain)
    
    // this should add id attempt reject our promise
    let addFailExpectation = expectation(description: "Expected add test user fail")
    nativeKeychain.addTouchIdItem(
      userid: "testfail",
      password: "failword",
      resolve: { _ in
        XCTFail("Adding user should have failed")
        addFailExpectation.fulfill()
    },
      reject: { code, message, error in
        guard let error = error as? MockKeychainError else {
          XCTFail("Error was nil")
          return
        }
        XCTAssertEqual(code, "add_failed")
        XCTAssertEqual(error, MockKeychainError.generic)
        addFailExpectation.fulfill()
    }
    )
    
    waitForExpectations(timeout: 4) { error in
      XCTAssertNil(error, "Expected failure in adding user has failed")
    }
  }
  
  func testGetFailure() {
    let mockKeychain = MockKeychain()
    let nativeKeychain = NativeKeychain(keychain: mockKeychain)
    
    // this get id attempt should reject our promise
    let getIdErrorExpectation = expectation(description: "Expected get test id fail")
    nativeKeychain.getTouchIdItem(
      userid: "testfail",
      resolve: { _ in
        XCTFail("Getting password should have failed")
    },
      reject: { code, message, error in
        guard let error = error as? MockKeychainError else {
          XCTFail("Error was nil")
          return
        }
        XCTAssertEqual(code, "get_failed")
        XCTAssertEqual(error, MockKeychainError.generic)
        getIdErrorExpectation.fulfill()
    }
    )
    
    waitForExpectations(timeout: 4) { error in
      XCTAssertNil(error, "Expected failure in getting ids has failed")
    }
  }
  
  func testGetNotFound() {
    let mockKeychain = MockKeychain()
    let nativeKeychain = NativeKeychain(keychain: mockKeychain)
    
    // this get id attempt should fail because the key doesn't exist
    let getIdNotFoundExpectation = expectation(description: "Expected get test id not found")
    let unknownUserid = "willalsofail"
    nativeKeychain.getTouchIdItem(
      userid: unknownUserid,
      resolve: { _ in
        XCTFail("Getting password should have failed")
    },
      reject: { code, message, error in
        XCTAssertEqual(code, "password_undefined")
        XCTAssertEqual(message, "The password for \(unknownUserid) is undefined")
        XCTAssertNil(error)
        getIdNotFoundExpectation.fulfill()
    }
    )
    
    waitForExpectations(timeout: 4) { error in
      XCTAssertNil(error, "Expected id not found in getting ids has failed")
    }
  }
  
  func testGetUserCancelled() {
    let mockKeychain = MockKeychain()
    let nativeKeychain = NativeKeychain(keychain: mockKeychain)
    
    // this get id attempt should fail because the key doesn't exist
    let getIdCancelledExpectation = expectation(description: "Expected get test id not found")
    let cancelUserid = "testopcancel"
    nativeKeychain.getTouchIdItem(
      userid: cancelUserid,
      resolve: { _ in
        XCTFail("Getting password should have failed because operation was cancelled")
    },
      reject: { code, message, error in
        XCTAssertEqual(code, "op_cancelled")
        XCTAssertEqual(message, Status.userCanceled.localizedDescription)
        XCTAssertNotNil(error)
        getIdCancelledExpectation.fulfill()
    }
    )
    
    waitForExpectations(timeout: 4) { error in
      XCTAssertNil(error, "Expected id not found in getting ids has failed")
    }
  }
  
  func testRemoveSuccess() {
    let mockKeychain = MockKeychain()
    let nativeKeychain = NativeKeychain(keychain: mockKeychain)
    
    //this id should silently succeed
    let removeIdExpectation = expectation(description: "Expected remove test id success")
    let removableId = "testuser"
    
    nativeKeychain.addTouchIdItem(
      userid: removableId,
      password: "password",
      resolve: {_ in
        nativeKeychain.removeTouchIdItem(
          userid: removableId,
          resolve: { result in
            XCTAssertEqual(mockKeychain.keychainStore.count, 0)
            removeIdExpectation.fulfill()
        },
          reject: { _, description, _ in
            guard let description = description else {
              XCTFail()
              removeIdExpectation.fulfill()
              return
            }
            XCTFail(description)
            removeIdExpectation.fulfill()
        }
        )
    },
      reject: {_,_,_ in}
    )
    
    waitForExpectations(timeout: 4) { error in
      XCTAssertNil(error, "Expected touch id item to be removed")
    }
  }
  
  func testRemoveFailure() {
    let mockKeychain = MockKeychain()
    let nativeKeychain = NativeKeychain(keychain: mockKeychain)
    
    //this id cannot be added, but removal will throw an exception
    let removeIdExpectation = expectation(description: "Expected remove test id failure")
    let removableId = "unremovabletestuser"
    
    nativeKeychain.addTouchIdItem(
      userid: removableId,
      password: "password",
      resolve: {_ in
        nativeKeychain.removeTouchIdItem(
          userid: removableId,
          resolve: { _ in
            XCTFail("Removing this id should have failed")
            removeIdExpectation.fulfill()
        },
          reject: { _, _, error in
            XCTAssertNotNil(error)
            XCTAssertEqual(mockKeychain.keychainStore.count, 1)
            removeIdExpectation.fulfill()
        }
        )
    },
      reject: {_,_,_ in}
    )
    
    waitForExpectations(timeout: 4) { error in
      XCTAssertNil(error, "Expected touch id item removal to fail")
    }
  }
}

enum MockKeychainError: Error {
  case generic
  
  var localizedDescription: String {
    switch self {
    case .generic:
      return "Testing failed as expected"
    }
  }
}

final class MockKeychain: Keychainable {
  var keychainStore = [String: String]()
  func authenticationPrompt(_ authenticationPrompt: String) -> Keychainable {
    return self
  }
  func accessibility(_ accessibility: Accessibility, authenticationPolicy: AuthenticationPolicy) -> Keychainable {
    return self
  }
  func set(_ value: String, key: String) throws {
    if key == "testuser" || key == "unremovabletestuser" {
      keychainStore[key] = value
    } else {
      throw MockKeychainError.generic
    }
  }
  func get(_ key: String) throws -> String? {
    if key == "testuser" {
      return "password"
    } else if key == "testfail" {
      throw MockKeychainError.generic
    } else if key == "testopcancel" {
      let error = Status(status: Status.userCanceled.rawValue)
      throw error
    } else {
      return keychainStore[key]
    }
  }
  func remove(_ key: String) throws {
    if key == "testuser" {
      keychainStore.removeValue(forKey: key)
    } else {
      throw MockKeychainError.generic
    }
  }
}
