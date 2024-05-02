import { NativeModulesProxy, EventEmitter, Subscription } from 'expo-modules-core';

// Import the native module. On web, it will be resolved to ExpoEncryptor.web.ts
// and on native platforms to ExpoEncryptor.ts
import ExpoEncryptorModule from './ExpoEncryptorModule';
import ExpoEncryptorView from './ExpoEncryptorView';
import { ExpoEncryptorViewProps, ExpoEncryptorEncryptionResult, ExpoEncryptorEncryptionGenericResult } from './ExpoEncryptor.types';

export function encryptWithSymmKey(key: any, plainText: string): ExpoEncryptorEncryptionResult {
  return ExpoEncryptorModule.encryptWithSymmKey(key, plainText);
}

export function decryptWithSymmKey(encryptedText: string, ivString: string, symmKey: string, tag: string): ExpoEncryptorEncryptionGenericResult {
  return ExpoEncryptorModule.decryptWithSymmKey(encryptedText, ivString, symmKey, tag);
}

export function encryptWithPublicKey(key: string, plainText: string): ExpoEncryptorEncryptionGenericResult {
  return ExpoEncryptorModule.encryptWithPublicKey(key, plainText);
}

export { ExpoEncryptorView, ExpoEncryptorViewProps };
