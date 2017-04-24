import React from 'react';
import ReactDOM from 'react-dom';
import { ApolloClient, createNetworkInterface, ApolloProvider } from 'react-apollo';

import Shows from './components/shows'

export default class App extends React.Component {
  createClient() {
    const csrfToken = document.head.querySelector('meta[name=csrf-token]').getAttribute('content');
    // Initialize Apollo Client with URL to our server
    return new ApolloClient({
      networkInterface: createNetworkInterface({
        uri: '/graphql',
        opts: { credentials: 'same-origin', headers: { 'X-CSRF-Token': csrfToken } },
      }),
    });
  }

  render() {
    return (
      // Feed the client instance into your React component tree
      <ApolloProvider client={this.createClient()}>
        <Shows />
      </ApolloProvider>
    );
  }
}

ReactDOM.render(
  <App />,
  document.getElementById('root')
);
