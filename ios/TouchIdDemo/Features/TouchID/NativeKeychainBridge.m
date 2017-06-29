//
//  NativeKeychainBridge.m
//  IdentityForce
//
//  Created by Stephen Wong on 1/24/17.
//  Copyright © 2017 IdentityForce. All rights reserved.
//

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(NativeKeychain, NSObject)

RCT_EXTERN_METHOD(checkTouchIdAvailabilityWithResolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(addTouchIdItemWithUserid:(NSString *)userid
                  password:(NSString *)password
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getTouchIdItemWithUserid:(NSString *)userid
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(removeTouchIdItemWithUserid:(NSString *)userid
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
@end
