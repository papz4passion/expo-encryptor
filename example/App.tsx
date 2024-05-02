import { StyleSheet, Text, View, Button, TextInput, SafeAreaView, ScrollView } from 'react-native';
import React, { useState } from 'react';

import * as ExpoEncryptor from 'expo-encryptor';

export default function App() {
  const [text, setText] = useState('');
  const [key, setKey] = useState('');

  const [encrypted, setEncrypted] = useState('');
  const [nonce, setNonce] = useState('');
  const [tag, setTag] = useState('');
  const [decrypted, setDecrypted] = useState('');
 
  const [secondText, setSecondText] = useState('');
  const [rsaEncrypted, setRsaEncrypted] = useState("");
  const [rsaDecrypted, setRsaDecrypted] = useState("");

  const encryptText = async () => {
    try {
      const result = ExpoEncryptor.encryptWithSymmKey(key.length > 0 ? key : null, text);
      setEncrypted(result.encryptedText);
      setNonce(result.nonce);
      setKey(result.key);
      setTag(result.tag);
      alert('Encryption Successful');
    } catch (e) {
      alert(`Encryption Failed: ${JSON.stringify(e)}`);
    }
  };

  const decryptFromSeverWithSymmKey = async () => {
    try {
      const response = await fetch("http://localhost:8080/decryptWithSymmKey", {
        method: "POST",
        body: JSON.stringify({
          symmKey: rsaDecrypted,
          tag: tag,
          iv: nonce,
          encrypted: encrypted
        })
      });

      const decryptedText = await response.text();
      setDecrypted(decryptedText);
    } catch (error) {
      alert(error);
    }
  }

  const decryptText = async () => {
    try {
      const plaintext = ExpoEncryptor.decryptWithSymmKey(encrypted, nonce, rsaDecrypted, tag);
      setDecrypted(plaintext.data ? plaintext.data : "");
      alert('Decryption Successful');
    } catch (e) {
      alert(`Decryption Failed: ${JSON.stringify(e)}`);
    }
  };

  const getPublicKey = async () => {
    try{
      let response = await fetch("http://localhost:8080/publicKey", );
      let text = await response.text();
      return text;
      // setPublicKey(text);
    } catch (error) {
      alert(error);
      return "";
    }
  };

  const encryptWithPublicKey = async () => {
    try{
      let publicKey = await getPublicKey();
      const result = ExpoEncryptor.encryptWithPublicKey(publicKey, key);
      setRsaEncrypted(result.data ? result.data : "");
    } catch(error) {
      alert(error);
    }
  }

  const decryptWithPrivateKey = async () => {
    try {
      let response = await fetch("http://localhost:8080/decrypt", {
        method: "POST",
        body: rsaEncrypted
      });

      let decryptedText = await response.text();
      setRsaDecrypted(decryptedText);
    } catch(error) {
      alert(error);
    }
  }

  const encryptInServer = async () => {
      try {
        let response = await fetch("http://localhost:8080/encrypt", {
          method: "POST",
          body: text
        });

        let encryptedText = await response.text();
        setRsaEncrypted(encryptedText);
      } catch (error) {
        alert(error)
      }
  };

  return (
    <SafeAreaView>
      <ScrollView>
      <View style={{ padding: 20 }}>
        <TextInput
          style={{ height: 40, borderColor: 'gray', borderWidth: 1 }}
          placeholder="Enter text to encrypt"
          onChangeText={setText}
          value={text}
        />
        <TextInput
          style={{ height: 40, borderColor: 'gray', borderWidth: 1 }}
          placeholder="Enter symmetric key (optional)"
          onChangeText={setKey}
          value={key}
        />
        <Button title="Encrypt" onPress={encryptText} />
        <Text>Encrypted: {encrypted}</Text>
        <Button title="Decrypt" onPress={decryptText} />
        <Button title="DecryptInServer" onPress={decryptFromSeverWithSymmKey} />
        <Text>Decrypted: {decrypted}</Text>
      </View>

      <View style={{ padding: 20 }}>
        <Text> Public key encryption</Text>
        {/* <Text> Public Key {publicKey == '' ? "not ": ""} recieved</Text>r */}
        <TextInput
          style={{ height: 40, borderColor: 'gray', borderWidth: 1 }}
          placeholder="Enter text to encrypt"
          onChangeText={setSecondText}
          value={secondText}
        />
        <Button title="EncryptWithPublicKey" onPress={encryptWithPublicKey} />
        <Text>Encrypted:</Text>
        <TextInput
          style={{ height: 40, borderColor: 'gray', borderWidth: 1 }}
          placeholder="EncryptedText"
          onChangeText={setRsaEncrypted}
          value={rsaEncrypted}
        ></TextInput>
        <Button title="DecryptWithPrivateKey" onPress={decryptWithPrivateKey} />
        <Text>Decrypted: {rsaDecrypted}</Text>
      </View>
      <View style={{ padding: 20 }}>
        <Text>Encrypt in server section</Text>
        <Button title="Encrypt in server" onPress={encryptInServer}/>
      </View>

      </ScrollView>
    </SafeAreaView >
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
