# react-native-shared-webview

A webview that detects mounting/unmounting and focus changes and keeps a single instance mounted.
Only works on iOS for now.


https://github.com/software-mansion-labs/react-native-shared-webview/assets/5597580/bc5cc843-da43-4a6e-adae-91a987da2681




# Example

Check out the example app for expo-router integration.

```example/SharedWebview.tsx
import { useRouter } from "expo-router";
import { SharedWebviewView } from "shared-webview";
import { useIsFocused } from "@react-navigation/native";

const ORIGIN = "https://swmansion.com";

export default ({ pathname = "/" }: { pathname: string }) => {
  const { navigate } = useRouter();
  const isFocused = useIsFocused();
  return (
    <SharedWebviewView
      style={{ flex: 1 }}
      options={{
        url: (ORIGIN + "/" + pathname).replaceAll("//", "/"),
        focused: isFocused,
      }}
      onNavigation={(event: any) => {
        const { url } = event.nativeEvent;
        if (url.startsWith(ORIGIN) === false) return navigate(url);
        const urlObject = new URL(url);
        navigate(urlObject.pathname);
      }}
    />
  );
};
```

# Installation in managed Expo projects

For [managed](https://docs.expo.dev/archive/managed-vs-bare/) Expo projects, please follow the installation instructions in the [API documentation for the latest stable release](#api-documentation). If you follow the link and there is no documentation available then this library is not yet usable within managed projects &mdash; it is likely to be included in an upcoming Expo SDK release.

# Installation in bare React Native projects

For bare React Native projects, you must ensure that you have [installed and configured the `expo` package](https://docs.expo.dev/bare/installing-expo-modules/) before continuing.

### Add the package to your npm dependencies

```
npm install react-native-shared-webview
```

### Configure for iOS

Run `npx pod-install` after installing the npm package.


### Configure for Android

**Android is not supported yet.**

# Contributing

Contributions are very welcome! Please refer to guidelines described in the [contributing guide]( https://github.com/expo/expo#contributing).
