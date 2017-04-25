import React, { Component } from 'react';
import {QueryRenderer} from 'react-relay/compat';
import RelayClassic from 'react-relay/classic';

import Loading from './Loading';
import Shows from './Shows';
// Need to require setup_network --- it sets authentication settings necessary for GraphQL
import _ from '../setup_network';

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
              { props ? <Shows viewer={props.viewer} /> : <Loading /> }
            </div>
          )
        }}
      />
    );
  }
}

export default App;
