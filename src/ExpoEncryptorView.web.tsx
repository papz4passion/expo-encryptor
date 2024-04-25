import * as React from 'react';

import { ExpoEncryptorViewProps } from './ExpoEncryptor.types';

export default function ExpoEncryptorView(props: ExpoEncryptorViewProps) {
  return (
    <div>
      <span>{props.name}</span>
    </div>
  );
}
