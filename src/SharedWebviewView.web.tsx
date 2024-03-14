import * as React from 'react';

import { SharedWebviewViewProps } from './SharedWebview.types';

export default function SharedWebviewView(props: SharedWebviewViewProps) {
  return (
    <div>
      <span>{props.name}</span>
    </div>
  );
}
