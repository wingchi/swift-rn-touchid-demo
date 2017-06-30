# Swift & React Native Touch ID Demo

A demo React Native app converted to Swift that demonstrates native bridging using a Touch ID component.

This demo codebase is made of the following commits. Checkout the specific sha to see the changes made at each point.

1. [14dbcd4: React Native Login Screen](#14dbcd4)
1. [ae24a53: Conversion to Swift](#ae24a53)
1. [915eaf4: React Bridge in Swift](#915eaf4)
1. [ec27851: NativeModules in JS](#ec27851)

## 14dbcd4
**Adds login screen built in React Native**

This commit adds code for a login screen built completely with React Native.

## ae24a53
**Converts project to Swift**

This commit converts the base iOS project from Objective-C to Swift.

## 915eaf4
**Adds react bridged class for Keychain and Touch ID**

This commit adds a class that wraps the [KeychainAccess](https://cocoapods.org/pods/KeychainAccess) Cocoapod to make it accessible by our React Native code through the React Bridge. Unit tests have also been added to test for callability.

## ec27851
**Adds JS for Touch ID support**

This commit add the JavaScript required on our React Native side to interface with the bridged component we created previously.
