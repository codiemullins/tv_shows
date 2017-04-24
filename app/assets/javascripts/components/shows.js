import Loading from './loading'
import React from 'react';
import { ApolloClient, createNetworkInterface, ApolloProvider, graphql } from 'react-apollo';

import SHOW_QUERY from '../graphql/show'

const ITEMS_PER_PAGE = 20;

class Shows extends React.Component {
  render() {
    const { loading, shows, fetchMore } = this.props;

    return (
      <div>
        {loading ? <Loading /> : null}
        <h1>Shows found {(shows || []).length}</h1>
        <a onClick={fetchMore}>Load more</a>
        <ul>

          {(shows || []).map(show => (
            <li key={show.id}>
              {show.name}
              { show.network ? (<span>
                &nbsp;- <i>{show.network.name}</i>
              </span>) : null }
            </li>
          ))}
        </ul>
      </div>
    )
  }
}

// Shows.propTypes = {
//   loading: React.PropTypes.bool.isRequired,
//   // feed: Feed.propTypes.entries,
//   fetchMore: React.PropTypes.func,
// };

const variables = {
  // where: [
  //   {"field": "runtime", "value": "45", "operator": "GT" },
  //   {"field": "runtime", "value": "61", "operator": "LT" },
  //   {"field": "status", "value": "Running", "operator": "EQ"}
  // ],
  offset: 0,
  limit: ITEMS_PER_PAGE,
}

const withData = graphql(SHOW_QUERY, {
  options: { variables },
  props({ data: { loading, shows, fetchMore } }) {
    return {
      loading,
      shows,
      fetchMore() {
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
});

export default withData(Shows);
