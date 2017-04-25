import React, { Component } from 'react';
import Show from './Show';
import {createFragmentContainer} from 'react-relay/compat';

class Shows extends Component {
  renderShows() {
    return this.props.viewer.shows.edges.map(edge =>
      <Show
        key={edge.node.id}
        show={edge.node}
        viewer={this.props.viewer}
      />
    )
  }
  render() {
    return (
      <div>
        <h1>Shows</h1>
        <ul>{this.renderShows()}</ul>
      </div>
    )
  }
}

export default createFragmentContainer(
  Shows,
  graphql`
    fragment Shows_viewer on User {
      id,
      shows(first: $first) {
        pageInfo {
          hasNextPage
        }
        edges {
          node {
            id,
            ...Show_show,
          }
        }
      }
    }
  `,
);
