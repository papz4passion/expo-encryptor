// Import the native module. On web, it will be resolved to ExpoEncryptor.web.ts
// and on native platforms to ExpoEncryptor.ts
import ExpoEncryptorModule from './ExpoEncryptorModule';
import ExpoEncryptorView from './ExpoEncryptorView';
export function encryptWithSymmKey(key, plainText) {
    return ExpoEncryptorModule.encryptWithSymmKey(key, plainText);
}
export { ExpoEncryptorView };
//# sourceMappingURL=index.js.map