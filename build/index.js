// Import the native module. On web, it will be resolved to ExpoEncryptor.web.ts
// and on native platforms to ExpoEncryptor.ts
import ExpoEncryptorModule from './ExpoEncryptorModule';
import ExpoEncryptorView from './ExpoEncryptorView';
export async function encryptWithSymmKey(key, plainText) {
    return await ExpoEncryptorModule.encryptWithSymmKey(key, plainText);
}
export async function decryptWithSymmKey(encryptedText, ivString, symmKey, tag) {
    return await ExpoEncryptorModule.decryptWithSymmKey(encryptedText, ivString, symmKey, tag);
}
export async function encryptWithPublicKey(key, plainText) {
    return await ExpoEncryptorModule.encryptWithPublicKey(key, plainText);
}
export { ExpoEncryptorView };
//# sourceMappingURL=index.js.map