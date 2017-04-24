import Loading from './loading'
import React from 'react';

// class Profile extends Component { ... }
export default ({loading, shows, loadMoreEntries}) => (
  <div>
    {loading ? <Loading /> : null}
    <h1>Shows found {(shows || []).length}</h1>
    <a onClick={loadMoreEntries}>Load more</a>
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
