import React, { Component } from 'react';
import {createFragmentContainer} from 'react-relay/compat';

class Show extends Component {
  render() {
    const show = this.props.show;
    return (
      <li>
        {show.name} {show.network ? `- ${show.network.name}` : null}
      </li>
    )
  }
}

export default createFragmentContainer(
  Show,
  graphql`
    fragment Show_show on Show {
      name
      network {
        name
      }
    }
  `,
)
