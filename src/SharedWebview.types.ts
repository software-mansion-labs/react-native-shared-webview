export type SharedWebviewViewProps = {
  style: any;
  options: {
    url: string;
    focused: boolean;
  };
  onNavigation: (event: { nativeEvent: { url: string } }) => void;
};
