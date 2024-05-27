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
