import { EventEmitter } from 'expo-modules-core';
const emitter = new EventEmitter({});
export default {
    encryptWithSymmKey(symKey, plainText) {
        return 'Hello world! 👋';
    },
    decryptWithSymmKey(encryptedText, ivString, symmKey, tag) {
        return "decrypted Text";
    }
};
//# sourceMappingURL=ExpoEncryptorModule.web.js.map