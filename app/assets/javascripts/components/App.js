import React, { Component } from 'react';
import {
  QueryRenderer,
  graphql,
} from 'react-relay';

import environment from '../createRelayEnvironment';

import Shows from './Shows'

class App extends Component {
  render() {
    return (
      <QueryRenderer
        environment={environment}
        query={graphql`
          query AppQuery($limit: Int!) {
            shows(limit: $limit) {
              name
            }
          }
        `}
        variables={{
          limit: 20,
        }}

        render={({error, props}) => {
          if (error) {
            return <div>{error.message}</div>;
          } else if (props) {
            return <Shows shows={props.shows} />;
          }
            return <div>Loading</div>;
        }}
      />
    );
  }
}

export default App;
