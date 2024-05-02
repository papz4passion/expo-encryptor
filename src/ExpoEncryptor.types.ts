export type ExpoEncryptorViewProps = {
  name: string;
};

export type ExpoEncryptorEncryptionResult = {
  encryptedText: string;
  nonce: string;
  key: string;
  tag: string;
}

export type ExpoEncryptorEncryptionGenericResult = {
  data?: string;
  error?: string;
}