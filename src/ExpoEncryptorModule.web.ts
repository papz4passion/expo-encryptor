import { EventEmitter } from 'expo-modules-core';

const emitter = new EventEmitter({} as any);

export default {
  
  encryptWithSymmKey(symKey: any, plainText: string) {
    return 'Hello world! 👋';
  },
  decryptWithSymmKey(encryptedText: string, ivString: string, symmKey: string, tag: string) {
    return "decrypted Text";
  }
};
