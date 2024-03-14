import { NativeModulesProxy, EventEmitter, Subscription } from 'expo-modules-core';

// Import the native module. On web, it will be resolved to SharedWebview.web.ts
// and on native platforms to SharedWebview.ts
import SharedWebviewModule from './SharedWebviewModule';
import SharedWebviewView from './SharedWebviewView';
import { ChangeEventPayload, SharedWebviewViewProps } from './SharedWebview.types';

// Get the native constant value.
export const PI = SharedWebviewModule.PI;

export function hello(): string {
  return SharedWebviewModule.hello();
}

export async function setValueAsync(value: string) {
  return await SharedWebviewModule.setValueAsync(value);
}

const emitter = new EventEmitter(SharedWebviewModule ?? NativeModulesProxy.SharedWebview);

export function addChangeListener(listener: (event: ChangeEventPayload) => void): Subscription {
  return emitter.addListener<ChangeEventPayload>('onChange', listener);
}

export { SharedWebviewView, SharedWebviewViewProps, ChangeEventPayload };
