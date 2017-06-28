/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Button,
  Alert,
  TextInput
} from 'react-native';

const textInputMargin = 16

export default class TouchIdDemo extends Component {
  state = {
    username: '',
    password: '',
  }

  onLoginPress = () => {
    const testUsername = 'wingchi'
    const testPassword = 'password'
    if (this.state.username.toLowerCase() === testUsername
      && this.state.password === testPassword) {
      Alert.alert(`Login Successful`)
    } else {
      Alert.alert(`Login Failed`)
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
    borderColor: '#001EFF',
    backgroundColor: '#DDD',
    marginLeft: 2*textInputMargin,
    marginRight: 2*textInputMargin,
    marginBottom: textInputMargin,
    paddingLeft: 8,
  }
});

AppRegistry.registerComponent('TouchIdDemo', () => TouchIdDemo);
