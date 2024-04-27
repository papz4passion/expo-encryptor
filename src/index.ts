import { NativeModulesProxy, EventEmitter, Subscription } from 'expo-modules-core';

// Import the native module. On web, it will be resolved to ExpoEncryptor.web.ts
// and on native platforms to ExpoEncryptor.ts
import ExpoEncryptorModule from './ExpoEncryptorModule';
import ExpoEncryptorView from './ExpoEncryptorView';
import { ExpoEncryptorViewProps, ExpoEncryptorEncryptionResult } from './ExpoEncryptor.types';

export async function encryptWithSymmKey(key: any, plainText: string): Promise<ExpoEncryptorEncryptionResult> {
  return await ExpoEncryptorModule.encryptWithSymmKey(key, plainText);
}

export async function decryptWithSymmKey(encryptedText: string, ivString: string, symmKey: string, tag: string): Promise<string> {
  return await ExpoEncryptorModule.decryptWithSymmKey(encryptedText, ivString, symmKey, tag);
}

export async function encryptWithPublicKey(key: string, plainText: string): Promise<string> {
  return await ExpoEncryptorModule.encryptWithPublicKey(key, plainText);
}

export { ExpoEncryptorView, ExpoEncryptorViewProps };
