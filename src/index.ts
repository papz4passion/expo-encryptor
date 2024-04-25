import { NativeModulesProxy, EventEmitter, Subscription } from 'expo-modules-core';

// Import the native module. On web, it will be resolved to ExpoEncryptor.web.ts
// and on native platforms to ExpoEncryptor.ts
import ExpoEncryptorModule from './ExpoEncryptorModule';
import ExpoEncryptorView from './ExpoEncryptorView';
import { ExpoEncryptorViewProps } from './ExpoEncryptor.types';

export function encryptWithSymmKey(key: any, plainText: String): string {
  return ExpoEncryptorModule.encryptWithSymmKey(key, plainText);
}

export { ExpoEncryptorView, ExpoEncryptorViewProps };
