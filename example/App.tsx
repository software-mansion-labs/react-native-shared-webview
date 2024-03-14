import { StyleSheet, Text, View } from 'react-native';

import * as SharedWebview from 'shared-webview';

export default function App() {
  return (
    <View style={styles.container}>
      <Text>{SharedWebview.hello()}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
