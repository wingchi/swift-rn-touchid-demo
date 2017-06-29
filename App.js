/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react'
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Button,
  Alert,
  TextInput
} from 'react-native';

import FingerprintManager from './FingerprintManager'

const textInputMargin = 16

const testUsername = 'wingchi'
const testPassword = 'password'

export default class TouchIdDemo extends Component {
  state = {
    username: '',
    password: '',
    fingerprintAvailable: false,
  }

  authenticate = (username, password) => (username === testUsername && password === testPassword)

  onLoginPress = () => {
    const username = this.state.username.toLowerCase()
    const password = this.state.password
    if (this.authenticate(username, password)) {
      Alert.alert(`Login Successful`)
      if (this.state.fingerprintAvailable) {
        FingerprintManager.setFingerprintCredential(username, password)
      }
    } else {
      Alert.alert(`Login Failed`)
    }
  }

  onTouchIdLoginPress = async () => {
    const username = this.state.username.toLowerCase()
    try {
      const password = await FingerprintManager.getFingerprintCredential(username)
      if (this.authenticate(username, password)) {
        Alert.alert('Touch ID Login Successful')
      }
    } catch (e) {
      Alert.alert('Touch ID Failed')
    }
  }

  componentDidMount = async () => {
    try {
      const fingerprintAvailable = await FingerprintManager.checkFingerprintAvailability()
      this.setState({fingerprintAvailable})
    } catch (e) {
      console.log(e)
    }
  }

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Touch ID Demo
        </Text>
        <TextInput
          style={styles.loginInput}
          onChangeText={(text) => this.setState({username: text})}
          autoCorrect={false}
          placeholder="Username"
          autoCapitalize='none'
          value={this.state.username}
        />
        <TextInput
          style={styles.loginInput}
          onChangeText={(text) => this.setState({password: text})}
          autoCorrect={false}
          placeholder="Password"
          autoCapitalize='none'
          value={this.state.password}
          secureTextEntry={true}
        />
        <Button
          onPress={this.onLoginPress}
          title="Login"
          color="#001EFF"
          accessibilityLabel="Login"
        />
        { this.state.fingerprintAvailable &&
          <Button
            onPress={this.onTouchIdLoginPress}
            title="Login with Touch ID"
            color="#001EFF"
            accessibilityLabel="Login with Touch ID"
          />
        }
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  loginInput: {
    height: 40,
    alignSelf: 'stretch',
    borderColor: '#001EFF',
    backgroundColor: '#DDD',
    marginLeft: 2*textInputMargin,
    marginRight: 2*textInputMargin,
    marginBottom: textInputMargin,
    paddingLeft: 8,
  }
});

AppRegistry.registerComponent('TouchIdDemo', () => TouchIdDemo);
