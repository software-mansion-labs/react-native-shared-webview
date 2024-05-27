import { requireNativeViewManager } from "expo-modules-core";
import * as React from "react";

import { SharedWebviewViewProps } from "./SharedWebview.types";

const NativeView: React.ComponentType<SharedWebviewViewProps> =
  requireNativeViewManager("SharedWebview");

export default function SharedWebviewView(props: SharedWebviewViewProps) {
  return <NativeView {...props} />;
}
