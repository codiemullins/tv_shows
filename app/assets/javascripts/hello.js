import React from 'react';
import ReactDOM from 'react-dom';
import { ApolloClient, createNetworkInterface, ApolloProvider, graphql } from 'react-apollo';
import Profile from './components/profile'

import SHOW_QUERY from './graphql/show'

const ITEMS_PER_PAGE = 20;

const variables = {
  // where: [
  //   {"field": "runtime", "value": "45", "operator": "GT" },
  //   {"field": "runtime", "value": "61", "operator": "LT" },
  //   {"field": "status", "value": "Running", "operator": "EQ"}
  // ],
  offset: 0,
  limit: ITEMS_PER_PAGE,
}

const ProfileWithData = graphql(SHOW_QUERY, {
  options: { variables },
  props({ data: { loading, shows, fetchMore } }) {
    return {
      loading,
      shows,
      loadMoreEntries() {
        return fetchMore({
          variables: {
            offset: shows.length,
          },
          updateQuery: (previousResult, { fetchMoreResult }) => {
            if (!fetchMoreResult) { return previousResult; }
            return Object.assign({}, previousResult, {
              shows: [...previousResult.shows, ...fetchMoreResult.shows],
            })
          },
        });
      },
    }
  },
})(Profile);

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
        <ProfileWithData />
      </ApolloProvider>
    );
  }
}

ReactDOM.render(
  <App />,
  document.getElementById('root')
);
