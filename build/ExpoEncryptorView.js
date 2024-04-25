import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';
const NativeView = requireNativeViewManager('ExpoEncryptor');
export default function ExpoEncryptorView(props) {
    return <NativeView {...props}/>;
}
//# sourceMappingURL=ExpoEncryptorView.js.map