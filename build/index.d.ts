import ExpoEncryptorView from './ExpoEncryptorView';
import { ExpoEncryptorViewProps, ExpoEncryptorEncryptionResult } from './ExpoEncryptor.types';
export declare function encryptWithSymmKey(key: any, plainText: string): Promise<ExpoEncryptorEncryptionResult>;
export declare function decryptWithSymmKey(encryptedText: string, ivString: string, symmKey: string, tag: string): Promise<string>;
export declare function encryptWithPublicKey(key: string, plainText: string): Promise<string>;
export { ExpoEncryptorView, ExpoEncryptorViewProps };
//# sourceMappingURL=index.d.ts.map