import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';

import { ExpoEncryptorViewProps } from './ExpoEncryptor.types';

const NativeView: React.ComponentType<ExpoEncryptorViewProps> =
  requireNativeViewManager('ExpoEncryptor');

export default function ExpoEncryptorView(props: ExpoEncryptorViewProps) {
  return <NativeView {...props} />;
}
