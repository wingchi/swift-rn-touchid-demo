import { Platform } from 'react-native'
import { NativeKeychain as iosNativeKeychain } from 'NativeModules';

const FingerprintManager = {
  checkFingerprintAvailability: async () => {
    try {
      const isAvailable = (Platform.OS === 'ios') ?
        await iosNativeKeychain.checkTouchIdAvailabilityWithResolve() :
        false
      return isAvailable
    } catch (e) {
      throw e
    }
  },
  setFingerprintCredential: async (username, password) => {
    try {
      const success = (Platform.OS === 'ios') ?
        await iosNativeKeychain.addTouchIdItemWithUserid(username, password) :
        false
      return success
    } catch (e) {
      throw e
    }
  },
  getFingerprintCredential: async (username) => {
    try {
      const password = (Platform.OS === 'ios') ?
        await iosNativeKeychain.getTouchIdItemWithUserid(username) :
        null
      return password
    } catch (e) {
      throw e
    }
  },
  removeFingerprintCredential: async (username) => {
    try {
      const credentialRemoved = (Platform.OS === 'ios') ?
        await iosNativeKeychain.removeTouchIdItemWithUserid(username) :
        false
      return credentialRemoved
    } catch (e) {
      throw e
    }
  },
  error: {
    noTouchId: 'no_touchid',
    inAppExtensionRunning: 'in_app_extension_running',
    addFailed: 'add_failed',
    getFailed: 'get_failed',
    passwordUndefined: 'password_undefined',
    opCancelled: 'op_cancelled',
    deleteFailed: 'delete_failed',
    tooManyAttempts: 'too_many_attempts',
  },
}

export default FingerprintManager
