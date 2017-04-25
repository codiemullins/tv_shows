import React, { Component } from 'react';
import {QueryRenderer} from 'react-relay/compat';
import RelayClassic from 'react-relay/classic';

import Shows from './Shows'

const csrfToken = document.head.querySelector('meta[name=csrf-token]').getAttribute('content');
RelayClassic.injectNetworkLayer(
  new RelayClassic.DefaultNetworkLayer('/graphql', {
    credentials: 'same-origin',
    headers: {
      'X-CSRF-Token': csrfToken,
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    }
  })
)

class App extends Component {
  render() {
    return (
      <QueryRenderer
        environment={RelayClassic.Store}
        query={graphql`
          query AppQuery($first: Int!) {
            viewer {
              id
              ...Shows_viewer
            }
          }
        `}
        variables={{first: 20}}
        render={({error, props}) => {
          return (
            <div>
              { props ? <Shows viewer={props.viewer} /> : null }
            </div>
          )
        }}
      />
    );
  }
}

export default App;
