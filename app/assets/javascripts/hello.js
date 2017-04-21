import React from 'react';
import ReactDOM from 'react-dom';
import { gql, ApolloClient, createNetworkInterface, ApolloProvider, graphql } from 'react-apollo';

// class Profile extends Component { ... }
const Profile = ({data}) => (
  <div>
    <h1>Shows found {(data.shows || []).length}</h1>
    {data.shows.each (show) => {
      <li>{show.name}</li>
    }}
  </div>
)

// We use the gql tag to parse our query string into a query document
const shows = gql`
  query ($where: [Where]!) {
    shows(where: $where) {
      id
      name
      network {
        name
        country {
          name
        }
      }
      created_at
      show_type
      thetvdb_id
      status
    }
  }
`;

const variables = {
  where: [
    {"field": "runtime", "value": "45", "operator": "GT" },
    {"field": "runtime", "value": "61", "operator": "LT" },
    {"field": "status", "value": "Running", "operator": "EQ"}
  ]
}

const ProfileWithData = graphql(shows, { options: { variables }})(Profile);

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
